import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pixelplayapp/data/model/auth/user_login.dart';
import 'package:pixelplayapp/data/model/auth/user_model.dart';
import 'package:pixelplayapp/data/model/auth/user_req.dart';
import 'package:pixelplayapp/domain/entities/userEntity.dart';

abstract class AuthFirebaseService {
  Future<Either> signup(UserReq userReq);
  Future<Either> signin(UserLogin userLogin);
  Future<User?> seamlessLogin();
  Future<Either> getUser();
}

class AuthFirebaseServiceImplementation extends AuthFirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  @override
  Future<Either> signup(UserReq userReq) async {
    try {
      var data = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userReq.userEmail,
        password: userReq.userPassword,
      );

      FirebaseFirestore.instance.collection('Users').doc(data.user?.uid).set({
        'userName': userReq.userName,
        'userEmail': userReq.userEmail,
        'userId': data.user?.uid,
      });
      return Right('Signup successful');
    } on FirebaseAuthException catch (e) {
      String message = '';

      switch (e.code) {
        case 'weak-password':
          message = 'The password provided is too weak.';
          break;
        case 'email-already-in-use':
          message = 'The account already exists for that email.';
          break;
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
        case 'operation-not-allowed':
          message = 'Email/Password accounts are not enabled.';
          break;
        default:
          message = 'An undefined Error happened.';
          break;
      }
      return left(message);
    }
  }

  @override
  Future<Either> signin(UserLogin userLogin) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userLogin.userEmail,
        password: userLogin.userPassword,
      );

      //store credentials in local storage securely
      await _secureStorage.write(
        key: 'email',
        value: userLogin.userEmail,
      );
      await _secureStorage.write(
        key: 'password',
        value: userLogin.userPassword,
      );
      return Right('Signin successful');
    } on FirebaseAuthException catch (e) {
      String message = '';

      switch (e.code) {
        case 'user-not-found':
          message = 'No user found for that email.';
          break;
        case 'wrong-password':
          message = 'Wrong password provided for that user.';
          break;
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
        default:
          message = 'An undefined Error happened.';
          break;
      }
      return left(message);
    }
  }

  @override
  Future<User?> seamlessLogin() async {
    String? email = await _secureStorage.read(key: 'email');
    String? password = await _secureStorage.read(key: 'password');
    
    if (email == null || password == null) {
      return null;
    }
    
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      await _secureStorage.deleteAll();
      return null;
    }
  }


  @override
  Future<Either> getUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      var user = await firestore.collection('Users').doc(
        auth.currentUser?.uid
      ).get();
      
      if (user.exists) {
        UserModel usermodel = UserModel.fromJson(user.data()!);
        UserEntity userEntity = usermodel.toEntity();
        return Right(userEntity);
      } else {
        return Left('User not found');
      }
    } catch (e) {
      return Left('Error fetching user data: ${e.toString()}');
    }
  }


}
