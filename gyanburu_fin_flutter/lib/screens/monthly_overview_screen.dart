import 'package:flutter/material.dart';
import 'package:gyanburu_fin_client/gyanburu_fin_client.dart';
import 'package:intl/intl.dart';

import '../mock/mock_data.dart';
import '../theme/app_theme.dart';

final _currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

class MonthlyOverviewScreen extends StatefulWidget {
  const MonthlyOverviewScreen({super.key});

  @override
  State<MonthlyOverviewScreen> createState() => _MonthlyOverviewScreenState();
}

class _MonthlyOverviewScreenState extends State<MonthlyOverviewScreen> {
  late DateTime _selectedMonth;
  late List<MonthlyEntry> _entries;
  late List<Category> _categories;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = DateTime(now.year, now.month);
    _entries = List.from(MockData.monthlyEntries);
    _categories = List.from(MockData.categories);
  }

  String get _monthKey =>
      '${_selectedMonth.year}-${_selectedMonth.month.toString().padLeft(2, '0')}';

  List<MonthlyEntry> get _monthEntries =>
      _entries.where((e) => e.month == _monthKey).toList();

  List<MonthlyEntry> get _incomeEntries =>
      _monthEntries.where((e) => e.type == EntryType.income).toList();

  List<MonthlyEntry> get _expenseEntries =>
      _monthEntries.where((e) => e.type == EntryType.expense).toList();

  double get _totalIncome =>
      _incomeEntries.fold(0.0, (s, e) => s + e.amount);

  double get _totalExpenses =>
      _expenseEntries.fold(0.0, (s, e) => s + e.amount);

  double get _balance => _totalIncome - _totalExpenses;

  int get _unconfirmedCount =>
      _monthEntries.where((e) => e.variable && !e.confirmed).length;

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
  }

  void _addEntry(EntryType type) async {
    final result = await showDialog<MonthlyEntry>(
      context: context,
      builder: (_) => _EntryDialog(
        type: type,
        month: _monthKey,
        categories: _categories,
        onManageCategories: _openCategoryManager,
      ),
    );
    if (result != null) {
      setState(() {
        _entries.add(result.copyWith(
          id: (_entries.map((e) => e.id ?? 0).reduce((a, b) => a > b ? a : b)) + 1,
        ));
      });
    }
  }

  void _editEntry(MonthlyEntry entry) async {
    final result = await showDialog<MonthlyEntry>(
      context: context,
      builder: (_) => _EntryDialog(
        type: entry.type,
        month: _monthKey,
        categories: _categories,
        existing: entry,
        onManageCategories: _openCategoryManager,
      ),
    );
    if (result != null) {
      setState(() {
        final idx = _entries.indexWhere((e) => e.id == entry.id);
        if (idx != -1) _entries[idx] = result;
      });
    }
  }

  void _deleteEntry(MonthlyEntry entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete entry'),
        content: Text('Remove "${entry.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Delete',
                style: TextStyle(color: AppColors.negative)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      setState(() => _entries.removeWhere((e) => e.id == entry.id));
    }
  }

  void _toggleConfirmed(MonthlyEntry entry) {
    setState(() {
      final idx = _entries.indexWhere((e) => e.id == entry.id);
      if (idx != -1) {
        _entries[idx] = _entries[idx].copyWith(confirmed: !entry.confirmed);
      }
    });
  }

  void _openCategoryManager() async {
    final result = await showDialog<List<Category>>(
      context: context,
      builder: (_) => _CategoryManagerDialog(categories: _categories),
    );
    if (result != null) {
      setState(() => _categories = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Text('Monthly Overview',
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
          // Month picker
          _MonthPicker(
            month: _selectedMonth,
            onPrevious: () => _changeMonth(-1),
            onNext: () => _changeMonth(1),
          ),
          const SizedBox(height: 20),
          // Unconfirmed warning
          if (_unconfirmedCount > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.vibrantOrange.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        color: AppColors.vibrantOrange, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      '$_unconfirmedCount variable ${_unconfirmedCount == 1 ? 'item needs' : 'items need'} value confirmation',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: AppColors.vibrantOrange),
                    ),
                  ],
                ),
              ),
            ),
          // Summary bar
          _SummaryBar(
            totalIncome: _totalIncome,
            totalExpenses: _totalExpenses,
            balance: _balance,
          ),
          const SizedBox(height: 24),
          // Two columns
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Income column
              Expanded(
                child: _EntryColumn(
                  title: 'Income',
                  icon: Icons.trending_up,
                  accentColor: AppColors.positive,
                  entries: _incomeEntries,
                  total: _totalIncome,
                  categoryFor: _categoryFor,
                  colorFor: _colorFor,
                  iconFor: _iconFor,
                  onAdd: () => _addEntry(EntryType.income),
                  onEdit: _editEntry,
                  onDelete: _deleteEntry,
                  onToggleConfirmed: _toggleConfirmed,
                ),
              ),
              const SizedBox(width: 20),
              // Expense column
              Expanded(
                child: _EntryColumn(
                  title: 'Expenses',
                  icon: Icons.trending_down,
                  accentColor: AppColors.negative,
                  entries: _expenseEntries,
                  total: _totalExpenses,
                  categoryFor: _categoryFor,
                  colorFor: _colorFor,
                  iconFor: _iconFor,
                  onAdd: () => _addEntry(EntryType.expense),
                  onEdit: _editEntry,
                  onDelete: _deleteEntry,
                  onToggleConfirmed: _toggleConfirmed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Month Picker
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
// Summary Bar
// ---------------------------------------------------------------------------

class _SummaryBar extends StatelessWidget {
  const _SummaryBar({
    required this.totalIncome,
    required this.totalExpenses,
    required this.balance,
  });
  final double totalIncome;
  final double totalExpenses;
  final double balance;

  @override
  Widget build(BuildContext context) {
    final total = totalIncome + totalExpenses;
    final incomeFraction = total > 0 ? totalIncome / total : 0.5;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _SummaryChip(
                  label: 'Income',
                  value: _currencyFormat.format(totalIncome),
                  color: AppColors.positive,
                ),
                const SizedBox(width: 16),
                _SummaryChip(
                  label: 'Expenses',
                  value: _currencyFormat.format(totalExpenses),
                  color: AppColors.negative,
                ),
                const SizedBox(width: 16),
                _SummaryChip(
                  label: 'Balance',
                  value: _currencyFormat.format(balance),
                  color: balance >= 0 ? AppColors.positive : AppColors.negative,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Stacked bar
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedBox(
                height: 12,
                child: Row(
                  children: [
                    Expanded(
                      flex: (incomeFraction * 100).round(),
                      child: Container(color: AppColors.positive),
                    ),
                    Expanded(
                      flex: ((1 - incomeFraction) * 100).round(),
                      child: Container(color: AppColors.negative),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.labelSmall),
          const SizedBox(height: 4),
          Text(value,
              style: theme.textTheme.titleMedium
                  ?.copyWith(color: color, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Entry Column (Income or Expenses)
// ---------------------------------------------------------------------------

class _EntryColumn extends StatelessWidget {
  const _EntryColumn({
    required this.title,
    required this.icon,
    required this.accentColor,
    required this.entries,
    required this.total,
    required this.categoryFor,
    required this.colorFor,
    required this.iconFor,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleConfirmed,
  });
  final String title;
  final IconData icon;
  final Color accentColor;
  final List<MonthlyEntry> entries;
  final double total;
  final Category? Function(int) categoryFor;
  final Color Function(Category?) colorFor;
  final IconData Function(Category?) iconFor;
  final VoidCallback onAdd;
  final void Function(MonthlyEntry) onEdit;
  final void Function(MonthlyEntry) onDelete;
  final void Function(MonthlyEntry) onToggleConfirmed;

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
                Icon(icon, color: accentColor, size: 20),
                const SizedBox(width: 8),
                Text(title, style: theme.textTheme.titleMedium),
                const Spacer(),
                Text(
                  _currencyFormat.format(total),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (entries.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text('No entries yet',
                      style: theme.textTheme.bodySmall),
                ),
              )
            else
              ...entries.map((entry) {
                final cat = categoryFor(entry.categoryId);
                return _EntryRow(
                  entry: entry,
                  category: cat,
                  color: colorFor(cat),
                  icon: iconFor(cat),
                  onEdit: () => onEdit(entry),
                  onDelete: () => onDelete(entry),
                  onToggleConfirmed: () => onToggleConfirmed(entry),
                );
              }),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add, size: 18),
                label: Text('Add $title'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Entry Row
// ---------------------------------------------------------------------------

class _EntryRow extends StatelessWidget {
  const _EntryRow({
    required this.entry,
    required this.category,
    required this.color,
    required this.icon,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleConfirmed,
  });
  final MonthlyEntry entry;
  final Category? category;
  final Color color;
  final IconData icon;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleConfirmed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final needsConfirmation = entry.variable && !entry.confirmed;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: needsConfirmation
            ? AppColors.vibrantOrange.withValues(alpha: 0.06)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onEdit,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                // Category icon
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
                // Name + badges
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entry.name,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w500)),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          if (category != null)
                            Text(category!.name,
                                style: theme.textTheme.labelSmall),
                          if (entry.recurrent) ...[
                            if (category != null)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Text('·',
                                    style: theme.textTheme.labelSmall),
                              ),
                            Icon(Icons.repeat,
                                size: 12, color: AppColors.textMuted),
                            const SizedBox(width: 2),
                            Text('Recurrent',
                                style: theme.textTheme.labelSmall),
                          ],
                          if (entry.variable) ...[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: Text('·',
                                  style: theme.textTheme.labelSmall),
                            ),
                            Icon(Icons.swap_vert,
                                size: 12,
                                color: needsConfirmation
                                    ? AppColors.vibrantOrange
                                    : AppColors.textMuted),
                            const SizedBox(width: 2),
                            Text('Variable',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: needsConfirmation
                                      ? AppColors.vibrantOrange
                                      : null,
                                )),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                // Confirm button for variable items
                if (needsConfirmation)
                  IconButton(
                    icon: Icon(Icons.check_circle_outline,
                        color: AppColors.vibrantOrange, size: 20),
                    tooltip: 'Confirm value',
                    onPressed: onToggleConfirmed,
                  ),
                // Amount
                Text(
                  _currencyFormat.format(entry.amount),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: needsConfirmation ? AppColors.vibrantOrange : null,
                  ),
                ),
                // Delete
                const SizedBox(width: 4),
                IconButton(
                  icon: Icon(Icons.close,
                      size: 16, color: AppColors.textMuted),
                  tooltip: 'Delete',
                  onPressed: onDelete,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Entry CRUD Dialog
// ---------------------------------------------------------------------------

class _EntryDialog extends StatefulWidget {
  const _EntryDialog({
    required this.type,
    required this.month,
    required this.categories,
    this.existing,
    required this.onManageCategories,
  });
  final EntryType type;
  final String month;
  final List<Category> categories;
  final MonthlyEntry? existing;
  final VoidCallback onManageCategories;

  @override
  State<_EntryDialog> createState() => _EntryDialogState();
}

class _EntryDialogState extends State<_EntryDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _amountController;
  late int _categoryId;
  late bool _recurrent;
  late bool _variable;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.existing?.name ?? '');
    _amountController = TextEditingController(
        text: widget.existing?.amount.toStringAsFixed(2) ?? '');
    _categoryId =
        widget.existing?.categoryId ?? widget.categories.first.id!;
    _recurrent = widget.existing?.recurrent ?? true;
    _variable = widget.existing?.variable ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final entry = MonthlyEntry(
      id: widget.existing?.id,
      userId: UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
      categoryId: _categoryId,
      name: _nameController.text.trim(),
      type: widget.type,
      amount: double.parse(_amountController.text.trim()),
      month: widget.month,
      recurrent: _recurrent,
      variable: _variable,
      confirmed: !_variable,
    );
    Navigator.pop(context, entry);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIncome = widget.type == EntryType.income;
    final accentColor = isIncome ? AppColors.positive : AppColors.negative;
    final title = _isEditing
        ? 'Edit ${isIncome ? 'Income' : 'Expense'}'
        : 'New ${isIncome ? 'Income' : 'Expense'}';

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(isIncome ? Icons.trending_up : Icons.trending_down,
                        color: accentColor, size: 22),
                    const SizedBox(width: 8),
                    Text(title, style: theme.textTheme.titleLarge),
                  ],
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'Amount (R\$)',
                    prefixText: 'R\$ ',
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    if (double.tryParse(v.trim()) == null) return 'Invalid';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Category dropdown
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        initialValue: _categoryId,
                        decoration:
                            const InputDecoration(labelText: 'Category'),
                        items: widget.categories.map((cat) {
                          final icon =
                              MockData.categoryIconMap[cat.icon] ??
                                  Icons.category;
                          final color = Color(
                              int.parse('FF${cat.color}', radix: 16));
                          return DropdownMenuItem(
                            value: cat.id,
                            child: Row(
                              children: [
                                Icon(icon, size: 18, color: color),
                                const SizedBox(width: 8),
                                Text(cat.name),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (v) {
                          if (v != null) setState(() => _categoryId = v);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline, size: 20),
                      tooltip: 'Manage Categories',
                      onPressed: () {
                        Navigator.pop(context);
                        widget.onManageCategories();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Checkboxes
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        value: _recurrent,
                        onChanged: (v) =>
                            setState(() => _recurrent = v ?? false),
                        title: const Text('Recurrent'),
                        subtitle: const Text('Appears every month'),
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        value: _variable,
                        onChanged: (v) =>
                            setState(() => _variable = v ?? false),
                        title: const Text('Variable'),
                        subtitle: const Text('Value changes monthly'),
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                  ],
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
                    ElevatedButton(
                      onPressed: _save,
                      child: Text(_isEditing ? 'Save' : 'Add'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Category Manager Dialog
// ---------------------------------------------------------------------------

class _CategoryManagerDialog extends StatefulWidget {
  const _CategoryManagerDialog({required this.categories});
  final List<Category> categories;

  @override
  State<_CategoryManagerDialog> createState() => _CategoryManagerDialogState();
}

class _CategoryManagerDialogState extends State<_CategoryManagerDialog> {
  late List<Category> _categories;

  @override
  void initState() {
    super.initState();
    _categories = List.from(widget.categories);
  }

  void _addCategory() async {
    final result = await showDialog<Category>(
      context: context,
      builder: (_) => _CategoryEditDialog(
        nextId: (_categories.map((c) => c.id ?? 0).reduce((a, b) => a > b ? a : b)) + 1,
      ),
    );
    if (result != null) {
      setState(() => _categories.add(result));
    }
  }

  void _editCategory(int index) async {
    final result = await showDialog<Category>(
      context: context,
      builder: (_) => _CategoryEditDialog(existing: _categories[index]),
    );
    if (result != null) {
      setState(() => _categories[index] = result);
    }
  }

  void _deleteCategory(int index) {
    setState(() => _categories.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 500),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.category, size: 22),
                  const SizedBox(width: 8),
                  Text('Manage Categories',
                      style: theme.textTheme.titleLarge),
                ],
              ),
              const SizedBox(height: 20),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _categories.length,
                  itemBuilder: (ctx, i) {
                    final cat = _categories[i];
                    final icon =
                        MockData.categoryIconMap[cat.icon] ?? Icons.category;
                    final color =
                        Color(int.parse('FF${cat.color}', radix: 16));

                    return ListTile(
                      leading: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(icon, color: color, size: 18),
                      ),
                      title: Text(cat.name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, size: 18),
                            onPressed: () => _editCategory(i),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete,
                                size: 18, color: AppColors.negative),
                            onPressed: () => _deleteCategory(i),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: _addCategory,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('New Category'),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, _categories),
                    child: const Text('Done'),
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

// ---------------------------------------------------------------------------
// Category Edit Dialog
// ---------------------------------------------------------------------------

class _CategoryEditDialog extends StatefulWidget {
  const _CategoryEditDialog({this.existing, this.nextId});
  final Category? existing;
  final int? nextId;

  @override
  State<_CategoryEditDialog> createState() => _CategoryEditDialogState();
}

class _CategoryEditDialogState extends State<_CategoryEditDialog> {
  late final TextEditingController _nameController;
  late String _selectedIcon;
  late String _selectedColor;

  static const _availableIcons = [
    'work', 'computer', 'trending_up', 'home', 'bolt', 'directions_car',
    'local_hospital', 'movie', 'school', 'restaurant', 'shopping_bag',
    'attach_money', 'credit_card', 'pets', 'fitness_center', 'flight',
    'phone_android', 'child_care', 'build',
  ];

  static const _availableColors = [
    '4CAF50', '66BB6A', '26A69A', '42A5F5', '5C6BC0', 'AB47BC',
    'EF5350', 'FF7043', 'FFA726', 'FFCA28', '29B6F6', '78909C',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existing?.name ?? '');
    _selectedIcon = widget.existing?.icon ?? _availableIcons.first;
    _selectedColor = widget.existing?.color ?? _availableColors.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final cat = Category(
      id: widget.existing?.id ?? widget.nextId,
      userId: UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
      name: name,
      icon: _selectedIcon,
      color: _selectedColor,
    );
    Navigator.pop(context, cat);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.existing != null;

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(isEditing ? 'Edit Category' : 'New Category',
                  style: theme.textTheme.titleLarge),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 20),
              Text('Icon', style: theme.textTheme.labelMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _availableIcons.map((iconKey) {
                  final iconData =
                      MockData.categoryIconMap[iconKey] ?? Icons.category;
                  final isSelected = _selectedIcon == iconKey;
                  return InkWell(
                    onTap: () => setState(() => _selectedIcon = iconKey),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.deepPurple.withValues(alpha: 0.2)
                            : AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(iconData,
                          size: 20,
                          color: isSelected
                              ? AppColors.deepPurple
                              : AppColors.textSecondary),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Text('Color', style: theme.textTheme.labelMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _availableColors.map((hex) {
                  final color = Color(int.parse('FF$hex', radix: 16));
                  final isSelected = _selectedColor == hex;
                  return InkWell(
                    onTap: () => setState(() => _selectedColor = hex),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8),
                        border: isSelected
                            ? Border.all(color: Colors.white, width: 2)
                            : null,
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
                    child: Text(isEditing ? 'Save' : 'Create'),
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
