import 'package:flutter/material.dart';

import '../../core/api_client.dart';

/// One-tap kill switch: freeze card + UPI + revoke sessions, with the
/// time-to-block timer on screen (RBI liability is graded by reporting speed).
class KillSwitchScreen extends StatefulWidget {
  const KillSwitchScreen({super.key});
  @override
  State<KillSwitchScreen> createState() => _KillSwitchScreenState();
}

class _KillSwitchScreenState extends State<KillSwitchScreen> {
  Map<String, dynamic>? _result;
  bool _busy = false;

  Future<void> _freeze() async {
    setState(() => _busy = true);
    final sw = Stopwatch()..start();
    try {
      final res = await ApiClient.instance.killSwitch('priya');
      sw.stop();
      setState(() => _result = {...res, 'round_trip_ms': sw.elapsedMilliseconds});
    } catch (e) {
      setState(() => _result = {'error': e.toString()});
    } finally {
      setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emergency Kill Switch')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Card stolen? Phone snatched?\nOne tap blocks everything.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: 200,
                height: 200,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: const CircleBorder(),
                  ),
                  onPressed: _busy ? null : _freeze,
                  child: const Text('FREEZE\nEVERYTHING',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 32),
              if (_result != null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      _result!.containsKey('error')
                          ? 'Failed: ${_result!['error']}'
                          : '✅ Card frozen: ${_result!['card_frozen']}\n'
                              '✅ UPI frozen: ${_result!['upi_frozen']}\n'
                              '✅ Active sessions: ${_result!['active_sessions']}\n'
                              '⏱ Time to block: ${_result!['round_trip_ms']} ms',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
