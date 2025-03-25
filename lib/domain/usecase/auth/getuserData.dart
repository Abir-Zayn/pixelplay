
import 'package:dartz/dartz.dart';
import 'package:pixelplayapp/core/config/service_locator.dart';
import 'package:pixelplayapp/core/usecase/usecase.dart';
import 'package:pixelplayapp/domain/repo/auth_repo.dart';

class GetuserdataUseCase implements Usecase<Either,dynamic>{
  @override
  Future<Either>call({params}) async {
    return await sl<AuthRepo>().getUser();
  }
}