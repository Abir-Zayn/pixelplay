import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pixelplayapp/domain/entities/song.dart';

class SongsModel {
  final String? id;
  final String? title;
  final String? searchOpt;
  final String? artist;
  final num? duration;
  Timestamp? releaseDate;
  String? imageUrl;
  String? musicUrl;
  bool? isFav;
  final String? genre;

  SongsModel({
    this.id,
    this.title,
    this.artist,
    this.duration,
    this.releaseDate,
    this.imageUrl,
    this.musicUrl,
    this.isFav,
    this.searchOpt,
    this.genre,
  });
  // Convert entity to JSON map
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'artist': artist,
      'duration': duration,
      'releaseDate': releaseDate,
      'coverImg': imageUrl,
      'musicUrl': musicUrl,
      'id': id,
      'isFav': isFav,
      'searchOpt': searchOpt,
      'genre': genre,
    };
  }

  // Create entity from JSON map
  factory SongsModel.fromJson(Map<String, dynamic> json) {
    return SongsModel(
      title: json['title'] as String?,
      artist: json['artist'] as String?,
      duration: _parseNum(json['duration']),
      releaseDate: _parseTimestamp(json['releaseDate']),
      imageUrl: json['coverImg'] as String?,
      musicUrl: json['musicUrl'] as String?,
      id: json['id'] as String?,
      isFav: json['isFav'] as bool? ?? false,
      searchOpt: json['searchOpt'] as String?,
      genre: json['genre'] as String?,
    );
  }
  // Add this helper method to the class
  static num _parseNum(dynamic value) {
    if (value is num) return value;
    if (value is String) return num.tryParse(value) ?? 0;
    return 0;
  }

  // Add this helper method for handling Timestamp
  static Timestamp _parseTimestamp(dynamic value) {
    if (value is Timestamp) return value;
    // Return a default timestamp if the value is null or not a Timestamp
    return Timestamp.now();
  }

  SongsModel copyWith({
    String? id,
    String? title,
    String? artist,
    num? duration,
    Timestamp? releaseDate,
    String? imageUrl,
    String? musicUrl,
    bool? isFav,
    String? searchOpt,
    String? genre,
  }) {
    return SongsModel(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      duration: duration ?? this.duration,
      releaseDate: releaseDate ?? this.releaseDate,
      imageUrl: imageUrl ?? this.imageUrl,
      musicUrl: musicUrl ?? this.musicUrl,
      isFav: isFav ?? this.isFav,
      searchOpt: searchOpt ?? this.searchOpt,
      genre: genre ?? this.genre,
    );
  }
}

extension SongsModelX on SongsModel {
  SongEntity toEntity() {
    return SongEntity(
      title: title ?? '',
      artist: artist ?? '',
      duration: duration ?? 0,
      releaseDate: releaseDate ?? Timestamp.now(),
      imageUrl: imageUrl ?? '',
      musicUrl: musicUrl ?? '',
      id: id ?? '',
      isFav: isFav ?? false,
      searchOpt: searchOpt ?? '',
      genre: genre ?? '',
    );
  }
}
