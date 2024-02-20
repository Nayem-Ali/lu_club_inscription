import 'package:flutter/material.dart';
import 'package:lu_club_inscription/section/functionality/admin/admin_login.dart';
import 'package:lu_club_inscription/servcies/firebase.dart';
import 'package:lu_club_inscription/utility/logo.dart';

import '../../../utility/reusable_widgets.dart';

class AdminRegister extends StatefulWidget {
  const AdminRegister({Key? key}) : super(key: key);

  @override
  State<AdminRegister> createState() => _AdminRegisterState();
}

class _AdminRegisterState extends State<AdminRegister> {
  FireStoreService fireStoreService = FireStoreService();
  TextEditingController nameController = TextEditingController();
  TextEditingController adminEmail = TextEditingController();
  TextEditingController adminPassword = TextEditingController();
  TextEditingController adminConfirmPassword = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final emailRegex = RegExp(r'^(crystalizedmeteorite@gmail\.com)$');
  final nameRegex = RegExp(r'^[a-zA-Z]+ [a-zA-Z]+( [a-zA-Z]+)?( [a-zA-Z]+)?$');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const Logo(height: 150, width: 150, fontSize: 21),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: nameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter your name!";
                      } else if (!nameRegex.hasMatch(value)) {
                        return "Only Character and White Space is Allowed";
                      }
                      return null;
                    },
                    decoration: textInputDecoration(
                      "Enter your full name",
                      Icons.person,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: adminEmail,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter your email";
                      } else if (!emailRegex.hasMatch(value)) {
                        return "Enter your club official email";
                      }
                      return null;
                    },
                    decoration: textInputDecoration(
                      "Enter your official club email",
                      Icons.email,
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: adminPassword,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter your password";
                      } else if (value.length < 6) {
                        return "Password length is less than 6.";
                      }
                      return null;
                    },
                    decoration: textInputDecoration(
                      "Enter your password",
                      Icons.password,
                    ),
                  ),

                  const SizedBox(height: 12),
                  TextFormField(
                    controller: adminConfirmPassword,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter your password";
                      } else if (value != adminPassword.text.trim()) {
                        return "Password not matched.";
                      }
                      return null;
                    },
                    decoration: textInputDecoration(
                      "Re-enter your password",
                      Icons.password,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text("Password must be 6 characters long"),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        fireStoreService.registerUser(
                          adminEmail.text.trim(),
                          adminPassword.text.trim(),
                          nameController.text.trim(),
                          context,
                        );
                      }
                    },
                    style: elevated(),
                    child: Text(
                      "Register",
                      style: txtStyle(20, FontWeight.bold),
                    ),
                  ),
                  //const SizedBox(height: 12),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) => const AdminLogin()));
                      },
                      child: Text(
                        "Login as Admin",
                        style: txtStyle(18, FontWeight.bold),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
