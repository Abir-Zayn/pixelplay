import 'package:hive/hive.dart';

part 'wishlistSongs.g.dart';

@HiveType(typeId: 1)
class Wishlistsongs {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final bool isFav;

  Wishlistsongs({
    required this.id,
    required this.isFav,
  });

}