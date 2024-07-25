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
      itemName: fields[7] as String?,
      customer: fields[6] as CustomerModel?,
    );
  }

  @override
  void write(BinaryWriter writer, SalesModel obj) {
    writer
      ..writeByte(8)
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
      ..write(obj.customer)
      ..writeByte(7)
      ..write(obj.itemName);
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
      id: (json['saleId'] as num).toInt(),
      dateTime: SalesModel._dateTimeFromJson(json['soldDate'] as String),
      stockDetailModel: json['itemDetail'] == null
          ? null
          : StockDetailModel.fromJson(
              json['itemDetail'] as Map<String, dynamic>),
      quantity: (json['quantitySold'] as num?)?.toDouble(),
      price: (json['salePrice'] as num?)?.toDouble(),
      currency:
          $enumDecodeNullable(_$CurrencyEnumEnumMap, json['currencyType']),
      itemName: json['itemName'] as String?,
      customer: json['customer'] == null
          ? null
          : CustomerModel.fromJson(json['customer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SalesModelToJson(SalesModel instance) =>
    <String, dynamic>{
      'saleId': instance.id,
      'itemDetail': instance.stockDetailModel?.toJson(),
      'quantitySold': instance.quantity,
      'soldDate': SalesModel._dateTimeToJson(instance.dateTime),
      'salePrice': instance.price,
      'currencyType': _$CurrencyEnumEnumMap[instance.currency],
      'customer': instance.customer?.toJson(),
      'itemName': instance.itemName,
    };

const _$CurrencyEnumEnumMap = {
  CurrencyEnum.tl: 'tl',
  CurrencyEnum.usd: 'usd',
  CurrencyEnum.nullValue: '',
};
