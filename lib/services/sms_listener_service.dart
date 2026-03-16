import 'dart:async';
import 'package:telephony/telephony.dart';
import 'package:kings_ledger/services/sms_parser_service.dart';
import 'package:kings_ledger/services/storage_service.dart';
import 'package:kings_ledger/models/transaction_model.dart';
import 'package:flutter/foundation.dart';

// Must be top-level for background execution
@pragma('vm:entry-point')
void backgroundMessageHandler(SmsMessage message) async {
  // Initialize box internally if background spawned
  await StorageService.init(); 
  await SmsListenerService._processMessage(message);
}

class SmsListenerService {
  static final Telephony telephony = Telephony.instance;
  
  // Stream to trigger UI overlays (e.g., Categorization Sheet)
  static final StreamController<TransactionModel> _newTransactionStream = StreamController<TransactionModel>.broadcast();
  static Stream<TransactionModel> get onNewTransaction => _newTransactionStream.stream;

  static Future<void> init() async {
    bool? permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
    if (permissionsGranted == true) {
      telephony.listenIncomingSms(
        onNewMessage: (SmsMessage message) {
          _processMessage(message, fromForeground: true);
        },
        onBackgroundMessage: backgroundMessageHandler,
      );
    }
  }

  static Future<void> fetchAndParseOldTransactions() async {
    List<SmsMessage> messages = await telephony.getInboxSms(
      columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE],
      // We could filter by "MPESA", but sometimes addresses vary slightly.
      sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.DESC)],
    );

    for (var msg in messages) {
      if (msg.body != null && msg.address?.toUpperCase() == 'MPESA') {
        final date = DateTime.fromMillisecondsSinceEpoch(msg.date ?? DateTime.now().millisecondsSinceEpoch);
        final transaction = SmsParserService.parseMpesaSms(msg.body!, date);
        if (transaction != null) {
          await StorageService.saveTransaction(transaction);
        }
      }
    }
  }

  static Future<void> _processMessage(SmsMessage message, {bool fromForeground = false}) async {
    final body = message.body;
    final address = message.address?.toUpperCase();

    if (body == null || address == null) return;
    
    // Allow known financial institutions
    final allowedSenders = ['MPESA', 'EQUITY', 'KCB', 'CO-OP', 'NCBA'];
    if (!allowedSenders.contains(address)) return;

    final date = DateTime.fromMillisecondsSinceEpoch(message.date ?? DateTime.now().millisecondsSinceEpoch);
    
    if (address == 'MPESA') {
      final transaction = SmsParserService.parseMpesaSms(body, date);
      if (transaction != null) {
        await StorageService.saveTransaction(transaction);
        
        if (fromForeground) {
          _newTransactionStream.add(transaction); // Trigger instant UI
        }
      }
    }
    // Logic for other banks goes here...
  }
}
