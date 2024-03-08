import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lu_club_inscription/section/functionality/clubs/event_details_page.dart';

class ClubEvents extends StatefulWidget {
  final String clubAcronym;

  const ClubEvents({Key? key, required this.clubAcronym}) : super(key: key);

  @override
  State<ClubEvents> createState() => _ClubEventsState();
}

class _ClubEventsState extends State<ClubEvents> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  dynamic events = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    QuerySnapshot querySnapshot =
        await firestore.collection("clubs").doc(widget.clubAcronym).collection("allEvents").get();

    // Get data from docs and convert map to List
    // project1=
    events = querySnapshot.docs.map((doc) => doc.data()).toList();
    setState(() {});
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Club Events"),
        centerTitle: true,

      ),
      body: events.length == 0
          ? const Center(
              child: Text("No events"),
            )
          : ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                String eventName = events[index]["eventName"] ?? "Unknown Event";
                return Card(
                  color: index % 2 == 1 ? Colors.teal.shade50 : Colors.cyan.shade100,
                  //color: index % 2 == 1 ? Colors.cyan.shade100 : Colors.lime.shade100,
                  child: ListTile(
                    title: GestureDetector(
                      onTap: () {
                        Get.to(()=> const EventDetailsPage(), arguments: [events[index], widget.clubAcronym]);
                      },
                      child: Text(
                        events[index]["eventName"].toString(),
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
