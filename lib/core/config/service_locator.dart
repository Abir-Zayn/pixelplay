import 'package:get_it/get_it.dart';
import 'package:pixelplayapp/core/config/utils/appwrite_provider.dart';
import 'package:pixelplayapp/data/repo/auth/auth_repo_implementation.dart';
import 'package:pixelplayapp/data/repo/song/song_repo_implementation.dart';
import 'package:pixelplayapp/data/src/audio_player_service.dart';
import 'package:pixelplayapp/data/src/auth_firebase_service.dart';
import 'package:pixelplayapp/data/src/songs_firebase_service.dart';
import 'package:pixelplayapp/domain/repo/auth_repo.dart';
import 'package:pixelplayapp/domain/repo/song_repo.dart';
import 'package:pixelplayapp/domain/usecase/auth/getuserData.dart';
import 'package:pixelplayapp/domain/usecase/auth/seamlessLogin.dart';
import 'package:pixelplayapp/domain/usecase/auth/signinUseCase.dart';
import 'package:pixelplayapp/domain/usecase/auth/signupUseCase.dart';
import 'package:pixelplayapp/domain/usecase/song/addRemoveFav.dart';
import 'package:pixelplayapp/domain/usecase/song/getFavSongs.dart';
import 'package:pixelplayapp/domain/usecase/song/getMusicById.dart';
import 'package:pixelplayapp/domain/usecase/song/getPlayListUseCase.dart';
import 'package:pixelplayapp/domain/usecase/song/isfavSong.dart';
import 'package:pixelplayapp/domain/usecase/song/songuseCase.dart';
import 'package:pixelplayapp/presentation/page/music/bloc/cubit/get_music_by_id_cubit.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Register Firebase services
  sl.registerSingleton<AuthFirebaseService>(
    AuthFirebaseServiceImplementation(),
  );
  sl.registerSingleton<SongsFirebaseService>(
    SongsFirebaseServiceImplementation(),
  );
  sl.registerSingleton<AuthRepo>(
    AuthRepoImplementation(),
  );
  sl.registerSingleton<SongRepo>(
    SongRepositoryImplementation(),
  );
  sl.registerSingleton<Signupusecase>(
    Signupusecase(),
  );
  sl.registerSingleton<Signinusecase>(
    Signinusecase(),
  );
  sl.registerSingleton<SeamlessLogin>(
    SeamlessLogin(),
  );
  sl.registerSingleton<GetuserdataUseCase>(
    GetuserdataUseCase(),
  );
  sl.registerSingleton<AppwriteProvider>(
    AppwriteProvider(),
  );
  sl.registerSingleton<GetNewSongUseCase>(
    GetNewSongUseCase(),
  );

  sl.registerSingleton<Getplaylistusecase>(
    Getplaylistusecase(),
  );
  sl.registerSingleton<AudioPlayerService>(
    AudioPlayerService(),
  );
  sl.registerSingleton<GetSongByIdUseCase>(
    GetSongByIdUseCase(sl<SongRepo>()),
  );
  sl.registerSingleton<AddremovefavSongUseCase>(
    AddremovefavSongUseCase(),
  );
  sl.registerSingleton<IsfavsongUseCase>(IsfavsongUseCase());
  // Register Cubit
  sl.registerFactory<GetMusicByIdCubit>(
    () => GetMusicByIdCubit(sl<GetSongByIdUseCase>()),
  );
  sl.registerSingleton<GetfavsongsUseCases>(
    GetfavsongsUseCases(),
  );
}
