import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/utils/hive_bootstrap.dart';
import 'features/expense/presentation/screens/app_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveBootstrap.initialize();
  runApp(const ProviderScope(child: PensaApp()));
}

class PensaApp extends StatelessWidget {
  const PensaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pensa',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF3F7FC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0A6BE8),
          primary: const Color(0xFF0A6BE8),
          secondary: const Color(0xFFFF5B6C),
          surface: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const AppShell(),
    );
  }
}
