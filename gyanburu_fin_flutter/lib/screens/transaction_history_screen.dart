import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  String? _selectedCategory;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories = MockData.spendingByCategory.keys.toList()..sort();

    var filtered = MockData.transactions.toList();
    if (_selectedCategory != null) {
      filtered = filtered.where((t) => t.category == _selectedCategory).toList();
    }
    final query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      filtered = filtered.where((t) =>
          t.merchantName.toLowerCase().contains(query) ||
          (t.description?.toLowerCase().contains(query) ?? false)).toList();
    }

    // Group by date
    final grouped = <String, List<dynamic>>{};
    final dateFormat = DateFormat('dd MMMM yyyy');
    for (final tx in filtered) {
      final key = dateFormat.format(tx.occurredAt);
      grouped.putIfAbsent(key, () => []).add(tx);
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Transaction History', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 20),
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
                  _showCategoryPicker(context, categories);
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
          const SizedBox(height: 16),
          Text(
            '${filtered.length} transactions',
            style: theme.textTheme.labelSmall,
          ),
          const SizedBox(height: 12),
          // Transaction list
          Expanded(
            child: ListView(
              children: grouped.entries.expand((group) {
                return [
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      group.key,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ...group.value.map((tx) => _TransactionRow(tx: tx)),
                ];
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _showCategoryPicker(BuildContext context, List<String> categories) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Select Category'),
        children: categories.map((cat) {
          return SimpleDialogOption(
            onPressed: () {
              setState(() => _selectedCategory = cat);
              Navigator.pop(ctx);
            },
            child: Row(
              children: [
                Icon(
                  MockData.categoryIcons[cat] ?? Icons.category,
                  color: MockData.categoryColors[cat] ?? AppColors.deepPurple,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(cat),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _TransactionRow extends StatefulWidget {
  const _TransactionRow({required this.tx});
  final dynamic tx;

  @override
  State<_TransactionRow> createState() => _TransactionRowState();
}

class _TransactionRowState extends State<_TransactionRow> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tx = widget.tx;
    final icon = MockData.categoryIcons[tx.category] ?? Icons.attach_money;
    final color = MockData.categoryColors[tx.category] ?? AppColors.deepPurple;
    final isIncome = tx.amount > 0;
    final timeFormat = DateFormat('HH:mm');

    return Card(
      child: InkWell(
        onTap: () => setState(() => _expanded = !_expanded),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  const SizedBox(width: 14),
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
                        Text(
                          '${tx.category} · ${timeFormat.format(tx.occurredAt)}',
                          style: theme.textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${isIncome ? '+' : ''}${_currencyFormat.format(tx.amount)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isIncome
                          ? AppColors.positive
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 20,
                    color: AppColors.textMuted,
                  ),
                ],
              ),
              if (_expanded && tx.description != null) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description',
                        style: theme.textTheme.labelSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tx.description ?? '',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Currency: ${tx.currency}',
                        style: theme.textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
