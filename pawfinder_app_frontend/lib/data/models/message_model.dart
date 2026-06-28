import 'package:equatable/equatable.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/message.dart' as domain show ContentType;

class MessageModel extends Equatable {
  final String id;
  final String conversationId;
  final String senderId;
  final String content;
  final String contentType;
  final DateTime createdAt;
  final DateTime? readAt;

  const MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    this.contentType = 'text',
    required this.createdAt,
    this.readAt,
  });

  /// Creates a [MessageModel] from a JSON map.
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    // Guard against empty fallback responses
    if (!json.containsKey('id') || json['id'] == null) {
      throw FormatException('MessageModel.fromJson: missing required field "id"');
    }
    return MessageModel(
      id: json['id'] as String,
      conversationId: (json['conversationId'] ?? '') as String,
      senderId: (json['senderId'] ?? '') as String,
      content: (json['content'] ?? '') as String,
      contentType: json['contentType'] as String? ?? 'text',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      readAt: json['readAt'] != null
          ? DateTime.tryParse(json['readAt'].toString())
          : null,
    );
  }

  /// Converts this model to a JSON map.
  Map<String, dynamic> toJson() => {
        'id': id,
        'conversationId': conversationId,
        'senderId': senderId,
        'content': content,
        'contentType': contentType,
        'createdAt': createdAt.toIso8601String(),
        'readAt': readAt?.toIso8601String(),
      };

  /// Parses the content-type string to a domain [ContentType] enum.
  domain.ContentType _parseContentType() {
    switch (contentType) {
      case 'image':
        return domain.ContentType.image;
      case 'location':
        return domain.ContentType.location;
      default:
        return domain.ContentType.text;
    }
  }

  /// Maps this data model to a domain [Message] entity.
  Message toEntity() => Message(
        id: id,
        conversationId: conversationId,
        senderId: senderId,
        content: content,
        contentType: _parseContentType(),
        createdAt: createdAt,
        readAt: readAt,
      );

  @override
  List<Object?> get props => [
        id,
        conversationId,
        senderId,
        content,
        contentType,
        createdAt,
        readAt,
      ];
}
