class RiskSignal {
  final String signal;
  final double score;
  final String severity; // LOW, MEDIUM, HIGH, CRITICAL

  RiskSignal({
    required this.signal,
    required this.score,
    required this.severity,
  });

  factory RiskSignal.fromJson(Map<String, dynamic> json) {
    return RiskSignal(
      signal: json['signal'] ?? '',
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      severity: json['severity'] ?? 'LOW',
    );
  }
}

class RiskAssessment {
  final double overallScore;
  final String decision; // ALLOW, STEP_UP, BLOCK
  final List<RiskSignal> topSignals;
  final String stepupChannel; // TOTP, SMS_OTP, CALL_OTP
  final String explanation;

  RiskAssessment({
    required this.overallScore,
    required this.decision,
    required this.topSignals,
    required this.stepupChannel,
    required this.explanation,
  });

  factory RiskAssessment.fromJson(Map<String, dynamic> json) {
    final signals = (json['top_signals'] as List?)
        ?.map((s) => RiskSignal.fromJson(s as Map<String, dynamic>))
        .toList() ?? [];

    return RiskAssessment(
      overallScore: (json['overall_score'] as num?)?.toDouble() ?? 0.0,
      decision: json['decision'] ?? 'ALLOW',
      topSignals: signals,
      stepupChannel: json['stepup_channel'] ?? 'SMS_OTP',
      explanation: json['explanation'] ?? '',
    );
  }
}
