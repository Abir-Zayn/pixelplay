part of 'fav_btn_cubit.dart';

abstract class FavBtnState {}

class FavBtnStateInitial extends FavBtnState {}

class FavBtnUpdated extends FavBtnState {
  final bool isFav;
  FavBtnUpdated({required this.isFav});
}
