import 'package:kings_ledger/models/transaction_model.dart';
import 'package:kings_ledger/models/subscription_model.dart';
import 'package:kings_ledger/services/storage_service.dart';
import 'package:uuid/uuid.dart';

class AnalyticsService {
  static final Uuid _uuid = const Uuid();
  
  // 1. Predictive "Safe-to-Spend"
  static double calculateSafeToSpend() {
    // Basic Heuristic:
    // Total Liquidity - (Upcoming Bills & Envelopes) / Days Remaining in Month
    double totalLiquidity = StorageService.getMpesaBalance(); 
    // In a full app, you'd add bank balances here if available via other sms parsers
    
    // Assume we need to preserve Ksh 10,000 for fixed bills
    double fixedBills = 10000.0;
    
    int daysInMonth = DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day;
    int daysRemaining = daysInMonth - DateTime.now().day;
    if (daysRemaining <= 0) daysRemaining = 1;
    
    double safeRemaining = totalLiquidity - fixedBills;
    if (safeRemaining < 0) return 0.0;
    
    return safeRemaining / daysRemaining;
  }

  // 2. Subscription Detective
  static Future<void> detectSubscriptions() async {
    List<dynamic> allTx = StorageService.getAllTransactions();
    
    Map<String, List<TransactionModel>> potentialSubs = {};
    
    for (var tx in allTx) {
      if (tx is TransactionModel && tx.amount < 0 && tx.type == 'Paybill / Buy Goods') {
        String p = tx.party.toLowerCase();
        if (p.contains('netflix') || p.contains('spotify') || p.contains('zuku') || p.contains('icloud')) {
          if (!potentialSubs.containsKey(tx.party)) {
            potentialSubs[tx.party] = [];
          }
          potentialSubs[tx.party]!.add(tx);
        }
      }
    }
    
    final subBox = StorageService.getSubscriptionsBox();
    
    for (var entry in potentialSubs.entries) {
      if (entry.value.length >= 2) {
        // Repeated payments detected
        entry.value.sort((a, b) => b.date.compareTo(a.date)); // Newest first
        TransactionModel latest = entry.value.first;
        
        // Calculate average amount
        double totalAmt = entry.value.fold(0.0, (sum, item) => sum + item.amount.abs());
        double avg = totalAmt / entry.value.length;
        
        // Predict next date (assumes monthly)
        DateTime nextDate = DateTime(latest.date.year, latest.date.month + 1, latest.date.day);
        
        // Save/Update Subscription
        SubscriptionModel sub = SubscriptionModel(
          id: _uuid.v4(), // Simplified
          name: entry.key,
          averageAmount: avg,
          lastPaidDate: latest.date,
          expectedNextDate: nextDate,
          provider: latest.provider,
        );
        
        await subBox.put(sub.name, sub);
      }
    }
  }

  // 3. Debt & Fuliza Tracker
  static double getFulizaDebt() {
    double mpesaBal = StorageService.getMpesaBalance();
    if (mpesaBal < 0) {
      return mpesaBal.abs(); // Return the debt magnitude
    }
    return 0.0;
  }

  // 4. "Where Did My Money Go?" Heuristic Summary
  static String generateWeeklySummary() {
    List<dynamic> allTx = StorageService.getAllTransactions();
    DateTime weekAgo = DateTime.now().subtract(const Duration(days: 7));
    
    double totalSpent = 0.0;
    Map<String, double> categorySpend = {};
    
    for (var tx in allTx) {
      if (tx is TransactionModel && tx.amount < 0 && tx.date.isAfter(weekAgo)) {
        double absAmt = tx.amount.abs();
        totalSpent += absAmt;
        categorySpend[tx.category] = (categorySpend[tx.category] ?? 0.0) + absAmt;
      }
    }
    
    if (totalSpent == 0) return "You haven't spent anything this week! Great job.";
    
    // Find highest category
    String mainLeak = '';
    double maxSpend = 0.0;
    categorySpend.forEach((cat, amt) {
      if (amt > maxSpend) {
        maxSpend = amt;
        mainLeak = cat;
      }
    });
    
    int percent = ((maxSpend / totalSpent) * 100).round();
    
    return "You spent Ksh ${totalSpent.toStringAsFixed(0)} this week. Your main leak was '$mainLeak' taking up $percent% of your spending.";
  }

  // 5. Savings Goal & Rounding
  static double calculateRounding(double amount) {
    // If you spend 43, round to 50 -> save 7
    double exact = amount.abs();
    double remainder = exact % 100; // Round to nearest 100
    if (remainder == 0) return 0.0;
    return 100 - remainder;
  }
}
