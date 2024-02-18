import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lu_club_inscription/section/functionality/admin/add_events.dart';
import 'package:lu_club_inscription/servcies/firebase.dart';
import 'package:lu_club_inscription/section/functionality/admin/edit_club_events.dart';
import 'package:lu_club_inscription/utility/reusable_widgets.dart';

class AllEvents extends StatefulWidget {
  const AllEvents({Key? key}) : super(key: key);

  @override
  State<AllEvents> createState() => _AllEventsState();
}

class _AllEventsState extends State<AllEvents> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  dynamic events = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    events = await getEvents();
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
              dynamic clubID = await clubAcronym();
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

  showEventInfo(int index) {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: false,
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                events[index]["eventName"].toString(),
                style: txtStyle(22, FontWeight.bold),
              ),
              const Spacer(),
              Text(
                "Description: ${events[index]["eventDescription"]}",
                style: txtStyle(16, FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              Text(
                "Payment Receiver: ${events[index]["eventHandler"]}",
                style: txtStyle(16, FontWeight.bold),
              ),
              const Spacer(),
              Text(
                "Bkash Number: ${events[index]["paymentNumber"]} ",
                style: txtStyle(16, FontWeight.bold),
              ),
              const Spacer(),
              Text(
                "Fees: ${events[index]["fees"]}",
                style: txtStyle(16, FontWeight.bold),
              ),
              const Spacer(),
            ],
          ),
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
                          title: GestureDetector(
                            onTap: () {
                              showEventInfo(index);
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
