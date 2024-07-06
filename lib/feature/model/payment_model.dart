import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stokip/product/database/core/hive_types.dart';

part 'payment_model.g.dart';

@JsonSerializable()
@HiveType(typeId: HiveTypes.paymentModelId)
final class PaymentModel {
  PaymentModel({this.price, this.payedTime});
  @HiveField(0)
  final double? price;
  @HiveField(1)
  final DateTime? payedTime;
}
