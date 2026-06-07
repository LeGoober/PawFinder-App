import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'messaging_state.dart';

class MessagingCubit extends Cubit<MessagingState> {
  MessagingCubit() : super(MessagingInitial());

  Future<void> loadMessages(String conversationId) async {
    emit(MessagingLoading());
    await Future.delayed(const Duration(seconds: 1));
    emit(
      const MessagesLoaded(
        messages: [
          _MockMessage(
            id: 'm1',
            text: 'Hi! I think I saw Max near the park on Elm Street.',
            senderId: 'finder-1',
            senderName: 'Sarah',
            isOwner: false,
            timestamp: '10:30 AM',
          ),
          _MockMessage(
            id: 'm2',
            text: 'Really? That is close to home. Can you send a photo?',
            senderId: 'owner-1',
            senderName: 'Me',
            isOwner: true,
            timestamp: '10:32 AM',
          ),
          _MockMessage(
            id: 'm3',
            text: 'Sure, I will grab one. He looked a bit scared but unharmed.',
            senderId: 'finder-1',
            senderName: 'Sarah',
            isOwner: false,
            timestamp: '10:33 AM',
          ),
          _MockMessage(
            id: 'm4',
            text: 'Thank you so much! I am heading there now.',
            senderId: 'owner-1',
            senderName: 'Me',
            isOwner: true,
            timestamp: '10:34 AM',
          ),
        ],
      ),
    );
  }

  Future<void> sendMessage(String text) async {
    emit(MessagingLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    emit(const MessageSent());
  }
}

class _MockMessage {
  final String id;
  final String text;
  final String senderId;
  final String senderName;
  final bool isOwner;
  final String timestamp;

  const _MockMessage({
    required this.id,
    required this.text,
    required this.senderId,
    required this.senderName,
    required this.isOwner,
    required this.timestamp,
  });
}
