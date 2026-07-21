class TotpSecret {
  final String secret;
  final String qrCode;
  final String backupCodes;
  final DateTime createdAt;
  final bool isActive;
  final String deviceName;

  TotpSecret({
    required this.secret,
    required this.qrCode,
    required this.backupCodes,
    required this.createdAt,
    required this.isActive,
    required this.deviceName,
  });

  factory TotpSecret.fromJson(Map<String, dynamic> json) {
    return TotpSecret(
      secret: json['secret'] ?? '',
      qrCode: json['qr_code'] ?? '',
      backupCodes: json['backup_codes'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      isActive: json['is_active'] ?? false,
      deviceName: json['device_name'] ?? 'Mobile Device',
    );
  }

  Map<String, dynamic> toJson() => {
    'secret': secret,
    'qr_code': qrCode,
    'backup_codes': backupCodes,
    'created_at': createdAt.toIso8601String(),
    'is_active': isActive,
    'device_name': deviceName,
  };
}
