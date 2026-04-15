import 'package:flutter/material.dart';
import 'package:gyanburu_fin_client/gyanburu_fin_client.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import '../shared/icon_map.dart';
import '../shared/category_manager_dialog.dart';
import '../theme/app_theme.dart';

final _currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  List<FinancialTransaction> _transactions = [];
  List<Category> _categories = [];
  List<CategoryRule> _rules = [];
  bool _loading = true;
  String? _selectedCategory;
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

    // Checkbox defaults to the current propagation state: if the rule
    // already carries a display name it's propagating, otherwise not.
    // For brand new merchants (no rule yet) default to propagating.
    final initialPropagate = existingRule == null
        ? true
        : (existingRule.displayName != null &&
            existingRule.displayName!.isNotEmpty);

    final result = await showDialog<_TransactionEditResult>(
      context: context,
      builder: (ctx) => _TransactionEditDialog(
        transaction: transaction,
        categories: _categories,
        existingDisplayName:
            existingRule?.displayName ?? transaction.displayName,
        initialPropagateDisplayName: initialPropagate,
      ),
    );

    if (result == null || !mounted) return;

    try {
      await client.transaction.saveWithPropagation(
        transaction.id!,
        result.category?.name,
        result.displayName,
        result.propagateDisplayName,
      );
      _loadData();
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

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.transactions});
  final List<FinancialTransaction> transactions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = transactions.fold(0.0, (sum, t) => sum + t.amount);
    final uncategorized = transactions.where((t) => t.category.isEmpty).length;

    return Row(
      children: [
        Text(
          '${transactions.length} transactions',
          style: theme.textTheme.labelSmall,
        ),
        const SizedBox(width: 16),
        Text(
          'Total: ${_currencyFormat.format(total)}',
          style: theme.textTheme.labelSmall?.copyWith(
            color: AppColors.negative,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (uncategorized > 0) ...[
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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

    final hasCategory = tx.category.isNotEmpty;
    final catObj = hasCategory
        ? categories.where((c) => c.name == tx.category).firstOrNull
        : null;
    final icon = catObj != null
        ? (categoryIconMap[catObj.icon] ?? Icons.category)
        : Icons.help_outline;
    final color = catObj != null
        ? Color(int.parse('FF${catObj.color}', radix: 16))
        : AppColors.textMuted;

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
                        if (hasCategory)
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
                _currencyFormat.format(tx.amount),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Transaction Edit Dialog
// ---------------------------------------------------------------------------

class _TransactionEditResult {
  final Category? category;
  final String? displayName;
  final bool propagateDisplayName;

  _TransactionEditResult({
    this.category,
    this.displayName,
    required this.propagateDisplayName,
  });
}

class _TransactionEditDialog extends StatefulWidget {
  const _TransactionEditDialog({
    required this.transaction,
    required this.categories,
    required this.initialPropagateDisplayName,
    this.existingDisplayName,
  });
  final FinancialTransaction transaction;
  final List<Category> categories;
  final String? existingDisplayName;
  final bool initialPropagateDisplayName;

  @override
  State<_TransactionEditDialog> createState() => _TransactionEditDialogState();
}

class _TransactionEditDialogState extends State<_TransactionEditDialog> {
  late final TextEditingController _displayNameController;
  Category? _selectedCategory;
  late bool _propagateDisplayName;

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController(
      text: widget.existingDisplayName ?? '',
    );
    _propagateDisplayName = widget.initialPropagateDisplayName;
    // Pre-select current category
    if (widget.transaction.category.isNotEmpty) {
      _selectedCategory = widget.categories
          .where((c) => c.name == widget.transaction.category)
          .firstOrNull;
    }
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    super.dispose();
  }

  void _save() {
    final displayName = _displayNameController.text.trim();
    Navigator.pop(
      context,
      _TransactionEditResult(
        category: _selectedCategory,
        displayName: displayName.isEmpty ? null : displayName,
        propagateDisplayName: _propagateDisplayName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tx = widget.transaction;
    final hasInstallment =
        tx.installmentCurrent != null && tx.installmentTotal != null;

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Edit Transaction', style: theme.textTheme.titleLarge),
              const SizedBox(height: 6),
              // Show original merchant name
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.store, size: 16, color: AppColors.textMuted),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        tx.merchantName,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    Text(
                      _currencyFormat.format(tx.amount),
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (hasInstallment) ...[
                      const SizedBox(width: 8),
                      Text(
                        'Parcela ${tx.installmentCurrent}/${tx.installmentTotal}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Display name field
              Text('Display Name', style: theme.textTheme.labelMedium),
              const SizedBox(height: 6),
              TextField(
                controller: _displayNameController,
                decoration: InputDecoration(
                  hintText: tx.merchantName,
                  helperText: 'A friendly name for this merchant',
                  helperMaxLines: 2,
                ),
              ),
              const SizedBox(height: 8),
              // Propagation toggle
              InkWell(
                onTap: () => setState(() {
                  _propagateDisplayName = !_propagateDisplayName;
                }),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _propagateDisplayName,
                        onChanged: (v) => setState(() {
                          _propagateDisplayName = v ?? false;
                        }),
                        visualDensity: VisualDensity.compact,
                      ),
                      Expanded(
                        child: Text(
                          'Apply this name to other ${tx.merchantName} transactions',
                          style: theme.textTheme.labelSmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Category picker
              Text('Category', style: theme.textTheme.labelMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.categories.map((cat) {
                  final icon =
                      categoryIconMap[cat.icon] ?? Icons.category;
                  final color =
                      Color(int.parse('FF${cat.color}', radix: 16));
                  final isSelected = _selectedCategory?.id == cat.id;

                  return InkWell(
                    onTap: () => setState(() {
                      _selectedCategory =
                          isSelected ? null : cat;
                    }),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? color.withValues(alpha: 0.2)
                            : AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(10),
                        border: isSelected
                            ? Border.all(color: color, width: 1.5)
                            : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(icon, color: color, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            cat.name,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: isSelected
                                  ? color
                                  : AppColors.textSecondary,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _save,
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
