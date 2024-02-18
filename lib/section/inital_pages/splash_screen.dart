import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utility/logo.dart';
import 'main_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        animationDuration: const Duration(milliseconds: 60),
        splashTransition: SplashTransition.fadeTransition,
        splashIconSize: 400,
        splash: const Logo(height: 250, width: 350, fontSize: 25),
        nextScreen:  const MainPage(),);
  }
}

