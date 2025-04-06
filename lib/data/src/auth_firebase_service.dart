import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pixelplayapp/data/model/auth/user_login.dart';
import 'package:pixelplayapp/data/model/auth/user_model.dart';
import 'package:pixelplayapp/data/model/auth/user_req.dart';
import 'package:pixelplayapp/domain/entities/userEntity.dart';

abstract class AuthFirebaseService {
  Future<Either> signup(UserReq userReq);
  Future<Either> signin(UserLogin userLogin);
  Future<User?> seamlessLogin();
  Future<Either> getUser();
  Future<Either<String, UserCredential>> signInwithGoogle();
  Future<void> signOut();
}

// This is the backend implementation of the AuthFirebaseService
// When the user has done specific actions and the data and required information
// has passed through the repository[abstract class] then the data is passed to
// the backend implementation which is known as the AuthFirebaseServiceImplementation

class AuthFirebaseServiceImplementation extends AuthFirebaseService {
  // FirebaseAuth instance to handle authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // FlutterSecureStorage instance to store user credentials securely for one time login
  // This is used for email and password login but not for Google login
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  Future<Either> signup(UserReq userReq) async {
    try {
      //Registering user with email and password
      var data = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userReq.userEmail,
        password: userReq.userPassword,
      );

      //store user credentials in Cloud Firestore
      FirebaseFirestore.instance.collection('Users').doc(data.user?.uid).set({
        'userName': userReq.userName,
        'userEmail': userReq.userEmail,
        'userId': data.user?.uid,
      });
      //Returning success message
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
      //Returning error message
      return left(message);
    }
  }

  //Sign in with email and password operation
  @override
  Future<Either> signin(UserLogin userLogin) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userLogin.userEmail,
        password: userLogin.userPassword,
      );
      // When user login to the app, the app will store the user credentials in the local storage
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

  // This method is used to login the user without entering the credentials again
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

  /// Retrieves the current user's data from Firestore
  /// Returns Either a UserEntity or error message
  @override
  Future<Either> getUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      var user =
          await firestore.collection('Users').doc(auth.currentUser?.uid).get();

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

  /// Handles Google Sign-In authentication flow
  /// Creates a new user record in Firestore if one doesn't exist
  /// Returns Either an error message or the UserCredential
  @override
  Future<Either<String, UserCredential>> signInwithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return Left('Google sign-in aborted by user');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      //Sign In to Firebase with the obtained credential
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;
      if (user != null) {
        // Store user data in Firestore
        final userDocument = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .get();

        if (!userDocument.exists) {
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(user.uid)
              .set({
            'userName': user.displayName,
            'userEmail': user.email,
            'userId': user.uid,
          });
        }
        return Right(userCredential);
      }
      return Left('User not found');
    } catch (e) {
      return Left('Error signing in with Google: ${e.toString()}');
    }
  }

  // This method is used to sign out the user from the app
  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _secureStorage.deleteAll();
    } catch (e) {
      throw Exception('Error signing out: ${e.toString()}');
    }
  }
}
