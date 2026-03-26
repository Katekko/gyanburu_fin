import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gyanburu_fin_client/gyanburu_fin_client.dart' show BillStatus;
import 'package:intl/intl.dart';

import '../mock/mock_data.dart';
import '../theme/app_theme.dart';

final _currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, this.onBillTap});

  final void Function(int index)? onBillTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Dashboard', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 20),
          _BalanceSummaryRow(),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: _SpendingChart()),
              const SizedBox(width: 20),
              Expanded(flex: 2, child: _UpcomingBills(onBillTap: onBillTap)),
            ],
          ),
          const SizedBox(height: 24),
          _RecentTransactions(),
        ],
      ),
    );
  }
}

class _BalanceSummaryRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            label: 'Net Balance',
            value: _currencyFormat.format(MockData.netBalance),
            color: MockData.netBalance >= 0
                ? AppColors.positive
                : AppColors.negative,
            icon: Icons.account_balance_wallet,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _SummaryCard(
            label: 'Income',
            value: _currencyFormat.format(MockData.totalIncome),
            color: AppColors.positive,
            icon: Icons.trending_up,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _SummaryCard(
            label: 'Expenses',
            value: _currencyFormat.format(MockData.totalExpenses.abs()),
            color: AppColors.negative,
            icon: Icons.trending_down,
          ),
        ),
      ],
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
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spending = MockData.spendingByCategory;
    final total = spending.values.fold(0.0, (s, v) => s + v);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Spending by Category', style: theme.textTheme.titleMedium),
            const SizedBox(height: 20),
            SizedBox(
              height: 180,
              child: Center(child: _DonutChart(spending: spending)),
            ),
            const SizedBox(height: 20),
            ...spending.entries.map((e) {
              final pct = total > 0 ? (e.value / total * 100) : 0;
              final color = MockData.categoryColors[e.key] ??
                  AppColors.deepPurple;
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
        ),
      ),
    );
  }
}

class _DonutChart extends StatelessWidget {
  const _DonutChart({required this.spending});
  final Map<String, double> spending;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(160, 160),
      painter: _DonutPainter(spending),
    );
  }
}

class _DonutPainter extends CustomPainter {
  _DonutPainter(this.spending);
  final Map<String, double> spending;

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
      final color =
          MockData.categoryColors[entry.key] ?? AppColors.deepPurple;
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
  const _UpcomingBills({this.onBillTap});
  final void Function(int index)? onBillTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final upcoming = MockData.bills
        .where((b) => b.status == BillStatus.pending)
        .toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Upcoming Bills', style: theme.textTheme.titleMedium),
            const SizedBox(height: 16),
            if (upcoming.isEmpty)
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
              ...upcoming.map((bill) {
                final daysUntil =
                    bill.dueAt.difference(DateTime.now()).inDays;
                return InkWell(
                  onTap: () {
                    final idx = MockData.bills.indexOf(bill);
                    onBillTap?.call(idx);
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.receipt_long,
                          color: AppColors.vibrantOrange,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bill.merchantName,
                                style: theme.textTheme.bodyMedium,
                              ),
                              Text(
                                'Due in $daysUntil days',
                                style: theme.textTheme.labelSmall,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          _currencyFormat.format(bill.amount),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.vibrantOrange,
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

class _RecentTransactions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final recent = MockData.transactions.take(5).toList();
    final dateFormat = DateFormat('dd MMM');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recent Transactions', style: theme.textTheme.titleMedium),
            const SizedBox(height: 16),
            ...recent.map((tx) {
              final icon = MockData.categoryIcons[tx.category] ??
                  Icons.attach_money;
              final color = MockData.categoryColors[tx.category] ??
                  AppColors.deepPurple;
              final isIncome = tx.amount > 0;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, color: color, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tx.merchantName,
                            style: theme.textTheme.bodyMedium,
                          ),
                          Text(
                            '${tx.category} · ${dateFormat.format(tx.occurredAt)}',
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
