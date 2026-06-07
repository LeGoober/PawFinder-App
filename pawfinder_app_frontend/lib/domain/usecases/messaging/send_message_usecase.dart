import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/message.dart';
import '../../repositories/conversation_repository.dart';

/// Params for the [SendMessageUseCase].
class SendMessageParams extends Equatable {
  final String conversationId;
  final String senderId;
  final String content;

  const SendMessageParams({
    required this.conversationId,
    required this.senderId,
    required this.content,
  });

  @override
  List<Object?> get props => [conversationId, senderId, content];
}

/// Sends a message in a conversation.
class SendMessageUseCase extends UseCase<Message, SendMessageParams> {
  final ConversationRepository _repository;

  SendMessageUseCase(this._repository);

  @override
  Future<Either<Failure, Message>> call(SendMessageParams params) {
    return _repository.sendMessage(
      conversationId: params.conversationId,
      senderId: params.senderId,
      content: params.content,
    );
  }
}
