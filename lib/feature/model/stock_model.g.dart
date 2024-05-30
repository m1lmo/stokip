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
      id: fields[0] as int,
      title: fields[3] as String?,
      pPrice: fields[1] as double?,
      sPrice: fields[2] as double?,
      stockDetailModel: (fields[4] as List).cast<StockDetailModel>(),
      totalMeter: fields[5] as double?,
      purchaseDate: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, StockModel obj) {
    writer
      ..writeByte(7)
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
      ..write(obj.purchaseDate);
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
      title: fields[0] as String?,
      meter: fields[1] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, StockDetailModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.meter);
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
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String?,
      pPrice: (json['pPrice'] as num?)?.toDouble(),
      sPrice: (json['sPrice'] as num?)?.toDouble(),
      stockDetailModel: (json['stockDetailModel'] as List<dynamic>?)
              ?.map((e) => StockDetailModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      totalMeter: (json['totalMeter'] as num?)?.toDouble(),
      purchaseDate: json['purchaseDate'] == null
          ? null
          : DateTime.parse(json['purchaseDate'] as String),
    );

Map<String, dynamic> _$StockModelToJson(StockModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pPrice': instance.pPrice,
      'sPrice': instance.sPrice,
      'title': instance.title,
      'stockDetailModel': instance.stockDetailModel,
      'totalMeter': instance.totalMeter,
      'purchaseDate': instance.purchaseDate?.toIso8601String(),
    };

StockDetailModel _$StockDetailModelFromJson(Map<String, dynamic> json) =>
    StockDetailModel(
      title: json['title'] as String?,
      meter: (json['meter'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$StockDetailModelToJson(StockDetailModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'meter': instance.meter,
    };
