import 'package:flutter/material.dart';
import 'package:gyanburu_fin_client/gyanburu_fin_client.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import '../mock/mock_data.dart';
import '../theme/app_theme.dart';

final _currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  late DateTime _selectedMonth;
  List<BudgetCategory> _budgets = [];
  List<IncomeSource> _incomes = [];
  List<FinancialTransaction> _transactions = [];
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
      final month = _selectedMonth;
      final results = await Future.wait([
        client.budget.listByMonth(month),
        client.income.listByMonth(month),
        client.transaction.listByMonth(month),
      ]);
      setState(() {
        _budgets = results[0] as List<BudgetCategory>;
        _incomes = results[1] as List<IncomeSource>;
        _transactions = results[2] as List<FinancialTransaction>;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load budget data: $e')),
        );
      }
    }
  }

  double _spentInCategory(String category) => _transactions
      .where((t) => t.category == category && t.amount > 0)
      .fold(0.0, (s, t) => s + t.amount);

  void _changeMonth(int delta) {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month + delta,
      );
    });
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalIncome = _incomes.fold(0.0, (s, i) => s + i.amount);

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Monthly Budget & Incomes',
              style: theme.textTheme.headlineMedium),
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
                      Icon(Icons.trending_up,
                          color: AppColors.positive, size: 20),
                      const SizedBox(width: 8),
                      Text('Income Sources',
                          style: theme.textTheme.titleMedium),
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
                  if (_incomes.isEmpty)
                    Text('No income sources for this month.',
                        style: theme.textTheme.bodySmall),
                  ..._incomes.map(
                    (income) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.positive.withValues(alpha: 0.15),
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
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Budget categories
          Text('Budget Categories', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          if (_budgets.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text('No budget categories for this month.',
                    style: theme.textTheme.bodySmall),
              ),
            ),
          ..._budgets.map((budget) {
            final spent = _spentInCategory(budget.name);
            final ratio = budget.limitAmount > 0
                ? (spent / budget.limitAmount).clamp(0.0, 1.0)
                : 0.0;
            final isOverBudget = spent > budget.limitAmount;
            final iconData =
                MockData.categoryIconMap[budget.icon] ?? Icons.category;

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
                            color: AppColors.deepPurple.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(iconData,
                              color: AppColors.deepPurple, size: 18),
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
                          isOverBudget
                              ? AppColors.negative
                              : AppColors.deepPurple,
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
