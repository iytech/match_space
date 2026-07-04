import '../core/constants/app_constants.dart';

class UserProfile {
  final String id;
  final String fullName;
  final String? email;
  final String? phone;
  final String? avatarUrl;
  final UserRole role;
  final SubscriptionTier tier;
  final DateTime createdAt;

  const UserProfile({
    required this.id,
    required this.fullName,
    this.email,
    this.phone,
    this.avatarUrl,
    this.role = UserRole.user,
    this.tier = SubscriptionTier.free,
    required this.createdAt,
  });

  bool get isAdmin => role == UserRole.admin;
  bool get isPremium => tier == SubscriptionTier.premium;

  factory UserProfile.fromMap(Map<String, dynamic> m) => UserProfile(
        id: m['id'] as String,
        fullName: (m['full_name'] ?? 'User') as String,
        email: m['email'] as String?,
        phone: m['phone'] as String?,
        avatarUrl: m['avatar_url'] as String?,
        role: UserRole.values.firstWhere(
          (r) => r.name == m['role'],
          orElse: () => UserRole.user,
        ),
        tier: SubscriptionTier.values.firstWhere(
          (t) => t.name == m['tier'],
          orElse: () => SubscriptionTier.free,
        ),
        createdAt: DateTime.tryParse(m['created_at']?.toString() ?? '') ??
            DateTime.now(),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'avatar_url': avatarUrl,
        'role': role.name,
        'tier': tier.name,
      };

  UserProfile copyWith({String? fullName, String? phone, String? avatarUrl,
      SubscriptionTier? tier}) =>
      UserProfile(
        id: id,
        fullName: fullName ?? this.fullName,
        email: email,
        phone: phone ?? this.phone,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        role: role,
        tier: tier ?? this.tier,
        createdAt: createdAt,
      );
}
