import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../utility/reusable_widgets.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  resetPassword() async {
    await auth.sendPasswordResetEmail(email: emailController.text.trim()).whenComplete(() {
      popUpDialog();
    });
  }

  popUpDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("{Password reset message is sent"),
          content: Text(
              "To reset password open your email ${emailController.text}"),
          actions: [
            TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text("OK")),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Reset Password",
              style: txtStyle(32, FontWeight.bold),
            ),
            const SizedBox(height: 12,),
            Text(
              "Enter your email and tap send email button to get a password recovery email.",
              style: txtStyle(20, FontWeight.bold,), textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12,),
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
            ElevatedButton(
              onPressed: resetPassword,
              style: elevated(),
              child: Text(
                "Send Email",
                style: txtStyle(20, FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
