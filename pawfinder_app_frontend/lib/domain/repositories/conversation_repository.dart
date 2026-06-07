import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/conversation.dart';
import '../entities/message.dart';

/// Abstract repository for conversation / messaging operations.
abstract class ConversationRepository {
  /// Fetches all conversations for a user.
  Future<Either<Failure, List<Conversation>>> getConversations(
    String userId,
  );

  /// Fetches all messages in a conversation, ordered by [createdAt] ascending.
  Future<Either<Failure, List<Message>>> getMessages(
    String conversationId,
  );

  /// Sends a message in a conversation.
  Future<Either<Failure, Message>> sendMessage({
    required String conversationId,
    required String senderId,
    required String content,
  });
}
