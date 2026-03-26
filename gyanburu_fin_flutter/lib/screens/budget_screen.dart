import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../mock/mock_data.dart';
import '../theme/app_theme.dart';

final _currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final budgets = MockData.budgetCategories;
    final incomes = MockData.incomeSources;
    final totalIncome = incomes.fold(0.0, (s, i) => s + i.amount);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Monthly Budget & Incomes', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            DateFormat('MMMM yyyy').format(DateTime.now()),
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 24),
          // Income section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.trending_up, color: AppColors.positive, size: 20),
                      const SizedBox(width: 8),
                      Text('Income Sources', style: theme.textTheme.titleMedium),
                      const Spacer(),
                      Text(
                        _currencyFormat.format(totalIncome),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: AppColors.positive,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...incomes.map((income) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.positive.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            income.type.name.toUpperCase(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppColors.positive,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            income.name,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                        Text(
                          _currencyFormat.format(income.amount),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Budget categories
          Text('Budget Categories', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          ...budgets.map((budget) {
            final spent = MockData.spentInCategory(budget.name);
            final ratio = budget.limitAmount > 0
                ? (spent / budget.limitAmount).clamp(0.0, 1.0)
                : 0.0;
            final isOverBudget = spent > budget.limitAmount;
            final color = MockData.categoryColors[budget.name] ??
                AppColors.deepPurple;
            final icon = MockData.categoryIcons[budget.name] ??
                Icons.category;

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                          child: Text(
                            budget.name,
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                        Text(
                          '${_currencyFormat.format(spent)} / ${_currencyFormat.format(budget.limitAmount)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isOverBudget
                                ? AppColors.negative
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: ratio,
                        minHeight: 6,
                        backgroundColor: AppColors.surfaceElevated,
                        valueColor: AlwaysStoppedAnimation(
                          isOverBudget ? AppColors.negative : color,
                        ),
                      ),
                    ),
                    if (isOverBudget) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Over budget by ${_currencyFormat.format(spent - budget.limitAmount)}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColors.negative,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
