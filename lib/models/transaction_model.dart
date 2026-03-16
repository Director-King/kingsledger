import 'package:hive/hive.dart';

part 'transaction_model.g.dart'; // Will be generated using build_runner

@HiveType(typeId: 0)
class TransactionModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final String provider; // 'MPESA', 'EQUITY', 'KCB', 'CO-OP', 'NCBA'

  @HiveField(4)
  final String type; // 'Paybill', 'Buy Goods', 'Send Money', 'Withdrawal', 'Deposit'

  @HiveField(5)
  final String party; // e.g. "SAFARICOM", "JOHN DOE"

  @HiveField(6)
  String category;

  @HiveField(7)
  bool isBusiness;

  @HiveField(8)
  String envelopeId;

  @HiveField(9)
  final double balance; // "New Balance" after transaction
  
  @HiveField(10)
  final String rawMessage; // The original SMS message

  TransactionModel({
    required this.id,
    required this.amount,
    required this.date,
    required this.provider,
    required this.type,
    required this.party,
    this.category = 'Uncategorized',
    this.isBusiness = false,
    this.envelopeId = '',
    required this.balance,
    required this.rawMessage,
  });
}
