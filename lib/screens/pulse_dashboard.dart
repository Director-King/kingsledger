import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:kings_ledger/theme/app_theme.dart';

class PulseDashboardScreen extends StatelessWidget {
  const PulseDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100), // space for overlapping elements
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              _buildSafeToSpendArc(context),
              _buildLiquidityStack(),
              _buildBurnRateChart(),
            ],
          ),
        ),
      ),
      // Dummy bottom nav bar to match design completeness
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
                ),
                child: const Icon(Icons.person, color: AppTheme.primary),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Welcome back,', style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                  const Text('Soma Pesa', style: TextStyle(color: AppTheme.textLight, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: const Icon(Icons.notifications_outlined, color: AppTheme.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildSafeToSpendArc(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          // Build Arc visualization via Stack + CircularProgressIndicator or CustomPainter
          SizedBox(
            height: 120, // Semi-circle is half height of width
            width: 200,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // Background Arc
                SizedBox(
                  height: 200,
                  width: 200,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.0, end: 0.65), // 65% remaining
                    duration: const Duration(milliseconds: 1000),
                    builder: (context, value, _) {
                      return CircularProgressIndicator(
                        value: value,
                        strokeWidth: 16,
                        color: AppTheme.primary,
                        backgroundColor: AppTheme.primary.withOpacity(0.1),
                        strokeCap: StrokeCap.round,
                      );
                    },
                  ),
                ),
                // Since CircularProgressIndicator completes a full circle, we emulate it 
                // Alternatively, in a real app, use a package or CustomPainter for a proper arc.
              ],
            ),
          ),
          const SizedBox(height: 16), // space between arc and text
          const Text(
            'SAFE-TO-SPEND',
            style: TextStyle(
              color: AppTheme.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Ksh 3,450',
            style: TextStyle(
              color: AppTheme.textLight,
              fontSize: 40,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Daily Allowance Remaining',
            style: TextStyle(
              color: AppTheme.primary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiquidityStack() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'LIQUIDITY STACK',
            style: TextStyle(
              color: AppTheme.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          // M-PESA
          _buildLiquidityItem(
            icon: Icons.account_balance_wallet,
            title: 'M-PESA Balance',
            amount: 'Ksh 12,400',
            subtitleDetails: {
              'Last Transaction': '-Ksh 500 (Groceries)',
              'Status': 'Active (Predictive)',
            },
          ),
          const SizedBox(height: 12),
          // Bank
          _buildLiquidityItem(
            icon: Icons.account_balance,
            title: 'Bank Balance',
            amount: 'Ksh 45,000',
            subtitleDetails: {
              'Equity Bank': 'Ksh 30,000',
              'KCB Bank': 'Ksh 15,000',
            },
          ),
          const SizedBox(height: 16),
          // Total
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.payments, color: AppTheme.primary),
                    const SizedBox(width: 12),
                    const Text('Total Liquid Cash', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold)),
                  ],
                ),
                const Text('Ksh 57,400', style: TextStyle(color: AppTheme.primary, fontSize: 18, fontWeight: FontWeight.w900)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiquidityItem({
    required IconData icon,
    required String title,
    required String amount,
    required Map<String, String> subtitleDetails,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent),
        child: ExpansionTile(
          collapsedIconColor: AppTheme.textMuted,
          iconColor: AppTheme.primary,
          title: Row(
            children: [
              Icon(icon, color: AppTheme.primary),
              const SizedBox(width: 12),
              Text(title, style: const TextStyle(color: AppTheme.textLight, fontSize: 14)),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(amount, style: const TextStyle(color: AppTheme.textLight, fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(width: 8),
              const Icon(Icons.expand_more, size: 20),
            ],
          ),
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: subtitleDetails.entries.map((e) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(e.key, style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                        Text(e.value, style: const TextStyle(color: AppTheme.textLight, fontSize: 12)),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBurnRateChart() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'BURN RATE CHART',
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('Last 7 Days', style: TextStyle(color: AppTheme.textMuted, fontSize: 10)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 200,
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(color: Colors.white.withOpacity(0.05), strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      getTitlesWidget: (value, meta) {
                        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                        if (value >= 0 && value < days.length) {
                          return Text(days[value.toInt()], style: TextStyle(color: AppTheme.textMuted, fontSize: 10));
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 10),
                      FlSpot(1, 15),
                      FlSpot(2, 25),
                      FlSpot(3, 20),
                      FlSpot(4, 40),
                      FlSpot(5, 30),
                      FlSpot(6, 45),
                    ],
                    isCurved: true,
                    color: AppTheme.primary,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppTheme.primary.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
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
        currentIndex: 0, // Pulse selected
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Pulse'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Wallet'),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: 'Budget'),
          BottomNavigationBarItem(icon: Icon(Icons.insights), label: 'Insights'),
        ],
      ),
    );
  }
}
