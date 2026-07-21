import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/api_client.dart';
import '../../services/dummy_data_service.dart';

/// Travel mode: declare travel + enroll TOTP. The bank app becomes the
/// authenticator — codes generate offline abroad, no Indian SIM needed.
class TravelModeScreen extends StatefulWidget {
  const TravelModeScreen({super.key});
  @override
  State<TravelModeScreen> createState() => _TravelModeScreenState();
}

class _TravelModeScreenState extends State<TravelModeScreen> {
  String? _otpauthUri;
  bool _busy = false;
  bool _enrolled = false;

  @override
  void initState() {
    super.initState();
    // Check if already enrolled
    _otpauthUri = null;
  }

  Future<void> _enroll() async {
    setState(() => _busy = true);
    try {
      final data = await ApiClient.instance.totpEnroll('rahul_nri');
      setState(() {
        _otpauthUri = data['otpauth_uri'] as String;
        _enrolled = true;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Enroll failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Travel / Abroad Mode')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(Icons.flight_takeoff, size: 40, color: Colors.blue),
                      const SizedBox(height: 16),
                      Text(
                        'Secure Authentication Abroad',
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Going abroad? Your Indian SIM may not receive OTPs. '
                        'Enroll once while you still have network — after that, this app '
                        'generates login codes completely offline. No internet required.',
                        textAlign: TextAlign.center,
                        style: TextStyle(height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              if (!_enrolled) ...[
                FilledButton.icon(
                  onPressed: _busy ? null : _enroll,
                  icon: const Icon(Icons.flight_takeoff),
                  label: Text(_busy ? 'Enrolling…' : 'Declare Travel & Enroll TOTP'),
                ),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('How it works', style: Theme.of(context).textTheme.titleSmall),
                        const SizedBox(height: 12),
                        _buildStepItem('1', 'Enroll TOTP while on home network'),
                        _buildStepItem('2', 'Backup code to Authenticator (optional)'),
                        _buildStepItem('3', 'Travel abroad with offline access'),
                        _buildStepItem('4', 'Generate codes without internet'),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 32),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Enrollment Complete', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(
                              'You can now generate TOTP codes offline',
                              style: TextStyle(color: Colors.grey[600], fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text('Backup: Scan into Google Authenticator (optional)', textAlign: TextAlign.center),
                const SizedBox(height: 12),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _otpauthUri != null
                        ? QrImageView(data: _otpauthUri!, size: 200)
                        : const SizedBox(height: 200, child: Center(child: CircularProgressIndicator())),
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/totp'),
                  icon: const Icon(Icons.pin),
                  label: const Text('Show My Offline Code'),
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () => _showBackupCodes(),
                  child: const Text('View Backup Codes'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepItem(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  void _showBackupCodes() {
    final totpSecret = DummyDataService.getDummyTotpSecret();
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Backup Codes',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning, color: Colors.orange[700]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Save these codes in a safe place. Use if you lose device access.',
                      style: TextStyle(color: Colors.orange[900], fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                totpSecret.backupCodes,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const SizedBox(
                width: double.infinity,
                child: Center(child: Text('Close')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
