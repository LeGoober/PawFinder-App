import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

class UserModel extends Equatable {
  final String id;
  final String? authProvider;
  final String? displayName;
  final String? email;
  final String? phoneHash;
  final bool verified;
  final int rescuerBadgeLevel;
  final DateTime createdAt;
  final DateTime? lastActive;

  // Transient — not persisted in the entity, used during auth response parsing
  final String? accessToken;
  final String? refreshToken;

  const UserModel({
    required this.id,
    this.authProvider,
    this.displayName,
    this.email,
    this.phoneHash,
    this.verified = false,
    this.rescuerBadgeLevel = 0,
    required this.createdAt,
    this.lastActive,
    this.accessToken,
    this.refreshToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        authProvider: json['authProvider'] as String?,
        displayName: json['displayName'] as String?,
        email: json['email'] as String?,
        phoneHash: json['phoneHash'] as String?,
        verified: json['verified'] as bool? ?? false,
        rescuerBadgeLevel: json['rescuerBadgeLevel'] as int? ?? 0,
        createdAt: DateTime.parse(json['createdAt'] as String),
        lastActive: json['lastActive'] != null
            ? DateTime.parse(json['lastActive'] as String)
            : null,
        accessToken: json['accessToken'] as String?,
        refreshToken: json['refreshToken'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'authProvider': authProvider,
        'displayName': displayName,
        'email': email,
        'phoneHash': phoneHash,
        'verified': verified,
        'rescuerBadgeLevel': rescuerBadgeLevel,
        'createdAt': createdAt.toIso8601String(),
        'lastActive': lastActive?.toIso8601String(),
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      };

  User toEntity() => User(
        id: id,
        authProvider: authProvider,
        displayName: displayName,
        email: email,
        phoneHash: phoneHash,
        verified: verified,
        rescuerBadgeLevel: rescuerBadgeLevel,
        createdAt: createdAt,
        lastActive: lastActive,
      );

  @override
  List<Object?> get props => [
        id,
        authProvider,
        displayName,
        email,
        phoneHash,
        verified,
        rescuerBadgeLevel,
        createdAt,
        lastActive,
        accessToken,
        refreshToken,
      ];
}
