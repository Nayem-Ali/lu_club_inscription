import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lu_club_inscription/utility/reusable_widgets.dart';

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
              Text("Payment Receiver: ${events[index]["paymentNumber"]} (bKash)",
                style: txtStyle(16, FontWeight.bold),
              ),
              const Spacer(),
              Text("Fees: ${events[index]["fees"]}",
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
          : ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                return Card(
                  color: index%2 == 1 ? Colors.cyan.shade100 :  Colors.lime.shade100 ,
                  child: ListTile(
                    title: GestureDetector(
                      onTap: () {
                        showEventInfo(index);
                      },
                      child: Text(
                        events[index]["eventName"].toString(),

                        style: const TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                          fontSize: 22
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
