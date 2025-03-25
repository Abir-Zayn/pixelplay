part of 'profile_info_cubit_cubit.dart';

abstract class ProfileInfoCubitState {}

final class ProfileInfoCubitInitial extends ProfileInfoCubitState {}

final class ProfileInfoCubitLoading extends ProfileInfoCubitState {}

final class ProfileInfoCubitLoaded extends ProfileInfoCubitState {
  final UserEntity userEntity;

  ProfileInfoCubitLoaded({required this.userEntity});
}

final class ProfileInfoCubitError extends ProfileInfoCubitState {
  final String errorMessage;

  ProfileInfoCubitError({required this.errorMessage});
}
