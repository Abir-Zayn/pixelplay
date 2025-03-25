import 'package:dartz/dartz.dart';
import 'package:pixelplayapp/core/config/service_locator.dart';
import 'package:pixelplayapp/core/usecase/usecase.dart';
import 'package:pixelplayapp/data/model/auth/user_req.dart';
import 'package:pixelplayapp/domain/repo/auth_repo.dart';

class Signupusecase implements Usecase<Either, UserReq>{
  @override
  Future<Either> call({UserReq? params}) async{
    return await sl<AuthRepo>().signup(params!);
  }
  
}