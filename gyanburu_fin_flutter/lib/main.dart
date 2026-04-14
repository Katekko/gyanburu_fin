import 'package:gyanburu_fin_client/gyanburu_fin_client.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import 'screens/dashboard_screen.dart';
import 'screens/monthly_overview_screen.dart';
import 'screens/transaction_history_screen.dart';
import 'screens/nubank_sync_screen.dart';
import 'screens/bill_detail_screen.dart';
import 'screens/budget_screen.dart';
import 'screens/sign_in_screen.dart';
import 'theme/app_theme.dart';

late final Client client;

const _serverUrl = String.fromEnvironment(
  'SERVER_URL',
  defaultValue: 'http://192.168.0.229:8080/',
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  client = Client(_serverUrl)
    ..connectivityMonitor = FlutterConnectivityMonitor()
    ..authSessionManager = FlutterAuthSessionManager();

  client.auth.initialize();

  runApp(const GyanburuFinApp());
}

class GyanburuFinApp extends StatelessWidget {
  const GyanburuFinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gyanburu Fin',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: SignInScreen(child: const AppShell()),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  void _navigateToBills() {
    setState(() {
      _selectedIndex = 4;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            extended: true,
            minExtendedWidth: 200,
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.account_balance_wallet,
                    color: AppColors.deepPurple,
                    size: 28,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Gyanburu',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.deepPurple,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.calendar_month_outlined),
                selectedIcon: Icon(Icons.calendar_month),
                label: Text('Monthly'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.payment_outlined),
                selectedIcon: Icon(Icons.payment),
                label: Text('Bills'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.receipt_long_outlined),
                selectedIcon: Icon(Icons.receipt_long),
                label: Text('Transactions'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.upload_file_outlined),
                selectedIcon: Icon(Icons.upload_file),
                label: Text('Import'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.pie_chart_outline),
                selectedIcon: Icon(Icons.pie_chart),
                label: Text('Budget'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: _buildScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildScreen() {
    return switch (_selectedIndex) {
      0 => DashboardScreen(onBillTap: (_) => _navigateToBills()),
      1 => const MonthlyOverviewScreen(),
      2 => const BillDetailScreen(),
      3 => const TransactionHistoryScreen(),
      4 => const NubankSyncScreen(),
      5 => const BudgetScreen(),
      _ => const SizedBox.shrink(),
    };
  }
}
