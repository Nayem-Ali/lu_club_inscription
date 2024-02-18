import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_club_inscription/section/inital_pages/splash_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// To interact with flutter engine
  await Firebase.initializeApp(
    name: "LU club inscription",
    options: const FirebaseOptions(
      apiKey: "AIzaSyD4sgBjFmrUef6sLN7xFNP6W8OCM9yaVWw",
      appId: "1:978700481634:android:3b7c8e4e4a5a4a0894cd3b",
      messagingSenderId: "978700481634",
      projectId: "lu-club-inscription-6a507",
      storageBucket: "gs://lu-club-inscription-6a507.appspot.com/",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "LU Club Inscription",
      theme: ThemeData(
        useMaterial3: false,
        primarySwatch: Colors.teal,
       textTheme: GoogleFonts.aBeeZeeTextTheme()
      ),
      color: Colors.teal,

      home: const SplashScreen(),
    );
  }
}

