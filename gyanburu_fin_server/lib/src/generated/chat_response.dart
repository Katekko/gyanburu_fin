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
import 'pending_action.dart' as _i2;
import 'package:gyanburu_fin_server/src/generated/protocol.dart' as _i3;

abstract class ChatResponse
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ChatResponse._({
    required this.reply,
    required this.pendingActions,
  });

  factory ChatResponse({
    required String reply,
    required List<_i2.PendingAction> pendingActions,
  }) = _ChatResponseImpl;

  factory ChatResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChatResponse(
      reply: jsonSerialization['reply'] as String,
      pendingActions: _i3.Protocol().deserialize<List<_i2.PendingAction>>(
        jsonSerialization['pendingActions'],
      ),
    );
  }

  String reply;

  List<_i2.PendingAction> pendingActions;

  /// Returns a shallow copy of this [ChatResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ChatResponse copyWith({
    String? reply,
    List<_i2.PendingAction>? pendingActions,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChatResponse',
      'reply': reply,
      'pendingActions': pendingActions.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ChatResponse',
      'reply': reply,
      'pendingActions': pendingActions.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ChatResponseImpl extends ChatResponse {
  _ChatResponseImpl({
    required String reply,
    required List<_i2.PendingAction> pendingActions,
  }) : super._(
         reply: reply,
         pendingActions: pendingActions,
       );

  /// Returns a shallow copy of this [ChatResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ChatResponse copyWith({
    String? reply,
    List<_i2.PendingAction>? pendingActions,
  }) {
    return ChatResponse(
      reply: reply ?? this.reply,
      pendingActions:
          pendingActions ??
          this.pendingActions.map((e0) => e0.copyWith()).toList(),
    );
  }
}
