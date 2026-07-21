import 'package:flutter/material.dart';

class AccountRecoveryScreen extends StatefulWidget {
  const AccountRecoveryScreen({super.key});

  @override
  State<AccountRecoveryScreen> createState() => _AccountRecoveryScreenState();
}

class _AccountRecoveryScreenState extends State<AccountRecoveryScreen> {
  int _currentStep = 0;
  bool _phoneVerified = false;
  bool _identityVerified = false;
  bool _recoverySuccess = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account Recovery')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProgressIndicator(),
              const SizedBox(height: 32),
              if (!_recoverySuccess)
                _buildRecoverySteps()
              else
                _buildSuccessScreen(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account Recovery',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 4),
        Text(
          'Tiered, risk-based recovery process',
          style: TextStyle(color: Colors.grey[600]),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            _buildStepIndicator(
              1,
              'Phone Verify',
              _phoneVerified,
              _currentStep >= 1,
            ),
            _buildConnector(_phoneVerified),
            _buildStepIndicator(
              2,
              'Identity Check',
              _identityVerified,
              _currentStep >= 2,
            ),
            _buildConnector(_identityVerified),
            _buildStepIndicator(
              3,
              'Recovery',
              _recoverySuccess,
              _currentStep >= 3,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStepIndicator(
    int number,
    String label,
    bool completed,
    bool current,
  ) {
    Color backgroundColor;
    if (completed) {
      backgroundColor = Colors.green;
    } else if (current) {
      backgroundColor = Theme.of(context).colorScheme.primary;
    } else {
      backgroundColor = Colors.grey[300]!;
    }

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: completed
                  ? const Icon(Icons.check, color: Colors.white)
                  : Text(
                      '$number',
                      style: TextStyle(
                        color: current ? Colors.white : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildConnector(bool completed) {
    return Expanded(
      child: Container(
        height: 2,
        color: completed ? Colors.green : Colors.grey[300],
      ),
    );
  }

  Widget _buildRecoverySteps() {
    if (_currentStep == 0) {
      return _buildPhoneVerificationStep();
    } else if (_currentStep == 1) {
      return _buildIdentityVerificationStep();
    } else {
      return _buildRecoveryStep();
    }
  }

  Widget _buildPhoneVerificationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Verify Your Phone',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Text(
          'We\'ll send a verification code to your registered phone number.',
          style: TextStyle(color: Colors.grey[600]),
        ),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Phone Number', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                const SizedBox(height: 8),
                Text('+91 98765 43210', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () => _showOtpDialog(),
          child: const SizedBox(
            width: double.infinity,
            child: Center(child: Text('Send OTP')),
          ),
        ),
      ],
    );
  }

  Widget _buildIdentityVerificationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Verify Your Identity',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Text(
          'Please answer security questions to verify your identity.',
          style: TextStyle(color: Colors.grey[600]),
        ),
        const SizedBox(height: 24),
        _buildSecurityQuestion(
          'What is your pet\'s name?',
          _buildAnswerField('Enter your answer'),
        ),
        const SizedBox(height: 16),
        _buildSecurityQuestion(
          'In which city were you born?',
          _buildAnswerField('Enter your answer'),
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () => setState(() {
            _identityVerified = true;
            _currentStep = 2;
          }),
          child: const SizedBox(
            width: double.infinity,
            child: Center(child: Text('Verify Identity')),
          ),
        ),
      ],
    );
  }

  Widget _buildRecoveryStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account Recovery Options',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Text(
          'Choose how you\'d like to recover your account access.',
          style: TextStyle(color: Colors.grey[600]),
        ),
        const SizedBox(height: 24),
        _buildRecoveryOption(
          Icons.pin,
          'Reset PIN',
          'Create a new login PIN',
          () => _completeRecovery(),
        ),
        const SizedBox(height: 12),
        _buildRecoveryOption(
          Icons.vpn_key,
          'Reset TOTP',
          'Enroll new travel authentication',
          () => _completeRecovery(),
        ),
        const SizedBox(height: 12),
        _buildRecoveryOption(
          Icons.phone,
          'Contact Support',
          'Talk to our support team',
          () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Connecting to support...')),
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityQuestion(String question, Widget answer) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            answer,
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerField(String hint) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  Widget _buildRecoveryOption(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSuccessScreen() {
    return Column(
      children: [
        Icon(
          Icons.check_circle,
          size: 72,
          color: Colors.green,
        ),
        const SizedBox(height: 24),
        Text(
          'Account Recovered',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Your account has been successfully recovered.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[600]),
        ),
        const SizedBox(height: 32),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Recovery Summary', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 16),
                _summaryItem('Phone Verified', '✓'),
                _summaryItem('Identity Verified', '✓'),
                _summaryItem('PIN Reset', '✓'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: const SizedBox(
            width: double.infinity,
            child: Center(child: Text('Done')),
          ),
        ),
      ],
    );
  }

  Widget _summaryItem(String label, String status) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(status, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  void _showOtpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter OTP'),
        content: TextField(
          keyboardType: TextInputType.number,
          maxLength: 6,
          decoration: const InputDecoration(
            hintText: 'Enter 6-digit OTP',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _phoneVerified = true;
                _currentStep = 1;
              });
            },
            child: const Text('Verify'),
          ),
        ],
      ),
    );
  }

  void _completeRecovery() {
    setState(() {
      _recoverySuccess = true;
      _currentStep = 3;
    });
  }
}
