import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pixelplayapp/core/config/service_locator.dart';
import 'package:pixelplayapp/core/usecase/usecase.dart';
import 'package:pixelplayapp/domain/repo/auth_repo.dart';

// google Sign in usecase
class SignInWithGoogleUseCase
    implements Usecase<Either<String, UserCredential>, void> {
  @override
  Future<Either<String, UserCredential>> call({void params}) async {
    return await sl<AuthRepo>().signInwithGoogle();
  }
}
