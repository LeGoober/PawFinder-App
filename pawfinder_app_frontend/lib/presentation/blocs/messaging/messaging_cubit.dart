import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pawfinder_app/domain/entities/message.dart';
import 'package:pawfinder_app/domain/entities/conversation.dart';
import 'package:pawfinder_app/domain/repositories/conversation_repository.dart';
import 'package:pawfinder_app/services/websocket_service.dart' show WebSocketService, WsConnectionState;

part 'messaging_state.dart';

class MessagingCubit extends Cubit<MessagingState> {
  final ConversationRepository _conversationRepository;
  final WebSocketService? _wsService;

  StreamSubscription? _messageSub;
  StreamSubscription? _typingSub;
  StreamSubscription? _presenceSub;

  MessagingCubit({
    required ConversationRepository conversationRepository,
    WebSocketService? wsService,
  })  : _conversationRepository = conversationRepository,
        _wsService = wsService,
        super(MessagingInitial());

  String? _currentUserId;
  String? _activeConversationId;

  /// Public getter for UI to determine message ownership.
  String? get currentUserId => _currentUserId;

  /// Set the current user ID for owner detection.
  void setCurrentUserId(String userId) {
    _currentUserId = userId;
  }

  /// Connect to WebSocket for real-time messaging.
  Future<void> connectWebSocket() async {
    if (_wsService == null) return;

    // Listen for incoming messages
    _messageSub?.cancel();
    _messageSub = _wsService!.messages.listen(_onIncomingMessage);

    // Listen for typing indicators
    _typingSub?.cancel();
    _typingSub = _wsService!.typingEvents.listen(_onTypingEvent);

    // Listen for connection state changes
    _presenceSub?.cancel();
    _presenceSub = _wsService!.connectionState.listen((wsState) {
      if (state is MessagesLoaded) {
        final current = state as MessagesLoaded;
        emit(current.copyWith(
          connectionStatus: _mapWsState(wsState),
        ));
      }
    });

    await _wsService!.connect();
  }

  ConnectionStatus _mapWsState(WsConnectionState s) {
    switch (s) {
      case WsConnectionState.connected:
        return ConnectionStatus.connected;
      case WsConnectionState.connecting:
        return ConnectionStatus.connecting;
      default:
        return ConnectionStatus.disconnected;
    }
  }

  void _onIncomingMessage(Map<String, dynamic> data) {
    if (state is MessagesLoaded) {
      final current = state as MessagesLoaded;
      try {
        // Parse incoming WebSocket message as a domain Message
        final newMsg = Message(
          id: data['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
          conversationId: data['conversationId']?.toString() ?? _activeConversationId ?? '',
          senderId: data['senderId']?.toString() ?? '',
          content: data['content']?.toString() ?? '',
          contentType: _parseContentType(data['contentType']?.toString()),
          createdAt: data['createdAt'] != null
              ? DateTime.tryParse(data['createdAt'].toString()) ?? DateTime.now()
              : DateTime.now(),
        );

        // Don't add duplicate messages (our own sent messages already in the list)
        final exists = current.messages.any((m) => m.id == newMsg.id);
        if (!exists) {
          final updated = [...current.messages, newMsg];
          emit(current.copyWith(messages: updated));
        }
      } catch (_) {
        // Ignore malformed messages
      }
    }
  }

  void _onTypingEvent(Map<String, dynamic> data) {
    if (state is MessagesLoaded) {
      final current = state as MessagesLoaded;
      final isTyping = data['typing'] == true;
      emit(current.copyWith(isRecipientTyping: isTyping));
    }
  }

  ContentType _parseContentType(String? type) {
    switch (type) {
      case 'image':
        return ContentType.image;
      case 'location':
        return ContentType.location;
      default:
        return ContentType.text;
    }
  }

  /// Subscribe to a conversation for real-time updates.
  void joinConversation(String conversationId) {
    _activeConversationId = conversationId;
    _wsService?.subscribeToConversation(conversationId);
  }

  /// Leave a conversation.
  void leaveConversation() {
    if (_activeConversationId != null) {
      _wsService?.unsubscribeFromConversation(_activeConversationId!);
    }
    _activeConversationId = null;
  }

  /// Notify the other party that user is typing.
  void onTyping() {
    if (_activeConversationId != null) {
      _wsService?.onUserTyping(_activeConversationId!);
    }
  }

  /// Mark message as read.
  void markAsRead(String messageId) {
    if (_activeConversationId != null) {
      _wsService?.markAsRead(_activeConversationId!, messageId);
    }
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
        (conversations) =>
            emit(ConversationsLoaded(conversations: conversations)),
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
        (messages) {
          // Join conversation for real-time updates
          joinConversation(conversationId);

          emit(MessagesLoaded(
            messages: messages,
            connectionStatus: _wsService?.isConnected == true
                ? ConnectionStatus.connected
                : ConnectionStatus.disconnected,
          ));
        },
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

    // Send via WebSocket for real-time delivery
    if (_wsService?.isConnected == true) {
      _wsService!.sendMessage(
        conversationId: conversationId,
        content: content,
      );
      return; // Message will arrive via WebSocket subscription
    }

    // Fallback: REST API
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

  @override
  Future<void> close() {
    _messageSub?.cancel();
    _typingSub?.cancel();
    _presenceSub?.cancel();
    leaveConversation();
    return super.close();
  }
}
