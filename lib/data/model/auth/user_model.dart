import 'package:pixelplayapp/domain/entities/userEntity.dart';

class UserModel {
  final String? userId;
  final String? userName;
  final String? userEmail;

  UserModel({
    this.userId,
    this.userName,
    this.userEmail,
  });

  // Create model from JSON map
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] as String?,
      userName: json['userName'] as String?,
      userEmail: json['userEmail'] as String?,
    );
  }

  // Convert model to JSON map
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
    };
  }

  // Convert model to entity
  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      userName: userName,
      userEmail: userEmail,
    );
  }

  // Create model from entity
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      userId: entity.userId,
      userName: entity.userName,
      userEmail: entity.userEmail,
    );
  }
}
