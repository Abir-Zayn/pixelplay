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
import 'package:pixelplayapp/core/route/approuter.dart';
import 'package:pixelplayapp/firebase_options.dart';
import 'package:pixelplayapp/presentation/page/intro/bloc/theme_cubit.dart';
import 'package:pixelplayapp/presentation/page/root/bloc/new_song_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDependencies();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );

  runApp(Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    //Some of system settings mainly responsible for the top app bar
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white, // Set the color of the status bar
      statusBarIconBrightness: Brightness.dark, // For Android: use dark icons
      statusBarBrightness: Brightness.light, // For iOS: use light icons
    ));
    Size screensize = MediaQuery.of(context).size;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => NewSongCubit()),
      ],
      child: ScreenUtilInit(
        designSize: screensize,
        minTextAdapt: true,
        splitScreenMode: false,
        useInheritedMediaQuery: true,
        builder: (_, Widget? child) {
          return BlocBuilder<ThemeCubit, ThemeMode>(builder: (context, state) {
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
