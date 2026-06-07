import 'package:equatable/equatable.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/entities/conversation.dart' as domain show ConversationStatus;

class ConversationModel extends Equatable {
  final String id;
  final String alertId;
  final String ownerId;
  final String finderId;
  final String status;
  final DateTime createdAt;
  final DateTime? closedAt;

  const ConversationModel({
    required this.id,
    required this.alertId,
    required this.ownerId,
    required this.finderId,
    this.status = 'open',
    required this.createdAt,
    this.closedAt,
  });

  /// Creates a [ConversationModel] from a JSON map.
  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      ConversationModel(
        id: json['id'] as String,
        alertId: json['alertId'] as String,
        ownerId: json['ownerId'] as String,
        finderId: json['finderId'] as String,
        status: json['status'] as String? ?? 'open',
        createdAt: DateTime.parse(json['createdAt'] as String),
        closedAt: json['closedAt'] != null
            ? DateTime.parse(json['closedAt'] as String)
            : null,
      );

  /// Converts this model to a JSON map.
  Map<String, dynamic> toJson() => {
        'id': id,
        'alertId': alertId,
        'ownerId': ownerId,
        'finderId': finderId,
        'status': status,
        'createdAt': createdAt.toIso8601String(),
        'closedAt': closedAt?.toIso8601String(),
      };

  /// Parses the status string to a domain [ConversationStatus] enum.
  domain.ConversationStatus _parseStatus() {
    switch (status) {
      case 'closed':
        return domain.ConversationStatus.closed;
      default:
        return domain.ConversationStatus.open;
    }
  }

  /// Maps this data model to a domain [Conversation] entity.
  Conversation toEntity() => Conversation(
        id: id,
        alertId: alertId,
        ownerId: ownerId,
        finderId: finderId,
        status: _parseStatus(),
        createdAt: createdAt,
        closedAt: closedAt,
      );

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
