import 'package:intl/intl.dart';
import 'package:kings_ledger/models/transaction_model.dart';
import 'package:uuid/uuid.dart';

class SmsParserService {
  static final Uuid _uuid = const Uuid();

  /// Parse M-PESA SMS. Returns a TransactionModel if successful.
  static TransactionModel? parseMpesaSms(String message, DateTime receiveDate) {
    if (!message.contains('confirmed') || !message.contains('Ksh')) return null;

    final id = _uuid.v4();
    double amount = _extractAmount(message);
    double balance = _extractBalance(message);
    String type = _determineType(message);
    String party = _extractParty(message, type);

    if (amount == 0) return null; // Failed to parse amount

    return TransactionModel(
      id: id,
      amount: amount,
      date: receiveDate,
      provider: 'MPESA',
      type: type,
      party: party,
      balance: balance,
      rawMessage: message,
      category: _suggestCategory(party, type),
    );
  }

  static double _extractAmount(String msg) {
    // Looks for "Ksh1,200.00" or "Ksh 1200.00"
    final regex = RegExp(r'Ksh([0-9,.]+)', caseSensitive: false);
    final match = regex.firstMatch(msg);
    if (match != null) {
      String cleanAmount = match.group(1)!.replaceAll(',', '');
      return double.tryParse(cleanAmount) ?? 0.0;
    }
    return 0.0;
  }

  static double _extractBalance(String msg) {
    // Looks for "New M-PESA balance is Ksh10,240.50"
    final regex = RegExp(r'balance is Ksh([0-9,.]+)', caseSensitive: false);
    final match = regex.firstMatch(msg);
    if (match != null) {
      String cleanAmount = match.group(1)!.replaceAll(',', '');
      return double.tryParse(cleanAmount) ?? 0.0;
    }
    // Check for negative/Fuliza balance
    final fulizaRegex = RegExp(r'Fuliza M-PESA balance is Ksh([0-9,.]+)', caseSensitive: false);
    final fulizaMatch = fulizaRegex.firstMatch(msg);
    if (fulizaMatch != null) {
      String cleanAmount = fulizaMatch.group(1)!.replaceAll(',', '');
      return -(double.tryParse(cleanAmount) ?? 0.0);
    }
    return 0.0;
  }

  static String _determineType(String msg) {
    if (msg.contains('paid to')) return 'Paybill / Buy Goods';
    if (msg.contains('sent to')) return 'Send Money';
    if (msg.contains('Withdraw')) return 'Withdrawal';
    if (msg.contains('received')) return 'Deposit';
    return 'Other';
  }

  static String _extractParty(String msg, String type) {
    // This is a simplified regex approach. 
    // M-PESA formats: "Ksh500.00 paid to KPLC PREPAID..."
    // "Ksh1,000.00 sent to JOHN DOE 07..."
    try {
      if (type == 'Paybill / Buy Goods') {
        final r = RegExp(r'paid to (.+?) on');
        final m = r.firstMatch(msg);
        return m?.group(1)?.trim() ?? 'Unknown Entity';
      } else if (type == 'Send Money') {
        final r = RegExp(r'sent to (.+?) (?:07|01|254)');
        final m = r.firstMatch(msg);
        return m?.group(1)?.trim() ?? 'Unknown Person';
      } else if (type == 'Withdrawal') {
        final r = RegExp(r'Withdraw.+?from (.+?) New');
        final m = r.firstMatch(msg);
        return m?.group(1)?.trim() ?? 'Agent';
      } else if (type == 'Deposit') {
        final r = RegExp(r'received.+?from (.+?) on');
        final m = r.firstMatch(msg);
        return m?.group(1)?.trim() ?? 'Unknown Sender';
      }
    } catch (e) {
      return 'Unknown';
    }
    return 'Unknown';
  }

  static String _suggestCategory(String party, String type) {
    String p = party.toLowerCase();
    if (p.contains('kplc') || p.contains('token')) return 'Utilities';
    if (p.contains('zuku') || p.contains('safaricom') || p.contains('netflix')) return 'Subscriptions';
    if (p.contains('supermarket') || p.contains('carrefour') || p.contains('naivas')) return 'Groceries';
    if (p.contains('petrol') || p.contains('rubis') || p.contains('shell')) return 'Fuel';
    if (p.contains('restaurant') || p.contains('eatery') || p.contains('cafe')) return 'Dining';
    return 'Uncategorized';
  }
}
