import 'package:cloud_firestore/cloud_firestore.dart';

class SongEntity {
  final String title;
  final String artist;
  final num duration;
  final Timestamp releaseDate;
  final String imageUrl;
  final String musicUrl;
  final String id;
  bool isFav;
  final String searchOpt;
  final String genre;

  SongEntity({
    required this.id,
    required this.title,
    required this.artist,
    required this.duration,
    required this.releaseDate,
    required this.imageUrl,
    required this.musicUrl,
    this.isFav = false,
    required this.searchOpt,
    required this.genre,
  });
}
