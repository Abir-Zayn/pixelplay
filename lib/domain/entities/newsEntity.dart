import 'package:cloud_firestore/cloud_firestore.dart';

class Newsentity {
  final String id;
  final String title;
  final String body;
  num like;
  final String newsImg;
  final Timestamp postedOn;

  Newsentity({
    required this.id,
    required this.title,
    required this.body,
    required this.like,
    required this.newsImg,
    required this.postedOn,
  });
}
