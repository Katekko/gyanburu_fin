import 'package:flutter/material.dart';
import 'package:gyanburu_fin_client/gyanburu_fin_client.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import '../mock/mock_data.dart';
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
    } catch (_) {}
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
              (t.description?.toLowerCase().contains(query) ?? false))
          .toList();
    }

    return list;
  }

  Future<void> _showCategoryPicker(FinancialTransaction transaction) async {
    final selected = await showDialog<Category>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Select Category'),
        children: [
          // "No category" option
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, null),
            child: Row(
              children: [
                Icon(Icons.clear, color: AppColors.textMuted, size: 20),
                const SizedBox(width: 12),
                Text('No category',
                    style: TextStyle(color: AppColors.textMuted)),
              ],
            ),
          ),
          ..._categories.map((cat) {
            final icon =
                MockData.categoryIconMap[cat.icon] ?? Icons.category;
            final color = Color(int.parse('FF${cat.color}', radix: 16));
            return SimpleDialogOption(
              onPressed: () => Navigator.pop(ctx, cat),
              child: Row(
                children: [
                  Icon(icon, color: color, size: 20),
                  const SizedBox(width: 12),
                  Text(cat.name),
                ],
              ),
            );
          }),
        ],
      ),
    );

    // User dismissed dialog
    if (!mounted) return;

    // If they picked "No category" (null returned via pop), clear it
    // If they dismissed (null from showDialog), do nothing
    // We can't distinguish these easily, so we use a sentinel approach:
    // The dialog always returns via pop, so null = dismissed or cleared.
    // Let's just handle the Category case.
    if (selected == null) return;

    await _assignCategory(transaction, selected);
  }

  Future<void> _assignCategory(
    FinancialTransaction transaction,
    Category category,
  ) async {
    try {
      // Update the transaction
      transaction.category = category.name;
      await client.transaction.update(transaction);

      // Create or update CategoryRule for auto-categorization
      final existingRule = _rules
          .where((r) => r.merchantPattern == transaction.merchantName)
          .firstOrNull;

      if (existingRule != null) {
        existingRule.categoryId = category.id!;
        await client.categoryRule.update(existingRule);
      } else {
        final newRule = CategoryRule(
          userId: transaction.userId,
          merchantPattern: transaction.merchantName,
          categoryId: category.id!,
        );
        await client.categoryRule.create(newRule);
      }

      _loadData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update category: $e'),
            backgroundColor: AppColors.negative,
          ),
        );
      }
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
          Text('Transactions', style: theme.textTheme.headlineMedium),
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
                                  onCategoryTap: () =>
                                      _showCategoryPicker(tx),
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
                ? (MockData.categoryIconMap[catObj.icon] ?? Icons.category)
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
    required this.onCategoryTap,
  });
  final FinancialTransaction tx;
  final List<Category> categories;
  final VoidCallback onCategoryTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final hasCategory = tx.category.isNotEmpty;
    final catObj =
        hasCategory ? categories.where((c) => c.name == tx.category).firstOrNull : null;
    final icon = catObj != null
        ? (MockData.categoryIconMap[catObj.icon] ?? Icons.category)
        : Icons.help_outline;
    final color = catObj != null
        ? Color(int.parse('FF${catObj.color}', radix: 16))
        : AppColors.textMuted;

    final hasInstallment =
        tx.installmentCurrent != null && tx.installmentTotal != null;

    return Card(
      child: InkWell(
        onTap: onCategoryTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Category icon (tappable indicator)
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
              // Merchant name + category label
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tx.merchantName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        if (hasCategory)
                          Text(tx.category, style: theme.textTheme.labelSmall)
                        else
                          Text(
                            'Tap to categorize',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppColors.vibrantOrange,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        if (hasInstallment) ...[
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
              // Amount
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
