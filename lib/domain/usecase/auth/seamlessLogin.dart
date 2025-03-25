import 'package:firebase_auth/firebase_auth.dart';
import 'package:pixelplayapp/core/config/service_locator.dart';
import 'package:pixelplayapp/domain/repo/auth_repo.dart';

class SeamlessLogin {
  Future<User?> call() async {
    return await sl<AuthRepo>().seamlessLogin();
  }
}
