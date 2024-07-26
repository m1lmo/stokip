import 'package:flutter/material.dart';

import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stokip/feature/service/model/service_model.dart';
import 'package:stokip/product/constants/enums/currency_enum.dart';
import 'package:stokip/product/database/core/hive_types.dart';
import 'package:stokip/product/database/core/model/hive_model2_mixin.dart';

part 'stock_model.g.dart';

// enum Models { StockModel, StockDetailModel, ImporterModel }

// abstract class MainModel<T extends Models> {
abstract class MainModel with HiveModel2Mixin, EquatableMixin, ServiceModel {
  MainModel({
    this.title,
  });
  final String? title;
}

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: HiveTypes.stockModelId)
class StockModel extends MainModel {
  StockModel({
    required this.stockDetailModel,
    this.id = 0,
    this.title,
    this.pPrice,
    this.sPrice,
    this.purchaseDate,
    this.totalMeter,
    this.currency = CurrencyEnum.usd,
  });
  factory StockModel.fromJson(Map<String, dynamic> json) {
    return _$StockModelFromJson(json);
  }
  @override
  String get key {
    return id.toString();
  }

  @HiveField(0)
  @JsonKey(name: 'itemId')
  final int id;
  @HiveField(1)
  final double? pPrice;
  @HiveField(2)
  final double? sPrice;
  @HiveField(3)
  @override
  @JsonKey(name: 'title')
  final String? title;
  @HiveField(4)
  @JsonKey(name: 'itemDetail')
  final List<StockDetailModel> stockDetailModel;
  @HiveField(5)
  double? totalMeter;
  @HiveField(6)
  DateTime? purchaseDate;
  @HiveField(7)
  CurrencyEnum currency;

  @override
  Map<String, dynamic> toJson() {
    return _$StockModelToJson(this);
  }

  @override
  List<Object?> get props => [id, pPrice, sPrice, title, stockDetailModel, totalMeter, purchaseDate, currency];

  StockModel copyWith({
    int? id,
    ValueGetter<double?>? pPrice,
    ValueGetter<double?>? sPrice,
    ValueGetter<String?>? title,
    List<StockDetailModel>? stockDetailModel,
    ValueGetter<double?>? totalMeter,
    ValueGetter<DateTime?>? purchaseDate,
    CurrencyEnum? currency,
  }) {
    return StockModel(
      id: id ?? this.id,
      pPrice: pPrice != null ? pPrice() : this.pPrice,
      sPrice: sPrice != null ? sPrice() : this.sPrice,
      title: title != null ? title() : this.title,
      stockDetailModel: stockDetailModel ?? this.stockDetailModel,
      totalMeter: totalMeter != null ? totalMeter() : this.totalMeter,
      purchaseDate: purchaseDate != null ? purchaseDate() : this.purchaseDate,
      currency: currency ?? this.currency,
    );
  }
}

@JsonSerializable()
@HiveType(typeId: HiveTypes.stockDetailModelId)
class StockDetailModel extends MainModel {
  StockDetailModel({
    this.itemDetailId,
    this.itemId,
    this.title,
    this.meter,
  });
  factory StockDetailModel.fromJson(Map<String, dynamic> json) {
    return _$StockDetailModelFromJson(json);
  }
  @HiveField(0)
  @JsonKey(name: 'itemDetailId')
  final int? itemDetailId;
  @override
  @HiveField(1)
  @JsonKey(name: 'name')
  final String? title;
  @HiveField(2)
  @JsonKey(name: 'quantity')
  double? meter;
  @HiveField(3)
  @JsonKey(name: 'itemId')
  final int? itemId;

  @override
  Map<String, dynamic> toJson() {
    return _$StockDetailModelToJson(this);
  }

  @override
  String get key => itemDetailId.toString();

  @override
  // TODO: implement props
  List<Object?> get props => [itemDetailId, title, meter, itemId];

  StockDetailModel copyWith({
    int? itemDetailId,
    ValueGetter<String?>? title,
    ValueGetter<double?>? meter,
    ValueGetter<int?>? itemId,
  }) {
    return StockDetailModel(
      itemDetailId: itemDetailId ?? this.itemDetailId,
      title: title != null ? title() : this.title,
      meter: meter != null ? meter() : this.meter,
      itemId: itemId != null ? itemId() : this.itemId,
    );
  }
}
