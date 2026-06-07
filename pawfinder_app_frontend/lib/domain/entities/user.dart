import 'package:equatable/equatable.dart';

/// Domain entity representing a user.
class User extends Equatable {
  final String id;
  final String? authProvider;
  final String? displayName;
  final bool verified;
  final int rescuerBadgeLevel;
  final DateTime createdAt;
  final DateTime? lastActive;

  const User({
    required this.id,
    this.authProvider,
    this.displayName,
    this.verified = false,
    this.rescuerBadgeLevel = 0,
    required this.createdAt,
    this.lastActive,
  });

  /// Returns a copy with the given fields replaced.
  User copyWith({
    String? id,
    String? authProvider,
    bool? authProviderNull, // set to true to nullify
    String? displayName,
    bool? displayNameNull,
    bool? verified,
    int? rescuerBadgeLevel,
    DateTime? createdAt,
    DateTime? lastActive,
    bool? lastActiveNull,
  }) {
    return User(
      id: id ?? this.id,
      authProvider: authProviderNull == true ? null : (authProvider ?? this.authProvider),
      displayName: displayNameNull == true ? null : (displayName ?? this.displayName),
      verified: verified ?? this.verified,
      rescuerBadgeLevel: rescuerBadgeLevel ?? this.rescuerBadgeLevel,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActiveNull == true ? null : (lastActive ?? this.lastActive),
    );
  }

  @override
  List<Object?> get props => [
        id,
        authProvider,
        displayName,
        verified,
        rescuerBadgeLevel,
        createdAt,
        lastActive,
      ];
}
