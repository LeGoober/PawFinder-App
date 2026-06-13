import 'package:dartz/dartz.dart';

import '../../core/constants/api_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../data/datasources/remote/api_client.dart';
import '../../data/models/conversation_model.dart';
import '../../data/models/message_model.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/conversation_repository.dart';

/// Real API implementation of [ConversationRepository].
class ConversationRepositoryImpl implements ConversationRepository {
  final ApiClient _client;

  ConversationRepositoryImpl({required ApiClient client}) : _client = client;

  @override
  Future<Either<Failure, List<Conversation>>> getConversations(
    String userId,
  ) async {
    try {
      final json = await _client.get(ApiConstants.conversations);
      final list = (json as List<dynamic>)
          .map((e) =>
              ConversationModel.fromJson(e as Map<String, dynamic>).toEntity())
          .toList();
      return Right(list);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Message>>> getMessages(
    String conversationId,
  ) async {
    try {
      final json =
          await _client.get(ApiConstants.conversationMessages(conversationId));
      final list = (json as List<dynamic>)
          .map((e) =>
              MessageModel.fromJson(e as Map<String, dynamic>).toEntity())
          .toList();
      return Right(list);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Message>> sendMessage({
    required String conversationId,
    required String senderId,
    required String content,
  }) async {
    try {
      final json = await _client.post(
        ApiConstants.conversationMessages(conversationId),
        data: {
          'senderId': senderId,
          'content': content,
        },
      );
      final message =
          MessageModel.fromJson(json as Map<String, dynamic>).toEntity();
      return Right(message);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
