import 'package:flutter/material.dart';
import 'package:gyanburu_fin_client/gyanburu_fin_client.dart';
import 'package:intl/intl.dart';

import 'icon_map.dart';
import '../theme/app_theme.dart';

final _currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

class TransactionEditResult {
  final Category? category;
  final String? displayName;
  final bool propagateDisplayName;
  final bool propagateCategory;

  TransactionEditResult({
    this.category,
    this.displayName,
    required this.propagateDisplayName,
    required this.propagateCategory,
  });
}

class TransactionEditDialog extends StatefulWidget {
  const TransactionEditDialog({
    super.key,
    required this.transaction,
    required this.categories,
    required this.initialPropagateDisplayName,
    required this.initialPropagateCategory,
    this.existingDisplayName,
  });
  final FinancialTransaction transaction;
  final List<Category> categories;
  final String? existingDisplayName;
  final bool initialPropagateDisplayName;
  final bool initialPropagateCategory;

  @override
  State<TransactionEditDialog> createState() => _TransactionEditDialogState();
}

class _TransactionEditDialogState extends State<TransactionEditDialog> {
  late final TextEditingController _displayNameController;
  Category? _selectedCategory;
  late bool _propagateDisplayName;
  late bool _propagateCategory;

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController(
      text: widget.existingDisplayName ?? '',
    );
    _propagateDisplayName = widget.initialPropagateDisplayName;
    _propagateCategory = widget.initialPropagateCategory;
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
      TransactionEditResult(
        category: _selectedCategory,
        displayName: displayName.isEmpty ? null : displayName,
        propagateDisplayName: _propagateDisplayName,
        propagateCategory: _propagateCategory,
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
              const SizedBox(height: 8),
              // Category propagation toggle
              InkWell(
                onTap: _selectedCategory == null
                    ? null
                    : () => setState(() {
                          _propagateCategory = !_propagateCategory;
                        }),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _propagateCategory,
                        onChanged: _selectedCategory == null
                            ? null
                            : (v) => setState(() {
                                  _propagateCategory = v ?? false;
                                }),
                        visualDensity: VisualDensity.compact,
                      ),
                      Expanded(
                        child: Text(
                          'Apply this category to other ${tx.merchantName} transactions',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: _selectedCategory == null
                                ? AppColors.textMuted
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
