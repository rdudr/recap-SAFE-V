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
            ? const Text('Biometric unlock required')
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_code,
                      style: const TextStyle(
                          fontSize: 44,
                          letterSpacing: 8,
                          fontWeight: FontWeight.bold)),
                  Text('refreshes in $_secondsLeft s'),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Works without SIM or internet — try airplane mode.\n'
                      'This notification never bridges to your smartwatch.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
