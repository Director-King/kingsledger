import 'package:flutter/material.dart';
import 'package:kings_ledger/theme/app_theme.dart';
import 'package:kings_ledger/services/storage_service.dart';
import 'package:kings_ledger/services/sms_listener_service.dart';
import 'package:kings_ledger/screens/pulse_dashboard.dart';
import 'package:kings_ledger/screens/envelope_manager.dart';
import 'package:kings_ledger/screens/terasoko_bridge.dart';
import 'package:kings_ledger/widgets/sms_trigger_sheet.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive Offline Database
  await StorageService.init();
  
  runApp(const KingsLedgerApp());
}

class KingsLedgerApp extends StatelessWidget {
  const KingsLedgerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kings Ledger',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const PulseDashboardScreen(),
    const EnvelopeManagerScreen(),
    const TerasokoBridgeScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Request SMS Permissions & start background listener when app opens
    SmsListenerService.init();
    
    // Listen for new transactions to trigger the categorization bottomsheet globally
    SmsListenerService.onNewTransaction.listen((transaction) {
      if (mounted) {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) => SmsTriggerSheet(transaction: transaction),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.backgroundDark.withOpacity(0.95),
          border: Border(top: BorderSide(color: AppTheme.primary.withOpacity(0.1))),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppTheme.primary,
          unselectedItemColor: AppTheme.textMuted,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Pulse'),
            BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: 'Envelopes'),
            BottomNavigationBarItem(icon: Icon(Icons.work), label: 'TeraSoko'),
          ],
        ),
      ),
    );
  }
}
