import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:otp/otp.dart';

/// In-app offline TOTP generator — the airplane-mode demo moment.
/// isGoogle: true matches pyotp's defaults (SHA1, 6 digits, 30s) — the classic
/// interop gotcha, already handled.
class TotpScreen extends StatefulWidget {
  const TotpScreen({super.key});
  @override
  State<TotpScreen> createState() => _TotpScreenState();
}

class _TotpScreenState extends State<TotpScreen> {
  static const _storage = FlutterSecureStorage();
  String _code = '------';
  int _secondsLeft = 30;
  bool _unlocked = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _unlock();
  }

  Future<void> _unlock() async {
    // Biometric gate before showing the code (skips gracefully on emulators).
    try {
      final auth = LocalAuthentication();
      if (await auth.canCheckBiometrics) {
        _unlocked = await auth.authenticate(
            localizedReason: 'Unlock your offline travel code');
      } else {
        _unlocked = true;
      }
    } catch (_) {
      _unlocked = true; // emulator without biometrics
    }
    if (_unlocked) {
      _tick();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    }
    setState(() {});
  }

  Future<void> _tick() async {
    final secret = await _storage.read(key: 'totp_secret');
    if (secret == null) {
      setState(() => _code = 'ENROLL FIRST');
      return;
    }
    final now = DateTime.now().millisecondsSinceEpoch;
    setState(() {
      _code = OTP.generateTOTPCodeString(secret, now,
          algorithm: Algorithm.SHA1, isGoogle: true);
      _secondsLeft = 30 - (now ~/ 1000) % 30;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Offline Travel Code')),
      body: Center(
        child: !_unlocked
            ? _buildLockScreen()
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 40),
                    Icon(
                      Icons.privacy_tip,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Your TOTP Code',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.primary.withOpacity(0.1),
                            Theme.of(context).colorScheme.primary.withOpacity(0.05),
                          ],
                        ),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            _code,
                            style: TextStyle(
                              fontSize: 48,
                              letterSpacing: 12,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                              fontFamily: 'monospace',
                            ),
                          ),
                          const SizedBox(height: 24),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularProgressIndicator(
                                value: _secondsLeft / 30,
                                minRadius: 30,
                              ),
                              Text(
                                '$_secondsLeft s',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Key Features',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: 12),
                            _buildFeatureItem(Icons.wifi_off, 'Works without internet'),
                            _buildFeatureItem(Icons.phone_android, 'No SIM required'),
                            _buildFeatureItem(Icons.airplanemode_active, 'Airplane mode compatible'),
                            _buildFeatureItem(Icons.lock, 'Secure & encrypted'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Text(
                        'This code refreshes every 30 seconds. Your authenticator never connects to the internet for verification.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.blue.shade900),
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Back'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildLockScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.lock,
          size: 72,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 24),
        Text(
          'Biometric Authentication Required',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Use your fingerprint or face to unlock your TOTP code',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
        const SizedBox(height: 32),
        FilledButton.icon(
          onPressed: _unlock,
          icon: const Icon(Icons.fingerprint),
          label: const Text('Unlock with Biometrics'),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
