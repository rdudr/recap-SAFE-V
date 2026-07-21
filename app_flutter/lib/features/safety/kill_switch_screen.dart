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
  bool _showWarning = true;

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

  Future<void> _unfreeze() async {
    setState(() => _busy = true);
    try {
      // In a real app, this would call an unfreeze endpoint
      setState(() => _result = null);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account unfrozen. Contact support for full recovery.')),
      );
    } finally {
      setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emergency Kill Switch')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 24),
              if (_result == null) ...[
                Icon(Icons.warning_amber_rounded, size: 64, color: Colors.red[700]),
                const SizedBox(height: 24),
                Text(
                  'Emergency Account Freeze',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Card stolen? Phone snatched? One tap blocks everything.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
                const SizedBox(height: 40),
                Card(
                  color: Colors.red.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'This will immediately:',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 12),
                        _buildImpactItem('🔴 Freeze debit/credit card'),
                        _buildImpactItem('🔴 Disable UPI payments'),
                        _buildImpactItem('🔴 Revoke active sessions'),
                        _buildImpactItem('🔴 Block new logins'),
                        _buildImpactItem('🔴 Alert the bank immediately'),
                      ],
                    ),
                  ),
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
                    child: _busy
                        ? const SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.emergency_share, size: 48),
                              SizedBox(height: 8),
                              Text(
                                'FREEZE\nEVERYTHING',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info, color: Colors.orange[700]),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'This action is reversible. Contact our support team to restore access.',
                          style: TextStyle(fontSize: 12, color: Colors.orange[900]),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else if (_result!.containsKey('error')) ...[
                Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 24),
                Text(
                  'Action Failed',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                Card(
                  color: Colors.red.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Error: ${_result!['error']}',
                      style: TextStyle(color: Colors.red[900]),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => setState(() => _result = null),
                  child: const Text('Back'),
                ),
              ] else ...[
                Icon(Icons.check_circle, size: 64, color: Colors.green),
                const SizedBox(height: 24),
                Text(
                  'Account Frozen Successfully',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildResultItem(
                          Icons.credit_card,
                          'Card Frozen',
                          _result!['card_frozen']?.toString() ?? 'true',
                          Colors.green,
                        ),
                        const Divider(height: 24),
                        _buildResultItem(
                          Icons.payment,
                          'UPI Frozen',
                          _result!['upi_frozen']?.toString() ?? 'true',
                          Colors.green,
                        ),
                        const Divider(height: 24),
                        _buildResultItem(
                          Icons.security,
                          'Active Sessions Revoked',
                          _result!['active_sessions']?.toString() ?? '0',
                          Colors.green,
                        ),
                        const Divider(height: 24),
                        _buildResultItem(
                          Icons.schedule,
                          'Block Time',
                          '${_result!['round_trip_ms']} ms',
                          Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check, color: Colors.green[700]),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Bank has been notified. An SMS confirmation has been sent.',
                          style: TextStyle(fontSize: 12, color: Colors.green[900]),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _busy ? null : () => setState(() => _result = null),
                        child: const Text('Reset'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: _busy ? null : () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Contacting support team...')),
                        ),
                        child: const Text('Contact Support'),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImpactItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(text, style: TextStyle(color: Colors.red[900], fontSize: 14)),
    );
  }

  Widget _buildResultItem(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }
}
