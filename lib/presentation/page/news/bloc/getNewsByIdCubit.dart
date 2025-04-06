import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixelplayapp/domain/usecase/news/getNewsByIdUseCase.dart';
import 'package:pixelplayapp/presentation/page/news/bloc/getNewsByIdState.dart';

class GetnewsbyIDcubit extends Cubit<GetnewsbyIdState> {
  final GetnewsbyIdUseCase getnewsbyIdUseCase;

  GetnewsbyIDcubit(this.getnewsbyIdUseCase) : super(GetnewsbyIdInitial());

  void fetchNewsByID(String newsId) async {
    emit(GetnewsbyIdLoading());
    try {
      await Future.delayed(const Duration(seconds: 1));
      final result = await getnewsbyIdUseCase(newsId);
      result.fold(
        (error) {
          emit(GetnewsbyIdError(error));
        },
        (news) {
          emit(GetnewsbyIdLoaded(news));
        },
      );
    } catch (e) {
      emit(GetnewsbyIdError(e.toString()));
    }
  }
}
