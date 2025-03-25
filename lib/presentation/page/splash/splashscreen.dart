import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pixelplayapp/core/config/service_locator.dart';
import 'package:pixelplayapp/core/config/src/appvectors.dart';
import 'package:pixelplayapp/domain/usecase/auth/seamlessLogin.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      redirect(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(Appvectors.applogoBasepath),
      ),
    );
  }

  Future<void> redirect(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));

    try {
      User? user = await sl<SeamlessLogin>().call();
      if (user != null) {
        if (mounted) context.go('/home');
      } else {
        if (mounted) context.push('/getstarted');
      }
    } catch (e) {
      // Error during authentication, go to get started
      if (mounted) {
        context.go('/getstarted');
      }
    }
  }
}
