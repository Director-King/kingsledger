import 'package:hive/hive.dart';

class EnvelopeModel extends HiveObject {
  final String id;
  final String name;
  final String icon;
  final String colorHex;
  double allocatedAmount;
  double spentAmount;
  final DateTime createdDate;

  EnvelopeModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.colorHex,
    required this.allocatedAmount,
    this.spentAmount = 0.0,
    required this.createdDate,
  });
  
  double get remaining => allocatedAmount - spentAmount;
  double get progress => allocatedAmount > 0 ? (spentAmount / allocatedAmount).clamp(0.0, 1.0) : 0.0;
}

class EnvelopeModelAdapter extends TypeAdapter<EnvelopeModel> {
  @override
  final int typeId = 1;

  @override
  EnvelopeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EnvelopeModel(
      id: fields[0] as String,
      name: fields[1] as String,
      icon: fields[2] as String,
      colorHex: fields[3] as String,
      allocatedAmount: fields[4] as double,
      spentAmount: fields[5] as double? ?? 0.0,
      createdDate: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, EnvelopeModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.icon)
      ..writeByte(3)
      ..write(obj.colorHex)
      ..writeByte(4)
      ..write(obj.allocatedAmount)
      ..writeByte(5)
      ..write(obj.spentAmount)
      ..writeByte(6)
      ..write(obj.createdDate);
  }
}
