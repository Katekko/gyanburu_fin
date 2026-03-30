import 'package:flutter/material.dart';
import 'package:gyanburu_fin_client/gyanburu_fin_client.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import '../mock/mock_data.dart';
import '../theme/app_theme.dart';

final _currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
final _dateFormat = DateFormat('dd/MM/yyyy');

const _paymentMethods = [
  'PIX',
  'Boleto',
  'Credit Card',
  'Debit Card',
  'Transfer',
  'Cash',
];

class BillDetailScreen extends StatefulWidget {
  const BillDetailScreen({super.key});

  @override
  State<BillDetailScreen> createState() => _BillDetailScreenState();
}

class _BillDetailScreenState extends State<BillDetailScreen> {
  late DateTime _selectedMonth;
  List<MonthlyEntry> _entries = [];
  List<Category> _categories = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = DateTime(now.year, now.month);
    _loadData();
  }

  String get _monthKey =>
      '${_selectedMonth.year}-${_selectedMonth.month.toString().padLeft(2, '0')}';

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      final results = await Future.wait([
        client.monthlyEntry.listByMonth(_monthKey),
        client.category.list(),
      ]);
      setState(() {
        _entries = results[0] as List<MonthlyEntry>;
        _categories = results[1] as List<Category>;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  // Only show expenses and income for the selected month
  List<MonthlyEntry> get _expenses =>
      _entries.where((e) => e.type == EntryType.expense).toList()
        ..sort(_sortByStatus);

  List<MonthlyEntry> get _incomes =>
      _entries.where((e) => e.type == EntryType.income).toList()
        ..sort(_sortByStatus);

  int _sortByStatus(MonthlyEntry a, MonthlyEntry b) {
    // Overdue first, then pending, then paid
    final aScore = _statusScore(a);
    final bScore = _statusScore(b);
    if (aScore != bScore) return aScore.compareTo(bScore);
    // Then by due date (nulls last)
    if (a.dueDate != null && b.dueDate != null) {
      return a.dueDate!.compareTo(b.dueDate!);
    }
    if (a.dueDate != null) return -1;
    if (b.dueDate != null) return 1;
    return a.name.compareTo(b.name);
  }

  int _statusScore(MonthlyEntry e) {
    if (e.paid) return 2; // paid last
    if (_isOverdue(e)) return 0; // overdue first
    return 1; // pending middle
  }

  bool _isOverdue(MonthlyEntry e) {
    if (e.paid) return false;
    if (e.dueDate == null) return false;
    return e.dueDate!.isBefore(DateTime.now());
  }

  double _totalPending(List<MonthlyEntry> entries) =>
      entries.where((e) => !e.paid).fold(0.0, (s, e) => s + e.amount);

  double _totalPaid(List<MonthlyEntry> entries) =>
      entries.where((e) => e.paid).fold(0.0, (s, e) => s + (e.paidAmount ?? e.amount));

  double _total(List<MonthlyEntry> entries) =>
      entries.fold(0.0, (s, e) => s + e.amount);

  Category? _categoryFor(int id) {
    try {
      return _categories.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  Color _colorFor(Category? cat) {
    if (cat == null) return AppColors.deepPurple;
    return Color(int.parse('FF${cat.color}', radix: 16));
  }

  IconData _iconFor(Category? cat) {
    if (cat == null) return Icons.category;
    return MockData.categoryIconMap[cat.icon] ?? Icons.category;
  }

  void _changeMonth(int delta) {
    setState(() {
      _selectedMonth =
          DateTime(_selectedMonth.year, _selectedMonth.month + delta);
    });
    _loadData();
  }

  Future<void> _markAsPaid(MonthlyEntry entry) async {
    final result = await showDialog<MonthlyEntry>(
      context: context,
      builder: (_) => _MarkAsPaidDialog(entry: entry),
    );
    if (result != null) {
      final saved = await client.monthlyEntry.update(result);
      setState(() {
        final idx = _entries.indexWhere((e) => e.id == entry.id);
        if (idx != -1) _entries[idx] = saved;
      });
    }
  }

  Future<void> _undoPaid(MonthlyEntry entry) async {
    final updated = entry.copyWith(
      paid: false,
      paidAt: null,
      paidAmount: null,
      paymentMethod: null,
      paymentNote: null,
    );
    final saved = await client.monthlyEntry.update(updated);
    setState(() {
      final idx = _entries.indexWhere((e) => e.id == entry.id);
      if (idx != -1) _entries[idx] = saved;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text('Bills & Payments', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 4),
          Text(
            'Track what you need to pay and what you\'ve already received.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          // Month picker
          _MonthPicker(
            month: _selectedMonth,
            onPrevious: () => _changeMonth(-1),
            onNext: () => _changeMonth(1),
          ),
          const SizedBox(height: 20),
          // Expenses section
          _BillSection(
            title: 'Expenses to Pay',
            icon: Icons.trending_down,
            accentColor: AppColors.negative,
            entries: _expenses,
            totalPending: _totalPending(_expenses),
            totalPaid: _totalPaid(_expenses),
            total: _total(_expenses),
            paidLabel: 'Paid',
            pendingLabel: 'To Pay',
            isOverdue: _isOverdue,
            categoryFor: _categoryFor,
            colorFor: _colorFor,
            iconFor: _iconFor,
            onMarkAsPaid: _markAsPaid,
            onUndoPaid: _undoPaid,
          ),
          const SizedBox(height: 24),
          // Income section
          _BillSection(
            title: 'Income to Receive',
            icon: Icons.trending_up,
            accentColor: AppColors.positive,
            entries: _incomes,
            totalPending: _totalPending(_incomes),
            totalPaid: _totalPaid(_incomes),
            total: _total(_incomes),
            paidLabel: 'Received',
            pendingLabel: 'Pending',
            isOverdue: _isOverdue,
            categoryFor: _categoryFor,
            colorFor: _colorFor,
            iconFor: _iconFor,
            onMarkAsPaid: _markAsPaid,
            onUndoPaid: _undoPaid,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Month Picker (same pattern as MonthlyOverviewScreen)
// ---------------------------------------------------------------------------

class _MonthPicker extends StatelessWidget {
  const _MonthPicker({
    required this.month,
    required this.onPrevious,
    required this.onNext,
  });
  final DateTime month;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = DateFormat('MMMM yyyy').format(month);

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: onPrevious,
            ),
            const SizedBox(width: 8),
            Text(label,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: onNext,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bill Section (expenses or income)
// ---------------------------------------------------------------------------

class _BillSection extends StatelessWidget {
  const _BillSection({
    required this.title,
    required this.icon,
    required this.accentColor,
    required this.entries,
    required this.totalPending,
    required this.totalPaid,
    required this.total,
    required this.paidLabel,
    required this.pendingLabel,
    required this.isOverdue,
    required this.categoryFor,
    required this.colorFor,
    required this.iconFor,
    required this.onMarkAsPaid,
    required this.onUndoPaid,
  });
  final String title;
  final IconData icon;
  final Color accentColor;
  final List<MonthlyEntry> entries;
  final double totalPending;
  final double totalPaid;
  final double total;
  final String paidLabel;
  final String pendingLabel;
  final bool Function(MonthlyEntry) isOverdue;
  final Category? Function(int) categoryFor;
  final Color Function(Category?) colorFor;
  final IconData Function(Category?) iconFor;
  final Future<void> Function(MonthlyEntry) onMarkAsPaid;
  final Future<void> Function(MonthlyEntry) onUndoPaid;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pending = entries.where((e) => !e.paid).toList();
    final paid = entries.where((e) => e.paid).toList();
    final paidFraction = total > 0 ? totalPaid / total : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(icon, color: accentColor, size: 22),
                const SizedBox(width: 8),
                Text(title, style: theme.textTheme.titleMedium),
                const Spacer(),
                Text(
                  _currencyFormat.format(total),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Summary chips
            Row(
              children: [
                _SummaryChip(
                  label: pendingLabel,
                  value: _currencyFormat.format(totalPending),
                  color: AppColors.vibrantOrange,
                ),
                const SizedBox(width: 12),
                _SummaryChip(
                  label: paidLabel,
                  value: _currencyFormat.format(totalPaid),
                  color: AppColors.positive,
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedBox(
                height: 8,
                child: LinearProgressIndicator(
                  value: paidFraction,
                  backgroundColor: AppColors.surfaceElevated,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.positive),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Pending entries
            if (pending.isNotEmpty) ...[
              Text(pendingLabel,
                  style: theme.textTheme.labelMedium
                      ?.copyWith(color: AppColors.textMuted)),
              const SizedBox(height: 8),
              ...pending.map((entry) => _BillEntryRow(
                    entry: entry,
                    isOverdue: isOverdue(entry),
                    category: categoryFor(entry.categoryId),
                    colorFor: colorFor,
                    iconFor: iconFor,
                    onMarkAsPaid: () => onMarkAsPaid(entry),
                    paidLabel: paidLabel,
                  )),
            ],
            // Paid entries
            if (paid.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(paidLabel,
                  style: theme.textTheme.labelMedium
                      ?.copyWith(color: AppColors.textMuted)),
              const SizedBox(height: 8),
              ...paid.map((entry) => _BillEntryRow(
                    entry: entry,
                    isOverdue: false,
                    category: categoryFor(entry.categoryId),
                    colorFor: colorFor,
                    iconFor: iconFor,
                    onUndoPaid: () => onUndoPaid(entry),
                    paidLabel: paidLabel,
                  )),
            ],
            // Empty state
            if (entries.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    'No entries for this month. Add them in Monthly Overview.',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Summary Chip
// ---------------------------------------------------------------------------

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.label,
    required this.value,
    required this.color,
  });
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: theme.textTheme.labelSmall),
            const SizedBox(height: 2),
            Text(value,
                style: theme.textTheme.titleSmall
                    ?.copyWith(color: color, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bill Entry Row
// ---------------------------------------------------------------------------

class _BillEntryRow extends StatelessWidget {
  const _BillEntryRow({
    required this.entry,
    required this.isOverdue,
    required this.category,
    required this.colorFor,
    required this.iconFor,
    this.onMarkAsPaid,
    this.onUndoPaid,
    required this.paidLabel,
  });
  final MonthlyEntry entry;
  final bool isOverdue;
  final Category? category;
  final Color Function(Category?) colorFor;
  final IconData Function(Category?) iconFor;
  final VoidCallback? onMarkAsPaid;
  final VoidCallback? onUndoPaid;
  final String paidLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final catColor = colorFor(category);
    final catIcon = iconFor(category);
    final isPaid = entry.paid;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Material(
        color: isOverdue
            ? AppColors.negative.withValues(alpha: 0.08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              // Category icon
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: catColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(catIcon, color: catColor, size: 18),
              ),
              const SizedBox(width: 12),
              // Name + due date + status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.name,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        decoration:
                            isPaid ? TextDecoration.lineThrough : null,
                        color: isPaid ? AppColors.textMuted : null,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        if (category != null)
                          Text(category!.name,
                              style: theme.textTheme.labelSmall),
                        if (entry.dueDate != null) ...[
                          if (category != null)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: Text('·',
                                  style: theme.textTheme.labelSmall),
                            ),
                          Icon(Icons.calendar_today,
                              size: 11,
                              color: isOverdue
                                  ? AppColors.negative
                                  : AppColors.textMuted),
                          const SizedBox(width: 3),
                          Text(
                            _dateFormat.format(entry.dueDate!),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color:
                                  isOverdue ? AppColors.negative : null,
                              fontWeight:
                                  isOverdue ? FontWeight.w600 : null,
                            ),
                          ),
                        ],
                        if (isOverdue) ...[
                          const SizedBox(width: 6),
                          _StatusBadge(
                              label: 'Overdue',
                              color: AppColors.negative),
                        ],
                        if (isPaid && entry.paymentMethod != null) ...[
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4),
                            child: Text('·',
                                style: theme.textTheme.labelSmall),
                          ),
                          Text(entry.paymentMethod!,
                              style: theme.textTheme.labelSmall),
                        ],
                        if (isPaid && entry.paidAt != null) ...[
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4),
                            child: Text('·',
                                style: theme.textTheme.labelSmall),
                          ),
                          Text(
                            '$paidLabel ${_dateFormat.format(entry.paidAt!)}',
                            style: theme.textTheme.labelSmall
                                ?.copyWith(color: AppColors.positive),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              // Amount
              Text(
                _currencyFormat.format(
                    isPaid ? (entry.paidAmount ?? entry.amount) : entry.amount),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isPaid ? AppColors.positive : null,
                ),
              ),
              const SizedBox(width: 8),
              // Action button
              if (!isPaid && onMarkAsPaid != null)
                IconButton(
                  icon: const Icon(Icons.check_circle_outline, size: 22),
                  color: AppColors.positive,
                  tooltip: 'Mark as paid',
                  onPressed: onMarkAsPaid,
                ),
              if (isPaid && onUndoPaid != null)
                IconButton(
                  icon: const Icon(Icons.undo, size: 20),
                  color: AppColors.textMuted,
                  tooltip: 'Undo payment',
                  onPressed: onUndoPaid,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Status Badge
// ---------------------------------------------------------------------------

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Mark as Paid Dialog
// ---------------------------------------------------------------------------

class _MarkAsPaidDialog extends StatefulWidget {
  const _MarkAsPaidDialog({required this.entry});
  final MonthlyEntry entry;

  @override
  State<_MarkAsPaidDialog> createState() => _MarkAsPaidDialogState();
}

class _MarkAsPaidDialogState extends State<_MarkAsPaidDialog> {
  late final TextEditingController _amountController;
  late final TextEditingController _noteController;
  String? _paymentMethod;
  late DateTime _paidAt;

  bool get _isIncome => widget.entry.type == EntryType.income;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
        text: widget.entry.amount.toStringAsFixed(2));
    _noteController = TextEditingController();
    _paidAt = DateTime.now();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _save() {
    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) return;

    final updated = widget.entry.copyWith(
      paid: true,
      paidAt: _paidAt,
      paidAmount: amount,
      paymentMethod: _paymentMethod,
      paymentNote:
          _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
    );
    Navigator.pop(context, updated);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final actionLabel = _isIncome ? 'Confirm Received' : 'Confirm Payment';

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _isIncome ? Icons.savings : Icons.payment,
                    color: AppColors.positive,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _isIncome
                          ? 'Mark "${widget.entry.name}" as Received'
                          : 'Pay "${widget.entry.name}"',
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Amount
              TextField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount (R\$)',
                  prefixText: 'R\$ ',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 16),
              // Payment date
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _paidAt,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setState(() => _paidAt = picked);
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: _isIncome ? 'Received Date' : 'Payment Date',
                    suffixIcon:
                        const Icon(Icons.calendar_today, size: 18),
                  ),
                  child: Text(
                    _dateFormat.format(_paidAt),
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Payment method
              DropdownButtonFormField<String>(
                initialValue: _paymentMethod,
                decoration: const InputDecoration(
                  labelText: 'Payment Method',
                ),
                items: _paymentMethods.map((m) {
                  return DropdownMenuItem(value: m, child: Text(m));
                }).toList(),
                onChanged: (v) => setState(() => _paymentMethod = v),
              ),
              const SizedBox(height: 16),
              // Notes
              TextField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Notes (optional)',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.check, size: 18),
                    label: Text(actionLabel),
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
