// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchases_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PurchasesModelAdapter extends TypeAdapter<PurchasesModel> {
  @override
  final int typeId = 5;

  @override
  PurchasesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PurchasesModel(
      purchasedDate: fields[5] as DateTime,
      id: fields[1] as int,
      supplier: fields[2] as String?,
      title: fields[3] as String?,
      detailTitle: fields[4] as String?,
      totalAmount: fields[6] as double?,
      meter: fields[7] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, PurchasesModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.supplier)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.detailTitle)
      ..writeByte(5)
      ..write(obj.purchasedDate)
      ..writeByte(6)
      ..write(obj.totalAmount)
      ..writeByte(7)
      ..write(obj.meter);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PurchasesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchasesModel _$PurchasesModelFromJson(Map<String, dynamic> json) =>
    PurchasesModel(
      purchasedDate: DateTime.parse(json['purchasedDate'] as String),
      id: json['id'] as int? ?? 0,
      supplier: json['supplier'] as String?,
      title: json['title'] as String?,
      detailTitle: json['detailTitle'] as String?,
      totalAmount: (json['totalAmount'] as num?)?.toDouble(),
      meter: (json['meter'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$PurchasesModelToJson(PurchasesModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'supplier': instance.supplier,
      'title': instance.title,
      'detailTitle': instance.detailTitle,
      'purchasedDate': instance.purchasedDate.toIso8601String(),
      'totalAmount': instance.totalAmount,
      'meter': instance.meter,
    };
