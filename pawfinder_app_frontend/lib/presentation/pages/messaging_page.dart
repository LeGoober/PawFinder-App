import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../di/injection.dart';
import '../../domain/entities/message.dart';
import '../../services/websocket_service.dart';
import '../blocs/messaging/messaging_cubit.dart';
import '../blocs/messaging/messaging_state.dart';
import '../widgets/info_banner.dart';
import '../widgets/skeleton_loader.dart';

class MessagingPage extends StatefulWidget {
  final String conversationId;
  final String? recipientName;

  const MessagingPage({
    super.key,
    required this.conversationId,
    this.recipientName,
  });

  @override
  State<MessagingPage> createState() => _MessagingPageState();
}

class _MessagingPageState extends State<MessagingPage> {
  late final MessagingCubit _cubit;
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();
  bool _showScrollToBottom = false;

  @override
  void initState() {
    super.initState();
    _cubit = MessagingCubit(
      conversationRepository: getIt(),
      wsService: getIt<WebSocketService>(),
    );
    _cubit.setCurrentUserId('current-user-id');
    _cubit.connectWebSocket();
    _cubit.loadMessages(widget.conversationId);

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _cubit.leaveConversation();
    _cubit.close();
    _textController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onScroll() {
    final show = _scrollController.hasClients &&
        _scrollController.position.maxScrollExtent -
                _scrollController.offset >
            200;
    if (show != _showScrollToBottom) {
      setState(() => _showScrollToBottom = show);
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _cubit.sendMessage(
      conversationId: widget.conversationId,
      content: text,
    );
    _textController.clear();
    _focusNode.requestFocus();

    // Scroll to bottom after sending
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(),
        body: BlocConsumer<MessagingCubit, MessagingState>(
          bloc: _cubit,
          listener: (context, state) {
            if (state is MessagesLoaded) {
              WidgetsBinding.instance
                  .addPostFrameCallback((_) => _scrollToBottom());
            }
          },
          builder: (context, state) {
            if (state is MessagingLoading) {
              return const SkeletonListLoader(itemCount: 6);
            }

            if (state is MessagesLoaded) {
              return Column(
                children: [
                  // Connection status banner
                  if (state.connectionStatus != ConnectionStatus.connected)
                    _buildConnectionBanner(state.connectionStatus),
                  // Security notice
                  const InfoBanner(
                    message:
                        '🔒 Your contact info is hidden. Chat safely in-app.',
                    type: InfoBannerType.info,
                  ),
                  // Messages
                  Expanded(child: _buildMessageList(state)),
                  // Typing indicator
                  if (state.isRecipientTyping) _buildTypingIndicator(),
                  // Input bar
                  _buildInputBar(context),
                ],
              );
            }

            if (state is MessagingError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: AppColors.danger),
                      const SizedBox(height: 12),
                      Text(state.message,
                          style: AppTypography.body,
                          textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () =>
                            _cubit.loadMessages(widget.conversationId),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.ink900),
        onPressed: () => context.pop(),
      ),
      title: BlocBuilder<MessagingCubit, MessagingState>(
        bloc: _cubit,
        builder: (context, state) {
          final isOnline = state is MessagesLoaded &&
              state.connectionStatus == ConnectionStatus.connected;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.recipientName ?? 'Conversation',
                style: AppTypography.h3.copyWith(color: AppColors.ink900),
              ),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isOnline ? AppColors.success : AppColors.ink300,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isOnline ? 'Online' : 'Offline',
                    style: AppTypography.caption.copyWith(
                      color: isOnline ? AppColors.success : AppColors.ink500,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.phone_outlined, color: AppColors.ink500),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.videocam_outlined, color: AppColors.ink500),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.more_vert, color: AppColors.ink500),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildConnectionBanner(ConnectionStatus status) {
    final text = status == ConnectionStatus.connecting
        ? 'Connecting...'
        : 'Messages may be delayed — reconnecting...';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      color: AppColors.warning.withValues(alpha: 0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (status == ConnectionStatus.connecting)
            const SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          if (status == ConnectionStatus.connecting) const SizedBox(width: 8),
          Text(
            text,
            style: AppTypography.caption.copyWith(color: AppColors.warning),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList(MessagesLoaded state) {
    final messages = state.messages;
    if (messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(Icons.chat_bubble_outline,
                  size: 36, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(
              'No messages yet',
              style: AppTypography.h3.copyWith(color: AppColors.ink900),
            ),
            const SizedBox(height: 4),
            Text(
              'Send a message to start the conversation',
              style: AppTypography.body.copyWith(color: AppColors.ink500),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final msg = messages[index];
            final isOwner = msg.senderId == _cubit.currentUserId;

            // Show date separator for first message or when date changes
            final showDate = index == 0 ||
                messages[index].createdAt.day !=
                    messages[index - 1].createdAt.day;

            return Column(
              children: [
                if (showDate)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: _DateSeparator(date: msg.createdAt),
                  ),
                _MessageBubble(
                  text: msg.content,
                  isOwner: isOwner,
                  time: _formatTime(msg.createdAt),
                  status: isOwner ? _getMessageStatus(msg) : null,
                ),
              ],
            );
          },
        ),
        // Scroll to bottom FAB
        if (_showScrollToBottom)
          Positioned(
            bottom: 8,
            right: 8,
            child: FloatingActionButton.small(
              backgroundColor: AppColors.primary,
              onPressed: _scrollToBottom,
              child: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
            ),
          ),
      ],
    );
  }

  String? _getMessageStatus(Message msg) {
    if (msg.readAt != null) return 'read';
    // In a full implementation, check delivery status from WebSocket
    return 'sent';
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          const SizedBox(
            width: 36,
            child: _TypingDots(),
          ),
          const SizedBox(width: 8),
          Text(
            'typing...',
            style: AppTypography.caption.copyWith(
              color: AppColors.ink500,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8).copyWith(
        bottom: MediaQuery.of(context).padding.bottom + 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.ink100)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Attachment button
            IconButton(
              icon: const Icon(Icons.attach_file, color: AppColors.ink500),
              onPressed: () {},
            ),
            // Camera button
            IconButton(
              icon:
                  const Icon(Icons.camera_alt_outlined, color: AppColors.ink500),
              onPressed: () {},
            ),
            // Text input
            Expanded(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 120),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.ink100),
                ),
                child: TextField(
                  controller: _textController,
                  focusNode: _focusNode,
                  style:
                      AppTypography.body.copyWith(color: AppColors.ink900),
                  maxLines: null,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    hintText: 'Message',
                    hintStyle: AppTypography.body.copyWith(
                      color: AppColors.ink300,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 10),
                  ),
                  onChanged: (_) => _cubit.onTyping(),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 4),
            // Send / Mic button
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

  String _formatTime(DateTime dt) {
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

/// Animated typing dots like WhatsApp.
class _TypingDots extends StatefulWidget {
  const _TypingDots();

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) {
            final delay = i * 0.2;
            final t = ((_controller.value - delay) % 1.0).clamp(0.0, 1.0);
            final scale = 0.4 + (0.6 * (t < 0.5 ? t * 2 : 2 - t * 2));
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1.5),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.ink500,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

/// Date separator showing "Today", "Yesterday", or the date.
class _DateSeparator extends StatelessWidget {
  final DateTime date;

  const _DateSeparator({required this.date});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final msgDate = DateTime(date.year, date.month, date.day);

    String label;
    if (msgDate == today) {
      label = 'Today';
    } else if (msgDate == yesterday) {
      label = 'Yesterday';
    } else {
      label =
          '${date.day}/${date.month}/${date.year}';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.ink100.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: AppColors.ink500,
          fontSize: 11,
        ),
      ),
    );
  }
}

/// Message bubble with WhatsApp-style design.
class _MessageBubble extends StatelessWidget {
  final String text;
  final bool isOwner;
  final String time;
  final String? status;

  const _MessageBubble({
    required this.text,
    required this.isOwner,
    required this.time,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment:
            isOwner ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Avatar for received messages
          if (!isOwner)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: const Icon(Icons.person,
                    size: 16, color: AppColors.primary),
              ),
            ),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isOwner ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isOwner ? 16 : 4),
                  bottomRight: Radius.circular(isOwner ? 4 : 16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    text,
                    style: AppTypography.body.copyWith(
                      color: isOwner ? Colors.white : AppColors.ink900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        time,
                        style: AppTypography.caption.copyWith(
                          fontSize: 10,
                          color: isOwner
                              ? Colors.white70
                              : AppColors.ink500,
                        ),
                      ),
                      if (isOwner && status != null) ...[
                        const SizedBox(width: 4),
                        Icon(
                          status == 'read'
                              ? Icons.done_all
                              : Icons.done,
                          size: 14,
                          color: status == 'read'
                              ? Colors.lightBlueAccent
                              : Colors.white70,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
