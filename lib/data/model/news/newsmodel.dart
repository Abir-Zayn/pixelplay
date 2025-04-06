import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pixelplayapp/domain/entities/newsEntity.dart';

class NewsModel {
  final String? id;
  final String? title;
  final String? body;
  num? like;
  final String? newsImg;
  final Timestamp? postedOn;

  NewsModel({
    this.id,
    this.title,
    this.body,
    this.like,
    this.newsImg,
    this.postedOn,
  });

  // Convert entity to JSON map
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'like': like,
      'newsImg': newsImg,
      'postedOn': postedOn,
      'id': id,
    };
  }

  // Create entity from JSON map
  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      title: json['title'] as String,
      body: json['body'] as String,
      like: _parseNum(json['like']),
      newsImg: json['newsImg'] as String,
      postedOn: _parseTimestamp(json['postedOn']),
      id: json['id'] as String?,
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

extension NewsModelX on NewsModel {
  Newsentity toEntity() {
    return Newsentity(
      id: id!,
      title: title!,
      body: body!,
      like: like ?? 0,
      newsImg: newsImg!,
      postedOn: postedOn!,
    );
  }
}
