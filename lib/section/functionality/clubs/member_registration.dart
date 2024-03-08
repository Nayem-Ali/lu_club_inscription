import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:lu_club_inscription/section/functionality/chats/chat_page.dart';
import 'package:lu_club_inscription/utility/reusable_widgets.dart';

import '../../../db_services/firebase.dart';


class MemberRegistration extends StatefulWidget {
  final String clubAcronym;

  const MemberRegistration({Key? key, required this.clubAcronym}) : super(key: key);

  @override
  State<MemberRegistration> createState() => _MemberRegistrationState();
}

class _MemberRegistrationState extends State<MemberRegistration> {
  FireStoreService fireStoreService = FireStoreService();
  Map<String, dynamic> userInfo = {};
  Map<String, dynamic> myClubData = {};
  dynamic clubData = {};
  TextEditingController name = TextEditingController();
  TextEditingController id = TextEditingController();
  TextEditingController dept = TextEditingController();
  TextEditingController batch = TextEditingController();
  TextEditingController section = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController tid = TextEditingController();

  final formKey = GlobalKey<FormState>();

  fetchUserData() async {
    userInfo = await fireStoreService.getUserData();
    name.text = userInfo['name'];
    dept.text = userInfo['department'];
    batch.text = userInfo['batch'];
    section.text = userInfo['section'];
    phone.text = userInfo['cell'];
    id.text = userInfo['id'];
    email.text = FirebaseAuth.instance.currentUser!.email!;
    myClubData = await fireStoreService.getIndividualClubData(widget.clubAcronym) ?? {};
    clubData = await fireStoreService.getClubData(widget.clubAcronym);
    setState(() {});
  }

  addRegistration() async {
    Map<String, dynamic> data = {
      "name": name.text.trim(),
      "id": id.text.trim(),
      "section": section.text.trim(),
      "batch": batch.text.trim(),
      "cell": phone.text.trim(),
      "dept": dept.text.trim(),
      "amount": amount.text.trim(),
      "tid": tid.text.trim(),
      "email": email.text.trim(),
      "status": 'pending',
      "img": userInfo['img'],
      "uid": "",
      "isApproved": false,
    };
    if (formKey.currentState!.validate()) {
      await fireStoreService.addMemberRegistration(widget.clubAcronym, data);
    }
    await fetchUserData();
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchUserData();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("General Member Registration"),
        //title: myClubData['status'] == "approved" && clubData['clubAcronym']!=null? Text(clubData['clubAcronym']):const Text("General Member Registration"),
        centerTitle: true,
      ),
      body: myClubData.isEmpty
          ? Container(
              margin: const EdgeInsets.all(10),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: name,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.teal,
                        ),
                        hintText: "Name",
                      ),
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return "Fill with info";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: email,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.teal,
                        ),
                        hintText: "Email",
                      ),
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return "Fill with info";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: phone,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.phone,
                          color: Colors.teal,
                        ),
                        hintText: "Phone",
                      ),
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return "Fill with info";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: dept,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.business_sharp,
                                color: Colors.teal,
                              ),
                              hintText: "Department",
                            ),
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return "Fill with info";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: batch,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.batch_prediction,
                                color: Colors.teal,
                              ),
                              hintText: "Batch",
                            ),
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return "Fill with info";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: section,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.groups,
                                color: Colors.teal,
                              ),
                              hintText: "Section",
                            ),
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return "Fill with info";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: id,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.numbers,
                                color: Colors.teal,
                              ),
                              hintText: "Student ID",
                            ),
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return "Fill with info";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: amount,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.attach_money,
                                color: Colors.teal,
                              ),
                              hintText: "Amount",
                              helperText: "Optional",
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: tid,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.password_rounded,
                                color: Colors.teal,
                              ),
                              hintText: "Name / Transaction ID",
                              helperText: "Optional",
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: addRegistration,
                      style: elevated(),
                      child: const Text("Register"),
                    ),
                  ],
                ),
              ),
            )
          // : myClubData['status'] == "approved"
          //     ? ChatPage(clubAcronym: Get.arguments)
              : Center(
                  child: Text(
                    "Your registration status: ${myClubData['status']}".toUpperCase(),
                    style: txtStyle(16, FontWeight.bold),
                  ),
                ),
    );
  }
}
