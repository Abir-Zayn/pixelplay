import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pixelplayapp/presentation/page/authentication/authchoice.dart';
import 'package:pixelplayapp/presentation/page/authentication/signinPage.dart';
import 'package:pixelplayapp/presentation/page/authentication/signupPage.dart';
import 'package:pixelplayapp/presentation/page/intro/pages/choosetheme.dart';
import 'package:pixelplayapp/presentation/page/intro/pages/getstarted.dart';
import 'package:pixelplayapp/presentation/page/music/pages/music_player.dart';
import 'package:pixelplayapp/presentation/page/profile/screen/profilePage.dart';
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
          path: '/choosetheme',
          builder: (context, state) => const Choosetheme()),
      GoRoute(
          path: '/authChoice', builder: (context, state) => const Authchoice()),
      GoRoute(path: '/signin', builder: (context, state) => const Signinpage()),
      GoRoute(path: '/signup', builder: (context, state) => const SignupPage()),
      GoRoute(path: '/home', builder: (context, state) => const Rootpage()),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const Profilepage(),
      ),
      GoRoute(
        path: '/musicplayer/:songId',
        builder: (context, state) {
          final songId = state.pathParameters['songId']!;
          return MusicPlayer(songId: songId);
        },
      ),
    ]);
GoRouter get appRouter => _router;
