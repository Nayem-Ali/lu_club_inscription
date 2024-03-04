import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lu_club_inscription/services/firebase.dart';

import '../../../utility/reusable_widgets.dart';

class ViewEvent extends StatefulWidget {
  const ViewEvent({Key? key}) : super(key: key);

  @override
  State<ViewEvent> createState() => _ViewEventState();
}

class _ViewEventState extends State<ViewEvent> {
  FireStoreService fireStoreService = FireStoreService();
  Map<String, dynamic> event = Get.arguments;
  late String clubAcronym;
  dynamic allRegistration = [];

  showRegistrationDetails(int index) {
    Get.bottomSheet(
        backgroundColor: Colors.white,
        Column(
          children: [
            const SizedBox(height: 20),
            Text(
              "Name: ${allRegistration[index]['name']}",
              style: txtStyle(16, FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              "ID: ${allRegistration[index]['id']}",
              style: txtStyle(16, FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              "Department: ${allRegistration[index]['dept']}",
              style: txtStyle(16, FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              "Batch: ${allRegistration[index]['batch']}",
              style: txtStyle(16, FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              "Amount: ${allRegistration[index]['amount']}",
              style: txtStyle(16, FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              "Transaction ID / Reference: ${allRegistration[index]['tid']}",
              style: txtStyle(16, FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      await fireStoreService.updateEventRegistrationStatus(
                        clubAcronym,
                        allRegistration[index]['eventName'],
                        allRegistration[index]['uid'],
                        'approved',
                      );
                      await getAllRegistration();
                      Get.back();
                    },
                    child: const Text("Approve")),
                ElevatedButton(
                    onPressed: () async {
                      await fireStoreService.updateEventRegistrationStatus(
                        clubAcronym,
                        allRegistration[index]['eventName'],
                        allRegistration[index]['uid'],
                        'rejected',
                      );
                      await getAllRegistration();
                      Get.back();
                    },
                    child: const Text("Reject")),
              ],
            )
          ],
        ));
    getAllRegistration();
  }

  getAllRegistration() async {
    clubAcronym = await fireStoreService.clubAcronym();
    allRegistration.clear();
    allRegistration = await fireStoreService.getEventRegistration(clubAcronym, event['eventName']);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllRegistration();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            event["eventName"].toString(),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                Text(
                  "Description: ${event["eventDescription"]}",
                  style: txtStyle(16, FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Payment Receiver: ${event["eventHandler"]}",
                  style: txtStyle(16, FontWeight.bold),
                ),
                Text(
                  "Bkash Number: ${event["paymentNumber"]} ",
                  style: txtStyle(16, FontWeight.bold),
                ),
                Text(
                  "Fees: ${event["fees"]}",
                  style: txtStyle(16, FontWeight.bold),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: allRegistration.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                            onTap: () {
                              showRegistrationDetails(index);
                            },
                            title: Text(allRegistration[index]['name']),
                            subtitle: Text(
                                "Registration ${allRegistration[index]['status']}".toUpperCase())),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
