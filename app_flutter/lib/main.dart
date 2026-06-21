import 'package:flutter/material.dart';

import 'core/api_client.dart';
import 'features/auth/login_screen.dart';
import 'features/home/home_screen.dart';
import 'features/safety/kill_switch_screen.dart';
import 'features/travel/totp_screen.dart';
import 'features/travel/travel_mode_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiClient.instance.init();
  runApp(const SafeVApp());
}

class SafeVApp extends StatelessWidget {
  const SafeVApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SAFE-V Bank',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFF37021)), // BoB orange
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/home': (_) => const HomeScreen(),
        '/travel': (_) => const TravelModeScreen(),
        '/totp': (_) => const TotpScreen(),
        '/killswitch': (_) => const KillSwitchScreen(),
      },
    );
  }
}
