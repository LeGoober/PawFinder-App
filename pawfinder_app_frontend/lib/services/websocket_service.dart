import 'dart:async';
import 'dart:convert';

import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../core/constants/api_constants.dart';
import '../services/auth_service.dart';

/// Real-time messaging via STOMP over WebSocket.
///
/// Connects to the messaging microservice's `/ws` endpoint and
/// subscribes to conversation topics for live message delivery.
class WebSocketService {
  StompClient? _client;
  final AuthService _authService;
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  final _typingController = StreamController<Map<String, dynamic>>.broadcast();
  final _presenceController = StreamController<Map<String, dynamic>>.broadcast();
  final _connectionController = StreamController<ConnectionState>.broadcast();

  final Set<String> _activeSubscriptions = {};
  String? _currentConversationId;
  Timer? _typingTimer;
  bool _isTyping = false;

  WebSocketService({required AuthService authService})
      : _authService = authService;

  /// Stream of incoming messages from subscribed conversations.
  Stream<Map<String, dynamic>> get messages => _messageController.stream;

  /// Stream of typing indicator events.
  Stream<Map<String, dynamic>> get typingEvents => _typingController.stream;

  /// Stream of presence (online/offline) events.
  Stream<Map<String, dynamic>> get presenceEvents =>
      _presenceController.stream;

  /// Stream of WebSocket connection state changes.
  Stream<ConnectionState> get connectionState =>
      _connectionController.stream;

  bool get isConnected =>
      _client?.connected ?? false;

  /// Connect to the messaging WebSocket and authenticate.
  Future<void> connect() async {
    if (_client?.connected == true) return;

    final token = await _authService.getToken();
    if (token == null || token.isEmpty) {
      _connectionController.add(ConnectionState.disconnected);
      return;
    }

    _client = StompClient(
      config: StompConfig(
        url: ApiConstants.wsUrl,
        onConnect: _onConnect,
        onDisconnect: (_) => _connectionController.add(ConnectionState.disconnected),
        onWebSocketError: (error) {
          _connectionController.add(ConnectionState.error);
        },
        stompConnectHeaders: {
          'Authorization': 'Bearer $token',
        },
        heartbeatOutgoing: const Duration(seconds: 10).inMilliseconds,
        heartbeatIncoming: const Duration(seconds: 10).inMilliseconds,
        reconnectDelay: const Duration(seconds: 3),
      ),
    );

    _client!.activate();
  }

  void _onConnect(StompFrame frame) {
    _connectionController.add(ConnectionState.connected);

    // Subscribe to user-specific private messages
    _subscribe('/user/queue/messages');
    _subscribe('/user/queue/typing');
  }

  /// Subscribe to a conversation topic for live messages.
  void subscribeToConversation(String conversationId) {
    if (_activeSubscriptions.contains(conversationId)) return;

    _currentConversationId = conversationId;
    _activeSubscriptions.add(conversationId);

    // Subscribe to conversation messages
    _subscribe('/topic/conversation.$conversationId');

    // Subscribe to typing indicators for this conversation
    _subscribe('/topic/conversation.$conversationId.typing');
  }

  /// Unsubscribe from a conversation topic.
  void unsubscribeFromConversation(String conversationId) {
    if (!_activeSubscriptions.contains(conversationId)) return;

    _client?.unsubscribe(destination: '/topic/conversation.$conversationId');
    _client?.unsubscribe(
        destination: '/topic/conversation.$conversationId.typing');
    _activeSubscriptions.remove(conversationId);

    if (_currentConversationId == conversationId) {
      _currentConversationId = null;
    }
  }

  void _subscribe(String destination) {
    _client?.subscribe(
      destination: destination,
      callback: (StompFrame frame) {
        if (frame.body == null) return;
        try {
          final data = jsonDecode(frame.body!) as Map<String, dynamic>;
          _routeMessage(destination, data);
        } catch (_) {
          // Ignore malformed messages
        }
      },
    );
  }

  void _routeMessage(String destination, Map<String, dynamic> data) {
    if (destination.contains('.typing')) {
      _typingController.add(data);
    } else if (destination.contains('presence')) {
      _presenceController.add(data);
    } else {
      _messageController.add(data);
    }
  }

  /// Send a message to a conversation via WebSocket.
  void sendMessage({
    required String conversationId,
    required String content,
    String contentType = 'text',
  }) {
    if (_client?.connected != true) return;

    _client!.send(
      destination: '/app/chat.send/$conversationId',
      body: jsonEncode({
        'content': content,
        'contentType': contentType,
      }),
    );

    // Stop typing indicator after sending
    _stopTyping(conversationId);
  }

  /// Send a typing indicator.
  void sendTypingIndicator(String conversationId, bool isTyping) {
    if (_client?.connected != true) return;
    if (this._isTyping == isTyping) return;

    this._isTyping = isTyping;
    _client!.send(
      destination: '/app/chat.typing/$conversationId',
      body: jsonEncode({'typing': isTyping}),
    );
  }

  /// Call when user starts typing — throttles to avoid spam.
  void onUserTyping(String conversationId) {
    if (!isConnected) return;

    if (!_isTyping) {
      _isTyping = true;
      _client?.send(
        destination: '/app/chat.typing/$conversationId',
        body: jsonEncode({'typing': true}),
      );
    }

    // Reset the typing timeout
    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(seconds: 3), () {
      _stopTyping(conversationId);
    });
  }

  void _stopTyping(String conversationId) {
    if (!_isTyping) return;
    _isTyping = false;
    _client?.send(
      destination: '/app/chat.typing/$conversationId',
      body: jsonEncode({'typing': false}),
    );
  }

  /// Mark messages as read.
  void markAsRead(String conversationId, String messageId) {
    if (_client?.connected != true) return;

    _client!.send(
      destination: '/app/chat.read/$conversationId',
      body: jsonEncode({'messageId': messageId}),
    );
  }

  /// Disconnect from WebSocket.
  Future<void> disconnect() async {
    _typingTimer?.cancel();
    _activeSubscriptions.clear();
    _currentConversationId = null;
    _client?.deactivate();
    _client = null;
    _connectionController.add(ConnectionState.disconnected);
  }

  /// Clean up resources.
  void dispose() {
    disconnect();
    _messageController.close();
    _typingController.close();
    _presenceController.close();
    _connectionController.close();
  }
}

enum ConnectionState { connected, disconnected, error, connecting }
