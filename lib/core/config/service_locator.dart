import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pixelplayapp/core/config/utils/appwrite_provider.dart';
import 'package:pixelplayapp/core/config/utils/hive_config.dart';
import 'package:pixelplayapp/data/model/song/wishlistSongs.dart';
import 'package:pixelplayapp/data/repo/auth/auth_repo_implementation.dart';
import 'package:pixelplayapp/data/repo/news/news_repo_impl.dart';
import 'package:pixelplayapp/data/repo/song/song_repo_implementation.dart';
import 'package:pixelplayapp/data/src/audio_player_service.dart';
import 'package:pixelplayapp/data/src/auth_firebase_service.dart';
import 'package:pixelplayapp/data/src/news_firebase_service.dart';
import 'package:pixelplayapp/data/src/songs_firebase_service.dart';
import 'package:pixelplayapp/data/src/wishlistSongsLocalStorage.dart';
import 'package:pixelplayapp/data/src/wishlist_sync_service.dart';
import 'package:pixelplayapp/domain/repo/auth_repo.dart';
import 'package:pixelplayapp/domain/repo/news_repo.dart';
import 'package:pixelplayapp/domain/repo/song_repo.dart';
import 'package:pixelplayapp/domain/usecase/auth/getuserData.dart';
import 'package:pixelplayapp/domain/usecase/auth/seamlessLogin.dart';
import 'package:pixelplayapp/domain/usecase/auth/signInGoogle.dart';
import 'package:pixelplayapp/domain/usecase/auth/signinUseCase.dart';
import 'package:pixelplayapp/domain/usecase/auth/signupUseCase.dart';
import 'package:pixelplayapp/domain/usecase/news/LikeUnlikeNewsUseCase.dart';
import 'package:pixelplayapp/domain/usecase/news/checkUserLikedNewsUseCase.dart';
import 'package:pixelplayapp/domain/usecase/news/getAllNewsUseCase.dart';
import 'package:pixelplayapp/domain/usecase/news/getNewsByIdUseCase.dart';
import 'package:pixelplayapp/domain/usecase/song/addRemoveFav.dart';
import 'package:pixelplayapp/domain/usecase/song/getFavSongs.dart';
import 'package:pixelplayapp/domain/usecase/song/getMusicById.dart';
import 'package:pixelplayapp/domain/usecase/song/getPlayListUseCase.dart';
import 'package:pixelplayapp/domain/usecase/song/getSongsbyGenre.dart';
import 'package:pixelplayapp/domain/usecase/song/isfavSong.dart';
import 'package:pixelplayapp/domain/usecase/song/searchSongUseCase.dart';
import 'package:pixelplayapp/domain/usecase/song/songuseCase.dart';
import 'package:pixelplayapp/presentation/page/Search/cubit/search_song_cubit.dart';
import 'package:pixelplayapp/presentation/page/music/bloc/cubit/get_music_by_id_cubit.dart';
import 'package:pixelplayapp/presentation/page/music/bloc/cubit/shuffle_music_cubit.dart';
import 'package:pixelplayapp/presentation/page/news/bloc/getNewsByIdCubit.dart';
import 'package:pixelplayapp/presentation/page/news/bloc/likeUnlikeNewsCubit.dart';
import 'package:pixelplayapp/presentation/page/root/bloc/getGenresCubit.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Register hive boxes
  sl.registerSingleton<Box<Wishlistsongs>>(HiveConfig.getWishlistBox());

  //Register WishListLocalStorage
  sl.registerSingleton<Wishlistsongslocalstorage>(
    WishlistsongslocalstorageImpl(
      wishlistBox: sl<Box<Wishlistsongs>>(),
    ),
  );

  // Register WishlistSyncService
  sl.registerLazySingleton<WishlistSyncService>(
    () => WishlistSyncService(
      localStorage: sl<Wishlistsongslocalstorage>(),
      firebaseService: sl<SongsFirebaseService>(),
      connectivity: sl<Connectivity>(),
    ),
  );

  sl.registerSingleton<Connectivity>(
    Connectivity(),
  );

  // Register Firebase services
  sl.registerSingleton<AuthFirebaseService>(
    AuthFirebaseServiceImplementation(),
  );
  sl.registerSingleton<SongsFirebaseService>(
    SongsFirebaseServiceImplementation(),
  );
  sl.registerSingleton<NewsFirebaseService>(
    NewsFirebaseServiceImpl(),
  );
  sl.registerSingleton<AuthRepo>(
    AuthRepoImplementation(),
  );
  sl.registerSingleton<SongRepo>(
    SongRepositoryImplementation(
      songsFirebaseService: sl<SongsFirebaseService>(),
      wishlistsongslocalstorage: sl<Wishlistsongslocalstorage>(),
    ),
  );
  sl.registerSingleton<NewsRepo>(
    NewsRepoImpl(),
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
  sl.registerSingleton<SignInWithGoogleUseCase>(
    SignInWithGoogleUseCase(),
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

  sl.registerSingleton<GetSongByIdUseCase>(
    GetSongByIdUseCase(sl<SongRepo>()),
  );
  sl.registerFactory<ShuffleMusicCubit>(
    () => ShuffleMusicCubit(
      sl<SongsFirebaseService>(),
      sl<AudioPlayerService>(),
    ),
  );
  sl.registerSingleton<AudioPlayerService>(
    AudioPlayerService(),
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

  sl.registerSingleton<GetAllNewsUseCase>(
    GetAllNewsUseCase(),
  );

  sl.registerSingleton<GetnewsbyIdUseCase>(
    GetnewsbyIdUseCase(sl<NewsRepo>()),
  );
  sl.registerFactory<GetnewsbyIDcubit>(
    () => GetnewsbyIDcubit(sl<GetnewsbyIdUseCase>()),
  );
  sl.registerSingleton<LikeUnlikeNewsUseCase>(
    LikeUnlikeNewsUseCase(sl<NewsRepo>()),
  );
  sl.registerSingleton<CheckUserLikedNewsUseCase>(
    CheckUserLikedNewsUseCase(sl<NewsRepo>()),
  );
  sl.registerFactory<Likeunlikenewscubit>(
    () => Likeunlikenewscubit(
        sl<LikeUnlikeNewsUseCase>(), sl<CheckUserLikedNewsUseCase>()),
  );
  sl.registerSingleton<SearchSongUseCase>(
    SearchSongUseCase(sl<SongRepo>()),
  );
  sl.registerSingleton<SearchSongCubit>(
    SearchSongCubit(sl<SearchSongUseCase>()),
  );
  sl.registerSingleton<GetSongsByGenreUseCase>(
    GetSongsByGenreUseCase(sl<SongRepo>()),
  );

  sl.registerSingleton<Getgenrescubit>(
    Getgenrescubit(sl<GetSongsByGenreUseCase>()),
  );
}
