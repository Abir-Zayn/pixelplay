import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pixelplayapp/data/model/auth/user_login.dart';
import 'package:pixelplayapp/data/model/auth/user_req.dart';

abstract class AuthRepo {
  Future<Either> signup(UserReq userReq);
  Future<Either> signin(UserLogin userLogin);
  Future<User?> seamlessLogin();
  Future<Either> getUser();
  Future<Either<String, UserCredential>> signInwithGoogle();
  Future<void> signOut();
}
