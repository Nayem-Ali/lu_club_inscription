import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lu_club_inscription/section/functionality/clubs/club_events.dart';
import 'package:lu_club_inscription/servcies/firebase.dart';

import '../../../utility/reusable_widgets.dart';

class EventDetailsPage extends StatefulWidget {
  const EventDetailsPage({Key? key}) : super(key: key);

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  FireStoreService fireStoreService = FireStoreService();
  TextEditingController name = TextEditingController();
  TextEditingController id = TextEditingController();
  TextEditingController dept = TextEditingController();
  TextEditingController batch = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController tid = TextEditingController();
  TextEditingController amount = TextEditingController();
  Map<String, dynamic> events = Get.arguments[0];
  String clubAcronym = Get.arguments[1];
  Map<String, dynamic> registrationData = {};
  final formKey = GlobalKey<FormState>();

  dynamic userInfo = {};

  eventRegistration() {
    Get.bottomSheet(
      ignoreSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      Container(
        margin: const EdgeInsets.all(10),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(height: Get.height * 0.05),
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
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
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
                      ),
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return "Fill with info";
                        }
                        return null;
                      },
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
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    Map<String, dynamic> data = {
                      "eventName": events['eventName'],
                      "name": name.text.trim(),
                      "dept": dept.text.trim(),
                      "id": id.text.trim(),
                      "batch": batch.text.trim(),
                      "amount": double.parse(amount.text.trim()),
                      "tid": tid.text.trim(),
                      "status": "pending",
                      "uid": "",
                    };
                    await fireStoreService.setEventRegistration(clubAcronym, data);

                    Get.off(() => ClubEvents(clubAcronym: clubAcronym));
                  }
                },
                style: elevated(),
                child: const Text("Submit"),
              )
            ],
          ),
        ),
      ),
    );
  }

  getUserData() async {
    userInfo = await fireStoreService.getUserData();
    name.text = userInfo['name'];
    dept.text = userInfo['department'];
    batch.text = userInfo['batch'];
    phone.text = userInfo['cell'];
    id.text = userInfo['id'];
    registrationData = await fireStoreService.memberEventRegistrationStatus(
          clubAcronym,
          events['eventName'],
        ) ??
        {};
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(events["eventName"]), centerTitle: true),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(
              "Description: ${events["eventDescription"]}",
              style: txtStyle(16, FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "Payment Receiver: ${events["eventHandler"]}",
              style: txtStyle(16, FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Payment Receiver: ${events["paymentNumber"]} (bKash)",
              style: txtStyle(16, FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Fees: ${events["fees"]}",
              style: txtStyle(16, FontWeight.bold),
            ),
            const SizedBox(height: 10),
            registrationData.isEmpty
                ? ElevatedButton(
                    onPressed: eventRegistration,
                    style: elevated(),
                    child: const Text("Register"),
                  )
                : Text(
                    "You registration status: ${registrationData['status']}".toUpperCase(),
                    style: txtStyle(16, FontWeight.bold),
                  ),
          ],
        ),
      ),
    );
  }
}
