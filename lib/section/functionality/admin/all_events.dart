import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lu_club_inscription/section/functionality/admin/add_events.dart';
import 'package:lu_club_inscription/section/functionality/admin/view_event.dart';
import 'package:lu_club_inscription/services/firebase.dart';
import 'package:lu_club_inscription/section/functionality/admin/edit_club_events.dart';
import 'package:lu_club_inscription/utility/reusable_widgets.dart';

class AllEvents extends StatefulWidget {
  const AllEvents({Key? key}) : super(key: key);

  @override
  State<AllEvents> createState() => _AllEventsState();
}

class _AllEventsState extends State<AllEvents> {
  FireStoreService fireStoreService = FireStoreService();
  dynamic events = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    events = await fireStoreService.getEvents();
    setState(() {});
  }

  deleteEvent(String docID) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Click yes to delete event"),
          actions: [
            TextButton(onPressed: () async {
              FirebaseFirestore fireStore = FirebaseFirestore.instance;
              dynamic clubID = await fireStoreService.clubAcronym();
              await fireStore.collection("clubs").doc(clubID).collection("allEvents").doc(docID).delete();
              await getData();
            }, child: const Text("Yes")),
            TextButton(onPressed: () {
              Navigator.pop(context);
            }, child: const Text("No")),
          ],
        );
      },
    );

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Club Events"),
      ),
      body: events.length == 0
          ? const Center(
              child: Text("No events"),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: index % 2 == 1 ? Colors.cyan.shade100 : Colors.lime.shade100,
                        child: ListTile(
                          title: InkWell(
                            onTap: () {
                              Get.to(()=> const ViewEvent(), arguments: events[index]);
                            },
                            child: Text(
                              events[index]["eventName"].toString(),
                              style: const TextStyle(
                                  color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 22),
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              deleteEvent(events[index]["eventName"].toString());
                            },
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                          ),
                          leading: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditEventData(
                                    eventData: events[index],
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit),
                            color: Colors.black,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddEvent(),
                        ));
                  },
                  style: ElevatedButton.styleFrom(minimumSize: Size(300, 45)),
                  child: Text(
                    "ADD Events",
                    style: txtStyle(17, FontWeight.bold),
                  ),
                )
              ],
            ),
    );
  }
}
