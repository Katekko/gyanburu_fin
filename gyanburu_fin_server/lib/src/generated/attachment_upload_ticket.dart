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
import 'package:serverpod/serverpod.dart' as _i1;

/// Returned by AttachmentEndpoint.requestUpload. Carries the storage path the
/// client must echo back on confirmUpload, plus the Serverpod upload description
/// that the client feeds to FileUploader.
abstract class AttachmentUploadTicket
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  AttachmentUploadTicket._({
    required this.path,
    required this.uploadDescription,
  });

  factory AttachmentUploadTicket({
    required String path,
    required String uploadDescription,
  }) = _AttachmentUploadTicketImpl;

  factory AttachmentUploadTicket.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AttachmentUploadTicket(
      path: jsonSerialization['path'] as String,
      uploadDescription: jsonSerialization['uploadDescription'] as String,
    );
  }

  String path;

  String uploadDescription;

  /// Returns a shallow copy of this [AttachmentUploadTicket]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AttachmentUploadTicket copyWith({
    String? path,
    String? uploadDescription,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AttachmentUploadTicket',
      'path': path,
      'uploadDescription': uploadDescription,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AttachmentUploadTicket',
      'path': path,
      'uploadDescription': uploadDescription,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _AttachmentUploadTicketImpl extends AttachmentUploadTicket {
  _AttachmentUploadTicketImpl({
    required String path,
    required String uploadDescription,
  }) : super._(
         path: path,
         uploadDescription: uploadDescription,
       );

  /// Returns a shallow copy of this [AttachmentUploadTicket]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AttachmentUploadTicket copyWith({
    String? path,
    String? uploadDescription,
  }) {
    return AttachmentUploadTicket(
      path: path ?? this.path,
      uploadDescription: uploadDescription ?? this.uploadDescription,
    );
  }
}
