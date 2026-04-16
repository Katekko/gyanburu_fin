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

  List<MonthlyEntry> get _expenseEntries =>
      _entries.where((e) => e.type == EntryType.expense).toList();

  double get _totalIncome => _transactions
      .where((t) => t.kind == 'income')
      .fold(0.0, (s, t) => s + t.amount);

  double get _totalBudgetedExpenses =>
      _expenseEntries.fold(0.0, (s, e) => s + e.amount);

  double get _totalCardSpending => _transactions
      .where((t) => t.kind == 'expense')
      .fold(0.0, (s, t) => s + t.amount);

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

  /// Spending by category from imported transactions (expenses only)
  List<FinancialTransaction> get _expenseTransactions => _transactions
      .where((t) => t.kind != 'income' && t.kind != 'fatura_payment')
      .toList();

  double get _totalExpenseSpending =>
      _expenseTransactions.fold(0.0, (s, t) => s + t.amount);

  Map<String, double> get _transactionSpendingByCategory {
    final Map<String, double> result = {};
    for (final t in _expenseTransactions) {
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
                  label: 'Expenses',
                  value: _currencyFormat.format(_totalCardSpending),
                  color: AppColors.negative,
                  icon: Icons.trending_down,
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
                  total: _totalExpenseSpending,
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

class _SpendingChart extends StatefulWidget {
  const _SpendingChart({
    required this.spending,
    required this.colorMap,
    required this.total,
  });

  final Map<String, double> spending;
  final Map<String, Color> colorMap;
  final double total;

  @override
  State<_SpendingChart> createState() => _SpendingChartState();
}

class _SpendingChartState extends State<_SpendingChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animCtrl;
  late final Animation<double> _animValue;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animValue = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic);
    if (widget.spending.isNotEmpty) _animCtrl.forward();
  }

  @override
  void didUpdateWidget(_SpendingChart old) {
    super.didUpdateWidget(old);
    if (widget.spending.isNotEmpty && !_animCtrl.isCompleted) {
      _animCtrl.forward();
    }
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  void _onTapCategory(String? category) {
    setState(() {
      _selectedCategory = _selectedCategory == category ? null : category;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spending = widget.spending;
    final colorMap = widget.colorMap;
    final total = widget.total;

    // Sort by amount descending
    final sorted = spending.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final maxAmount = sorted.isEmpty ? 0.0 : sorted.first.value;

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
              GestureDetector(
                onTapUp: (details) {
                  // Tapping the chart area but not a segment => deselect
                  _onTapCategory(null);
                },
                child: SizedBox(
                  height: 200,
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _animValue,
                      builder: (context, _) => _DonutChart(
                        spending: spending,
                        colorMap: colorMap,
                        total: total,
                        progress: _animValue.value,
                        selectedCategory: _selectedCategory,
                        onTapCategory: _onTapCategory,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ...sorted.map((e) {
                final pct = total > 0 ? (e.value / total * 100) : 0;
                final color = colorMap[e.key] ?? AppColors.deepPurple;
                final isSelected = _selectedCategory == e.key;
                final isDimmed =
                    _selectedCategory != null && !isSelected;
                final barRatio =
                    maxAmount > 0 ? e.value / maxAmount : 0.0;
                final isUncategorized = e.key == 'Uncategorized';

                return GestureDetector(
                  onTap: () => _onTapCategory(e.key),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isDimmed ? 0.35 : 1.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              if (isUncategorized)
                                _HatchedSwatch(color: color, size: 12)
                              else
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
                                child: Text(
                                  e.key,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight:
                                        isSelected ? FontWeight.w600 : null,
                                  ),
                                ),
                              ),
                              Text(
                                _currencyFormat.format(e.value),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight:
                                      isSelected ? FontWeight.w600 : null,
                                ),
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
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: SizedBox(
                              height: 4,
                              child: AnimatedFractionallySizedBox(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeOut,
                                alignment: Alignment.centerLeft,
                                widthFactor: barRatio.clamp(0.0, 1.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isUncategorized
                                        ? null
                                        : color.withValues(alpha: isSelected ? 1.0 : 0.6),
                                    gradient: isUncategorized
                                        ? LinearGradient(
                                            colors: [
                                              color.withValues(alpha: 0.6),
                                              color.withValues(alpha: 0.3),
                                              color.withValues(alpha: 0.6),
                                            ],
                                            stops: const [0, 0.5, 1],
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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

/// Small 12x12 swatch with diagonal hatching for "Uncategorized"
class _HatchedSwatch extends StatelessWidget {
  const _HatchedSwatch({required this.color, required this.size});
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _HatchedSwatchPainter(color),
    );
  }
}

class _HatchedSwatchPainter extends CustomPainter {
  _HatchedSwatchPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(3),
    );
    canvas.clipRRect(rrect);
    // background
    canvas.drawRRect(
      rrect,
      Paint()..color = color.withValues(alpha: 0.3),
    );
    // diagonal lines
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    const step = 4.0;
    for (double i = -size.height; i < size.width; i += step) {
      canvas.drawLine(Offset(i, size.height), Offset(i + size.height, 0), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Animated donut chart with center label, tap-to-highlight, and hatched uncategorized segment
class _DonutChart extends StatelessWidget {
  const _DonutChart({
    required this.spending,
    required this.colorMap,
    required this.total,
    required this.progress,
    this.selectedCategory,
    this.onTapCategory,
  });
  final Map<String, double> spending;
  final Map<String, Color> colorMap;
  final double total;
  final double progress;
  final String? selectedCategory;
  final ValueChanged<String?>? onTapCategory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTapUp: (details) {
        // Hit-test segments
        final box = context.findRenderObject() as RenderBox;
        final local = details.localPosition;
        final center = Offset(box.size.width / 2, box.size.height / 2);
        final radius = min(box.size.width, box.size.height) / 2;
        final strokeWidth = radius * 0.35;
        final dx = local.dx - center.dx;
        final dy = local.dy - center.dy;
        final dist = sqrt(dx * dx + dy * dy);
        final innerR = radius - strokeWidth;
        if (dist < innerR || dist > radius) {
          onTapCategory?.call(null);
          return;
        }
        var angle = atan2(dy, dx);
        if (angle < -pi / 2) angle += 2 * pi;
        angle += pi / 2;
        if (angle > 2 * pi) angle -= 2 * pi;

        var start = 0.0;
        for (final entry in spending.entries) {
          final sweep = (entry.value / total) * 2 * pi;
          if (angle >= start && angle < start + sweep) {
            onTapCategory?.call(entry.key);
            return;
          }
          start += sweep;
        }
        onTapCategory?.call(null);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(180, 180),
            painter: _DonutPainter(
              spending,
              colorMap,
              progress,
              selectedCategory,
            ),
          ),
          // Center label
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _currencyFormat.format(total),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'Total',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  _DonutPainter(
    this.spending,
    this.colorMap,
    this.progress,
    this.selectedCategory,
  );
  final Map<String, double> spending;
  final Map<String, Color> colorMap;
  final double progress;
  final String? selectedCategory;

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

    // Draw track ring
    canvas.drawCircle(
      center,
      radius - strokeWidth / 2,
      Paint()
        ..color = AppColors.surfaceElevated
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    final sweepLimit = 2 * pi * progress;
    var startAngle = -pi / 2;
    for (final entry in spending.entries) {
      final sweep = (entry.value / total) * 2 * pi;
      final clippedSweep = (startAngle + pi / 2 + sweep <= sweepLimit)
          ? sweep
          : max(0.0, sweepLimit - (startAngle + pi / 2));
      if (clippedSweep <= 0) {
        startAngle += sweep;
        continue;
      }

      final isSelected = selectedCategory == entry.key;
      final isDimmed = selectedCategory != null && !isSelected;
      final color = (colorMap[entry.key] ?? AppColors.deepPurple)
          .withValues(alpha: isDimmed ? 0.2 : 1.0);

      final isUncategorized = entry.key == 'Uncategorized';

      if (isUncategorized) {
        // Save, clip to the arc, then draw hatching
        canvas.save();
        final path = Path()
          ..arcTo(rect.inflate(strokeWidth / 2), startAngle, clippedSweep, true)
          ..arcTo(rect.inflate(-strokeWidth / 2),
              startAngle + clippedSweep, -clippedSweep, false)
          ..close();
        canvas.clipPath(path);
        canvas.drawPath(
          path,
          Paint()..color = color.withValues(alpha: isDimmed ? 0.08 : 0.25),
        );
        // hatching
        final hatchPaint = Paint()
          ..color = color
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke;
        const step = 6.0;
        for (double i = -size.height; i < size.width + size.height; i += step) {
          canvas.drawLine(
            Offset(i, size.height),
            Offset(i + size.height, 0),
            hatchPaint,
          );
        }
        canvas.restore();
      } else {
        final paint = Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = isSelected ? strokeWidth + 4 : strokeWidth
          ..strokeCap = StrokeCap.butt;
        canvas.drawArc(rect, startAngle, clippedSweep, false, paint);
      }
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter old) =>
      old.progress != progress || old.selectedCategory != selectedCategory;
}

/// AnimatedBuilder wrapper (Flutter doesn't export AnimatedBuilder, this is just ListenableBuilder)
class AnimatedBuilder extends StatelessWidget {
  const AnimatedBuilder({
    super.key,
    required this.animation,
    required this.builder,
  });
  final Animation<double> animation;
  final Widget Function(BuildContext, Widget?) builder;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder._wrap(animation: animation, builder: builder);
  }

  static Widget _wrap({
    required Animation<double> animation,
    required Widget Function(BuildContext, Widget?) builder,
  }) {
    return ListenableBuilder(
      listenable: animation,
      builder: (context, child) => builder(context, child),
    );
  }
}

/// FractionallySizedBox with implicit animation
class AnimatedFractionallySizedBox extends ImplicitlyAnimatedWidget {
  const AnimatedFractionallySizedBox({
    super.key,
    required super.duration,
    super.curve,
    this.alignment = Alignment.center,
    this.widthFactor,
    this.heightFactor,
    this.child,
  });
  final AlignmentGeometry alignment;
  final double? widthFactor;
  final double? heightFactor;
  final Widget? child;

  @override
  AnimatedWidgetBaseState<AnimatedFractionallySizedBox> createState() =>
      _AnimatedFractionallySizedBoxState();
}

class _AnimatedFractionallySizedBoxState
    extends AnimatedWidgetBaseState<AnimatedFractionallySizedBox> {
  Tween<double>? _widthFactor;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _widthFactor = visitor(
      _widthFactor,
      widget.widthFactor ?? 1.0,
      (v) => Tween<double>(begin: v as double),
    ) as Tween<double>?;
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: widget.alignment,
      widthFactor: _widthFactor?.evaluate(animation),
      heightFactor: widget.heightFactor,
      child: widget.child,
    );
  }
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
