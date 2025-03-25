import 'package:dartz/dartz.dart';
import 'package:pixelplayapp/core/config/service_locator.dart';
import 'package:pixelplayapp/core/usecase/usecase.dart';
import 'package:pixelplayapp/data/model/auth/user_login.dart';
import 'package:pixelplayapp/domain/repo/auth_repo.dart';

class Signinusecase implements Usecase<Either, UserLogin> {
  @override
  Future<Either> call({UserLogin? params}) async {
    return await sl<AuthRepo>().signin(params!);
  }
}
