import 'package:flutter/material.dart';
import 'package:gyanburu_fin_client/gyanburu_fin_client.dart';
import 'package:intl/intl.dart';

import '../mock/mock_data.dart';
import '../theme/app_theme.dart';

class NubankSyncScreen extends StatelessWidget {
  const NubankSyncScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nubank Sync Status', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'Manage your connected Nubank accounts and monitor sync health.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 24),
          ...MockData.nubankAccounts.map(
            (account) => _AccountCard(account: account),
          ),
          const SizedBox(height: 24),
          _SyncLogSection(),
        ],
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  const _AccountCard({required this.account});
  final NubankAccount account;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isHealthy = account.syncStatus == SyncStatus.success;
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');

    final daysUntilExpiry = account.consentExpiresAt != null
        ? account.consentExpiresAt!.difference(DateTime.now()).inDays
        : 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8A05BE).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.account_balance,
                    color: Color(0xFF8A05BE),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nubank ${_accountTypeName(account.accountType)}',
                        style: theme.textTheme.titleMedium,
                      ),
                      Text(
                        account.accountType.name.toUpperCase(),
                        style: theme.textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
                _StatusBadge(status: account.syncStatus),
              ],
            ),
            const SizedBox(height: 20),
            _InfoRow(
              icon: Icons.sync,
              label: 'Last sync',
              value: account.lastSyncAt != null
                  ? dateFormat.format(account.lastSyncAt!)
                  : 'Never',
            ),
            const SizedBox(height: 10),
            _InfoRow(
              icon: Icons.verified_user,
              label: 'Consent expires',
              value: account.consentExpiresAt != null
                  ? '$daysUntilExpiry days remaining'
                  : 'N/A',
              valueColor: daysUntilExpiry < 30
                  ? AppColors.vibrantOrange
                  : AppColors.textPrimary,
            ),
            const SizedBox(height: 10),
            _InfoRow(
              icon: isHealthy ? Icons.check_circle : Icons.error,
              label: 'Connection health',
              value: isHealthy ? 'Healthy' : 'Issue detected',
              valueColor: isHealthy ? AppColors.positive : AppColors.negative,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.sync, size: 18),
                  label: const Text('Sync Now'),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Re-authorize'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _accountTypeName(AccountType type) {
    switch (type) {
      case AccountType.checking:
        return 'Checking Account';
      case AccountType.savings:
        return 'Savings Account';
      case AccountType.creditCard:
        return 'Credit Card';
    }
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final SyncStatus status;

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (status) {
      SyncStatus.success => (AppColors.positive, 'Connected'),
      SyncStatus.syncing => (AppColors.vibrantOrange, 'Syncing...'),
      SyncStatus.error => (AppColors.negative, 'Error'),
      SyncStatus.idle => (AppColors.textMuted, 'Idle'),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textMuted),
        const SizedBox(width: 8),
        Text(label, style: theme.textTheme.labelSmall),
        const Spacer(),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            color: valueColor ?? AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _SyncLogSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd MMM HH:mm');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sync History', style: theme.textTheme.titleMedium),
            const SizedBox(height: 16),
            ...MockData.syncLogs.map((log) {
              final isError = log.status == SyncStatus.error;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Icon(
                      isError ? Icons.error_outline : Icons.check_circle_outline,
                      size: 18,
                      color: isError ? AppColors.negative : AppColors.positive,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dateFormat.format(log.syncedAt),
                            style: theme.textTheme.bodyMedium,
                          ),
                          if (log.errorMessage != null)
                            Text(
                              log.errorMessage!,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: AppColors.negative,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Text(
                      log.status.name,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isError
                            ? AppColors.negative
                            : AppColors.positive,
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
