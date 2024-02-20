import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lu_club_inscription/section/functionality/clubs/profile_screen.dart';

enum Gender { male, female, others }

class UpdateInfoScreen extends StatefulWidget {
  const UpdateInfoScreen({super.key});

  @override
  State<UpdateInfoScreen> createState() => _UpdateInfoScreenState();
}

class _UpdateInfoScreenState extends State<UpdateInfoScreen> {
  Gender selectedGender = Gender.male;
  TextEditingController name = TextEditingController();
  TextEditingController dept = TextEditingController();
  TextEditingController batch = TextEditingController();
  TextEditingController section = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController id = TextEditingController();
  DateTime? selectedDate;
  dynamic userInfo = {};

  fetchUserData() async {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid;
    await fireStore.collection("user").doc(uid).get().then((value) => {userInfo = value.data()});
    name.text = userInfo['name'];
    dept.text = userInfo['department'];
    batch.text = userInfo['batch'];
    section.text = userInfo['section'];
    phone.text = userInfo['cell'];
    id.text = userInfo['id'];
    selectedDate = DateTime.tryParse(userInfo['dob']);

    setState(() {});
  }

  datePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 70, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      selectedDate = pickedDate;
    });
  }

  updateData() async {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    await fireStore.collection("user").doc(auth.currentUser!.uid).update({
      "name": name.text.trim(),
      "department": dept.text.trim(),
      "batch": batch.text.trim(),
      "section": section.text.trim(),
      "dob": DateFormat("yyyy-MM-dd").format(selectedDate!),
      "gender": selectedGender.name.toUpperCase(),
      "cell": phone.text.trim(),
    }).whenComplete(() {
      // print("Updated");
      // print(widget.uid);
      Get.off(() => const ProfileScreen());
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: name,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    hintText: "Name",
                  ),
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
                          prefixIcon: Icon(Icons.business_sharp),
                          hintText: "Department",
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: id,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.business_sharp),
                          hintText: "Student ID",
                        ),
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
                      child: TextFormField(
                        controller: batch,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.batch_prediction),
                          hintText: "Batch",
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: section,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.group),
                          hintText: "Section",
                        ),
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
                      child: DropdownButtonFormField(
                        value: selectedGender,
                        items: Gender.values
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(category.name.toUpperCase()),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            selectedGender = value;
                          });
                        },
                        decoration: const InputDecoration(prefixIcon: Icon(Icons.select_all)),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            selectedDate == null
                                ? "Date of Birth"
                                : DateFormat("yyyy-MM-dd").format(selectedDate!),
                          ),
                          //const SizedBox(width: 10),
                          IconButton(
                              onPressed: datePicker, icon: const Icon(Icons.date_range_rounded))
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: phone,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.settings_cell),
                    hintText: "Phone",
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(onPressed: updateData, child: const Text("Update"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
