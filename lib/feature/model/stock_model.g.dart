// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StockModelAdapter extends TypeAdapter<StockModel> {
  @override
  final int typeId = 0;

  @override
  StockModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StockModel(
      stockDetailModel: (fields[4] as List).cast<StockDetailModel>(),
      id: fields[0] as int,
      title: fields[3] as String?,
      pPrice: fields[1] as double?,
      sPrice: fields[2] as double?,
      purchaseDate: fields[6] as DateTime?,
      currency: fields[7] as CurrencyEnum,
    )..totalMeter = fields[5] as double?;
  }

  @override
  void write(BinaryWriter writer, StockModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.pPrice)
      ..writeByte(2)
      ..write(obj.sPrice)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.stockDetailModel)
      ..writeByte(5)
      ..write(obj.totalMeter)
      ..writeByte(6)
      ..write(obj.purchaseDate)
      ..writeByte(7)
      ..write(obj.currency);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StockDetailModelAdapter extends TypeAdapter<StockDetailModel> {
  @override
  final int typeId = 1;

  @override
  StockDetailModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StockDetailModel(
      itemDetailId: fields[0] as int,
      itemId: fields[3] as int,
      title: fields[1] as String?,
      meter: fields[2] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, StockDetailModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.itemDetailId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.meter)
      ..writeByte(3)
      ..write(obj.itemId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockDetailModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockModel _$StockModelFromJson(Map<String, dynamic> json) => StockModel(
      stockDetailModel: (json['itemDetail'] as List<dynamic>)
          .map((e) => StockDetailModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: (json['itemId'] as num?)?.toInt() ?? 0,
      title: json['title'] as String?,
      pPrice: (json['pPrice'] as num?)?.toDouble(),
      sPrice: (json['sPrice'] as num?)?.toDouble(),
      purchaseDate: json['purchaseDate'] == null
          ? null
          : DateTime.parse(json['purchaseDate'] as String),
      currency: $enumDecodeNullable(_$CurrencyEnumEnumMap, json['currency']) ??
          CurrencyEnum.usd,
    )..totalMeter = (json['totalMeter'] as num?)?.toDouble();

Map<String, dynamic> _$StockModelToJson(StockModel instance) =>
    <String, dynamic>{
      'itemId': instance.id,
      'pPrice': instance.pPrice,
      'sPrice': instance.sPrice,
      'title': instance.title,
      'itemDetail': instance.stockDetailModel.map((e) => e.toJson()).toList(),
      'totalMeter': instance.totalMeter,
      'purchaseDate': instance.purchaseDate?.toIso8601String(),
      'currency': _$CurrencyEnumEnumMap[instance.currency]!,
    };

const _$CurrencyEnumEnumMap = {
  CurrencyEnum.tl: 'tl',
  CurrencyEnum.usd: 'usd',
  CurrencyEnum.nullValue: '',
};

StockDetailModel _$StockDetailModelFromJson(Map<String, dynamic> json) =>
    StockDetailModel(
      itemDetailId: (json['itemDetailId'] as num).toInt(),
      itemId: (json['itemId'] as num).toInt(),
      title: json['name'] as String?,
      meter: (json['quantity'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$StockDetailModelToJson(StockDetailModel instance) =>
    <String, dynamic>{
      'itemDetailId': instance.itemDetailId,
      'name': instance.title,
      'quantity': instance.meter,
      'itemId': instance.itemId,
    };
