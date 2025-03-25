import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pixelplayapp/common/cubit/cubit/fav_btn_cubit.dart';
import 'package:pixelplayapp/domain/entities/song.dart';

class FavBtn extends StatelessWidget {
  final SongEntity songEntity;

  const FavBtn({super.key, required this.songEntity});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavBtnCubit(
        songId: songEntity.id,
        initialFavStatus: songEntity.isFav,
      ),
      child: BlocBuilder<FavBtnCubit, FavBtnState>(
        builder: (context, state) {
          if (state is FavBtnStateInitial) {
            return IconButton(
              icon: Icon(
                songEntity.isFav
                    ? FontAwesomeIcons.solidHeart
                    : FontAwesomeIcons.heart,
                color: Colors.grey,
              ),
              onPressed: () {
                context.read<FavBtnCubit>().updateFavBtn(songEntity.id);
              },
            );
          }

          if (state is FavBtnUpdated) {
            songEntity.isFav = state.isFav; // Update the songEntity's isFav status
            return IconButton(
              icon: Icon(
                state.isFav
                    ? FontAwesomeIcons.solidHeart
                    : FontAwesomeIcons.heart,
                color: state.isFav ? Colors.red : Colors.grey,
              ),
              onPressed: () {
                context.read<FavBtnCubit>().updateFavBtn(songEntity.id);
              },
            );
          }

          // Default return for any other state
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
