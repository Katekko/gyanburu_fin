import 'package:flutter/material.dart';
import 'package:gyanburu_fin_client/gyanburu_fin_client.dart';

import '../theme/app_theme.dart';
import 'attachment_service.dart';

/// Lists, uploads, opens and deletes the attachments of a single bill entry for
/// one [kind] (boleto or receipt). Self-contained: it loads and mutates through
/// [AttachmentService], so changes persist immediately.
class AttachmentsSection extends StatefulWidget {
  const AttachmentsSection({
    super.key,
    required this.entryId,
    required this.kind,
    this.title,
    this.readOnly = false,
  });

  final int entryId;
  final AttachmentKind kind;
  final String? title;
  final bool readOnly;

  @override
  State<AttachmentsSection> createState() => _AttachmentsSectionState();
}

class _AttachmentsSectionState extends State<AttachmentsSection> {
  List<Attachment> _items = [];
  bool _loading = true;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final all = await AttachmentService.listForEntry(widget.entryId);
      _items = all.where((a) => a.kind == widget.kind).toList();
    } catch (e) {
      _showError('Could not load documents: $e');
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _add() async {
    setState(() => _busy = true);
    try {
      final created = await AttachmentService.pickAndUpload(
        widget.entryId,
        widget.kind,
      );
      if (created != null) {
        setState(() => _items = [..._items, created]);
      }
    } catch (e) {
      _showError('Upload failed: $e');
    }
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _delete(Attachment a) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceVariant,
        title: const Text('Remove document'),
        content: Text('Remove "${a.fileName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Remove', style: TextStyle(color: AppColors.negative)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await AttachmentService.delete(a.id!);
      setState(() => _items = _items.where((x) => x.id != a.id).toList());
    } catch (e) {
      _showError('Could not remove: $e');
    }
  }

  Future<void> _open(Attachment a) async {
    setState(() => _busy = true);
    try {
      final bytes = await AttachmentService.fetchBytes(a.id!);
      if (bytes == null) {
        _showError('File not found.');
      } else if (!mounted) {
        return;
      } else if (AttachmentService.isImage(a.contentType)) {
        await showDialog<void>(
          context: context,
          builder: (ctx) => Dialog(
            backgroundColor: Colors.black,
            child: Stack(
              children: [
                InteractiveViewer(child: Image.memory(bytes)),
                Positioned(
                  top: 4,
                  right: 4,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        final opened = AttachmentService.openInNewTab(
          bytes,
          a.contentType,
          a.fileName,
        );
        if (!opened) {
          _showError(
            'Opening this file type is only available on the web app.',
          );
        }
      }
    } catch (e) {
      _showError('Could not open: $e');
    }
    if (mounted) setState(() => _busy = false);
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.negative),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.title ?? 'Documents',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            if (_busy)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            if (!widget.readOnly && !_busy)
              TextButton.icon(
                onPressed: _add,
                icon: const Icon(Icons.attach_file, size: 18),
                label: const Text('Add'),
              ),
          ],
        ),
        if (_loading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          )
        else if (_items.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              widget.readOnly ? 'No documents.' : 'No documents yet.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          )
        else
          ..._items.map(_tile),
      ],
    );
  }

  Widget _tile(Attachment a) {
    final isImage = AttachmentService.isImage(a.contentType);
    return Container(
      margin: const EdgeInsets.only(top: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(
          isImage ? Icons.image_outlined : Icons.picture_as_pdf_outlined,
          color: AppColors.textSecondary,
        ),
        title: Text(
          a.fileName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 13),
        ),
        subtitle: Text(
          _formatSize(a.sizeBytes),
          style: TextStyle(fontSize: 11, color: AppColors.textMuted),
        ),
        onTap: () => _open(a),
        trailing: widget.readOnly
            ? const Icon(Icons.open_in_new, size: 18)
            : IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  size: 20,
                  color: AppColors.negative,
                ),
                tooltip: 'Remove',
                onPressed: () => _delete(a),
              ),
      ),
    );
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(0)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
