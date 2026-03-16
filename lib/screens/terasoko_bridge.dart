import 'package:flutter/material.dart';
import 'package:kings_ledger/theme/app_theme.dart';

class TerasokoBridgeScreen extends StatefulWidget {
  const TerasokoBridgeScreen({super.key});

  @override
  State<TerasokoBridgeScreen> createState() => _TerasokoBridgeScreenState();
}

class _TerasokoBridgeScreenState extends State<TerasokoBridgeScreen> {
  // Hardcoded for UI demonstration based on the HTML
  static const Color businessColor = Color(0xFF8B5CF6);
  
  // Dummy state for toggles
  bool tx1IsBusiness = true;
  bool tx2IsBusiness = false;
  bool tx3IsBusiness = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        title: const Text('Soma Pesa', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppTheme.primary, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: AppTheme.textLight), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications_none, color: AppTheme.textLight), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          _buildTabs(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Recent Activity', style: TextStyle(color: AppTheme.textLight, fontSize: 18, fontWeight: FontWeight.bold)),
                Text('SYNCING...', style: TextStyle(color: AppTheme.textMuted, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                _buildTransactionCard(
                  title: 'Inventory Supply Co.',
                  amount: '-Ksh 45,000.00',
                  dateStr: 'Today, 10:45 AM',
                  icon: Icons.storefront,
                  isBusiness: tx1IsBusiness,
                  onToggle: (val) => setState(() => tx1IsBusiness = val),
                ),
                const SizedBox(height: 16),
                _buildTransactionCard(
                  title: 'The Daily Grind',
                  amount: '-Ksh 650.00',
                  dateStr: 'Today, 8:12 AM',
                  icon: Icons.coffee,
                  isBusiness: tx2IsBusiness,
                  onToggle: (val) => setState(() => tx2IsBusiness = val),
                ),
                const SizedBox(height: 16),
                _buildTransactionCard(
                  title: 'Local Grocers',
                  amount: '-Ksh 8,420.00',
                  dateStr: 'Yesterday, 6:30 PM',
                  icon: Icons.shopping_bag,
                  isBusiness: tx3IsBusiness,
                  onToggle: (val) => setState(() => tx3IsBusiness = val),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppTheme.primary,
        shape: const CircleBorder(),
        elevation: 8,
        child: const Icon(Icons.add, color: AppTheme.backgroundDark, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                child: Text('All Transactions', style: TextStyle(color: AppTheme.textMuted, fontSize: 14, fontWeight: FontWeight.w600)),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppTheme.backgroundDark,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
                ),
                child: const Text('TeraSoko Bridge', style: TextStyle(color: AppTheme.primary, fontSize: 14, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionCard({
    required String title,
    required String amount,
    required String dateStr,
    required IconData icon,
    required bool isBusiness,
    required ValueChanged<bool> onToggle,
  }) {
    final activeColor = isBusiness ? businessColor : AppTheme.primary;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundDark.withOpacity(isBusiness ? 1 : 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isBusiness ? businessColor.withOpacity(0.5) : AppTheme.primary.withOpacity(0.1),
        ),
        boxShadow: isBusiness
            ? [BoxShadow(color: businessColor.withOpacity(0.2), blurRadius: 15, spreadRadius: 1)]
            : [],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: activeColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: activeColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: const TextStyle(color: AppTheme.textLight, fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(amount, style: TextStyle(color: isBusiness ? activeColor : AppTheme.textLight, fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(dateStr, style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: activeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: activeColor.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          Icon(isBusiness ? Icons.verified_user : Icons.person, color: activeColor, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            isBusiness ? 'BUSINESS TAX-EXEMPT' : 'PERSONAL EXPENSE',
                            style: TextStyle(color: activeColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                          ),
                        ],
                      ),
                    ),
                    // Custom Toggle
                    Row(
                      children: [
                        Text('PERSONAL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: !isBusiness ? AppTheme.primary : AppTheme.textMuted)),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => onToggle(!isBusiness),
                          child: Container(
                            width: 40,
                            height: 20,
                            decoration: BoxDecoration(
                              color: isBusiness ? businessColor : Colors.white24,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: AnimatedAlign(
                              duration: const Duration(milliseconds: 200),
                              alignment: isBusiness ? Alignment.centerRight : Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Container(
                                  width: 16,
                                  height: 16,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('BUSINESS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isBusiness ? businessColor : AppTheme.textMuted)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomAppBar(
      color: AppTheme.backgroundDark,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, 'Home', false),
            _buildNavItem(Icons.swap_horiz, 'Bridge', true),
            const SizedBox(width: 48), // Space for FAB
            _buildNavItem(Icons.analytics, 'Stats', false),
            _buildNavItem(Icons.settings, 'Settings', false),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: isSelected ? AppTheme.primary : AppTheme.textMuted),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: isSelected ? AppTheme.primary : AppTheme.textMuted, fontSize: 10, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
