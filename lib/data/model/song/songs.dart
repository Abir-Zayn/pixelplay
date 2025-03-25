import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pixelplayapp/domain/entities/song.dart';

class SongsModel {
  final String? id;
  final String? title;
  final String? artist;
  final num? duration;
  Timestamp? releaseDate;
  String? imageUrl;
  String? musicUrl;
  bool? isFav;

  SongsModel({
    this.id,
    this.title,
    this.artist,
    this.duration,
    this.releaseDate,
    this.imageUrl,
    this.musicUrl,
    this.isFav,
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
    };
  }

  // Create entity from JSON map
  factory SongsModel.fromJson(Map<String, dynamic> json) {
    return SongsModel(
      title: json['title'] as String,
      artist: json['artist'] as String,
      duration: _parseNum(json['duration']),
      releaseDate: _parseTimestamp(json['releaseDate']),
      imageUrl: json['coverImg'] as String,
      musicUrl: json['musicUrl'] as String,
      id: json['id'] as String?,
      isFav: json['isFav'] as bool? ?? false,
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
}

extension SongsModelX on SongsModel {
  SongEntity toEntity() {
    return SongEntity(
      title: title!,
      artist: artist!,
      duration: duration!,
      releaseDate: releaseDate!,
      imageUrl: imageUrl!,
      musicUrl: musicUrl!,
      id: id!,
      isFav: isFav ?? false,
    );
  }
}
