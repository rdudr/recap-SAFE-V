import 'package:flutter/material.dart';
import '../../models/transaction_model.dart';
import '../../services/dummy_data_service.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  late List<Transaction> transactions;
  String _filterStatus = 'ALL';

  @override
  void initState() {
    super.initState();
    transactions = DummyDataService.getDummyTransactions();
  }

  List<Transaction> get filteredTransactions {
    if (_filterStatus == 'ALL') return transactions;
    return transactions.where((t) => t.status == _filterStatus).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaction History')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildFilterChip('ALL', 'All'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildFilterChip('COMPLETED', 'Completed'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildFilterChip('PENDING', 'Pending'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildFilterChip('BLOCKED', 'Blocked'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredTransactions.length,
              itemBuilder: (context, index) {
                final txn = filteredTransactions[index];
                return _buildTransactionTile(context, txn);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String status, String label) {
    final isSelected = _filterStatus == status;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _filterStatus = status);
      },
    );
  }

  Widget _buildTransactionTile(BuildContext context, Transaction txn) {
    final statusColor = _getStatusColor(txn.status);
    final statusIcon = _getStatusIcon(txn.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showTransactionDetails(context, txn),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(statusIcon, color: statusColor, size: 28),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          txn.description,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${txn.recipientName ?? 'N/A'} • ${_formatDate(txn.timestamp)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${txn.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          txn.status,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (txn.riskScore != null) ...[
                const SizedBox(height: 12),
                _buildRiskIndicator(txn.riskScore!, txn.trustDecision ?? 'N/A'),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRiskIndicator(String riskScore, String decision) {
    final score = int.tryParse(riskScore) ?? 0;
    final riskColor = score > 75 ? Colors.red : score > 45 ? Colors.orange : Colors.green;

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: score / 100,
              minHeight: 6,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(riskColor),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 1,
          child: Text(
            'Risk: $riskScore',
            style: TextStyle(fontSize: 12, color: riskColor, fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: riskColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              decision,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: riskColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  void _showTransactionDetails(BuildContext context, Transaction txn) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Transaction Details',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              _detailRow('Description', txn.description),
              _detailRow('Amount', '₹${txn.amount.toStringAsFixed(2)}'),
              _detailRow('Status', txn.status),
              if (txn.recipientName != null) _detailRow('Recipient', txn.recipientName!),
              if (txn.recipientAccount != null)
                _detailRow('Recipient Account', '•••• ${txn.recipientAccount!.substring(txn.recipientAccount!.length - 4)}'),
              _detailRow('Date & Time', txn.timestamp.toString()),
              if (txn.riskScore != null) _detailRow('Risk Score', txn.riskScore!),
              if (txn.trustDecision != null) _detailRow('Trust Decision', txn.trustDecision!),
              const SizedBox(height: 24),
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
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
