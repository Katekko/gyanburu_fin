import 'dart:math';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../util/validation.dart';

/// Manages payment documents (boletos and receipts) attached to a
/// [MonthlyEntry]. Files live in Serverpod's built-in `private` cloud storage
/// and are only ever served back to their owner through [getData].
class AttachmentEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  static const _storageId = 'private';
  static const _maxFileSize = 10 * 1024 * 1024; // 10 MB

  UuidValue _userId(Session session) =>
      UuidValue.fromString(session.authenticated!.userIdentifier);

  Future<MonthlyEntry> _ownedEntry(Session session, int entryId) async {
    final entry = await MonthlyEntry.db.findById(session, entryId);
    if (entry == null || entry.userId != _userId(session)) {
      throw ArgumentError('Entry not found');
    }
    return entry;
  }

  Future<Attachment> _ownedAttachment(Session session, int attachmentId) async {
    final attachment = await Attachment.db.findById(session, attachmentId);
    if (attachment == null || attachment.userId != _userId(session)) {
      throw ArgumentError('Attachment not found');
    }
    return attachment;
  }

  // Keep only path-safe characters and avoid directory traversal in the
  // user-supplied file name.
  String _sanitize(String fileName) {
    final base = fileName.split(RegExp(r'[\\/]')).last;
    final cleaned = base.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
    final safe = cleaned.isEmpty ? 'file' : cleaned;
    return safe.length > 100 ? safe.substring(safe.length - 100) : safe;
  }

  String _token() {
    final rnd = Random.secure();
    return List<int>.generate(8, (_) => rnd.nextInt(256))
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join();
  }

  /// Step 1 of upload: verify ownership and hand the client a direct-upload
  /// description plus the storage path it must echo back to [confirmUpload].
  Future<AttachmentUploadTicket> requestUpload(
    Session session,
    int entryId,
    AttachmentKind kind,
    String fileName,
    int contentLength,
  ) async {
    Validate.requireString(fileName, 'fileName');
    if (contentLength <= 0 || contentLength > _maxFileSize) {
      throw ArgumentError('File too large. Maximum size is 10 MB.');
    }
    await _ownedEntry(session, entryId);

    final path =
        'entries/$entryId/${kind.name}/${_token()}-${_sanitize(fileName)}';
    final description = await session.storage.createDirectFileUploadDescription(
      storageId: _storageId,
      path: path,
      contentLength: contentLength,
      maxFileSize: _maxFileSize,
    );
    if (description == null) {
      throw StateError('Could not create upload description');
    }
    return AttachmentUploadTicket(path: path, uploadDescription: description);
  }

  /// Step 2 of upload: confirm the file landed in storage and record it.
  Future<Attachment> confirmUpload(
    Session session,
    int entryId,
    AttachmentKind kind,
    String path,
    String fileName,
    String contentType,
    int sizeBytes,
  ) async {
    Validate.requireString(fileName, 'fileName');
    Validate.requireString(contentType, 'contentType', maxLength: 100);
    if (sizeBytes <= 0 || sizeBytes > _maxFileSize) {
      throw ArgumentError('File too large. Maximum size is 10 MB.');
    }
    await _ownedEntry(session, entryId);

    final verified = await session.storage
        .verifyDirectFileUpload(storageId: _storageId, path: path);
    if (!verified) {
      throw StateError('Upload could not be verified');
    }

    return Attachment.db.insertRow(
      session,
      Attachment(
        userId: _userId(session),
        entryId: entryId,
        kind: kind,
        storagePath: path,
        fileName: fileName,
        contentType: contentType,
        sizeBytes: sizeBytes,
        uploadedAt: DateTime.now().toUtc(),
      ),
    );
  }

  Future<List<Attachment>> listForEntry(Session session, int entryId) async {
    await _ownedEntry(session, entryId);
    return Attachment.db.find(
      session,
      where: (a) =>
          a.entryId.equals(entryId) & a.userId.equals(_userId(session)),
      orderBy: (a) => a.uploadedAt,
    );
  }

  /// Returns the subset of [entryIds] (owned by the user) that have at least
  /// one attachment — used to show an indicator on bill rows in one round trip.
  Future<List<int>> entryIdsWithAttachments(
    Session session,
    List<int> entryIds,
  ) async {
    if (entryIds.isEmpty) return [];
    final rows = await Attachment.db.find(
      session,
      where: (a) =>
          a.userId.equals(_userId(session)) & a.entryId.inSet(entryIds.toSet()),
    );
    return rows.map((a) => a.entryId).toSet().toList();
  }

  Future<ByteData?> getData(Session session, int attachmentId) async {
    final attachment = await _ownedAttachment(session, attachmentId);
    return session.storage
        .retrieveFile(storageId: _storageId, path: attachment.storagePath);
  }

  Future<void> deleteAttachment(Session session, int attachmentId) async {
    final attachment = await _ownedAttachment(session, attachmentId);
    await session.storage
        .deleteFile(storageId: _storageId, path: attachment.storagePath);
    await Attachment.db.deleteRow(session, attachment);
  }
}
