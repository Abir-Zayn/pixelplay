import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixelplayapp/core/config/service_locator.dart';
import 'package:pixelplayapp/domain/usecase/news/getAllNewsUseCase.dart';
import 'package:pixelplayapp/presentation/page/root/bloc/getNewsListState.dart';

class GetNewsListCubit extends Cubit<GetAllNewsListState> {
  GetNewsListCubit() : super(GetAllNewsListStateInitial());

  Future<void> getNewsList() async {
    emit(GetAllNewsListStateLoading());
    try {
      // Simulate a network call or data fetching
      await Future.delayed(Duration(seconds: 2));
      var res = await sl<GetAllNewsUseCase>().call();
      res.fold(
        (left) {
          emit(GetAllNewsListStateError(left.toString()));
        },
        (news) {
          emit(GetAllNewsListStateSuccess(news));
        },
      );
    } catch (e) {
      emit(GetAllNewsListStateError(e.toString()));
    }
  }
}
