import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/api_client.dart';

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

  Future<void> _enroll() async {
    setState(() => _busy = true);
    try {
      final data = await ApiClient.instance.totpEnroll('rahul_nri');
      setState(() => _otpauthUri = data['otpauth_uri'] as String);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Enroll failed: $e')));
      }
    } finally {
      setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Travel / Abroad Mode')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Going abroad? Your Indian SIM may not receive OTPs. '
              'Enroll once while you still have network — after that, this app '
              'generates login codes completely offline.',
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _busy ? null : _enroll,
              icon: const Icon(Icons.flight_takeoff),
              label: Text(_busy ? 'Enrolling…' : 'Declare travel & enroll TOTP'),
            ),
            const SizedBox(height: 24),
            if (_otpauthUri != null) ...[
              const Text('Backup: scan into Google Authenticator (optional)',
                  textAlign: TextAlign.center),
              const SizedBox(height: 12),
              Center(child: QrImageView(data: _otpauthUri!, size: 180)),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/totp'),
                icon: const Icon(Icons.pin),
                label: const Text('Show my offline code'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
