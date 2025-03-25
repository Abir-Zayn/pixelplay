import 'package:bloc/bloc.dart';
import 'package:pixelplayapp/core/config/service_locator.dart';
import 'package:pixelplayapp/domain/entities/userEntity.dart';
import 'package:pixelplayapp/domain/usecase/auth/getuserData.dart';

part 'profile_info_cubit_state.dart';

class ProfileInfoCubitCubit extends Cubit<ProfileInfoCubitState> {
  ProfileInfoCubitCubit() : super(ProfileInfoCubitInitial());

  Future<void> getUser() async {
    emit(ProfileInfoCubitLoading());
    try {
      final result = await sl<GetuserdataUseCase>().call();
      result.fold(
        (error) {
          emit(ProfileInfoCubitError(errorMessage: error.toString()));
        },
        (user) {
          emit(ProfileInfoCubitLoaded(userEntity: user));
        },
      );
    } catch (e) {
      emit(ProfileInfoCubitError(errorMessage: e.toString()));
    }
  }
}
