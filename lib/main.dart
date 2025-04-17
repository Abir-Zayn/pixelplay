import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pixelplayapp/core/config/service_locator.dart';
import 'package:pixelplayapp/core/config/theme/apptheme.dart';
import 'package:pixelplayapp/core/config/utils/hive_config.dart';
import 'package:pixelplayapp/core/route/approuter.dart';
import 'package:pixelplayapp/firebase_options.dart';
import 'package:pixelplayapp/presentation/page/intro/bloc/theme_cubit.dart';
import 'package:pixelplayapp/presentation/page/root/bloc/new_song_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize JustAudio Background
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // sl<WishlistSyncService>().initialize();
  // Initialize Hive for local storage
  await HiveConfig.init();
  //

  await initializeDependencies();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );

  runApp(Main());
}

void _applySystemUISettings(BuildContext context, ThemeMode state) {
  final themeCubit = context.read<ThemeCubit>();
  final isDark = themeCubit.isDarkModeOn;

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
    systemNavigationBarColor: isDark ? Colors.black : Colors.white,
    systemNavigationBarIconBrightness:
        isDark ? Brightness.light : Brightness.dark,
  ));
}

class Main extends StatelessWidget {
  const Main({super.key});

  //Used for adaptive System appbar design as most of the appbar
  // doesn't have a color thats matched with the system appbar
  @override
  Widget build(BuildContext context) {
    //!Refactorized the code and moved into the _applySystemUISettings method

    // Determine the screen size
    Size screensize = MediaQuery.of(context).size;

    // Manage the Screen theme (light/dark)
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => NewSongCubit()),
      ],

      /*** 
        Initialize the ScreenUtil package for responsive design
        minTextAdapt: true, => Enable minimum text adaptation
        using the InheritedMediaQuery to ensure the mediaquery is inherited
        SplitScreenMode: false, => Disable split screen mode for better performance

      ***/
      child: ScreenUtilInit(
        designSize: screensize,
        minTextAdapt: true,
        splitScreenMode: false,
        useInheritedMediaQuery: true,
        builder: (_, Widget? child) {
          // Using BlocBuilder to listen and build state when the theme changes
          // approuter has the routes and the logic for the app navigation
          return BlocBuilder<ThemeCubit, ThemeMode>(builder: (context, state) {
            _applySystemUISettings(context, state);
            return MaterialApp.router(
              routerConfig: appRouter,
              theme: Apptheme.lightTheme,
              darkTheme: Apptheme.darkTheme,
              themeMode: state,
              debugShowCheckedModeBanner: false,
            );
          });
        },
      ),
    );
  }
}
