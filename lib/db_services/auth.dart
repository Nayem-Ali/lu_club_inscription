import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


FirebaseFirestore fireStore = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

addUserInfo(String uid, String name, String cell) async {
  await fireStore.collection("user").doc(uid).set({
    "uid": uid,
    "name": name,
    "id": "",
    "department": "",
    "batch": "",
    "section": "",
    "dob": "",
    "gender": "",
    "cell": cell,
    "admin": false,
    "img": "",
  });
}

registerUser(String email, String password, String name, String cell,
    BuildContext context) async {
  auth
      .createUserWithEmailAndPassword(email: email, password: password)
      .then((userInfo) async {
    await userInfo.user?.sendEmailVerification().whenComplete(() {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Email verification message is sent"),
            content: Text(
                "To login with your account please verify your email ${userInfo.user!.email} first."),
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
    });
    await addUserInfo(userInfo.user!.uid, name, cell);
  });
}

Future<String> loginUser(String email, String password) async {
  String message = "";
  try {
    await auth
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) async {
      if (value.user!.emailVerified) {
        message = "true";
        return message;
      } else {
        await value.user?.sendEmailVerification().whenComplete(() {});

        message = "Verification email sent $email";
        return message;
      }
    });
  } on FirebaseException catch (e) {
    message = e.message!;
  }
  return message;
}
