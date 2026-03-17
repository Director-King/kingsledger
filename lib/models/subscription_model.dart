import 'package:hive/hive.dart';

class SubscriptionModel extends HiveObject {
  final String id;
  final String name;
  final double averageAmount;
  final DateTime lastPaidDate;
  final DateTime expectedNextDate;
  final String provider;

  SubscriptionModel({
    required this.id,
    required this.name,
    required this.averageAmount,
    required this.lastPaidDate,
    required this.expectedNextDate,
    required this.provider,
  });
}

class SubscriptionModelAdapter extends TypeAdapter<SubscriptionModel> {
  @override
  final int typeId = 2;

  @override
  SubscriptionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubscriptionModel(
      id: fields[0] as String,
      name: fields[1] as String,
      averageAmount: fields[2] as double,
      lastPaidDate: fields[3] as DateTime,
      expectedNextDate: fields[4] as DateTime,
      provider: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SubscriptionModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.averageAmount)
      ..writeByte(3)
      ..write(obj.lastPaidDate)
      ..writeByte(4)
      ..write(obj.expectedNextDate)
      ..writeByte(5)
      ..write(obj.provider);
  }
}
