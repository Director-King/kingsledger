import 'package:flutter/material.dart';
import 'package:kings_ledger/theme/app_theme.dart';

class EnvelopeManagerScreen extends StatelessWidget {
  const EnvelopeManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        title: const Text('Envelope Manager', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textLight),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: AppTheme.primary),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100), // padding for bottom nav
        child: Column(
          children: [
            _buildHeroBalance(),
            const SizedBox(height: 24),
            _buildEnvelopeList(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeroBalance() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.primary.withOpacity(0.1),
          border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TOTAL ALLOCATED',
                  style: TextStyle(
                    color: AppTheme.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ksh 12,450.00', // Translated currency to Ksh
                  style: TextStyle(
                    color: AppTheme.textLight,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppTheme.textMuted, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Distributed across 8 envelopes',
                      style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            // Decorative abstracted element
            Positioned(
              right: -50,
              bottom: -50,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primary.withOpacity(0.05),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnvelopeList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildEnvelopeCard(
            title: 'Emergency Fund',
            icon: Icons.shield,
            targetDisplay: 'Target: Ksh 50,000',
            currentDisplay: 'Ksh 45,000',
            progressPercentage: 0.9,
            progressLabel: '90% Full',
          ),
          const SizedBox(height: 16),
          _buildEnvelopeCard(
            title: 'School Fees',
            icon: Icons.school,
            targetDisplay: 'Target: Ksh 80,000',
            currentDisplay: 'Ksh 36,000',
            progressPercentage: 0.45,
            progressLabel: '45% Full',
          ),
          const SizedBox(height: 16),
          _buildEnvelopeCard(
            title: 'Vacation',
            icon: Icons.flight_takeoff,
            targetDisplay: 'Target: Ksh 30,000',
            currentDisplay: 'Ksh 4,500',
            progressPercentage: 0.15,
            progressLabel: '15% Full',
          ),
          const SizedBox(height: 24),
          _buildAddEnvelopeButton(),
        ],
      ),
    );
  }

  Widget _buildEnvelopeCard({
    required String title,
    required IconData icon,
    required String targetDisplay,
    required String currentDisplay,
    required double progressPercentage,
    required String progressLabel,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.03),
        border: Border.all(color: AppTheme.primary.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Vertical Progress Bar
          Container(
            width: 48,
            height: 120,
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: progressPercentage,
              widthFactor: 1.0,
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppTheme.textLight,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(icon, color: AppTheme.primary),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  targetDisplay,
                  style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentDisplay,
                          style: const TextStyle(
                            color: AppTheme.textLight,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          progressLabel,
                          style: const TextStyle(
                            color: AppTheme.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: AppTheme.backgroundDark,
                        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        minimumSize: Size.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Add Funds'),
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

  Widget _buildAddEnvelopeButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: AppTheme.primary.withOpacity(0.2),
          style: BorderStyle.solid,
          width: 2, // Ideally dashed, using solid for MVP framework limitation
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Icon(Icons.add_circle_outline, color: AppTheme.primary, size: 36),
          const SizedBox(height: 12),
          const Text(
            'Create New Envelope',
            style: TextStyle(
              color: AppTheme.textMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundDark.withOpacity(0.9),
        border: Border(top: BorderSide(color: AppTheme.primary.withOpacity(0.1))),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primary,
        unselectedItemColor: AppTheme.textMuted,
        currentIndex: 1, // Envelopes is selected
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.mail), label: 'Envelopes'),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: 'Stats'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
