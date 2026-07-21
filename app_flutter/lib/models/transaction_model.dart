class Transaction {
  final String id;
  final String type; // PAYMENT, TRANSFER, WITHDRAWAL, DEPOSIT
  final double amount;
  final String currency;
  final String status; // COMPLETED, PENDING, FAILED, BLOCKED
  final String description;
  final DateTime timestamp;
  final String? recipientName;
  final String? recipientAccount;
  final String? riskScore;
  final String? trustDecision;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.currency,
    required this.status,
    required this.description,
    required this.timestamp,
    this.recipientName,
    this.recipientAccount,
    this.riskScore,
    this.trustDecision,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['transaction_id'] ?? '',
      type: json['type'] ?? 'TRANSFER',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] ?? 'INR',
      status: json['status'] ?? 'PENDING',
      description: json['description'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      recipientName: json['recipient_name'],
      recipientAccount: json['recipient_account'],
      riskScore: json['risk_score']?.toString(),
      trustDecision: json['trust_decision'],
    );
  }

  Map<String, dynamic> toJson() => {
    'transaction_id': id,
    'type': type,
    'amount': amount,
    'currency': currency,
    'status': status,
    'description': description,
    'timestamp': timestamp.toIso8601String(),
    'recipient_name': recipientName,
    'recipient_account': recipientAccount,
    'risk_score': riskScore,
    'trust_decision': trustDecision,
  };
}
