import 'package:flutter/material.dart';
import 'package:lu_club_inscription/section/functionality/admin/admin_register.dart';
import 'package:lu_club_inscription/services/firebase.dart';

import '../../../utility/logo.dart';
import '../../../utility/reusable_widgets.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({Key? key}) : super(key: key);

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  FireStoreService fireStoreService = FireStoreService();
  TextEditingController adminEmail = TextEditingController();
  TextEditingController adminPassword = TextEditingController();
  TextEditingController adminConfirmPassword = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const Logo(height: 150, width: 150, fontSize: 21),
                const SizedBox(height: 12),
                TextFormField(
                  controller: adminEmail,
                  decoration: textInputDecoration(
                    "Enter your official club email",
                    Icons.email,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: adminPassword,
                  decoration: textInputDecoration(
                    "Enter your password",
                    Icons.password,
                  ),
                ),

                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    fireStoreService.loginUser(
                        adminEmail.text.trim(), adminPassword.text.trim(), context);
                  },
                  style: elevated(),
                  child: Text(
                    "Login",
                    style: txtStyle(20, FontWeight.bold),
                  ),
                ),
                //const SizedBox(height: 12),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (context) => const AdminRegister()));
                    },
                    child: Text(
                      "Register as Admin",
                      style: txtStyle(18, FontWeight.bold),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
