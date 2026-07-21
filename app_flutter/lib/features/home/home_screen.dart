import 'package:flutter/material.dart';
import '../../models/account_model.dart';
import '../../models/transaction_model.dart';
import '../../services/dummy_data_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Account> accounts;
  late List<Transaction> recentTransactions;

  @override
  void initState() {
    super.initState();
    accounts = DummyDataService.getDummyAccounts();
    recentTransactions = DummyDataService.getDummyTransactions().take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SAFE-V Bank'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Primary Account Card
          _buildPrimaryAccountCard(context),
          const SizedBox(height: 24),

          // Quick Actions
          const Text('Quick Actions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildActionGrid(context),
          const SizedBox(height: 24),

          // Other Accounts
          const Text('Other Accounts', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ..._buildAccountsList(),
          const SizedBox(height: 24),

          // Recent Transactions
          const Text('Recent Transactions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ..._buildTransactionsList(),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => Navigator.pushNamed(context, '/transactions'),
            child: const Text('View All Transactions'),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryAccountCard(BuildContext context) {
    final primary = accounts.firstWhere((a) => a.isPrimary);
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primary.withOpacity(0.7),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Account Balance', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Text(
              '₹${primary.balance.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Card Number', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    Text(
                      '•••• ${primary.accountNumber.substring(primary.accountNumber.length - 4)}',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Account Type', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    Text(
                      primary.accountType,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _buildActionButton(
          context,
          Icons.qr_code_2,
          'UPI Pay',
          () => Navigator.pushNamed(context, '/upi'),
        ),
        _buildActionButton(
          context,
          Icons.person_add,
          'Add Payee',
          () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add Payee - Coming soon')),
          ),
        ),
        _buildActionButton(
          context,
          Icons.flight_takeoff,
          'Travel Mode',
          () => Navigator.pushNamed(context, '/travel'),
        ),
        _buildActionButton(
          context,
          Icons.lock_reset,
          'Recovery',
          () => Navigator.pushNamed(context, '/recovery'),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAccountsList() {
    return accounts
        .where((a) => !a.isPrimary)
        .map((account) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Card(
            child: ListTile(
              leading: const Icon(Icons.account_balance),
              title: Text(account.accountName),
              subtitle: Text('•••• ${account.accountNumber.substring(account.accountNumber.length - 4)}'),
              trailing: Text(
                '₹${account.balance.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ))
        .toList();
  }

  List<Widget> _buildTransactionsList() {
    return recentTransactions.map((txn) {
      final statusColor = _getStatusColor(txn.status);
      final statusIcon = _getStatusIcon(txn.status);

      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Card(
          child: ListTile(
            leading: Icon(statusIcon, color: statusColor),
            title: Text(txn.description),
            subtitle: Text(
              '${txn.recipientName ?? 'Transaction'} • ${txn.timestamp.toString().substring(0, 10)}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${txn.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
                Text(
                  txn.status,
                  style: TextStyle(fontSize: 12, color: statusColor),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'COMPLETED':
        return Colors.green;
      case 'PENDING':
        return Colors.orange;
      case 'BLOCKED':
        return Colors.red;
      case 'FAILED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'COMPLETED':
        return Icons.check_circle;
      case 'PENDING':
        return Icons.schedule;
      case 'BLOCKED':
        return Icons.cancel;
      case 'FAILED':
        return Icons.error;
      default:
        return Icons.info;
    }
  }
}
