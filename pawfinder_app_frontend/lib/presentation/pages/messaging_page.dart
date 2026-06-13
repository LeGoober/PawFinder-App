import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../di/injection.dart';
import '../../domain/entities/message.dart';
import '../blocs/messaging/messaging_cubit.dart';
import '../widgets/info_banner.dart';
import '../widgets/skeleton_loader.dart';

class MessagingPage extends StatefulWidget {
  final String conversationId;

  const MessagingPage({super.key, required this.conversationId});

  @override
  State<MessagingPage> createState() => _MessagingPageState();
}

class _MessagingPageState extends State<MessagingPage> {
  late final MessagingCubit _cubit;
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _cubit = MessagingCubit(conversationRepository: getIt());
    _cubit.setCurrentUserId('current-user-id');
    _cubit.loadMessages(widget.conversationId);
  }

  @override
  void dispose() {
    _cubit.close();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _cubit.sendMessage(
      conversationId: widget.conversationId,
      content: text,
    );
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.ink900),
            onPressed: () => context.pop(),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Conversation',
                style: AppTypography.h3.copyWith(color: AppColors.ink900),
              ),
            ],
          ),
        ),
        body: BlocConsumer<MessagingCubit, MessagingState>(
          bloc: _cubit,
          listener: (context, state) {
            if (state is MessageSent) {
              // Reload messages to show the new one
              _cubit.loadMessages(widget.conversationId);
            }
          },
          builder: (context, state) {
            if (state is MessagingLoading) {
              return const SkeletonListLoader(itemCount: 4);
            }

            if (state is MessagesLoaded) {
              return Column(
                children: [
                  InfoBanner(
                    message: 'Your contact info is hidden. Stay in-app.',
                    type: InfoBannerType.info,
                  ),
                  Expanded(
                    child: _buildMessageList(state.messages),
                  ),
                  _buildInputBar(context),
                ],
              );
            }

            if (state is MessagingError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: AppColors.danger),
                    const SizedBox(height: 12),
                    Text(state.message, style: AppTypography.body),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () =>
                          _cubit.loadMessages(widget.conversationId),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildMessageList(List<Message> messages) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        // In production, compare with currentUserId
        final isOwner = index % 2 == 0;
        final sender = isOwner ? 'You' : 'Finder';

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _MessageBubble(
            text: msg.content,
            sender: sender,
            isOwner: isOwner,
            time: _formatTime(msg.createdAt),
          ),
        );
      },
    );
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Widget _buildInputBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12).copyWith(
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.ink100)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.camera_alt_outlined,
                  color: AppColors.ink500),
              onPressed: () {},
            ),
            Expanded(
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.ink100),
                ),
                child: TextField(
                  controller: _textController,
                  style:
                      AppTypography.body.copyWith(color: AppColors.ink900),
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: AppTypography.body.copyWith(
                      color: AppColors.ink300,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.send_rounded,
                    color: Colors.white, size: 20),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final String text;
  final String sender;
  final bool isOwner;
  final String time;

  const _MessageBubble({
    required this.text,
    required this.sender,
    required this.isOwner,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final alignment = isOwner ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isOwner ? AppColors.primaryLight : AppColors.surface,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(isOwner ? 16 : 4),
              bottomRight: Radius.circular(isOwner ? 4 : 16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sender,
                style: AppTypography.caption.copyWith(
                  color: AppColors.ink500,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                text,
                style: AppTypography.body.copyWith(color: AppColors.ink900),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(time, style: AppTypography.caption.copyWith(fontSize: 10)),
      ],
    );
  }
}
