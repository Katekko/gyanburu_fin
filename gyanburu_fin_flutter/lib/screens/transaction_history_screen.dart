import 'package:flutter/material.dart';
import 'package:gyanburu_fin_client/gyanburu_fin_client.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import '../shared/icon_map.dart';
import '../shared/category_manager_dialog.dart';
import '../shared/transaction_edit_dialog.dart';
import '../theme/app_theme.dart';

final _currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

enum _SourceFilter { all, card, bank, income }

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  List<FinancialTransaction> _transactions = [];
  List<Category> _categories = [];
  List<CategoryRule> _rules = [];
  bool _loading = true;
  String? _selectedCategory;
  _SourceFilter _selectedSource = _SourceFilter.all;
  final _searchController = TextEditingController();
  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      final results = await Future.wait([
        client.transaction.listByMonth(_selectedMonth),
        client.category.list(),
        client.categoryRule.list(),
      ]);
      _transactions = results[0] as List<FinancialTransaction>;
      _categories = results[1] as List<Category>;
      _rules = results[2] as List<CategoryRule>;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load transactions: $e')),
        );
      }
    }
    setState(() => _loading = false);
  }

  void _changeMonth(int delta) {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month + delta,
      );
    });
    _loadData();
  }

  List<FinancialTransaction> get _filtered {
    var list = _transactions.toList();

    switch (_selectedSource) {
      case _SourceFilter.all:
        break;
      case _SourceFilter.card:
        list = list.where((t) => t.source == 'credit_card').toList();
        break;
      case _SourceFilter.bank:
        // Bank tab shows bank outflows (expenses + fatura payments), not income.
        list = list
            .where((t) => t.source == 'bank' && t.kind != 'income')
            .toList();
        break;
      case _SourceFilter.income:
        list = list.where((t) => t.kind == 'income').toList();
        break;
    }

    if (_selectedCategory != null) {
      list = list.where((t) => t.category == _selectedCategory).toList();
    }

    final query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      list = list
          .where((t) =>
              t.merchantName.toLowerCase().contains(query) ||
              (t.displayName?.toLowerCase().contains(query) ?? false) ||
              (t.description?.toLowerCase().contains(query) ?? false))
          .toList();
    }

    return list;
  }

  Future<void> _showTransactionEditor(FinancialTransaction transaction) async {
    final existingRule = _rules
        .where((r) => r.merchantPattern == transaction.merchantName)
        .firstOrNull;

    // Display name checkbox: propagate if rule already has a name, or new merchant.
    final initialPropagateDisplayName = existingRule == null
        ? true
        : (existingRule.displayName != null &&
            existingRule.displayName!.isNotEmpty);

    // Category checkbox: propagate if rule already has a category, or new merchant.
    final initialPropagateCategory = existingRule == null
        ? true
        : existingRule.categoryId != null;

    final result = await showDialog<TransactionEditResult>(
      context: context,
      builder: (ctx) => TransactionEditDialog(
        transaction: transaction,
        categories: _categories,
        existingDisplayName:
            existingRule?.displayName ?? transaction.displayName,
        initialPropagateDisplayName: initialPropagateDisplayName,
        initialPropagateCategory: initialPropagateCategory,
      ),
    );

    if (result == null || !mounted) return;

    try {
      final updated = await client.transaction.saveWithPropagation(
        transaction.id!,
        result.category?.name,
        result.displayName,
        result.propagateDisplayName,
        result.propagateCategory,
      );

      setState(() {
        // Update the edited transaction in place.
        final idx = _transactions.indexWhere((t) => t.id == updated.id);
        if (idx != -1) _transactions[idx] = updated;

        // Apply propagation to siblings in the local list.
        final categoryName = result.category?.name ?? '';
        for (var i = 0; i < _transactions.length; i++) {
          final t = _transactions[i];
          if (t.id == updated.id || t.merchantName != updated.merchantName) {
            continue;
          }
          if (result.propagateCategory) t.category = categoryName;
          if (result.propagateDisplayName) t.displayName = result.displayName;
        }

        // Update local rules cache.
        final ruleIdx =
            _rules.indexWhere((r) => r.merchantPattern == updated.merchantName);
        if (ruleIdx != -1) {
          if (result.propagateCategory) {
            _rules[ruleIdx].categoryId = result.category?.id;
          }
          if (result.propagateDisplayName) {
            _rules[ruleIdx].displayName = result.displayName;
          }
        } else if (result.propagateCategory || result.propagateDisplayName) {
          _rules.add(CategoryRule(
            userId: updated.userId,
            merchantPattern: updated.merchantName,
            categoryId: result.propagateCategory ? result.category?.id : null,
            displayName:
                result.propagateDisplayName ? result.displayName : null,
          ));
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update: $e'),
            backgroundColor: AppColors.negative,
          ),
        );
      }
    }
  }

  void _openCategoryManager() async {
    final result = await showCategoryManagerDialog(context, _categories);
    if (result != null) {
      setState(() => _categories = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final monthFormat = DateFormat('MMMM yyyy');
    final filtered = _filtered;

    // Group by date
    final grouped = <String, List<FinancialTransaction>>{};
    final dateFormat = DateFormat('dd MMMM yyyy');
    for (final tx in filtered) {
      final key = dateFormat.format(tx.occurredAt);
      grouped.putIfAbsent(key, () => []).add(tx);
    }

    // Categories present in current transactions (for filter)
    final usedCategories = _transactions
        .map((t) => t.category)
        .where((c) => c.isNotEmpty)
        .toSet()
        .toList()
      ..sort();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Transactions',
                    style: theme.textTheme.headlineMedium),
              ),
              IconButton(
                icon: const Icon(Icons.category, size: 20),
                tooltip: 'Manage Categories',
                onPressed: _openCategoryManager,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Month selector
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () => _changeMonth(-1),
              ),
              Text(
                monthFormat.format(_selectedMonth),
                style: theme.textTheme.titleMedium,
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () => _changeMonth(1),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Filters
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search transactions...',
                    prefixIcon: Icon(Icons.search, size: 20),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 12),
              FilterChip(
                label: Text(_selectedCategory ?? 'All Categories'),
                selected: _selectedCategory != null,
                onSelected: (_) {
                  _showFilterPicker(context, usedCategories);
                },
                avatar: const Icon(Icons.filter_list, size: 16),
              ),
              if (_selectedCategory != null) ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () => setState(() => _selectedCategory = null),
                  tooltip: 'Clear filter',
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          // Source filter chips
          _SourceFilterBar(
            selected: _selectedSource,
            onChanged: (s) => setState(() => _selectedSource = s),
          ),
          const SizedBox(height: 12),
          // Stats row
          _StatsRow(transactions: filtered),
          const SizedBox(height: 12),
          // Transaction list
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.receipt_long,
                                size: 48, color: AppColors.textMuted),
                            const SizedBox(height: 12),
                            Text(
                              'No transactions for this month',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Import an OFX file from the Import tab',
                              style: theme.textTheme.labelSmall,
                            ),
                          ],
                        ),
                      )
                    : ListView(
                        children: grouped.entries.expand((group) {
                          return [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 16, bottom: 8),
                              child: Text(
                                group.key,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            ...group.value.map((tx) => _TransactionRow(
                                  tx: tx,
                                  categories: _categories,
                                  onTap: () =>
                                      _showTransactionEditor(tx),
                                )),
                          ];
                        }).toList(),
                      ),
          ),
        ],
      ),
    );
  }

  void _showFilterPicker(BuildContext context, List<String> categories) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Filter by Category'),
        children: [
          SimpleDialogOption(
            onPressed: () {
              setState(() => _selectedCategory = null);
              Navigator.pop(ctx);
            },
            child: const Text('All Categories'),
          ),
          // Show "Uncategorized" filter
          SimpleDialogOption(
            onPressed: () {
              setState(() => _selectedCategory = '');
              Navigator.pop(ctx);
            },
            child: Row(
              children: [
                Icon(Icons.help_outline, color: AppColors.textMuted, size: 20),
                const SizedBox(width: 12),
                const Text('Uncategorized'),
              ],
            ),
          ),
          ...categories.where((c) => c.isNotEmpty).map((cat) {
            final catObj = _categories.where((c) => c.name == cat).firstOrNull;
            final icon = catObj != null
                ? (categoryIconMap[catObj.icon] ?? Icons.category)
                : Icons.category;
            final color = catObj != null
                ? Color(int.parse('FF${catObj.color}', radix: 16))
                : AppColors.deepPurple;
            return SimpleDialogOption(
              onPressed: () {
                setState(() => _selectedCategory = cat);
                Navigator.pop(ctx);
              },
              child: Row(
                children: [
                  Icon(icon, color: color, size: 20),
                  const SizedBox(width: 12),
                  Text(cat),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _SourceFilterBar extends StatelessWidget {
  const _SourceFilterBar({required this.selected, required this.onChanged});
  final _SourceFilter selected;
  final ValueChanged<_SourceFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    Widget chip(_SourceFilter value, String label, IconData icon) {
      final isSelected = selected == value;
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: FilterChip(
          label: Text(label),
          avatar: Icon(icon, size: 16),
          selected: isSelected,
          onSelected: (_) => onChanged(value),
        ),
      );
    }

    return Row(
      children: [
        chip(_SourceFilter.all, 'All', Icons.all_inclusive),
        chip(_SourceFilter.card, 'Card', Icons.credit_card),
        chip(_SourceFilter.bank, 'Bank', Icons.account_balance),
        chip(_SourceFilter.income, 'Income', Icons.trending_up),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.transactions});
  final List<FinancialTransaction> transactions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // fatura_payment is informational only — exclude from both totals.
    final income = transactions
        .where((t) => t.kind == 'income')
        .fold(0.0, (sum, t) => sum + t.amount);
    final expenses = transactions
        .where((t) => t.kind != 'income' && t.kind != 'fatura_payment')
        .fold(0.0, (sum, t) => sum + t.amount);
    final net = income - expenses;
    final uncategorized = transactions
        .where((t) => t.kind != 'income' && t.category.isEmpty)
        .length;

    Widget cell(String label, double value, Color color) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.labelSmall),
          const SizedBox(height: 2),
          Text(
            _currencyFormat.format(value),
            style: theme.textTheme.titleSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        cell('Income', income, AppColors.positive),
        const SizedBox(width: 24),
        cell('Expenses', expenses, AppColors.negative),
        const SizedBox(width: 24),
        cell('Net', net,
            net >= 0 ? AppColors.positive : AppColors.negative),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${transactions.length} transactions',
              style: theme.textTheme.labelSmall,
            ),
            if (uncategorized > 0) ...[
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.vibrantOrange.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$uncategorized uncategorized',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.vibrantOrange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({
    required this.tx,
    required this.categories,
    required this.onTap,
  });
  final FinancialTransaction tx;
  final List<Category> categories;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isIncome = tx.kind == 'income';
    final isFaturaPayment = tx.kind == 'fatura_payment';
    final hasCategory = tx.category.isNotEmpty;
    final catObj = hasCategory
        ? categories.where((c) => c.name == tx.category).firstOrNull
        : null;

    // Override icon/color for income and fatura payments so they read clearly
    // even without a category assigned.
    final IconData icon;
    final Color color;
    if (isIncome) {
      icon = Icons.trending_up;
      color = AppColors.positive;
    } else if (isFaturaPayment) {
      icon = Icons.sync_alt;
      color = AppColors.textMuted;
    } else {
      icon = catObj != null
          ? (categoryIconMap[catObj.icon] ?? Icons.category)
          : Icons.help_outline;
      color = catObj != null
          ? Color(int.parse('FF${catObj.color}', radix: 16))
          : AppColors.textMuted;
    }

    final hasInstallment =
        tx.installmentCurrent != null && tx.installmentTotal != null;
    final hasDisplayName =
        tx.displayName != null && tx.displayName!.isNotEmpty;

    // Build the main display name with installment appended
    String mainName;
    if (hasDisplayName) {
      mainName = hasInstallment
          ? '${tx.displayName} - ${tx.installmentCurrent}/${tx.installmentTotal}'
          : tx.displayName!;
    } else {
      mainName = tx.merchantName;
    }

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: hasCategory
                      ? color.withValues(alpha: 0.15)
                      : AppColors.vibrantOrange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: hasCategory ? color : AppColors.vibrantOrange,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mainName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // Original merchant name (shown when display name is set)
                    if (hasDisplayName)
                      Text(
                        tx.merchantName,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColors.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    Row(
                      children: [
                        _SourceBadge(tx: tx),
                        const SizedBox(width: 6),
                        if (isIncome)
                          Text('Income',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: AppColors.positive,
                                fontWeight: FontWeight.w600,
                              ))
                        else if (isFaturaPayment)
                          Text('Fatura payment',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: AppColors.textMuted,
                                fontWeight: FontWeight.w600,
                              ))
                        else if (hasCategory)
                          Text(tx.category, style: theme.textTheme.labelSmall)
                        else
                          Text(
                            'Tap to edit',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppColors.vibrantOrange,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        if (!hasDisplayName && hasInstallment) ...[
                          Text(' · ', style: theme.textTheme.labelSmall),
                          Text(
                            'Parcela ${tx.installmentCurrent}/${tx.installmentTotal}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                isIncome
                    ? '+${_currencyFormat.format(tx.amount)}'
                    : _currencyFormat.format(tx.amount),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isIncome
                      ? AppColors.positive
                      : isFaturaPayment
                          ? AppColors.textMuted
                          : AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  decoration: isFaturaPayment
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SourceBadge extends StatelessWidget {
  const _SourceBadge({required this.tx});
  final FinancialTransaction tx;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final IconData icon;
    final Color color;
    final String label;

    if (tx.source == 'credit_card') {
      icon = Icons.credit_card;
      color = AppColors.deepPurple;
      label = 'Card';
    } else if (tx.source == 'bank') {
      icon = Icons.account_balance;
      color = AppColors.vibrantOrange;
      label = 'Bank';
    } else {
      // Legacy rows with no source stamped.
      icon = Icons.receipt_long;
      color = AppColors.textMuted;
      label = 'Manual';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 3),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

