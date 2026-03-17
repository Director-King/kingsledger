import 'package:hive_flutter/hive_flutter.dart';
import 'package:kings_ledger/models/transaction_model.dart';
import 'package:kings_ledger/models/envelope_model.dart';
import 'package:kings_ledger/models/subscription_model.dart';

class StorageService {
  static const String transactionsBoxName = 'transactions';
  static const String envelopesBoxName = 'envelopes';
  static const String subscriptionsBoxName = 'subscriptions';
  static const String prefsBoxName = 'preferences';

  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register the custom manual adapters we built to avoid build_runner in the cloud
    Hive.registerAdapter(TransactionModelAdapter());
    Hive.registerAdapter(EnvelopeModelAdapter());
    Hive.registerAdapter(SubscriptionModelAdapter());
    
    await Future.wait([
      Hive.openBox<dynamic>(transactionsBoxName),
      Hive.openBox<dynamic>(envelopesBoxName),
      Hive.openBox<dynamic>(subscriptionsBoxName),
      Hive.openBox<dynamic>(prefsBoxName),
    ]);
  }

  static Box getTransactionsBox() => Hive.box<dynamic>(transactionsBoxName);
  static Box getEnvelopesBox() => Hive.box<dynamic>(envelopesBoxName);
  static Box getSubscriptionsBox() => Hive.box<dynamic>(subscriptionsBoxName);
  static Box getPrefsBox() => Hive.box<dynamic>(prefsBoxName);

  static Future<void> saveTransaction(dynamic transaction) async {
    final box = getTransactionsBox();
    await box.put(transaction.id, transaction);
    
    // Update liquidity balance preference
    updateLiquidity(transaction.balance);
  }

  static void updateLiquidity(double newBalance) {
    if (newBalance >= 0) {
      getPrefsBox().put('mpesa_balance', newBalance);
    }
  }

  static double getMpesaBalance() {
    return getPrefsBox().get('mpesa_balance', defaultValue: 0.0);
  }

  static List<dynamic> getAllTransactions() {
    return getTransactionsBox().values.toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // descending
  }
}
