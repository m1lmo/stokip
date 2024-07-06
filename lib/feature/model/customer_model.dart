import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stokip/feature/model/payment_model.dart';
import 'package:stokip/feature/model/sales_model.dart';
import 'package:stokip/feature/model/stock_model.dart';
import 'package:stokip/product/constants/enums/currency_enum.dart';
import 'package:stokip/product/database/core/hive_types.dart';
import 'package:stokip/product/database/core/model/hive_model2_mixin.dart';

part 'customer_model.g.dart';

@immutable
@JsonSerializable()
@HiveType(typeId: HiveTypes.customerModelId)

/// The `CustomerModel` class is a data model class that represents a customer.
final class CustomerModel extends MainModel with EquatableMixin, HiveModel2Mixin {
  /// constructor for the CustomerModel class.
  CustomerModel({
    required this.id,
    this.title,
    this.balance,
    this.boughtProducts,
    this.currency = CurrencyEnum.usd,
  });

  /// fromJson is a factory method that creates a `CustomerModel` object from a `Map<String, dynamic>`.
  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return _$CustomerModelFromJson(json);
  }
  @HiveField(0)
  final int id;
  @override
  @HiveField(1)
  final String? title;
  @HiveField(2)
  double? balance;
  @HiveField(3)
  final List<SalesModel>? boughtProducts;
  @HiveField(4)
  final List<PaymentModel> payments = const [];
  @HiveField(5)
  final CurrencyEnum currency;

  @override
  List<Object?> get props => [id, title, balance, boughtProducts, payments];

  @override
  String get key => id.toString();

  /// The `toJson` method is a method that converts a `CustomerModel` object into a `Map<String, dynamic>`.
  Map<String, dynamic> toJson() {
    return _$CustomerModelToJson(this);
  }
}
