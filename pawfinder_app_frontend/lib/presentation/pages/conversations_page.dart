import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../di/injection.dart';
import '../../domain/entities/conversation.dart';
import '../blocs/auth/auth_cubit.dart';
import '../blocs/messaging/messaging_cubit.dart';
import '../widgets/empty_state.dart';
import '../widgets/skeleton_loader.dart';

class ConversationsPage extends StatefulWidget {
  const ConversationsPage({super.key});

  @override
  State<ConversationsPage> createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  late final MessagingCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = MessagingCubit(conversationRepository: getIt());
    // Pull real user ID from AuthCubit
    final authCubit = context.read<AuthCubit>();
    final userId = authCubit.currentUser?.id ?? 'anonymous';
    _cubit.setCurrentUserId(userId);
    _cubit.loadConversations();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
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
          title: Text(
            'Messages',
            style: AppTypography.h2.copyWith(color: AppColors.ink900),
          ),
        ),
        body: BlocBuilder<MessagingCubit, MessagingState>(
          bloc: _cubit,
          builder: (context, state) {
            if (state is MessagingLoading) {
              return const SkeletonListLoader(itemCount: 4);
            }

            if (state is ConversationsLoaded) {
              if (state.conversations.isEmpty) {
                return const EmptyState(
                  icon: Icons.chat_bubble_outline,
                  title: 'No messages yet',
                  subtitle:
                      'When someone reports a sighting of a pet, conversations will appear here.',
                );
              }

              return RefreshIndicator(
                onRefresh: () => _cubit.loadConversations(),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: state.conversations.length,
                  separatorBuilder: (_, __) => const Divider(
                    height: 1,
                    indent: 72,
                    color: AppColors.ink100,
                  ),
                  itemBuilder: (context, index) {
                    final conv = state.conversations[index];
                    return _ConversationTile(
                      conversation: conv,
                      onTap: () {
                        context.push('/messages/${conv.id}');
                      },
                    );
                  },
                ),
              );
            }

            if (state is MessagingError) {
              return Padding(
                padding: const EdgeInsets.all(24),
                child: EmptyState(
                  icon: Icons.error_outline,
                  title: 'Failed to load messages',
                  subtitle: state.message,
                  actionText: 'Retry',
                  onAction: () => _cubit.loadConversations(),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback onTap;

  const _ConversationTile({
    required this.conversation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isOpen = conversation.status == ConversationStatus.open;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      leading: CircleAvatar(
        radius: 24,
        backgroundColor:
            isOpen ? AppColors.primary.withValues(alpha: 0.1) : AppColors.ink100,
        child: Icon(
          Icons.person,
          color: isOpen ? AppColors.primary : AppColors.border,
        ),
      ),
      title: Text(
        'Conversation #${conversation.id.substring(0, 8)}',
        style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        isOpen ? 'Active' : 'Closed',
        style: AppTypography.caption.copyWith(
          color: isOpen ? AppColors.success : AppColors.ink500,
        ),
      ),
      trailing: isOpen
          ? Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
            )
          : null,
      onTap: onTap,
    );
  }
}
