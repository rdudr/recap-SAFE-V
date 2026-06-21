import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SAFE-V Bank')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text('Savings •• 4321'),
              subtitle: const Text('₹84,500.00'),
            ),
          ),
          const SizedBox(height: 16),
          _tile(context, Icons.qr_code, 'UPI Pay', 'Send money — scored by the Trust Engine', null),
          _tile(context, Icons.person_add, 'Add Payee', 'Cooling period applies under probation', null),
          _tile(context, Icons.flight_takeoff, 'Travel Mode', 'Going abroad? Enroll offline TOTP codes', '/travel'),
          _tile(context, Icons.lock_reset, 'Account Recovery', 'Tiered, risk-based recovery', null),
          _tile(context, Icons.warning_amber, 'KILL SWITCH', 'Freeze card + UPI + sessions in one tap', '/killswitch',
              color: Colors.red),
        ],
      ),
    );
  }

  Widget _tile(BuildContext context, IconData icon, String title, String subtitle, String? route,
      {Color? color}) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: TextStyle(color: color, fontWeight: color != null ? FontWeight.bold : null)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: route == null
            ? () => ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Build me next! (see specs.md day plan)')))
            : () => Navigator.pushNamed(context, route),
      ),
    );
  }
}
