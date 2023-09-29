// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'importer_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ImporterModelAdapter extends TypeAdapter<ImporterModel> {
  @override
  final int typeId = 3;

  @override
  ImporterModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ImporterModel(
      id: fields[0] as int,
      title: fields[1] as String?,
      currency: fields[2] as CurrencyEnum?,
      balance: fields[3] as double?,
      customerPhoto: fields[5] as Uint8List?,
      purchases: (fields[6] as List).cast<PurchasesModel>(),
      payments: (fields[7] as List).cast<PaymentModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, ImporterModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.currency)
      ..writeByte(3)
      ..write(obj.balance)
      ..writeByte(5)
      ..write(obj.customerPhoto)
      ..writeByte(6)
      ..write(obj.purchases)
      ..writeByte(7)
      ..write(obj.payments);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImporterModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
