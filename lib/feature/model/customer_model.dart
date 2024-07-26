import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stokip/feature/model/payment_model.dart';
import 'package:stokip/feature/model/sales_model.dart';
import 'package:stokip/feature/model/stock_model.dart';
import 'package:stokip/product/constants/enums/currency_enum.dart';
import 'package:stokip/product/database/core/hive_types.dart';

part 'customer_model.g.dart';

@JsonSerializable()
@HiveType(typeId: HiveTypes.customerModelId)

/// The `CustomerModel` class is a data model class that represents a customer.
@JsonSerializable(explicitToJson: true)
final class CustomerModel extends MainModel {
  /// constructor for the CustomerModel class.
  CustomerModel({
    this.id,
    this.title,
    this.balance = 0,
    this.boughtProducts,
    this.currency = CurrencyEnum.usd,
  });

  /// fromJson is a factory method that creates a `CustomerModel` object from a `Map<String, dynamic>`.
  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return _$CustomerModelFromJson(json);
  }
  @HiveField(0)
  @JsonKey(name: 'customerId')
  final int? id;
  @override
  @HiveField(1)
  @JsonKey(name: 'name')
  final String? title;
  @HiveField(2)
  double? balance;
  @HiveField(3)
  @JsonKey(includeFromJson: false, includeToJson: false)
  late final List<SalesModel>? boughtProducts;
  @HiveField(4)
  final List<PaymentModel> payments = const [];
  @HiveField(5)
  @JsonKey(name: 'currencyType')
  final CurrencyEnum currency;

  @override
  List<Object?> get props => [id, title, balance, boughtProducts, payments];

  @override
  String get key => id.toString();

  /// The `toJson` method is a method that converts a `CustomerModel` object into a `Map<String, dynamic>`.
  @override
  Map<String, dynamic> toJson() {
    return _$CustomerModelToJson(this);
  }

  CustomerModel copyWith({
    int? id,
    ValueGetter<String?>? title,
    ValueGetter<double?>? balance,
    ValueGetter<List<SalesModel>?>? boughtProducts,
    CurrencyEnum? currency,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      title: title != null ? title() : this.title,
      balance: balance != null ? balance() : this.balance,
      boughtProducts: boughtProducts != null ? boughtProducts() : this.boughtProducts,
      currency: currency ?? this.currency,
    );
  }
}
