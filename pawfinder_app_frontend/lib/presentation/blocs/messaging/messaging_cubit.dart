import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pawfinder_app/domain/entities/message.dart';
import 'package:pawfinder_app/domain/entities/conversation.dart';
import 'package:pawfinder_app/domain/repositories/conversation_repository.dart';

part 'messaging_state.dart';

class MessagingCubit extends Cubit<MessagingState> {
  final ConversationRepository _conversationRepository;

  MessagingCubit({
    required ConversationRepository conversationRepository,
  })  : _conversationRepository = conversationRepository,
        super(MessagingInitial());

  String? _currentUserId;

  /// Set the current user ID for owner detection.
  void setCurrentUserId(String userId) {
    _currentUserId = userId;
  }

  /// Load conversations list.
  Future<void> loadConversations() async {
    if (_currentUserId == null) {
      emit(const MessagingError(message: 'Please log in to view messages'));
      return;
    }
    emit(MessagingLoading());

    try {
      final result =
          await _conversationRepository.getConversations(_currentUserId!);

      result.fold(
        (failure) => emit(MessagingError(message: failure.message)),
        (conversations) => emit(ConversationsLoaded(conversations: conversations)),
      );
    } catch (e) {
      emit(MessagingError(message: e.toString()));
    }
  }

  /// Load messages for a specific conversation.
  Future<void> loadMessages(String conversationId) async {
    emit(MessagingLoading());

    try {
      final result =
          await _conversationRepository.getMessages(conversationId);

      result.fold(
        (failure) => emit(MessagingError(message: failure.message)),
        (messages) => emit(MessagesLoaded(messages: messages)),
      );
    } catch (e) {
      emit(MessagingError(message: e.toString()));
    }
  }

  /// Send a message in a conversation.
  Future<void> sendMessage({
    required String conversationId,
    required String content,
  }) async {
    if (_currentUserId == null) {
      emit(const MessagingError(message: 'Please log in to send messages'));
      return;
    }

    emit(MessagingLoading());

    try {
      final result = await _conversationRepository.sendMessage(
        conversationId: conversationId,
        senderId: _currentUserId!,
        content: content,
      );

      result.fold(
        (failure) => emit(MessagingError(message: failure.message)),
        (message) => emit(MessageSent(message: message)),
      );
    } catch (e) {
      emit(MessagingError(message: e.toString()));
    }
  }
}
