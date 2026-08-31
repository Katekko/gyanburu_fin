import 'package:flutter/material.dart';
import 'package:gyanburu_fin_client/gyanburu_fin_client.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import '../theme/app_theme.dart';

final _currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
final _dateFormat = DateFormat('dd/MM/yyyy');

/// Manual tracking of the Caju benefit wallets. Caju has no OFX export, so
/// spends and top-ups are recorded by hand and the balance is anchored to
/// the last reconciliation against the real Caju app.
class CajuScreen extends StatefulWidget {
  const CajuScreen({super.key});

  @override
  State<CajuScreen> createState() => _CajuScreenState();
}

class _CajuScreenState extends State<CajuScreen> {
  late DateTime _selectedMonth;
  List<WalletSummary> _summaries = [];
  List<FinancialTransaction> _transactions = [];
  List<Category> _categories = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = DateTime(now.year, now.month);
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      final results = await Future.wait([
        client.wallet.summaries(_selectedMonth),
        client.wallet.monthTransactions(_selectedMonth),
        client.category.list(),
      ]);
      setState(() {
        _summaries = results[0] as List<WalletSummary>;
        _transactions = results[1] as List<FinancialTransaction>;
        _categories = results[2] as List<Category>;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load Caju data: $e')),
        );
      }
    }
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

  Future<void> _runAction(Future<void> Function() action) async {
    try {
      await action();
      await _loadData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Caju action failed: $e')),
        );
      }
    }
  }

  Future<void> _showSpendDialog(BenefitWallet wallet) async {
    final result = await showDialog<_SpendInput>(
      context: context,
      builder: (_) => _SpendDialog(wallet: wallet, categories: _categories),
    );
    if (result == null) return;
    await _runAction(() => client.wallet.spend(
          wallet.slug,
          result.amount,
          result.merchantName,
          result.categoryId,
          result.occurredAt,
          result.description,
        ));
  }

  Future<void> _showTopupDialog(BenefitWallet wallet) async {
    final result = await showDialog<_AmountDateInput>(
      context: context,
      builder: (_) => _AmountDateDialog(
        title: 'Top up ${wallet.name}',
        confirmLabel: 'Top up',
        initialAmount: wallet.monthlyTopupAmount,
        helper: wallet.monthlyTopupAmount == null
            ? null
            : 'Default monthly top-up: '
                '${_currencyFormat.format(wallet.monthlyTopupAmount)}',
      ),
    );
    if (result == null) return;
    await _runAction(() => client.wallet.topup(
          wallet.slug,
          result.amount,
          result.occurredAt,
          null,
        ));
  }

  Future<void> _showReconcileDialog(BenefitWallet wallet) async {
    final result = await showDialog<_AmountDateInput>(
      context: context,
      builder: (_) => _AmountDateDialog(
        title: 'Reconcile ${wallet.name}',
        confirmLabel: 'Set balance',
        helper: 'Enter the balance shown in the Caju app. Entries recorded '
            'after this moment keep counting.',
        endOfDay: true,
      ),
    );
    if (result == null) return;
    await _runAction(() => client.wallet.setBalance(
          wallet.slug,
          result.amount,
          result.occurredAt,
        ));
  }

  Future<void> _showDefaultTopupDialog(BenefitWallet wallet) async {
    final result = await showDialog<_AmountDateInput>(
      context: context,
      builder: (_) => _AmountDateDialog(
        title: 'Default top-up for ${wallet.name}',
        confirmLabel: 'Save',
        initialAmount: wallet.monthlyTopupAmount,
        helper: 'Used as the suggested amount when topping up.',
        showDate: false,
      ),
    );
    if (result == null) return;
    await _runAction(
      () => client.wallet.setMonthlyTopup(wallet.slug, result.amount),
    );
  }

  Future<void> _deleteTransaction(FinancialTransaction tx) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete entry?'),
        content: Text(
          '${tx.displayName ?? tx.merchantName} — '
          '${_currencyFormat.format(tx.amount)}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await _runAction(() => client.wallet.deleteTransaction(tx.id!));
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
          Text('Caju', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 4),
          Text(
            'Benefit wallets, tracked by hand — Caju has no OFX export.',
            style: theme.textTheme.bodySmall
                ?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () => _changeMonth(-1),
              ),
              Text(
                DateFormat('MMMM yyyy').format(_selectedMonth),
                style: theme.textTheme.bodySmall,
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () => _changeMonth(1),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              for (final summary in _summaries)
                _WalletCard(
                  summary: summary,
                  onSpend: () => _showSpendDialog(summary.wallet),
                  onTopup: () => _showTopupDialog(summary.wallet),
                  onReconcile: () => _showReconcileDialog(summary.wallet),
                  onDefaultTopup: () =>
                      _showDefaultTopupDialog(summary.wallet),
                ),
            ],
          ),
          const SizedBox(height: 24),
          Text('Entries', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          if (_transactions.isEmpty)
            Text(
              'No Caju entries this month.',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: AppColors.textMuted),
            )
          else
            Card(
              child: Column(
                children: [
                  for (final tx in _transactions) ...[
                    _EntryRow(
                      tx: tx,
                      walletName: _summaries
                              .where((s) => s.wallet.id == tx.walletId)
                              .map((s) => s.wallet.name)
                              .firstOrNull ??
                          '?',
                      onDelete: () => _deleteTransaction(tx),
                    ),
                    if (tx != _transactions.last)
                      const Divider(height: 1),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _WalletCard extends StatelessWidget {
  const _WalletCard({
    required this.summary,
    required this.onSpend,
    required this.onTopup,
    required this.onReconcile,
    required this.onDefaultTopup,
  });

  final WalletSummary summary;
  final VoidCallback onSpend;
  final VoidCallback onTopup;
  final VoidCallback onReconcile;
  final VoidCallback onDefaultTopup;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wallet = summary.wallet;
    final isFood = wallet.slug == 'comida';

    return SizedBox(
      width: 340,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    isFood ? Icons.restaurant : Icons.home_work_outlined,
                    color: AppColors.vibrantOrange,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(wallet.name, style: theme.textTheme.titleMedium),
                  const Spacer(),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, size: 18),
                    onSelected: (value) {
                      if (value == 'reconcile') onReconcile();
                      if (value == 'default-topup') onDefaultTopup();
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                        value: 'reconcile',
                        child: Text('Reconcile balance…'),
                      ),
                      PopupMenuItem(
                        value: 'default-topup',
                        child: Text('Default monthly top-up…'),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                _currencyFormat.format(summary.balance),
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: summary.balance >= 0
                      ? AppColors.positive
                      : AppColors.negative,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Spent this month: '
                '${_currencyFormat.format(summary.monthSpent)}',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: AppColors.textSecondary),
              ),
              Text(
                'Topped up: '
                '${_currencyFormat.format(summary.monthToppedUp)}',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  FilledButton.icon(
                    onPressed: onSpend,
                    icon: const Icon(Icons.remove, size: 16),
                    label: const Text('Spend'),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: onTopup,
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Top up'),
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

class _EntryRow extends StatelessWidget {
  const _EntryRow({
    required this.tx,
    required this.walletName,
    required this.onDelete,
  });

  final FinancialTransaction tx;
  final String walletName;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isExpense = tx.kind == 'expense';
    final signed = isExpense ? -tx.amount : tx.amount;

    return ListTile(
      dense: true,
      leading: Icon(
        isExpense ? Icons.shopping_bag_outlined : Icons.add_card,
        size: 18,
        color: isExpense ? AppColors.textSecondary : AppColors.positive,
      ),
      title: Text(tx.displayName ?? tx.merchantName),
      subtitle: Text(
        '$walletName · ${_dateFormat.format(tx.occurredAt.toLocal())}'
        '${tx.category.isEmpty ? '' : ' · ${tx.category}'}',
        style: theme.textTheme.labelSmall
            ?.copyWith(color: AppColors.textMuted),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _currencyFormat.format(signed),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isExpense ? AppColors.textPrimary : AppColors.positive,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 16),
            color: AppColors.textMuted,
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}

class _SpendInput {
  const _SpendInput({
    required this.amount,
    required this.merchantName,
    this.categoryId,
    this.occurredAt,
    this.description,
  });

  final double amount;
  final String merchantName;
  final int? categoryId;
  final DateTime? occurredAt;
  final String? description;
}

class _SpendDialog extends StatefulWidget {
  const _SpendDialog({required this.wallet, required this.categories});

  final BenefitWallet wallet;
  final List<Category> categories;

  @override
  State<_SpendDialog> createState() => _SpendDialogState();
}

class _SpendDialogState extends State<_SpendDialog> {
  final _amountController = TextEditingController();
  final _merchantController = TextEditingController();
  final _descriptionController = TextEditingController();
  int? _categoryId;
  DateTime? _pickedDate;

  @override
  void dispose() {
    _amountController.dispose();
    _merchantController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _pickedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) setState(() => _pickedDate = picked);
  }

  void _submit() {
    final amount =
        double.tryParse(_amountController.text.replaceAll(',', '.'));
    final merchant = _merchantController.text.trim();
    if (amount == null || amount <= 0 || merchant.isEmpty) return;
    final description = _descriptionController.text.trim();
    Navigator.pop(
      context,
      _SpendInput(
        amount: amount,
        merchantName: merchant,
        categoryId: _categoryId,
        occurredAt: _pickedDate,
        description: description.isEmpty ? null : description,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Spend from ${widget.wallet.name}'),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _amountController,
              autofocus: true,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: 'R\$ ',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _merchantController,
              decoration: const InputDecoration(labelText: 'Merchant'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int?>(
              initialValue: _categoryId,
              decoration: const InputDecoration(labelText: 'Category'),
              items: [
                const DropdownMenuItem<int?>(
                  value: null,
                  child: Text('Auto (merchant rule)'),
                ),
                for (final c in widget.categories)
                  DropdownMenuItem<int?>(value: c.id, child: Text(c.name)),
              ],
              onChanged: (value) => setState(() => _categoryId = value),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              decoration:
                  const InputDecoration(labelText: 'Note (optional)'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  _pickedDate == null
                      ? 'Date: today'
                      : 'Date: ${_dateFormat.format(_pickedDate!)}',
                ),
                const Spacer(),
                TextButton(
                  onPressed: _pickDate,
                  child: const Text('Change'),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Spend')),
      ],
    );
  }
}

class _AmountDateInput {
  const _AmountDateInput({required this.amount, this.occurredAt});

  final double amount;
  final DateTime? occurredAt;
}

class _AmountDateDialog extends StatefulWidget {
  const _AmountDateDialog({
    required this.title,
    required this.confirmLabel,
    this.initialAmount,
    this.helper,
    this.showDate = true,
    this.endOfDay = false,
  });

  final String title;
  final String confirmLabel;
  final double? initialAmount;
  final String? helper;
  final bool showDate;

  /// When a past date is picked, anchor at the end of that day (used by
  /// reconcile so the day's own entries stay behind the anchor).
  final bool endOfDay;

  @override
  State<_AmountDateDialog> createState() => _AmountDateDialogState();
}

class _AmountDateDialogState extends State<_AmountDateDialog> {
  late final TextEditingController _amountController;
  DateTime? _pickedDate;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.initialAmount?.toStringAsFixed(2) ?? '',
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _pickedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) setState(() => _pickedDate = picked);
  }

  void _submit() {
    final amount =
        double.tryParse(_amountController.text.replaceAll(',', '.'));
    if (amount == null) return;
    final date = _pickedDate;
    Navigator.pop(
      context,
      _AmountDateInput(
        amount: amount,
        occurredAt: date == null
            ? null
            : widget.endOfDay
                ? DateTime(date.year, date.month, date.day, 23, 59, 59)
                : date,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.helper != null) ...[
              Text(
                widget.helper!,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 12),
            ],
            TextField(
              controller: _amountController,
              autofocus: true,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: 'R\$ ',
              ),
            ),
            if (widget.showDate) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    _pickedDate == null
                        ? 'Date: today'
                        : 'Date: ${_dateFormat.format(_pickedDate!)}',
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _pickDate,
                    child: const Text('Change'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: Text(widget.confirmLabel)),
      ],
    );
  }
}
