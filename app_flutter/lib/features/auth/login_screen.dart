import 'package:flutter/material.dart';

import '../../core/api_client.dart';

/// Login with typing-cadence capture: we record timestamp deltas between
/// keystrokes in the PIN field and send the z-score as a behavioral SIGNAL
/// (never call it a "behavioral biometrics engine" — see Say-Never list).
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _pinController = TextEditingController();
  final List<int> _keystrokeGaps = [];
  DateTime? _lastKeystroke;
  String _status = '';
  bool _busy = false;

  void _onPinChanged(String _) {
    final now = DateTime.now();
    if (_lastKeystroke != null) {
      _keystrokeGaps.add(now.difference(_lastKeystroke!).inMilliseconds);
    }
    _lastKeystroke = now;
  }

  double _typingZ() {
    // Demo: distance of mean inter-key gap from an enrolled baseline of ~180ms.
    if (_keystrokeGaps.isEmpty) return 0;
    final mean = _keystrokeGaps.reduce((a, b) => a + b) / _keystrokeGaps.length;
    return ((mean - 180).abs() / 120).clamp(0.0, 3.0);
  }

  Future<void> _login() async {
    setState(() => _busy = true);
    try {
      final result = await ApiClient.instance.score({
        'user_id': 'priya',
        'event_type': 'login',
        'device_id': await ApiClient.instance.deviceId(),
        'typing_z': _typingZ(),
      });
      final decision = result['decision'] as String;
      if (!mounted) return;
      if (decision == 'ALLOW') {
        Navigator.pushReplacementNamed(context, '/home');
      } else if (decision == 'STEP_UP') {
        final channel = result['stepup_channel'] ?? 'SMS_OTP';
        setState(() => _status = 'Step-up required via $channel');
        if (channel == 'TOTP') Navigator.pushNamed(context, '/totp');
      } else {
        setState(() => _status = 'Blocked. Contact the bank. '
            'Top signal: ${(result['top_signals'] as List).isNotEmpty ? result['top_signals'][0]['signal'] : '-'}');
      }
    } catch (e) {
      setState(() => _status = 'Backend unreachable — is uvicorn running? ($e)');
    } finally {
      setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shield, size: 72, color: Color(0xFFF37021)),
              const SizedBox(height: 8),
              Text('SAFE-V Bank', style: Theme.of(context).textTheme.headlineMedium),
              const Text('Invisible when it\'s you. A wall when it\'s not.'),
              const SizedBox(height: 32),
              TextField(
                controller: _pinController,
                onChanged: _onPinChanged,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(
                  labelText: 'Login PIN',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _busy ? null : _login,
                child: Text(_busy ? 'Scoring…' : 'Login'),
              ),
              const SizedBox(height: 16),
              Text(_status, style: const TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ),
    );
  }
}
