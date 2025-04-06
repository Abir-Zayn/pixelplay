import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pixelplayapp/core/config/service_locator.dart';
import 'package:pixelplayapp/data/model/auth/user_login.dart';
import 'package:pixelplayapp/data/model/auth/user_req.dart';
import 'package:pixelplayapp/data/src/auth_firebase_service.dart';
import 'package:pixelplayapp/domain/repo/auth_repo.dart';

class AuthRepoImplementation extends AuthRepo {
  @override
  Future<Either> signin(UserLogin userLogin) async {
    final result = await sl<AuthFirebaseService>().signin(userLogin);
    return result;
  }

  @override
  Future<Either> signup(UserReq userReq) async {
    final result = await sl<AuthFirebaseService>().signup(userReq);
    return result;
  }

  @override
  Future<User?> seamlessLogin() async {
    final result = await sl<AuthFirebaseService>().seamlessLogin();
    return result;
  }

  @override
  Future<Either> getUser() async {
    return await sl<AuthFirebaseService>().getUser();
  }

  @override
  Future<Either<String, UserCredential>> signInwithGoogle() async {
    return await sl<AuthFirebaseService>().signInwithGoogle();
  }
  @override
  Future<void> signOut() async {
    await sl<AuthFirebaseService>().signOut();
  }
}
