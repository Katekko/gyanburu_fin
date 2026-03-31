import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gyanburu_fin_client/gyanburu_fin_client.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import '../shared/icon_map.dart';
import '../theme/app_theme.dart';

final _currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, this.onBillTap});

  final void Function(int index)? onBillTap;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<MonthlyEntry> _entries = [];
  List<Category> _categories = [];
  List<FinancialTransaction> _transactions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  String get _monthKey {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}';
  }

  DateTime get _currentMonth {
    final now = DateTime.now();
    return DateTime(now.year, now.month);
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      final results = await Future.wait([
        client.monthlyEntry.listByMonth(_monthKey),
        client.category.list(),
        client.transaction.listByMonth(_currentMonth),
      ]);
      setState(() {
        _entries = results[0] as List<MonthlyEntry>;
        _categories = results[1] as List<Category>;
        _transactions = results[2] as List<FinancialTransaction>;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load dashboard data: $e')),
        );
      }
    }
  }

  List<MonthlyEntry> get _incomeEntries =>
      _entries.where((e) => e.type == EntryType.income).toList();

  List<MonthlyEntry> get _expenseEntries =>
      _entries.where((e) => e.type == EntryType.expense).toList();

  double get _totalIncome => _incomeEntries.fold(0.0, (s, e) => s + e.amount);

  double get _totalBudgetedExpenses =>
      _expenseEntries.fold(0.0, (s, e) => s + e.amount);

  double get _totalCardSpending =>
      _transactions.fold(0.0, (s, t) => s + t.amount);

  Category? _categoryFor(int id) {
    try {
      return _categories.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  Color _colorFor(Category? cat) {
    if (cat == null) return AppColors.deepPurple;
    try {
      return Color(int.parse('FF${cat.color}', radix: 16));
    } catch (_) {
      return AppColors.deepPurple;
    }
  }

  IconData _iconFor(Category? cat) {
    if (cat == null) return Icons.category;
    return categoryIconMap[cat.icon] ?? Icons.category;
  }

  /// Spending by category from imported transactions
  Map<String, double> get _transactionSpendingByCategory {
    final Map<String, double> result = {};
    for (final t in _transactions) {
      final name = t.category.isNotEmpty ? t.category : 'Uncategorized';
      result[name] = (result[name] ?? 0) + t.amount;
    }
    return result;
  }

  Map<String, Color> get _categoryColorMap {
    final Map<String, Color> result = {};
    for (final cat in _categories) {
      result[cat.name] = _colorFor(cat);
    }
    result['Uncategorized'] = AppColors.textMuted;
    return result;
  }

  List<MonthlyEntry> get _upcomingBills {
    final unpaid = _entries.where((e) => !e.paid && e.dueDate != null).toList()
      ..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
    return unpaid;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final uncategorizedCount =
        _transactions.where((t) => t.category.isEmpty).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Dashboard', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 20),
          // Summary cards
          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  label: 'Income',
                  value: _currencyFormat.format(_totalIncome),
                  color: AppColors.positive,
                  icon: Icons.trending_up,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _SummaryCard(
                  label: 'Card Spending',
                  value: _currencyFormat.format(_totalCardSpending),
                  color: AppColors.negative,
                  icon: Icons.credit_card,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _SummaryCard(
                  label: 'Budgeted Expenses',
                  value: _currencyFormat.format(_totalBudgetedExpenses),
                  color: AppColors.vibrantOrange,
                  icon: Icons.receipt_long,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: _SpendingChart(
                  spending: _transactionSpendingByCategory,
                  colorMap: _categoryColorMap,
                  total: _totalCardSpending,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    _UpcomingBills(
                      bills: _upcomingBills,
                      categoryFor: _categoryFor,
                      colorFor: _colorFor,
                      iconFor: _iconFor,
                      onBillTap: widget.onBillTap,
                    ),
                    if (uncategorizedCount > 0) ...[
                      const SizedBox(height: 16),
                      _UncategorizedBanner(count: uncategorizedCount),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _RecentTransactions(
            transactions: _transactions,
            categories: _categories,
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(label, style: theme.textTheme.labelMedium),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpendingChart extends StatelessWidget {
  const _SpendingChart({
    required this.spending,
    required this.colorMap,
    required this.total,
  });

  final Map<String, double> spending;
  final Map<String, Color> colorMap;
  final double total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Sort by amount descending
    final sorted = spending.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('Spending by Category',
                      style: theme.textTheme.titleMedium),
                ),
                Text(
                  _currencyFormat.format(total),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.negative,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (spending.isEmpty)
              SizedBox(
                height: 180,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.upload_file,
                          size: 32, color: AppColors.textMuted),
                      const SizedBox(height: 8),
                      Text(
                        'Import an OFX file to see spending',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              )
            else ...[
              SizedBox(
                height: 180,
                child: Center(
                  child: _DonutChart(spending: spending, colorMap: colorMap),
                ),
              ),
              const SizedBox(height: 20),
              ...sorted.map((e) {
                final pct = total > 0 ? (e.value / total * 100) : 0;
                final color = colorMap[e.key] ?? AppColors.deepPurple;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(e.key, style: theme.textTheme.bodyMedium),
                      ),
                      Text(
                        _currencyFormat.format(e.value),
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 42,
                        child: Text(
                          '${pct.toStringAsFixed(0)}%',
                          style: theme.textTheme.labelSmall,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}

class _DonutChart extends StatelessWidget {
  const _DonutChart({required this.spending, required this.colorMap});
  final Map<String, double> spending;
  final Map<String, Color> colorMap;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(160, 160),
      painter: _DonutPainter(spending, colorMap),
    );
  }
}

class _DonutPainter extends CustomPainter {
  _DonutPainter(this.spending, this.colorMap);
  final Map<String, double> spending;
  final Map<String, Color> colorMap;

  @override
  void paint(Canvas canvas, Size size) {
    final total = spending.values.fold(0.0, (s, v) => s + v);
    if (total == 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;
    final strokeWidth = radius * 0.35;
    final rect = Rect.fromCircle(
      center: center,
      radius: radius - strokeWidth / 2,
    );

    var startAngle = -pi / 2;
    for (final entry in spending.entries) {
      final sweep = (entry.value / total) * 2 * pi;
      final color = colorMap[entry.key] ?? AppColors.deepPurple;
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(rect, startAngle, sweep, false, paint);
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _UpcomingBills extends StatelessWidget {
  const _UpcomingBills({
    required this.bills,
    required this.categoryFor,
    required this.colorFor,
    required this.iconFor,
    this.onBillTap,
  });

  final List<MonthlyEntry> bills;
  final Category? Function(int id) categoryFor;
  final Color Function(Category? cat) colorFor;
  final IconData Function(Category? cat) iconFor;
  final void Function(int index)? onBillTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Upcoming Bills', style: theme.textTheme.titleMedium),
            const SizedBox(height: 16),
            if (bills.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    'No upcoming bills',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              )
            else
              ...bills.map((entry) {
                final cat = categoryFor(entry.categoryId);
                final color = colorFor(cat);
                final daysUntil = entry.dueDate!.difference(now).inDays;
                final isOverdue = daysUntil < 0;
                final dueLabel = isOverdue
                    ? 'Overdue by ${daysUntil.abs()} days'
                    : daysUntil == 0
                        ? 'Due today'
                        : 'Due in $daysUntil days';

                return InkWell(
                  onTap: () => onBillTap?.call(0),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Icon(
                          iconFor(cat),
                          color: isOverdue ? AppColors.negative : color,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.name,
                                style: theme.textTheme.bodyMedium,
                              ),
                              Text(
                                dueLabel,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color:
                                      isOverdue ? AppColors.negative : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          _currencyFormat.format(entry.amount),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isOverdue
                                ? AppColors.negative
                                : AppColors.vibrantOrange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}

class _UncategorizedBanner extends StatelessWidget {
  const _UncategorizedBanner({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: AppColors.vibrantOrange.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.label_off, color: AppColors.vibrantOrange, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$count uncategorized transactions',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.vibrantOrange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Go to Transactions to categorize them',
                    style: theme.textTheme.labelSmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentTransactions extends StatelessWidget {
  const _RecentTransactions({
    required this.transactions,
    required this.categories,
  });
  final List<FinancialTransaction> transactions;
  final List<Category> categories;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final recent = transactions.take(10).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('Recent Transactions',
                      style: theme.textTheme.titleMedium),
                ),
                if (transactions.isNotEmpty)
                  Text(
                    '${transactions.length} this month',
                    style: theme.textTheme.labelSmall,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (recent.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.upload_file,
                          color: AppColors.textMuted, size: 32),
                      const SizedBox(height: 8),
                      Text(
                        'Import an OFX file to see transactions',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              )
            else
              ...recent.map((tx) {
                final hasCategory = tx.category.isNotEmpty;
                final catObj = hasCategory
                    ? categories
                        .where((c) => c.name == tx.category)
                        .firstOrNull
                    : null;
                final icon = catObj != null
                    ? (categoryIconMap[catObj.icon] ?? Icons.category)
                    : Icons.help_outline;
                final color = catObj != null
                    ? Color(int.parse('FF${catObj.color}', radix: 16))
                    : AppColors.textMuted;

                final hasDisplayName =
                    tx.displayName != null && tx.displayName!.isNotEmpty;
                final hasInstallment = tx.installmentCurrent != null &&
                    tx.installmentTotal != null;

                String mainName;
                if (hasDisplayName) {
                  mainName = hasInstallment
                      ? '${tx.displayName} - ${tx.installmentCurrent}/${tx.installmentTotal}'
                      : tx.displayName!;
                } else {
                  mainName = tx.merchantName;
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(icon, color: color, size: 16),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mainName,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (hasDisplayName)
                              Text(
                                tx.merchantName,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: AppColors.textMuted,
                                  fontSize: 11,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                      Text(
                        _currencyFormat.format(tx.amount),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
