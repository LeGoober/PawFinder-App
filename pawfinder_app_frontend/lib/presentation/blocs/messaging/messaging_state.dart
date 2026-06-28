part of 'messaging_cubit.dart';

abstract class MessagingState extends Equatable {
  const MessagingState();

  @override
  List<Object?> get props => [];
}

class MessagingInitial extends MessagingState {
  const MessagingInitial();
}

class MessagingLoading extends MessagingState {
  const MessagingLoading();
}

class ConversationsLoaded extends MessagingState {
  final List<Conversation> conversations;

  const ConversationsLoaded({required this.conversations});

  @override
  List<Object?> get props => [conversations];
}

class MessagesLoaded extends MessagingState {
  final List<Message> messages;
  final ConnectionStatus connectionStatus;
  final bool isRecipientTyping;

  const MessagesLoaded({
    required this.messages,
    this.connectionStatus = ConnectionStatus.disconnected,
    this.isRecipientTyping = false,
  });

  MessagesLoaded copyWith({
    List<Message>? messages,
    ConnectionStatus? connectionStatus,
    bool? isRecipientTyping,
  }) {
    return MessagesLoaded(
      messages: messages ?? this.messages,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      isRecipientTyping: isRecipientTyping ?? this.isRecipientTyping,
    );
  }

  @override
  List<Object?> get props => [messages, connectionStatus, isRecipientTyping];
}

class MessageSent extends MessagingState {
  final Message message;

  const MessageSent({required this.message});

  @override
  List<Object?> get props => [message];
}

class MessagingError extends MessagingState {
  final String message;

  const MessagingError({required this.message});

  @override
  List<Object?> get props => [message];
}

enum ConnectionStatus { connected, disconnected, connecting }
