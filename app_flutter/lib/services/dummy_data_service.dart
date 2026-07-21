import '../models/user_model.dart';
import '../models/account_model.dart';
import '../models/transaction_model.dart';
import '../models/totp_model.dart';
import '../models/risk_assessment_model.dart';

class DummyDataService {
  static final DummyDataService _instance = DummyDataService._internal();

  factory DummyDataService() {
    return _instance;
  }

  DummyDataService._internal();

  // Dummy Users
  static User getDummyUser() {
    return User(
      id: 'priya',
      name: 'Priya Sharma',
      email: 'priya.sharma@email.com',
      phone: '+91-9876543210',
      deviceId: 'device_abc123xyz',
      isAbroad: false,
      lastLogin: DateTime.now().subtract(const Duration(hours: 2)),
      accountStatus: 'ACTIVE',
    );
  }

  static List<User> getDummyUsers() {
    return [
      User(
        id: 'rajesh',
        name: 'Rajesh Kumar',
        email: 'rajesh.kumar@email.com',
        phone: '+91-9876543211',
        deviceId: 'device_def456uvw',
        isAbroad: true,
        lastLogin: DateTime.now().subtract(const Duration(hours: 1)),
        accountStatus: 'ACTIVE',
      ),
      User(
        id: 'anisha',
        name: 'Anisha Patel',
        email: 'anisha.patel@email.com',
        phone: '+91-9876543212',
        deviceId: 'device_ghi789stu',
        isAbroad: false,
        lastLogin: DateTime.now().subtract(const Duration(days: 1)),
        accountStatus: 'PROBATION',
      ),
    ];
  }

  // Dummy Accounts
  static List<Account> getDummyAccounts() {
    return [
      Account(
        accountNumber: '0123456789',
        accountType: 'SAVINGS',
        accountName: 'Savings Account',
        balance: 84500.00,
        currency: 'INR',
        isPrimary: true,
      ),
      Account(
        accountNumber: '0987654321',
        accountType: 'CURRENT',
        accountName: 'Business Account',
        balance: 250000.00,
        currency: 'INR',
        isPrimary: false,
      ),
      Account(
        accountNumber: '1122334455',
        accountType: 'SAVINGS',
        accountName: 'Emergency Fund',
        balance: 50000.00,
        currency: 'INR',
        isPrimary: false,
      ),
    ];
  }

  // Dummy Transactions
  static List<Transaction> getDummyTransactions() {
    final now = DateTime.now();
    return [
      Transaction(
        id: 'txn_001',
        type: 'PAYMENT',
        amount: 2500.00,
        currency: 'INR',
        status: 'COMPLETED',
        description: 'Coffee shop payment',
        timestamp: now.subtract(const Duration(hours: 3)),
        recipientName: 'Brew Haven Cafe',
        riskScore: '15',
        trustDecision: 'ALLOW',
      ),
      Transaction(
        id: 'txn_002',
        type: 'TRANSFER',
        amount: 10000.00,
        currency: 'INR',
        status: 'COMPLETED',
        description: 'Money transfer to Rajesh',
        timestamp: now.subtract(const Duration(hours: 5)),
        recipientName: 'Rajesh Kumar',
        recipientAccount: '1234567890',
        riskScore: '28',
        trustDecision: 'ALLOW',
      ),
      Transaction(
        id: 'txn_003',
        type: 'WITHDRAWAL',
        amount: 5000.00,
        currency: 'INR',
        status: 'COMPLETED',
        description: 'ATM withdrawal',
        timestamp: now.subtract(const Duration(hours: 8)),
        riskScore: '12',
        trustDecision: 'ALLOW',
      ),
      Transaction(
        id: 'txn_004',
        type: 'PAYMENT',
        amount: 15000.00,
        currency: 'INR',
        status: 'PENDING',
        description: 'Online shopping at TechStore',
        timestamp: now.subtract(const Duration(minutes: 15)),
        recipientName: 'TechStore Ltd',
        riskScore: '45',
        trustDecision: 'STEP_UP',
      ),
      Transaction(
        id: 'txn_005',
        type: 'TRANSFER',
        amount: 50000.00,
        currency: 'INR',
        status: 'BLOCKED',
        description: 'International transfer attempt',
        timestamp: now.subtract(const Duration(minutes: 30)),
        recipientName: 'Unknown Account',
        riskScore: '92',
        trustDecision: 'BLOCK',
      ),
      Transaction(
        id: 'txn_006',
        type: 'DEPOSIT',
        amount: 30000.00,
        currency: 'INR',
        status: 'COMPLETED',
        description: 'Salary deposit',
        timestamp: now.subtract(const Duration(days: 1)),
        riskScore: '5',
        trustDecision: 'ALLOW',
      ),
    ];
  }

  // Dummy TOTP Secrets
  static TotpSecret getDummyTotpSecret() {
    return TotpSecret(
      secret: 'JBSWY3DPEBLW64TMMQ======',
      qrCode: 'iVBORw0KGgoAAAANSUhEUgAAAMIAAADCAQAAABJV...', // Base64 encoded QR code
      backupCodes: '''
8765-4321
5432-1098
2109-8765
8765-4321
5432-1098
      '''.trim(),
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      isActive: true,
      deviceName: 'iPhone 14 Pro',
    );
  }

  // Dummy Risk Assessments
  static RiskAssessment getDummyLowRiskAssessment() {
    return RiskAssessment(
      overallScore: 15.0,
      decision: 'ALLOW',
      topSignals: [
        RiskSignal(signal: 'Trusted device', score: 5.0, severity: 'LOW'),
        RiskSignal(signal: 'Known location (home)', score: 10.0, severity: 'LOW'),
      ],
      stepupChannel: 'SMS_OTP',
      explanation: 'Transaction matches your usual patterns. Approved automatically.',
    );
  }

  static RiskAssessment getDummyMediumRiskAssessment() {
    return RiskAssessment(
      overallScore: 45.0,
      decision: 'STEP_UP',
      topSignals: [
        RiskSignal(signal: 'Unusual amount', score: 20.0, severity: 'MEDIUM'),
        RiskSignal(signal: 'New merchant', score: 15.0, severity: 'MEDIUM'),
        RiskSignal(signal: 'Different device used', score: 10.0, severity: 'LOW'),
      ],
      stepupChannel: 'TOTP',
      explanation: 'Transaction amount is higher than usual. Please confirm with TOTP.',
    );
  }

  static RiskAssessment getDummyHighRiskAssessment() {
    return RiskAssessment(
      overallScore: 92.0,
      decision: 'BLOCK',
      topSignals: [
        RiskSignal(signal: 'Potential SIM swap detected', score: 35.0, severity: 'CRITICAL'),
        RiskSignal(signal: 'Device fingerprint changed', score: 25.0, severity: 'HIGH'),
        RiskSignal(signal: 'New IP geolocation (abroad)', score: 20.0, severity: 'HIGH'),
        RiskSignal(signal: 'Rapid transaction sequence', score: 12.0, severity: 'MEDIUM'),
      ],
      stepupChannel: 'CALL_OTP',
      explanation: 'Multiple high-risk signals detected. Transaction blocked for your protection. Contact support.',
    );
  }

  // Get random transaction status
  static String getRandomTransactionStatus() {
    final statuses = ['COMPLETED', 'PENDING', 'FAILED', 'BLOCKED'];
    return statuses[(DateTime.now().millisecond % statuses.length)];
  }

  // Get random risk decision
  static String getRandomRiskDecision() {
    final decisions = ['ALLOW', 'STEP_UP', 'BLOCK'];
    return decisions[(DateTime.now().millisecond % decisions.length)];
  }
}
