import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stokip/feature/model/payment_model.dart';
import 'package:stokip/feature/model/stock_model.dart';
import 'package:stokip/product/constants/enums/currency_enum.dart';
import 'package:stokip/product/database/core/hive_types.dart';

import 'package:stokip/feature/model/purchases_model.dart';
import 'package:stokip/product/helper/uint8list_converter.dart';
part 'importer_model.g.dart';

@JsonSerializable()
@HiveType(typeId: HiveTypes.importerModelId)
final class ImporterModel extends MainModel {
  /// The code `ImporterModel({this.id = 0, this.title, this.currency, this.balance, this.customerPhoto,
  /// this.purchases = const []});` is defining a constructor for the `ImporterModel` class.

  ImporterModel({
    required this.id,
    this.title,
    this.currency,
    this.balance = 0,
    this.customerPhoto,
  }) : super();

  factory ImporterModel.fromJson(Map<String, dynamic> json) {
    return _$ImporterModelFromJson(json);
  }

  /// The line `final int id;` is declaring a final variable named `id` of type `int` in the
  /// `ImporterModel` class. This variable represents the unique identifier for an importer. The `final`
  /// keyword indicates that the value of `id` cannot be changed once it is assigned a value.
  @HiveField(0)
  @JsonKey(name: 'supplierID')
  final int id;
  @override
  @HiveField(1)
  @JsonKey(name: 'name')
  final String? title;
  @HiveField(2)
  @JsonKey(includeFromJson: false, includeToJson: false)
  final CurrencyEnum? currency;
  @HiveField(3)
  double? balance;

  @HiveField(5)
  // @Uint8ListConverter()
  @JsonKey(includeFromJson: false, includeToJson: false)
  Uint8List? customerPhoto;
  @HiveField(6)
  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<PurchasesModel> purchases = [];
  @HiveField(7)
  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<PaymentModel> payments = [];

  @override
  String get key => id.toString();

  @override
  // TODO: implement props
  List<Object?> get props => [id, title, currency, balance, customerPhoto, purchases, payments];

  @override
  Map<String, dynamic> toJson() {
    return _$ImporterModelToJson(this);
  }
}
