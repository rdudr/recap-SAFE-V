class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String deviceId;
  final bool isAbroad;
  final DateTime lastLogin;
  final String accountStatus; // ACTIVE, PROBATION, BLOCKED

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.deviceId,
    required this.isAbroad,
    required this.lastLogin,
    required this.accountStatus,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      deviceId: json['device_id'] ?? '',
      isAbroad: json['is_abroad'] ?? false,
      lastLogin: json['last_login'] != null
          ? DateTime.parse(json['last_login'])
          : DateTime.now(),
      accountStatus: json['account_status'] ?? 'ACTIVE',
    );
  }

  Map<String, dynamic> toJson() => {
    'user_id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'device_id': deviceId,
    'is_abroad': isAbroad,
    'last_login': lastLogin.toIso8601String(),
    'account_status': accountStatus,
  };
}
