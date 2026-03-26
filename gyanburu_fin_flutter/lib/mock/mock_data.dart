import 'package:flutter/material.dart';
import 'package:gyanburu_fin_client/gyanburu_fin_client.dart';

class MockData {
  static final now = DateTime.now();

  static final transactions = [
    FinancialTransaction(
      userId: UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
      merchantName: 'Uber Eats',
      category: 'Food',
      amount: -42.90,
      currency: 'BRL',
      occurredAt: now.subtract(const Duration(hours: 2)),
      description: 'Dinner delivery',
    ),
    FinancialTransaction(
      userId: UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
      merchantName: 'Spotify',
      category: 'Entertainment',
      amount: -21.90,
      currency: 'BRL',
      occurredAt: now.subtract(const Duration(days: 1)),
      description: 'Monthly subscription',
    ),
    FinancialTransaction(
      userId: UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
      merchantName: 'Shell',
      category: 'Transport',
      amount: -180.00,
      currency: 'BRL',
      occurredAt: now.subtract(const Duration(days: 2)),
      description: 'Gas station',
    ),
    FinancialTransaction(
      userId: UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
      merchantName: 'Amazon',
      category: 'Shopping',
      amount: -299.90,
      currency: 'BRL',
      occurredAt: now.subtract(const Duration(days: 3)),
      description: 'Mechanical keyboard',
    ),
    FinancialTransaction(
      userId: UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
      merchantName: 'Pao de Acucar',
      category: 'Groceries',
      amount: -312.45,
      currency: 'BRL',
      occurredAt: now.subtract(const Duration(days: 4)),
      description: 'Weekly groceries',
    ),
    FinancialTransaction(
      userId: UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
      merchantName: 'Employer Inc.',
      category: 'Income',
      amount: 8500.00,
      currency: 'BRL',
      occurredAt: now.subtract(const Duration(days: 5)),
      description: 'Salary deposit',
    ),
    FinancialTransaction(
      userId: UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
      merchantName: 'Netflix',
      category: 'Entertainment',
      amount: -55.90,
      currency: 'BRL',
      occurredAt: now.subtract(const Duration(days: 6)),
      description: 'Premium plan',
    ),
    FinancialTransaction(
      userId: UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
      merchantName: 'Farmacia',
      category: 'Health',
      amount: -87.50,
      currency: 'BRL',
      occurredAt: now.subtract(const Duration(days: 7)),
      description: 'Pharmacy',
    ),
    FinancialTransaction(
      userId: UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
      merchantName: 'iFood',
      category: 'Food',
      amount: -35.00,
      currency: 'BRL',
      occurredAt: now.subtract(const Duration(days: 8)),
      description: 'Lunch',
    ),
    FinancialTransaction(
      userId: UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
      merchantName: 'Steam',
      category: 'Entertainment',
      amount: -149.90,
      currency: 'BRL',
      occurredAt: now.subtract(const Duration(days: 10)),
      description: 'Game purchase',
    ),
  ];

  static final budgetCategories = [
    BudgetCategory(
      userId: UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
      name: 'Food',
      icon: 'restaurant',
      limitAmount: 800.0,
      month: DateTime(now.year, now.month),
    ),
    BudgetCategory(
      userId: UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
      name: 'Transport',
      icon: 'directions_car',
      limitAmount: 500.0,
      month: DateTime(now.year, now.month),
    ),
    BudgetCategory(
      userId: UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
      name: 'Entertainment',
      icon: 'movie',
      limitAmount: 300.0,
      month: DateTime(now.year, now.month),
    ),
    BudgetCategory(
      userId: UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
      name: 'Groceries',
      icon: 'shopping_cart',
      limitAmount: 1200.0,
      month: DateTime(now.year, now.month),
    ),
    BudgetCategory(
      userId: UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
      name: 'Health',
      icon: 'local_hospital',
      limitAmount: 400.0,
      month: DateTime(now.year, now.month),
    ),
    BudgetCategory(
      userId: UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
      name: 'Shopping',
      icon: 'shopping_bag',
      limitAmount: 600.0,
      month: DateTime(now.year, now.month),
    ),
  ];

  static final incomeSources = [
    IncomeSource(
      userId: UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
      name: 'Software Developer Salary',
      type: IncomeType.salary,
      amount: 8500.0,
      month: DateTime(now.year, now.month),
    ),
    IncomeSource(
      userId: UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
      name: 'Freelance Project',
      type: IncomeType.freelance,
      amount: 2000.0,
      month: DateTime(now.year, now.month),
    ),
    IncomeSource(
      userId: UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
      name: 'Investment Dividends',
      type: IncomeType.investment,
      amount: 350.0,
      month: DateTime(now.year, now.month),
    ),
  ];

  static final bills = [
    Bill(
      userId: UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
      merchantName: 'Vivo Internet',
      amount: 149.90,
      dueAt: now.add(const Duration(days: 3)),
      status: BillStatus.pending,
      recurrent: true,
    ),
    Bill(
      userId: UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
      merchantName: 'CPFL Energia',
      amount: 210.00,
      dueAt: now.add(const Duration(days: 7)),
      status: BillStatus.pending,
      recurrent: true,
    ),
    Bill(
      userId: UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
      merchantName: 'Nubank Credit Card',
      amount: 1890.45,
      dueAt: now.add(const Duration(days: 12)),
      status: BillStatus.pending,
      recurrent: true,
    ),
    Bill(
      userId: UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
      merchantName: 'Aluguel',
      amount: 2500.00,
      dueAt: now.subtract(const Duration(days: 2)),
      status: BillStatus.paid,
      recurrent: true,
    ),
    Bill(
      userId: UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
      merchantName: 'Gym Membership',
      amount: 89.90,
      dueAt: now.subtract(const Duration(days: 5)),
      status: BillStatus.paid,
      recurrent: true,
    ),
  ];

  static final nubankAccounts = [
    NubankAccount(
      userId: UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
      accountType: AccountType.checking,
      lastSyncAt: now.subtract(const Duration(minutes: 15)),
      syncStatus: SyncStatus.success,
      consentExpiresAt: now.add(const Duration(days: 85)),
    ),
    NubankAccount(
      userId: UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
      accountType: AccountType.creditCard,
      lastSyncAt: now.subtract(const Duration(minutes: 15)),
      syncStatus: SyncStatus.success,
      consentExpiresAt: now.add(const Duration(days: 85)),
    ),
  ];

  static final syncLogs = [
    SyncLog(
      nubankAccountId: UuidValue.fromString(
        '00000000-0000-0000-0000-000000000001',
      ),
      syncedAt: now.subtract(const Duration(minutes: 15)),
      status: SyncStatus.success,
    ),
    SyncLog(
      nubankAccountId: UuidValue.fromString(
        '00000000-0000-0000-0000-000000000001',
      ),
      syncedAt: now.subtract(const Duration(hours: 6)),
      status: SyncStatus.success,
    ),
    SyncLog(
      nubankAccountId: UuidValue.fromString(
        '00000000-0000-0000-0000-000000000001',
      ),
      syncedAt: now.subtract(const Duration(hours: 12)),
      status: SyncStatus.error,
      errorMessage: 'Connection timeout — retried automatically',
    ),
    SyncLog(
      nubankAccountId: UuidValue.fromString(
        '00000000-0000-0000-0000-000000000001',
      ),
      syncedAt: now.subtract(const Duration(days: 1)),
      status: SyncStatus.success,
    ),
    SyncLog(
      nubankAccountId: UuidValue.fromString(
        '00000000-0000-0000-0000-000000000001',
      ),
      syncedAt: now.subtract(const Duration(days: 1, hours: 6)),
      status: SyncStatus.success,
    ),
  ];

  static Map<String, double> get spendingByCategory {
    final Map<String, double> result = {};
    for (final t in transactions) {
      if (t.amount < 0) {
        result[t.category] = (result[t.category] ?? 0) + t.amount.abs();
      }
    }
    return result;
  }

  static double get totalIncome =>
      transactions.where((t) => t.amount > 0).fold(0.0, (s, t) => s + t.amount);

  static double get totalExpenses =>
      transactions.where((t) => t.amount < 0).fold(0.0, (s, t) => s + t.amount);

  static double get netBalance => totalIncome + totalExpenses;

  static double spentInCategory(String category) =>
      transactions
          .where((t) => t.category == category && t.amount < 0)
          .fold(0.0, (s, t) => s + t.amount.abs());

  static final categoryIcons = {
    'Food': Icons.restaurant,
    'Transport': Icons.directions_car,
    'Entertainment': Icons.movie,
    'Groceries': Icons.shopping_cart,
    'Health': Icons.local_hospital,
    'Shopping': Icons.shopping_bag,
    'Income': Icons.attach_money,
  };

  static final categoryColors = {
    'Food': Color(0xFFFF7043),
    'Transport': Color(0xFF42A5F5),
    'Entertainment': Color(0xFFAB47BC),
    'Groceries': Color(0xFF66BB6A),
    'Health': Color(0xFFEF5350),
    'Shopping': Color(0xFFFFCA28),
    'Income': Color(0xFF4CAF50),
  };
}
