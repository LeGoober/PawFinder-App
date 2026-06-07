import 'package:equatable/equatable.dart';

/// Possible message content types.
enum ContentType { text, image, location }

/// Domain entity representing a single message in a conversation.
class Message extends Equatable {
  final String id;
  final String conversationId;
  final String senderId;
  final String content;
  final ContentType contentType;
  final DateTime createdAt;
  final DateTime? readAt;

  const Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    this.contentType = ContentType.text,
    required this.createdAt,
    this.readAt,
  });

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
