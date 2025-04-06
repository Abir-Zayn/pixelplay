import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pixelplayapp/common/widgets/appstyle.dart';
import 'package:pixelplayapp/common/widgets/apptext.dart';
import 'package:pixelplayapp/core/config/service_locator.dart';
import 'package:pixelplayapp/core/config/theme/appColors.dart';
import 'package:pixelplayapp/domain/usecase/song/getSongsbyGenre.dart';
import 'package:pixelplayapp/presentation/page/root/bloc/getGenresCubit.dart';
import 'package:pixelplayapp/presentation/page/root/widgets/genreResult.dart';
import 'dart:math';

class GenreScreen extends StatelessWidget {
  const GenreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const GenreContent(),
    );
  }
}

class GenreContent extends StatelessWidget {
  const GenreContent({super.key});

  @override
  Widget build(BuildContext context) {
    final genres = [
      'Pop',
      'Rock',
      'Hip Hop',
      'R&B',
      'Romantic',
      'Classical',
      'Western',
      'Country',
      'Reggae',
    ];

    return Padding(
      padding: EdgeInsets.only(top: 30.h),
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 20,
        ),
        itemCount: genres.length,
        itemBuilder: (context, index) {
          return GenreCard(
            genre: genres[index],
            onTap: () => _navigateToGenreSongs(context, genres[index]),
          );
        },
      ),
    );
  }

  void _navigateToGenreSongs(BuildContext context, String genre) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => Getgenrescubit(sl<GetSongsByGenreUseCase>()),
          child: GenreSongsScreen(genre: genre),
        ),
      ),
    );
  }
}

class GenreCard extends StatelessWidget {
  final String genre;
  final VoidCallback onTap;

  const GenreCard({
    super.key,
    required this.genre,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final color = Colors.primaries[random.nextInt(Colors.primaries.length)];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.7), color.withOpacity(0.4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: AppTextstyle(
            text: genre,
            style: appStyle(
              size: 20,
              color: Theme.of(context).brightness == Brightness.light
                  ? AppColors.lightBackgroundColor
                  : AppColors.darkBackgroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
