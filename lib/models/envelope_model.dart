import 'package:hive/hive.dart';

part 'envelope_model.g.dart';

@HiveType(typeId: 1)
class EnvelopeModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String icon;

  @HiveField(3)
  final String colorHex;

  @HiveField(4)
  double allocatedAmount;

  @HiveField(5)
  double spentAmount;

  @HiveField(6)
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
