import 'package:hive/hive.dart';

part 'subscription_model.g.dart';

@HiveType(typeId: 2)
class SubscriptionModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double averageAmount;

  @HiveField(3)
  final DateTime lastPaidDate;

  @HiveField(4)
  final DateTime expectedNextDate;

  @HiveField(5)
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
