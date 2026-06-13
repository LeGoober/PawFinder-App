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

  const MessagesLoaded({required this.messages});

  @override
  List<Object?> get props => [messages];
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
