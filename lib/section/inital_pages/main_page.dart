import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lu_club_inscription/section/functionality/navigator_screen.dart';
import 'package:lu_club_inscription/section/user_authentication/login_screen.dart';


class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return  StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.emailVerified) {

          return const NavigatorScreen();
        } else {

          return const LoginScreen();
        }
      },
    );
  }
}
