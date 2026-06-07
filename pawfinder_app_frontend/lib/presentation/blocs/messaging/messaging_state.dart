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

class MessagesLoaded extends MessagingState {
  final List<_MockMessage> messages;

  const MessagesLoaded({required this.messages});

  @override
  List<Object?> get props => [messages];
}

class MessageSent extends MessagingState {
  const MessageSent();
}

class MessagingError extends MessagingState {
  final String message;

  const MessagingError({required this.message});

  @override
  List<Object?> get props => [message];
}
