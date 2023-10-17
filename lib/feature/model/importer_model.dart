import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stokip/feature/model/payment_model.dart';
import 'stock_model.dart';
import '../../product/constants/enums/currency_enum.dart';
import '../../product/database/core/hive_types.dart';

import '../../product/database/core/model/hive_model2_mixin.dart';
import 'purchases_model.dart';
part 'importer_model.g.dart';

@JsonSerializable()
@HiveType(typeId: HiveTypes.importerModelId)
final class ImporterModel extends MainModel with HiveModel2Mixin {
  /// The code `ImporterModel({this.id = 0, this.title, this.currency, this.balance, this.customerPhoto,
  /// this.purchases = const []});` is defining a constructor for the `ImporterModel` class.

  ImporterModel({
    this.id = 0,
    this.title,
    this.currency,
    this.balance,
    this.customerPhoto,
  });

  /// The line `final int id;` is declaring a final variable named `id` of type `int` in the
  /// `ImporterModel` class. This variable represents the unique identifier for an importer. The `final`
  /// keyword indicates that the value of `id` cannot be changed once it is assigned a value.
  @HiveField(0)
  final int id;
  @override
  @HiveField(1)
  final String? title;
  @HiveField(2)
  final CurrencyEnum? currency;
  @HiveField(3)
  double? balance;

  @HiveField(5)
  Uint8List? customerPhoto;
  @HiveField(6)
  final List<PurchasesModel> purchases = [];
  @HiveField(7)
  final List<PaymentModel> payments = [];

  @override
  String get key => id.toString();
}
