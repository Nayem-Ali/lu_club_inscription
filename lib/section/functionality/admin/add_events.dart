import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lu_club_inscription/utility/reusable_widgets.dart';

import '../../../db_services/firebase.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({Key? key}) : super(key: key);

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  FireStoreService fireStoreService = FireStoreService();
  final List<TextEditingController> eventName = [TextEditingController()];
  final List<TextEditingController> receiverName = [TextEditingController()];
  final List<TextEditingController> eventDescription = [TextEditingController()];

  final List<TextEditingController> payments = [TextEditingController()];
  final List<TextEditingController> fees = [TextEditingController()];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Events"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: eventName.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      TextFormField(
                        controller: eventName[index],
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), label: Text("Segment Name")),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: eventDescription[index],
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text("Segment description"),
                        ),
                        maxLines: null,
                        minLines: null,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              controller: receiverName[index],
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(), label: Text("Receiver Name")),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: payments[index],
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(), label: Text("Bkash Number")),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              controller: fees[index],
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(), label: Text("Fees")),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                eventName.add(TextEditingController());
                                eventDescription.add(TextEditingController());
                                receiverName.add(TextEditingController());
                                payments.add(TextEditingController());
                                fees.add(TextEditingController());
                              });
                            },
                            child: const Text("Create Another"),
                          ),
                          if (index != 0)
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  eventName[index].clear();
                                  eventName[index].dispose();
                                  eventName.removeAt(index);
                                  eventDescription[index].clear();
                                  eventDescription[index].dispose();
                                  eventDescription.removeAt(index);
                                  payments[index].clear();
                                  payments[index].dispose();
                                  payments.removeAt(index);
                                  receiverName[index].clear();
                                  receiverName[index].dispose();
                                  receiverName.removeAt(index);
                                  fees[index].clear();
                                  fees[index].dispose();
                                  fees.removeAt(index);
                                });
                              },
                              child: const Text("Remove"),
                            ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await fireStoreService.addEvent(
                    eventName, eventDescription, payments, fees, receiverName);
                showToast("Event added successfully");
                sleep(const Duration(seconds: 5));
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(minimumSize: const Size(300, 45)),
              child: Text(
                "ADD",
                style: txtStyle(17, FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
