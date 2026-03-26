import 'package:flutter/material.dart';
import 'package:gyanburu_fin_client/gyanburu_fin_client.dart';
import 'package:intl/intl.dart';

import '../mock/mock_data.dart';
import '../theme/app_theme.dart';

final _currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

class BillDetailScreen extends StatefulWidget {
  const BillDetailScreen({super.key, this.initialBillIndex});

  final int? initialBillIndex;

  @override
  State<BillDetailScreen> createState() => _BillDetailScreenState();
}

class _BillDetailScreenState extends State<BillDetailScreen> {
  late int _selectedIndex;
  late List<Bill> _bills;

  @override
  void initState() {
    super.initState();
    _bills = List.from(MockData.bills);
    _selectedIndex = (widget.initialBillIndex ?? 0).clamp(0, _bills.length - 1);
  }

  void _markAsPaid(int index) {
    setState(() {
      _bills[index] = Bill(
        userId: _bills[index].userId,
        merchantName: _bills[index].merchantName,
        amount: _bills[index].amount,
        dueAt: _bills[index].dueAt,
        status: BillStatus.paid,
        recurrent: _bills[index].recurrent,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Bills', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'Manage and track your recurring bills.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 24),
          // Bill list
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: bill list
              Expanded(
                flex: 2,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('All Bills', style: theme.textTheme.titleMedium),
                        const SizedBox(height: 12),
                        ..._bills.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final bill = entry.value;
                          final isSelected = idx == _selectedIndex;
                          final isPaid = bill.status == BillStatus.paid;
                          final isOverdue = bill.status == BillStatus.overdue ||
                              (bill.status == BillStatus.pending &&
                                  bill.dueAt.isBefore(DateTime.now()));

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Material(
                              color: isSelected
                                  ? AppColors.deepPurple.withValues(alpha: 0.12)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              child: InkWell(
                                onTap: () =>
                                    setState(() => _selectedIndex = idx),
                                borderRadius: BorderRadius.circular(10),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      Icon(
                                        isPaid
                                            ? Icons.check_circle
                                            : isOverdue
                                                ? Icons.warning
                                                : Icons.receipt_long,
                                        color: isPaid
                                            ? AppColors.positive
                                            : isOverdue
                                                ? AppColors.negative
                                                : AppColors.vibrantOrange,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          bill.merchantName,
                                          style: theme.textTheme.bodyMedium,
                                        ),
                                      ),
                                      Text(
                                        _currencyFormat.format(bill.amount),
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              // Right: bill detail
              Expanded(
                flex: 3,
                child: _BillDetailCard(
                  bill: _bills[_selectedIndex],
                  onMarkAsPaid: () => _markAsPaid(_selectedIndex),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BillDetailCard extends StatelessWidget {
  const _BillDetailCard({required this.bill, required this.onMarkAsPaid});
  final Bill bill;
  final VoidCallback onMarkAsPaid;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd MMMM yyyy');
    final isPaid = bill.status == BillStatus.paid;
    final isOverdue = !isPaid && bill.dueAt.isBefore(DateTime.now());

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.vibrantOrange.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.receipt_long,
                    color: AppColors.vibrantOrange,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bill.merchantName,
                        style: theme.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 4),
                      _StatusChip(
                        isPaid: isPaid,
                        isOverdue: isOverdue,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            _DetailRow(label: 'Amount', value: _currencyFormat.format(bill.amount)),
            const Divider(height: 24),
            _DetailRow(label: 'Due Date', value: dateFormat.format(bill.dueAt)),
            const Divider(height: 24),
            _DetailRow(
              label: 'Recurrent',
              value: bill.recurrent ? 'Yes — monthly' : 'No',
            ),
            const Divider(height: 24),
            _DetailRow(
              label: 'Status',
              value: isPaid
                  ? 'Paid'
                  : isOverdue
                      ? 'Overdue'
                      : 'Pending',
            ),
            const SizedBox(height: 28),
            // Mock payment history
            Text('Payment History', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            ..._mockPaymentHistory(bill).map((entry) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 16,
                    color: AppColors.positive,
                  ),
                  const SizedBox(width: 8),
                  Text(entry['date']!, style: theme.textTheme.bodySmall),
                  const Spacer(),
                  Text(
                    entry['amount']!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 24),
            if (!isPaid)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onMarkAsPaid,
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text('Mark as Paid'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Map<String, String>> _mockPaymentHistory(Bill bill) {
    final fmt = DateFormat('dd MMM yyyy');
    return List.generate(3, (i) {
      final date = DateTime(
        bill.dueAt.year,
        bill.dueAt.month - (i + 1),
        bill.dueAt.day,
      );
      return {
        'date': fmt.format(date),
        'amount': _currencyFormat.format(bill.amount),
      };
    });
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.isPaid, required this.isOverdue});
  final bool isPaid;
  final bool isOverdue;

  @override
  Widget build(BuildContext context) {
    final (color, label) = isPaid
        ? (AppColors.positive, 'Paid')
        : isOverdue
            ? (AppColors.negative, 'Overdue')
            : (AppColors.vibrantOrange, 'Pending');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text(label, style: theme.textTheme.labelMedium),
        const Spacer(),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
