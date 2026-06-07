import 'package:equatable/equatable.dart';

/// Possible conversation statuses.
enum ConversationStatus { open, closed }

/// Domain entity representing a conversation between a pet owner and a finder.
class Conversation extends Equatable {
  final String id;
  final String alertId;
  final String ownerId;
  final String finderId;
  final ConversationStatus status;
  final DateTime createdAt;
  final DateTime? closedAt;

  const Conversation({
    required this.id,
    required this.alertId,
    required this.ownerId,
    required this.finderId,
    this.status = ConversationStatus.open,
    required this.createdAt,
    this.closedAt,
  });

  @override
  List<Object?> get props => [
        id,
        alertId,
        ownerId,
        finderId,
        status,
        createdAt,
        closedAt,
      ];
}
