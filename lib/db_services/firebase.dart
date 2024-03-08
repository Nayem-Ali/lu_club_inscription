import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lu_club_inscription/section/functionality/admin/adminDashboard.dart';
import 'package:lu_club_inscription/utility/reusable_widgets.dart';
import '../section/user_authentication/login_screen.dart';

class FireStoreService {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  registerUser(
      String email, String password, String name, BuildContext context) async {
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
                      Navigator.pop(context);
                    },
                    child: const Text("OK")),
              ],
            );
          },
        );
      });
      await addAdminInfo(userInfo.user!.uid, name);
    });
  }

  loginUser(String email, String password, BuildContext context) async {
    try {
      await auth
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) async {
        if (value.user!.emailVerified) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const AdminDashboard(),
            ),
            ModalRoute.withName('/'),
          );
        } else {
          await value.user?.sendEmailVerification().whenComplete(() {
            return showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Email verification message is sent"),
                  content: Text(
                      "To login with your account please verify your email $email first."),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("OK")),
                  ],
                );
              },
            );
          });
        }
      });
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(
          msg: "${e.message}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  logoutUser(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Do you want to logout"),
          actions: [
            TextButton(
                onPressed: () async {
                  FirebaseAuth auth = FirebaseAuth.instance;
                  await auth.signOut().whenComplete(() {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      ModalRoute.withName('/'),
                    );
                  });
                },
                child: const Text("Yes")),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("No")),
          ],
        );
      },
    );
  }

  getUserData() async {
    dynamic userInfo = {};
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid;
    await fireStore
        .collection("user")
        .doc(uid)
        .get()
        .then((value) => {userInfo = value.data()});
    return userInfo;
  }

  addAdminInfo(String uid, String name) async {
    await fireStore.collection("admin").doc(uid).set({
      "uid": uid,
      "name": name,
      "admin": true,
      "hasClub": false,
      "clubAcronym": ""
    });
  }

  addClubInfo(Map<String, String> info) async {
    await fireStore.collection("clubs").doc(info['clubAcronym']).set(info);
    await fireStore
        .collection("admin")
        .doc(auth.currentUser!.uid)
        .update({"hasClub": true, "clubAcronym": info["clubAcronym"]});
  }

  dynamic clubAcronym() async {
    dynamic clubID;
    await fireStore
        .collection("admin")
        .doc(auth.currentUser!.uid)
        .get()
        .then((value) async {
      clubID = await value["clubAcronym"];
    });
    // print(clubID);
    return clubID;
  }

  updateClubInfo(dynamic info) async {
    await fireStore.collection("clubs").doc(info['clubAcronym']).update(info);
  }

  getClubData(dynamic clubAcronym) async {
    dynamic clubData = {};
    fireStore = FirebaseFirestore.instance;
    auth = FirebaseAuth.instance;
    //String uid = auth.currentUser!.uid;
    await fireStore
        .collection("clubs")
        .doc(clubAcronym)
        .get()
        .then((value) => {clubData = value.data()});
    // print(clubData);
    // print(uid);
    return clubData;
  }

  updatePhoto(
      File image, String location, String urlName, String fileName) async {
    var destination = location;
    String url;
    final ref = firebase_storage.FirebaseStorage.instance
        .ref(destination)
        .child('images/$fileName');
    await ref.putFile(image);
    url = await ref.getDownloadURL();
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    await fireStore.collection('clubs').doc(location).update({fileName: url});
  }

  Future uploadFile(List<File> images, String location) async {
    var destination = location;
    Map<String, dynamic> urls = {};
    try {
      final ref1 = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('images/logo');

      final ref2 = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('images/advisor');

      final ref3 = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('images/coAdvisor1');

      await ref1.putFile(images[0]);
      urls['logoUrl'] = await ref1.getDownloadURL();
      await ref2.putFile(images[1]);
      urls['advisorUrl'] = await ref2.getDownloadURL();
      await ref3.putFile(images[2]);
      urls['coAdvisorUrl1'] = await ref3.getDownloadURL();

      if (images.length == 6) {
        final ref4 = firebase_storage.FirebaseStorage.instance
            .ref(destination)
            .child('images/coAdvisor2');
        final ref5 = firebase_storage.FirebaseStorage.instance
            .ref(destination)
            .child('images/president');
        final ref6 = firebase_storage.FirebaseStorage.instance
            .ref(destination)
            .child('images/secretary');
        await ref4.putFile(images[3]);
        urls['coAdvisorUrl2'] = await ref4.getDownloadURL();
        await ref5.putFile(images[4]);
        urls['presidentUrl'] = await ref5.getDownloadURL();
        await ref6.putFile(images[5]);
        urls['secretaryUrl'] = await ref6.getDownloadURL();
      } else {
        final ref4 = firebase_storage.FirebaseStorage.instance
            .ref(destination)
            .child('images/president');
        final ref5 = firebase_storage.FirebaseStorage.instance
            .ref(destination)
            .child('images/secretary');
        await ref4.putFile(images[3]);
        urls['presidentUrl'] = await ref4.getDownloadURL();
        await ref5.putFile(images[4]);
        urls['secretaryUrl'] = await ref5.getDownloadURL();
      }
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      await firestore.collection('clubs').doc(location).update(urls);
    } catch (e) {
      showToast(e.toString());
    }
  }

  getAdminData() async {
    dynamic adminData = {};
    fireStore = FirebaseFirestore.instance;
    auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid;
    await fireStore
        .collection("admin")
        .doc(uid)
        .get()
        .then((value) => {adminData = value.data()});
    // print(adminData);
    // print(uid);
    return adminData;
  }

  addEvent(
      List<TextEditingController> eventName,
      List<TextEditingController> eventDescription,
      List<TextEditingController> payments,
      List<TextEditingController> fees,
      List<TextEditingController> receiverName) async {
    dynamic clubID = await clubAcronym();
    // print(clubID);
    for (int i = 0; i < eventName.length; i++) {
      await fireStore
          .collection("clubs")
          .doc(clubID)
          .collection("allEvents")
          .doc(eventName[i].text.trim())
          .set({
        "eventName": eventName[i].text.trim(),
        "eventDescription": eventDescription[i].text.trim(),
        "eventHandler": receiverName[i].text.trim(),
        "paymentNumber": payments[i].text.trim(),
        "fees": fees[i].text.trim(),
      });
    }
  }

  getEvents() async {
    dynamic clubID = await clubAcronym();
    //print(clubID);
    dynamic events = [];
    QuerySnapshot querySnapshot = await fireStore
        .collection("clubs")
        .doc(clubID)
        .collection("allEvents")
        .get();

    // Get data from docs and convert map to List
    // project1=
    events = querySnapshot.docs.map((doc) => doc.data()).toList();
    return events;
  }

  updateEvent(dynamic data) async {
    dynamic clubID = await clubAcronym();
    await fireStore
        .collection("clubs")
        .doc(clubID)
        .collection("allEvents")
        .doc(data["eventName"])
        .update(data);
  }

  setEventRegistration(String clubAcronym, Map<String, dynamic> data) async {
    String uid = auth.currentUser!.uid;
    data['uid'] = uid;
    await fireStore
        .collection('clubs')
        .doc(clubAcronym)
        .collection("allEvents")
        .doc(data['eventName'])
        .collection("registration")
        .doc(uid)
        .set(data);
  }

  getEventRegistration(String clubAcronym, String eventName) async {
    dynamic data = [];
    try {
      QuerySnapshot querySnapshot = await fireStore
          .collection('clubs')
          .doc(clubAcronym)
          .collection("allEvents")
          .doc(eventName)
          .collection("registration")
          .get();
      data = querySnapshot.docs.map((doc) => doc.data()).toList();
      return data;
    } catch (e) {
      return [];
    }
  }

  memberEventRegistrationStatus(String clubAcronym, String eventName) async {
    Map<String, dynamic>? registrationData;
    String uid = auth.currentUser!.uid;
    try {
      await fireStore
          .collection('clubs')
          .doc(clubAcronym)
          .collection("allEvents")
          .doc(eventName)
          .collection("registration")
          .doc(uid)
          .get()
          .then(
            (value) => registrationData = value.data(),
          );
      return registrationData;
    } catch (e) {
      return {};
    }
  }

  addMemberRegistration(String clubAcronym, Map<String, dynamic> data) async {
    String uid = auth.currentUser!.uid;
    data['uid'] = uid;
    await fireStore
        .collection('clubs')
        .doc(clubAcronym)
        .collection("member")
        .doc(uid)
        .set(data);
  }

  getClubMember(String clubAcronym) async {
    dynamic data = [];
    try {
      QuerySnapshot querySnapshot = await fireStore
          .collection('clubs')
          .doc(clubAcronym)
          .collection("member")
          .get();
      data = querySnapshot.docs.map((doc) => doc.data()).toList();
      return data;
    } catch (e) {
      return [];
    }
  }

  getIndividualClubData(String clubAcronym) async {
    Map<String, dynamic>? clubData;
    String uid = auth.currentUser!.uid;
    try {
      await fireStore
          .collection('clubs')
          .doc(clubAcronym)
          .collection("member")
          .doc(uid)
          .get()
          .then(
            (value) => clubData = value.data(),
          );
      return clubData;
    } catch (e) {
      return {};
    }
  }

  updateMemberRegistrationStatus(
      String clubAcronym, String uid, String status, bool isApproved) async {
    await fireStore
        .collection('clubs')
        .doc(clubAcronym)
        .collection('member')
        .doc(uid)
        .update({"status": status, "isApproved":isApproved});
  }

  updateEventRegistrationStatus(
      String clubAcronym, String eventName, String uid, String s) async {
    await fireStore
        .collection('clubs')
        .doc(clubAcronym)
        .collection("allEvents")
        .doc(eventName)
        .collection("registration")
        .doc(uid)
        .update({'status': s});
  }

  getChats(String clubAcronym) async {
    List<Map<String, dynamic>>? allData = [];
    try {
      final querySnapshot = await fireStore
          .collection('clubs')
          .doc(clubAcronym)
          .collection('chats')
          .orderBy("TimeStamp", descending: false)
          .get();
      allData = querySnapshot.docs.map((doc) => doc.data()).toList();
      return allData;
    } catch (e) {
      return [];
    }
  }
}
