import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lu_club_inscription/section/functionality/clubs/updateInfoScreen.dart';
import 'package:lu_club_inscription/utility/reusable_widgets.dart';

import '../../../servcies/firebase.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FireStoreService fireStoreService = FireStoreService();
  dynamic userInfo = {};
  final ImagePicker _picker = ImagePicker();
  late File image;
  FirebaseAuth auth = FirebaseAuth.instance;
  String imageUrl = "";

  @override
  void initState() {
    // TODO: implement initState
    fetchUserData();
    super.initState();
  }

  fetchUserData() async {
    userInfo = await fireStoreService.getUserData();
    imageUrl = userInfo['img'];
    setState(() {});
  }

  Future uploadFile() async {
    var destination = 'files/${auth.currentUser!.uid}';

    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref(destination).child('file/');
      await ref.putFile(image);
      String tempUrl = await ref.getDownloadURL();
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      FirebaseAuth auth = FirebaseAuth.instance;
      await firestore.collection("user").doc(auth.currentUser!.uid).update({"img": tempUrl});

      fetchUserData();
    } catch (e) {
      print('error occured');
    }
  }

  updateDialog() {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) {
        return const UpdateInfoScreen();
      },
    );
  }

  Future selectPhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source, imageQuality: 50);

    if (pickedFile == null) {
      return;
    }

    var file = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
    );
    if (file == null) {
      return;
    } else {
      image = File(file.path);
    }
    await uploadFile();
  }

  profilePicture() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        var screenSize = MediaQuery.of(context).size;
        return SizedBox(
          width: screenSize.width,
          height: screenSize.height * .1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: () {
                  Get.back();
                  selectPhoto(ImageSource.gallery);
                },
                label: const Text("Gallery"),
                icon: const Icon(Icons.image),
              ),
              TextButton.icon(
                onPressed: () {
                  Get.back();
                  selectPhoto(ImageSource.camera);
                },
                label: const Text("Camera"),
                icon: const Icon(Icons.camera_alt),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                imageUrl != ""
                    ? CircleAvatar(radius: 80, backgroundImage: NetworkImage(imageUrl))
                    : const CircleAvatar(
                        radius: 80,
                        child: Icon(
                          Icons.person,
                          size: 100,
                        ),
                      ),
                OutlinedButton.icon(
                  onPressed: profilePicture,
                  label: Text(
                    "Change Profile Picture",
                    style: txtStyle(18, FontWeight.w500),
                  ),
                  icon: const Icon(Icons.change_circle_outlined),
                ),
                const Divider(
                  color: Colors.teal,
                  thickness: 6,
                  height: 50,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Name: ${userInfo['name']}",
                      style: txtStyle(20, FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      "Student ID: ${userInfo['id']}",
                      style: txtStyle(20, FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      "Department: ${userInfo['department']}",
                      style: txtStyle(20, FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      "Batch: ${userInfo['batch']}",
                      style: txtStyle(20, FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      "Section: ${userInfo['section']}",
                      style: txtStyle(20, FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      "Date of Birth: ${userInfo['dob']}",
                      style: txtStyle(20, FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      "Gender: ${userInfo['gender']}",
                      style: txtStyle(20, FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      "Phone: ${userInfo['cell']}",
                      style: txtStyle(20, FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                OutlinedButton.icon(
                  onPressed: updateDialog,
                  label: Text(
                    "Update Information",
                    style: txtStyle(20, FontWeight.w500),
                  ),
                  icon: const Icon(Icons.update),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
