import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lu_club_inscription/section/user_authentication/login_screen.dart';
import '../../db_services/auth.dart';
import '../../utility/logo.dart';
import '../../utility/reusable_widgets.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController cellController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  bool isVisible = true;
  final formKey = GlobalKey<FormState>();
  final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@lus\.ac\.bd$');
  final phoneRegex = RegExp(r'^01[3-9][0-9]{8}$');
  final nameRegex = RegExp(r'^[a-zA-Z]+ [a-zA-Z]+( [a-zA-Z]+)?( [a-zA-Z]+)?$');

  final auth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: formKey,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Logo(
                      height: 120,
                      width: 120,
                      fontSize: 20,
                    ),
                    const Divider(),
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
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter your email";
                        } else if (!emailRegex.hasMatch(value)) {
                          return "Enter your academic email e.g cse_2012000000@lus.ac.bd";
                        }
                        return null;
                      },
                      decoration: textInputDecoration(
                        "Enter your academic email",
                        Icons.email,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: cellController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter cell number";
                        } else if (!phoneRegex.hasMatch(value)) {
                          return "Invalid Cell Number";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration: textInputDecoration(
                        "Enter your cell number",
                        Icons.phone,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: passController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          "Enter your password";
                        } else if (value.length < 6) {
                          return "Password length must be 6 character long";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              isVisible = !isVisible;
                            });
                          },
                          child: Icon(isVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                        hintText: "Enter your password",
                        prefixIcon: const Icon(Icons.password),
                      ),
                      obscureText: isVisible,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: confirmPassController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          "Re-enter your password";
                        } else if (value != passController.text.trim()) {
                          return "Password not matched";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              isVisible = !isVisible;
                            });
                          },
                          child: Icon(isVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                        hintText: "Re-enter your password",
                        prefixIcon: const Icon(Icons.password),
                      ),
                      obscureText: isVisible,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Password length must be 6 characters long",
                      style: txtStyle(16, FontWeight.w700),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          registerUser(
                              emailController.text.trim(),
                              passController.text.trim(),
                              nameController.text.trim(),
                              cellController.text.trim(),
                              context);
                        }
                      },
                      style: elevated(),
                      child: Text(
                        "Signup",
                        style: txtStyle(20, FontWeight.bold),
                      ),
                    ),
                    // const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: txtStyle(16, FontWeight.bold),
                        ),
                        TextButton(
                            onPressed: () {
                              Get.offAll(()=>const LoginScreen());
                            },
                            child: Text(
                              "Login",
                              style: txtStyle(16, FontWeight.bold),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
