import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gyanburu_fin_client/gyanburu_fin_client.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import '../theme/app_theme.dart';

class NubankSyncScreen extends StatefulWidget {
  const NubankSyncScreen({super.key});

  @override
  State<NubankSyncScreen> createState() => _NubankSyncScreenState();
}

class _NubankSyncScreenState extends State<NubankSyncScreen> {
  List<ImportHistory> _history = [];
  bool _loading = true;
  bool _importing = false;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _loading = true);
    try {
      _history = await client.importHistory.list();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load import history: $e')),
        );
      }
    }
    setState(() => _loading = false);
  }

  Future<void> _pickAndImport() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['ofx'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    if (file.bytes == null) return;

    final content = utf8.decode(file.bytes!, allowMalformed: true);
    final fileName = file.name;

    setState(() => _importing = true);

    try {
      final importResult = await client.ofxImport.importOfx(content, fileName);

      if (mounted) {
        _showImportResult(importResult);
        _loadHistory();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Import failed: $e'),
            backgroundColor: AppColors.negative,
          ),
        );
      }
    }

    setState(() => _importing = false);
  }

  void _showImportResult(ImportHistory result) {
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final dateFormat = DateFormat('dd/MM/yyyy');

        return AlertDialog(
          backgroundColor: AppColors.surfaceVariant,
          title: Row(
            children: [
              Icon(Icons.check_circle, color: AppColors.positive, size: 24),
              const SizedBox(width: 10),
              Text('Import Complete', style: theme.textTheme.titleLarge),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ResultRow(
                label: 'File',
                value: result.fileName,
              ),
              _ResultRow(
                label: 'Statement period',
                value:
                    '${dateFormat.format(result.statementStart)} - ${dateFormat.format(result.statementEnd)}',
              ),
              const Divider(height: 24),
              _ResultRow(
                label: 'Total in file',
                value: '${result.totalTransactions}',
              ),
              _ResultRow(
                label: 'New imported',
                value: '${result.newTransactions}',
                valueColor: AppColors.positive,
              ),
              _ResultRow(
                label: 'Skipped (duplicates)',
                value: '${result.skippedDuplicates}',
                valueColor: AppColors.textMuted,
              ),
              _ResultRow(
                label: 'Skipped (credits)',
                value: '${result.skippedCredits}',
                valueColor: AppColors.textMuted,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nubank Import', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'Import your Nubank credit card statement from an OFX file.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 24),
          _ImportCard(
            importing: _importing,
            onImport: _pickAndImport,
          ),
          const SizedBox(height: 24),
          if (_loading)
            const Center(child: CircularProgressIndicator())
          else if (_history.isNotEmpty)
            _ImportHistorySection(history: _history),
        ],
      ),
    );
  }
}

class _ImportCard extends StatelessWidget {
  const _ImportCard({required this.importing, required this.onImport});
  final bool importing;
  final VoidCallback onImport;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
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
                    Icons.upload_file,
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
                        'Import OFX File',
                        style: theme.textTheme.titleMedium,
                      ),
                      Text(
                        'Export from Nubank app and select the .ofx file',
                        style: theme.textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('How to export from Nubank:',
                      style: theme.textTheme.labelMedium),
                  const SizedBox(height: 8),
                  _StepText(number: '1', text: 'Open Nubank app'),
                  _StepText(
                      number: '2', text: 'Go to Credit Card > Your Bills'),
                  _StepText(
                      number: '3',
                      text: 'Select the month and tap "Share"'),
                  _StepText(number: '4', text: 'Choose "OFX" format'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: importing ? null : onImport,
                icon: importing
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.file_open, size: 18),
                label: Text(importing ? 'Importing...' : 'Select OFX File'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepText extends StatelessWidget {
  const _StepText({required this.number, required this.text});
  final String number;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.deepPurple.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              number,
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppColors.deepPurple,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(text, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _ImportHistorySection extends StatelessWidget {
  const _ImportHistorySection({required this.history});
  final List<ImportHistory> history;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');
    final periodFormat = DateFormat('MMM yyyy');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Import History', style: theme.textTheme.titleMedium),
            const SizedBox(height: 16),
            ...history.map((h) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 18,
                      color: AppColors.positive,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            h.fileName,
                            style: theme.textTheme.bodyMedium,
                          ),
                          Text(
                            '${dateFormat.format(h.importedAt)} · '
                            '${periodFormat.format(h.statementStart)} - ${periodFormat.format(h.statementEnd)}',
                            style: theme.textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '+${h.newTransactions} new',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppColors.positive,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (h.skippedDuplicates > 0)
                          Text(
                            '${h.skippedDuplicates} skipped',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                      ],
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

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.label, required this.value, this.valueColor});
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodySmall),
          Flexible(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: valueColor ?? AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
