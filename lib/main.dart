import 'package:flutter/material.dart';
import 'package:kings_ledger/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: Initialize Hive Database
  // TODO: Request SMS Permissions
  
  runApp(const KingsLedgerApp());
}

class KingsLedgerApp extends StatelessWidget {
  const KingsLedgerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kings Ledger',
      theme: AppTheme.darkTheme, // We'll stick to the dark theme as default for the premium "Obsidian" look
      home: const Scaffold(body: Center(child: Text('Kings Ledger Dashboard'))),
    );
  }
}
