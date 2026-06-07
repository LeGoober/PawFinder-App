import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/conversation_repository.dart';

/// Mock implementation of [ConversationRepository] for development.
class ConversationRepositoryImpl implements ConversationRepository {
  // ---- Mock data ----------------------------------------------------
  static final List<Conversation> _mockConversations = [
    Conversation(
      id: 'conv_3001',
      alertId: 'alt_1001',
      ownerId: 'usr_a1b2c3',
      finderId: 'usr_x999',
      status: ConversationStatus.open,
      createdAt: DateTime(2026, 6, 5, 16, 30),
      closedAt: null,
    ),
    Conversation(
      id: 'conv_3002',
      alertId: 'alt_1002',
      ownerId: 'usr_z777',
      finderId: 'usr_y888',
      status: ConversationStatus.open,
      createdAt: DateTime(2026, 6, 6, 8, 50),
      closedAt: null,
    ),
  ];

  static final List<Message> _mockMessages = [
    Message(
      id: 'msg_4001',
      conversationId: 'conv_3001',
      senderId: 'usr_x999',
      content: 'Hi! I think I saw your dog Max near the library.',
      contentType: ContentType.text,
      createdAt: DateTime(2026, 6, 5, 16, 35),
      readAt: DateTime(2026, 6, 5, 16, 40),
    ),
    Message(
      id: 'msg_4002',
      conversationId: 'conv_3001',
      senderId: 'usr_a1b2c3',
      content: 'Oh thank you! Is he still there?',
      contentType: ContentType.text,
      createdAt: DateTime(2026, 6, 5, 16, 42),
      readAt: null,
    ),
    Message(
      id: 'msg_4003',
      conversationId: 'conv_3001',
      senderId: 'usr_x999',
      content: 'He moved towards the park. I\'ll keep looking.',
      contentType: ContentType.text,
      createdAt: DateTime(2026, 6, 5, 16, 48),
      readAt: null,
    ),
  ];

  // ---- API ----------------------------------------------------------

  @override
  Future<Either<Failure, List<Conversation>>> getConversations(
    String userId,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    final filtered =
        _mockConversations
            .where(
              (c) => c.ownerId == userId || c.finderId == userId,
            )
            .toList();
    return Right(filtered.isEmpty ? _mockConversations : filtered);
  }

  @override
  Future<Either<Failure, List<Message>>> getMessages(
    String conversationId,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    final filtered =
        _mockMessages
            .where((m) => m.conversationId == conversationId)
            .toList();
    return Right(filtered.isEmpty ? _mockMessages : filtered);
  }

  @override
  Future<Either<Failure, Message>> sendMessage({
    required String conversationId,
    required String senderId,
    required String content,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    final message = Message(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      conversationId: conversationId,
      senderId: senderId,
      content: content,
      contentType: ContentType.text,
      createdAt: DateTime.now(),
      readAt: null,
    );
    return Right(message);
  }
}
