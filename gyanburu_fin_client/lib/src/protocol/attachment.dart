/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'attachment_kind.dart' as _i2;

abstract class Attachment implements _i1.SerializableModel {
  Attachment._({
    this.id,
    required this.userId,
    required this.entryId,
    required this.kind,
    required this.storagePath,
    required this.fileName,
    required this.contentType,
    required this.sizeBytes,
    required this.uploadedAt,
  });

  factory Attachment({
    int? id,
    required _i1.UuidValue userId,
    required int entryId,
    required _i2.AttachmentKind kind,
    required String storagePath,
    required String fileName,
    required String contentType,
    required int sizeBytes,
    required DateTime uploadedAt,
  }) = _AttachmentImpl;

  factory Attachment.fromJson(Map<String, dynamic> jsonSerialization) {
    return Attachment(
      id: jsonSerialization['id'] as int?,
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      entryId: jsonSerialization['entryId'] as int,
      kind: _i2.AttachmentKind.fromJson((jsonSerialization['kind'] as String)),
      storagePath: jsonSerialization['storagePath'] as String,
      fileName: jsonSerialization['fileName'] as String,
      contentType: jsonSerialization['contentType'] as String,
      sizeBytes: jsonSerialization['sizeBytes'] as int,
      uploadedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['uploadedAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i1.UuidValue userId;

  int entryId;

  _i2.AttachmentKind kind;

  String storagePath;

  String fileName;

  String contentType;

  int sizeBytes;

  DateTime uploadedAt;

  /// Returns a shallow copy of this [Attachment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Attachment copyWith({
    int? id,
    _i1.UuidValue? userId,
    int? entryId,
    _i2.AttachmentKind? kind,
    String? storagePath,
    String? fileName,
    String? contentType,
    int? sizeBytes,
    DateTime? uploadedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Attachment',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'entryId': entryId,
      'kind': kind.toJson(),
      'storagePath': storagePath,
      'fileName': fileName,
      'contentType': contentType,
      'sizeBytes': sizeBytes,
      'uploadedAt': uploadedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AttachmentImpl extends Attachment {
  _AttachmentImpl({
    int? id,
    required _i1.UuidValue userId,
    required int entryId,
    required _i2.AttachmentKind kind,
    required String storagePath,
    required String fileName,
    required String contentType,
    required int sizeBytes,
    required DateTime uploadedAt,
  }) : super._(
         id: id,
         userId: userId,
         entryId: entryId,
         kind: kind,
         storagePath: storagePath,
         fileName: fileName,
         contentType: contentType,
         sizeBytes: sizeBytes,
         uploadedAt: uploadedAt,
       );

  /// Returns a shallow copy of this [Attachment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Attachment copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    int? entryId,
    _i2.AttachmentKind? kind,
    String? storagePath,
    String? fileName,
    String? contentType,
    int? sizeBytes,
    DateTime? uploadedAt,
  }) {
    return Attachment(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      entryId: entryId ?? this.entryId,
      kind: kind ?? this.kind,
      storagePath: storagePath ?? this.storagePath,
      fileName: fileName ?? this.fileName,
      contentType: contentType ?? this.contentType,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      uploadedAt: uploadedAt ?? this.uploadedAt,
    );
  }
}
