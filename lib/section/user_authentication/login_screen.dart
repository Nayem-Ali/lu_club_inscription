import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lu_club_inscription/section/functionality/admin/admin_login.dart';
import 'package:lu_club_inscription/section/functionality/clubs/navigator_screen.dart';
import 'package:lu_club_inscription/section/user_authentication/reset_pass_screen.dart';
import 'package:lu_club_inscription/section/user_authentication/signup_screen.dart';
import 'package:lu_club_inscription/servcies/auth.dart';
import 'package:lu_club_inscription/utility/reusable_widgets.dart';

import '../../utility/logo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  //var reusableWidgets = ReusableWidgets();
  bool isVisible = true;

  login() async {
    String flag = await loginUser(emailController.text.trim(), passController.text.trim());
    if (flag == "true") {
      Get.offAll(() => const NavigatorScreen());
    } else {
      Get.snackbar(
        "Something went wrong",
        flag,
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.red
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Logo(
                      height: 150,
                      width: 150,
                      fontSize: 25,
                    ),
                    const Divider(),
                    TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value!.isEmpty) {}
                        return null;
                      },
                      decoration: textInputDecoration(
                        "Enter your email",
                        Icons.email,
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
                          child: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
                        ),
                        hintText: "Enter your password",
                        prefixIcon: const Icon(Icons.password),
                      ),
                      obscureText: isVisible,
                    ),
                    // const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Get.to(() => const ResetPasswordScreen());
                      },
                      child: Text(
                        "Forget Password?",
                        style: txtStyle(14, FontWeight.w600),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: login,
                      style: elevated(),
                      child: Text(
                        "Login",
                        style: txtStyle(20, FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Did not have an account?",
                          style: txtStyle(16, FontWeight.bold),
                        ),
                        const SizedBox(width: 5),
                        TextButton(
                            onPressed: () {
                              Get.off(() => const SignupScreen());
                            },
                            child: Text(
                              "Signup",
                              style: txtStyle(16, FontWeight.bold),
                            ))
                      ],
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Get.offAll(() => const AdminLogin());
                      },
                      icon: const Icon(Icons.admin_panel_settings),
                      label: Text(
                        "Login as Admin",
                        style: txtStyle(20, FontWeight.bold),
                      ),
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
