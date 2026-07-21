class Account {
  final String accountNumber;
  final String accountType; // SAVINGS, CURRENT
  final String accountName;
  final double balance;
  final String currency;
  final bool isPrimary;

  Account({
    required this.accountNumber,
    required this.accountType,
    required this.accountName,
    required this.balance,
    required this.currency,
    required this.isPrimary,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      accountNumber: json['account_number'] ?? '',
      accountType: json['account_type'] ?? 'SAVINGS',
      accountName: json['account_name'] ?? '',
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] ?? 'INR',
      isPrimary: json['is_primary'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'account_number': accountNumber,
    'account_type': accountType,
    'account_name': accountName,
    'balance': balance,
    'currency': currency,
    'is_primary': isPrimary,
  };
}
