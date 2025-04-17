import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pixelplayapp/presentation/page/Search/Screen/SearchPageScreen.dart';
import 'package:pixelplayapp/presentation/page/authentication/authchoice.dart';
import 'package:pixelplayapp/presentation/page/authentication/signinPage.dart';
import 'package:pixelplayapp/presentation/page/authentication/signupPage.dart';
import 'package:pixelplayapp/presentation/page/intro/pages/choosetheme.dart';
import 'package:pixelplayapp/presentation/page/intro/pages/getstarted.dart';
import 'package:pixelplayapp/presentation/page/music/pages/equalizer_page.dart';
import 'package:pixelplayapp/presentation/page/music/pages/music_player.dart';
import 'package:pixelplayapp/presentation/page/news/screen/news_page.dart';
import 'package:pixelplayapp/presentation/page/profile/screen/profilePage.dart';
import 'package:pixelplayapp/presentation/page/root/pages/entrypoint.dart';
import 'package:pixelplayapp/presentation/page/root/pages/rootpage.dart';
import 'package:pixelplayapp/presentation/page/splash/splashscreen.dart';

final GlobalKey<NavigatorState> appRouterKey = GlobalKey<NavigatorState>();
final GoRouter _router = GoRouter(
    navigatorKey: appRouterKey,
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (context, state) => const Splashscreen(),
      ),
      GoRoute(
          path: '/getstarted', builder: (context, state) => const Getstarted()),
      GoRoute(
          path: '/entrypoint', builder: (context, state) => const Entrypoint()),
      GoRoute(
          path: '/choosetheme',
          builder: (context, state) => const Choosetheme()),
      GoRoute(
          path: '/authChoice', builder: (context, state) => const Authchoice()),
      GoRoute(path: '/signin', builder: (context, state) => const Signinpage()),
      GoRoute(path: '/signup', builder: (context, state) => const SignupPage()),
      GoRoute(path: '/home', builder: (context, state) => const Rootpage()),
      GoRoute(
        path: '/profile',
        builder: (context, state) => Profilepage(),
      ),
      GoRoute(
        path: '/musicplayer/:songId',
        builder: (context, state) {
          final songId = state.pathParameters['songId']!;
          return MusicPlayer(songId: songId);
        },
      ),
      GoRoute(
        path: '/newspage/:newsId',
        builder: (context, state) {
          final newsId = state.pathParameters['newsId']!;
          return NewsPage(newsId: newsId);
        },
      ),
      GoRoute(
          path: '/equalizer',
          builder: (context, state) {
            return EqualizerPage();
          }),
      GoRoute(
          path: '/searchPage',
          builder: (context, state) => const Searchpagescreen()),
    ]);
GoRouter get appRouter => _router;
