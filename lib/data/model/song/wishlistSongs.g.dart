// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlistSongs.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WishlistsongsAdapter extends TypeAdapter<Wishlistsongs> {
  @override
  final int typeId = 1;

  @override
  Wishlistsongs read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Wishlistsongs(
      id: fields[0] as String,
      isFav: fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Wishlistsongs obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.isFav);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WishlistsongsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
