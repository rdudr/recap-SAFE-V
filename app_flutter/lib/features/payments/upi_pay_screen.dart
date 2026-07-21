import 'package:flutter/material.dart';
import '../../models/risk_assessment_model.dart';
import '../../services/dummy_data_service.dart';

class UpiPayScreen extends StatefulWidget {
  const UpiPayScreen({super.key});

  @override
  State<UpiPayScreen> createState() => _UpiPayScreenState();
}

class _UpiPayScreenState extends State<UpiPayScreen> {
  final _recipientController = TextEditingController();
  final _amountController = TextEditingController();
  RiskAssessment? _riskAssessment;
  bool _busy = false;
  int _currentStep = 0; // 0: Details, 1: Risk Assessment, 2: Confirmation

  Future<void> _initiatePayment() async {
    if (_recipientController.text.isEmpty || _amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() => _busy = true);
    try {
      // Simulate risk assessment
      await Future.delayed(const Duration(seconds: 1));

      final amount = int.tryParse(_amountController.text) ?? 0;
      late RiskAssessment assessment;

      if (amount > 50000) {
        assessment = DummyDataService.getDummyHighRiskAssessment();
      } else if (amount > 10000) {
        assessment = DummyDataService.getDummyMediumRiskAssessment();
      } else {
        assessment = DummyDataService.getDummyLowRiskAssessment();
      }

      setState(() {
        _riskAssessment = assessment;
        _currentStep = 1;
      });
    } finally {
      setState(() => _busy = false);
    }
  }

  Future<void> _confirmPayment() async {
    setState(() => _busy = true);
    try {
      await Future.delayed(const Duration(seconds: 2));
      setState(() => _currentStep = 2);
    } finally {
      setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('UPI Payment')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_currentStep == 0)
                _buildPaymentDetailsStep()
              else if (_currentStep == 1)
                _buildRiskAssessmentStep()
              else
                _buildSuccessStep(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentDetailsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter Payment Details',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 32),
        TextField(
          controller: _recipientController,
          decoration: const InputDecoration(
            labelText: 'Recipient UPI ID / Phone',
            hintText: 'user@bank or 9876543210',
            prefixIcon: Icon(Icons.person),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Amount (₹)',
            prefixIcon: Icon(Icons.currency_rupee),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 24),
        Card(
          color: Colors.blue.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.info, color: Colors.blue[700]),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Your payment will be analyzed by our Trust Engine. Step-up may be required.',
                    style: TextStyle(fontSize: 12, color: Colors.blue[900]),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        FilledButton(
          onPressed: _busy ? null : _initiatePayment,
          child: SizedBox(
            width: double.infinity,
            child: Center(
              child: Text(_busy ? 'Analyzing...' : 'Continue'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRiskAssessmentStep() {
    final assessment = _riskAssessment!;
    final riskColor = assessment.overallScore > 75
        ? Colors.red
        : assessment.overallScore > 45
            ? Colors.orange
            : Colors.green;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Risk Assessment',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: riskColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: riskColor),
          ),
          child: Column(
            children: [
              Text(
                'Risk Score',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 12),
              Text(
                '${assessment.overallScore.toStringAsFixed(0)}/100',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: riskColor,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: riskColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  assessment.decision,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Risk Signals',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        ...assessment.topSignals.map((signal) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getSeverityColor(signal.severity).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Icon(
                        _getSeverityIcon(signal.severity),
                        color: _getSeverityColor(signal.severity),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          signal.signal,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'Score: ${signal.score.toStringAsFixed(1)}',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getSeverityColor(signal.severity).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      signal.severity,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: _getSeverityColor(signal.severity),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            assessment.explanation,
            style: const TextStyle(fontSize: 13, height: 1.5),
          ),
        ),
        const SizedBox(height: 32),
        if (assessment.decision == 'STEP_UP')
          Column(
            children: [
              Card(
                color: Colors.orange.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.security, color: Colors.orange[700]),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Step-up required via ${assessment.stepupChannel}',
                          style: TextStyle(color: Colors.orange[900], fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: assessment.decision == 'BLOCK' ? Colors.red : null,
          ),
          onPressed: _busy || assessment.decision == 'BLOCK'
              ? null
              : _confirmPayment,
          child: SizedBox(
            width: double.infinity,
            child: Center(
              child: Text(
                _busy
                    ? 'Processing...'
                    : assessment.decision == 'BLOCK'
                        ? 'Payment Blocked'
                        : assessment.decision == 'STEP_UP'
                            ? 'Verify with ${assessment.stepupChannel}'
                            : 'Confirm Payment',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessStep() {
    return Column(
      children: [
        Icon(
          Icons.check_circle,
          size: 72,
          color: Colors.green,
        ),
        const SizedBox(height: 24),
        Text(
          'Payment Successful',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Your payment has been processed successfully',
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
                _summaryRow('Recipient', _recipientController.text),
                const Divider(height: 24),
                _summaryRow('Amount', '₹${_amountController.text}'),
                const Divider(height: 24),
                _summaryRow('Status', 'Completed'),
                const Divider(height: 24),
                _summaryRow('Reference', '#TXN${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
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

  Widget _summaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600])),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'CRITICAL':
        return Colors.red;
      case 'HIGH':
        return Colors.orange;
      case 'MEDIUM':
        return Colors.amber;
      case 'LOW':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getSeverityIcon(String severity) {
    switch (severity) {
      case 'CRITICAL':
        return Icons.error;
      case 'HIGH':
        return Icons.warning;
      case 'MEDIUM':
        return Icons.info;
      case 'LOW':
        return Icons.check_circle;
      default:
        return Icons.help;
    }
  }

  @override
  void dispose() {
    _recipientController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}
