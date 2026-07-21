import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/dummy_data_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late User user;
  bool _twoFactorEnabled = true;
  bool _notificationsEnabled = true;
  bool _biometricEnabled = true;

  @override
  void initState() {
    super.initState();
    user = DummyDataService.getDummyUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // Profile Section
          _buildProfileSection(),
          const SizedBox(height: 24),

          // Security Section
          _buildSectionHeader('Security'),
          _buildToggleTile(
            Icons.shield,
            'Two-Factor Authentication',
            'Additional layer of security',
            _twoFactorEnabled,
            (value) => setState(() => _twoFactorEnabled = value),
          ),
          _buildToggleTile(
            Icons.fingerprint,
            'Biometric Login',
            'Use fingerprint or face ID',
            _biometricEnabled,
            (value) => setState(() => _biometricEnabled = value),
          ),
          _buildActionTile(
            Icons.lock_reset,
            'Change PIN',
            'Update your login PIN',
            () => _showComingSoon(),
          ),
          _buildActionTile(
            Icons.vpn_key,
            'Manage API Keys',
            'Control third-party app access',
            () => _showComingSoon(),
          ),
          const Divider(),
          const SizedBox(height: 16),

          // Notifications Section
          _buildSectionHeader('Notifications'),
          _buildToggleTile(
            Icons.notifications,
            'Push Notifications',
            'Receive security alerts',
            _notificationsEnabled,
            (value) => setState(() => _notificationsEnabled = value),
          ),
          _buildActionTile(
            Icons.notifications_none,
            'Notification Settings',
            'Customize alert preferences',
            () => _showComingSoon(),
          ),
          const Divider(),
          const SizedBox(height: 16),

          // Account Section
          _buildSectionHeader('Account'),
          _buildActionTile(
            Icons.history,
            'Login History',
            'View recent account access',
            () => _showComingSoon(),
          ),
          _buildActionTile(
            Icons.devices,
            'Active Sessions',
            'Manage connected devices',
            () => _showComingSoon(),
          ),
          _buildActionTile(
            Icons.download,
            'Export Data',
            'Download your account data',
            () => _showComingSoon(),
          ),
          const Divider(),
          const SizedBox(height: 16),

          // Support Section
          _buildSectionHeader('Support'),
          _buildActionTile(
            Icons.help,
            'Help & FAQ',
            'Get answers to common questions',
            () => _showComingSoon(),
          ),
          _buildActionTile(
            Icons.bug_report,
            'Report Issue',
            'Report a bug or problem',
            () => _showComingSoon(),
          ),
          _buildActionTile(
            Icons.info,
            'About SAFE-V',
            'Version 1.0.0',
            () => _showAboutDialog(),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => _showLogoutDialog(),
              child: const Text('Logout'),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                  user.name.substring(0, 2).toUpperCase(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                user.name,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(user.email, style: TextStyle(color: Colors.grey[600])),
              const SizedBox(height: 4),
              Text(user.phone, style: TextStyle(color: Colors.grey[600])),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green),
                ),
                child: Text(
                  user.accountStatus,
                  style: TextStyle(
                    color: Colors.green[800],
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildToggleTile(
    IconData icon,
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        child: ListTile(
          leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
          title: Text(title),
          subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
          trailing: Switch(value: value, onChanged: onChanged),
        ),
      ),
    );
  }

  Widget _buildActionTile(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        child: ListTile(
          leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
          title: Text(title),
          subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
      ),
    );
  }

  void _showComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Feature coming soon')),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About SAFE-V'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version: 1.0.0'),
            SizedBox(height: 12),
            Text(
              'SAFE-V is a risk-based trust engine for banking transactions. Invisible when it\'s you. A wall when it\'s not.',
            ),
            SizedBox(height: 12),
            Text('Built for the BOB Hackathon 2026'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
