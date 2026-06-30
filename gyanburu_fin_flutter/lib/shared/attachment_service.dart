import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:gyanburu_fin_client/gyanburu_fin_client.dart';

import '../main.dart';
import 'attachment_opener_stub.dart'
    if (dart.library.js_interop) 'attachment_opener_web.dart'
    as opener;
import 'clipboard_image_stub.dart'
    if (dart.library.js_interop) 'clipboard_image_web.dart'
    as clipboard;

/// Wraps the Serverpod direct-upload flow and private-file retrieval for bill
/// attachments (boletos and receipts).
class AttachmentService {
  static const allowedExtensions = [
    'pdf',
    'jpg',
    'jpeg',
    'png',
    'webp',
    'heic',
    'heif',
  ];
  static const maxFileSize = 10 * 1024 * 1024; // 10 MB

  /// Picks a file and uploads it for [entryId] as [kind]. Returns the created
  /// [Attachment], or null if the user cancelled the picker. Throws on failure
  /// (the caller surfaces the message).
  static Future<Attachment?> pickAndUpload(
    int entryId,
    AttachmentKind kind,
  ) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return null;

    final file = result.files.first;
    final bytes = file.bytes;
    if (bytes == null) {
      throw Exception('Could not read the selected file.');
    }
    return _upload(entryId, kind, bytes, file.name, contentTypeFor(file.name));
  }

  /// Reads an image from the system clipboard (web only) and uploads it for
  /// [entryId] as [kind]. Returns the created [Attachment], or null if the
  /// clipboard had no image. Throws on read/upload failure.
  static Future<Attachment?> pasteAndUpload(
    int entryId,
    AttachmentKind kind,
  ) async {
    final image = await clipboard.readClipboardImage();
    if (image == null) return null;
    final ext = _imageExtension(image.contentType);
    final fileName = 'pasted-${DateTime.now().millisecondsSinceEpoch}.$ext';
    return _upload(entryId, kind, image.bytes, fileName, image.contentType);
  }

  /// Shared upload path: validates size, runs Serverpod's direct-upload
  /// request → upload → confirm round trip, and returns the recorded row.
  static Future<Attachment> _upload(
    int entryId,
    AttachmentKind kind,
    Uint8List bytes,
    String fileName,
    String contentType,
  ) async {
    if (bytes.length > maxFileSize) {
      throw Exception('File too large. Maximum size is 10 MB.');
    }

    final ticket = await client.attachment.requestUpload(
      entryId,
      kind,
      fileName,
      bytes.length,
    );

    final uploader = FileUploader(ticket.uploadDescription);
    final uploaded = await uploader.uploadByteData(
      ByteData.view(bytes.buffer, bytes.offsetInBytes, bytes.lengthInBytes),
    );
    if (!uploaded) {
      throw Exception('Upload failed.');
    }

    return client.attachment.confirmUpload(
      entryId,
      kind,
      ticket.path,
      fileName,
      contentType,
      bytes.length,
    );
  }

  static String _imageExtension(String contentType) {
    switch (contentType) {
      case 'image/jpeg':
        return 'jpg';
      case 'image/webp':
        return 'webp';
      case 'image/png':
      default:
        return 'png';
    }
  }

  static Future<List<Attachment>> listForEntry(int entryId) =>
      client.attachment.listForEntry(entryId);

  static Future<Uint8List?> fetchBytes(int attachmentId) async {
    final data = await client.attachment.getData(attachmentId);
    if (data == null) return null;
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  static Future<void> delete(int attachmentId) =>
      client.attachment.deleteAttachment(attachmentId);

  static Future<Set<int>> entryIdsWithAttachments(List<int> entryIds) async {
    final ids = await client.attachment.entryIdsWithAttachments(entryIds);
    return ids.toSet();
  }

  static bool isImage(String contentType) => contentType.startsWith('image/');

  /// Opens non-image bytes in a new browser tab (web only). Returns false where
  /// unsupported (e.g. native mobile).
  static bool openInNewTab(
    Uint8List bytes,
    String contentType,
    String fileName,
  ) => opener.openBytesInNewTab(bytes, contentType, fileName);

  static String contentTypeFor(String fileName) {
    final ext = fileName.contains('.')
        ? fileName.toLowerCase().split('.').last
        : '';
    switch (ext) {
      case 'pdf':
        return 'application/pdf';
      case 'png':
        return 'image/png';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'webp':
        return 'image/webp';
      case 'heic':
      case 'heif':
        return 'image/heic';
      default:
        return 'application/octet-stream';
    }
  }
}
