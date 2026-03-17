import 'package:hive/hive.dart';

class TransactionModel extends HiveObject {
  final String id;
  final double amount;
  final DateTime date;
  final String provider; // 'MPESA', 'EQUITY', 'KCB', 'CO-OP', 'NCBA'
  final String type; // 'Paybill', 'Buy Goods', 'Send Money', 'Withdrawal', 'Deposit'
  final String party; // e.g. "SAFARICOM", "JOHN DOE"
  String category;
  bool isBusiness;
  String envelopeId;
  final double balance; // "New Balance" after transaction
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

class TransactionModelAdapter extends TypeAdapter<TransactionModel> {
  @override
  final int typeId = 0;

  @override
  TransactionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionModel(
      id: fields[0] as String,
      amount: fields[1] as double,
      date: fields[2] as DateTime,
      provider: fields[3] as String,
      type: fields[4] as String,
      party: fields[5] as String,
      category: fields[6] as String? ?? 'Uncategorized',
      isBusiness: fields[7] as bool? ?? false,
      envelopeId: fields[8] as String? ?? '',
      balance: fields[9] as double,
      rawMessage: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TransactionModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.provider)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.party)
      ..writeByte(6)
      ..write(obj.category)
      ..writeByte(7)
      ..write(obj.isBusiness)
      ..writeByte(8)
      ..write(obj.envelopeId)
      ..writeByte(9)
      ..write(obj.balance)
      ..writeByte(10)
      ..write(obj.rawMessage);
  }
}
