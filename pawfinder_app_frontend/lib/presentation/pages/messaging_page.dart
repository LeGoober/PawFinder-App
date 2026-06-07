import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../widgets/info_banner.dart';

class MessagingPage extends StatelessWidget {
  const MessagingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              'Conversation about Max',
              style: AppTypography.h3.copyWith(color: AppColors.ink900),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          InfoBanner(
            message:
                '\uD83D\uDD12 Your phone and email are hidden. Stay in-app.',
            type: InfoBannerType.info,
          ),
          Expanded(
            child: _buildMessageList(),
          ),
          _buildInputBar(context),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    final messages = [
      _ChatMessage(
        text: 'Hi! I think I saw Max near the park on Elm Street.',
        sender: 'Sarah',
        isOwner: false,
        timestamp: '10:30 AM',
      ),
      _ChatMessage(
        text: 'Really? That is close to home. Can you send a photo?',
        sender: 'You',
        isOwner: true,
        timestamp: '10:32 AM',
      ),
      _ChatMessage(
        text: 'Sure, I will grab one. He looked a bit scared but unharmed.',
        sender: 'Sarah',
        isOwner: false,
        timestamp: '10:33 AM',
      ),
      _ChatMessage(
        text: 'Thank you so much! I am heading there now.',
        sender: 'You',
        isOwner: true,
        timestamp: '10:34 AM',
      ),
    ];

    return ListView.separated(
      padding: AppSpacing.paddingLg,
      itemCount: messages.length,
      separatorBuilder: (_, __) => AppSpacing.sm,
      itemBuilder: (context, index) {
        final message = messages[index];
        return _ChatBubble(message: message);
      },
    );
  }

  Widget _buildInputBar(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingMd.copyWith(
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(color: AppColors.ink100),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.camera_alt_outlined,
                color: AppColors.ink500,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(
                Icons.location_on_outlined,
                color: AppColors.ink500,
              ),
              onPressed: () {},
            ),
            Expanded(
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius:
                      BorderRadius.circular(AppSpacing.radiusPill),
                  border: Border.all(color: AppColors.ink100),
                ),
                child: TextField(
                  style: AppTypography.body.copyWith(
                    color: AppColors.ink900,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: AppTypography.body.copyWith(
                      color: AppColors.ink300,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius:
                    BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.send_rounded,
                  color: AppColors.background,
                  size: 20,
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final String sender;
  final bool isOwner;
  final String timestamp;

  const _ChatMessage({
    required this.text,
    required this.sender,
    required this.isOwner,
    required this.timestamp,
  });
}

class _ChatBubble extends StatelessWidget {
  final _ChatMessage message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final alignment =
        message.isOwner ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: message.isOwner
                ? AppColors.primaryLight
                : AppColors.surface,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(message.isOwner ? 16 : 4),
              bottomRight: Radius.circular(message.isOwner ? 4 : 16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.sender,
                style: AppTypography.caption.copyWith(
                  color: AppColors.ink500,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                message.text,
                style: AppTypography.body.copyWith(
                  color: AppColors.ink900,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          message.timestamp,
          style: AppTypography.caption.copyWith(
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
