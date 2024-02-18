import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_club_inscription/section/functionality/admin/admin_register.dart';
import '../../utility/reusable_widgets.dart';
import '../user_authentication/login_screen.dart';
import 'admin/admin_login.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  popUpDialog() {
    return showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: const Text("Do you want to logout"),
        actions: [
          TextButton(onPressed: () async {
            FirebaseAuth auth = FirebaseAuth.instance;
            await auth.signOut().whenComplete(() {
              Get.offAll(()=> const LoginScreen());
            });
          }, child: const Text("Yes")),
          TextButton(onPressed: () {
            Navigator.pop(context);
          }, child: const Text("No")),
        ],
      );
    },);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              color: Colors.teal,
              child: Text(
                "LU Club\nInscription",
                style: GoogleFonts.lato(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 28,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              label: Text(
                "Home",
                style: txtStyle(15, FontWeight.w500),
              ),
              icon: const Icon(Icons.home),
            ),
            const Divider(
              color: Colors.teal,
            ),
            TextButton.icon(
              onPressed: () {
                Get.offAll(()=>const AdminLogin());
              },
              label: Text(
                "Admin Login",
                style: txtStyle(15, FontWeight.w500),
              ),
              icon: const Icon(Icons.admin_panel_settings),
            ),
            const Divider(
              color: Colors.teal,
            ),
            TextButton.icon(
              onPressed: popUpDialog,
              label: Text(
                "Logout",
                style: txtStyle(15, FontWeight.w500),
              ),
              icon: const Icon(Icons.exit_to_app),
            ),
            const Divider(
              color: Colors.teal,
            ),
            TextButton.icon(
              onPressed: () {},
              label: Text(
                "Setting",
                style: txtStyle(15, FontWeight.w500),
              ),
              icon: const Icon(Icons.settings),
            ),
            const Divider(
              color: Colors.teal,
            ),
          ],
        ),
      ),
    );
  }
}
