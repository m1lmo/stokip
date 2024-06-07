// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SalesModelAdapter extends TypeAdapter<SalesModel> {
  @override
  final int typeId = 2;

  @override
  SalesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SalesModel(
      id: fields[0] as int,
      dateTime: fields[3] as DateTime,
      stockDetailModel: fields[1] as StockDetailModel?,
      quantity: fields[2] as double?,
      price: fields[4] as double?,
      currency: fields[5] as CurrencyEnum?,
      customer: fields[6] as CustomerModel?,
    );
  }

  @override
  void write(BinaryWriter writer, SalesModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.stockDetailModel)
      ..writeByte(2)
      ..write(obj.quantity)
      ..writeByte(3)
      ..write(obj.dateTime)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.currency)
      ..writeByte(6)
      ..write(obj.customer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SalesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SalesModel _$SalesModelFromJson(Map<String, dynamic> json) => SalesModel(
      id: (json['id'] as num).toInt(),
      dateTime: DateTime.parse(json['dateTime'] as String),
      stockDetailModel: json['stockDetailModel'] == null
          ? null
          : StockDetailModel.fromJson(
              json['stockDetailModel'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num?)?.toDouble(),
      price: (json['price'] as num?)?.toDouble(),
      currency: $enumDecodeNullable(_$CurrencyEnumEnumMap, json['currency']),
      customer: json['customer'] == null
          ? null
          : CustomerModel.fromJson(json['customer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SalesModelToJson(SalesModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'stockDetailModel': instance.stockDetailModel,
      'quantity': instance.quantity,
      'dateTime': instance.dateTime.toIso8601String(),
      'price': instance.price,
      'currency': _$CurrencyEnumEnumMap[instance.currency],
      'customer': instance.customer,
    };

const _$CurrencyEnumEnumMap = {
  CurrencyEnum.tl: 'tl',
  CurrencyEnum.usd: 'usd',
};
