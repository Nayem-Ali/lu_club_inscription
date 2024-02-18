import 'package:flutter/material.dart';
import 'package:lu_club_inscription/section/functionality/admin/all_events.dart';
import 'package:lu_club_inscription/servcies/firebase.dart';

class EditEventData extends StatefulWidget {
  final dynamic eventData;

  const EditEventData({Key? key, required this.eventData}) : super(key: key);

  @override
  State<EditEventData> createState() => _EditEventDataState();
}

class _EditEventDataState extends State<EditEventData> {
  TextEditingController eventName = TextEditingController();
  TextEditingController eventDescription = TextEditingController();
  TextEditingController receiverName = TextEditingController();
  TextEditingController fees = TextEditingController();
  TextEditingController paymentNumber = TextEditingController();

  dynamic events = [];

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() {
    events = widget.eventData;
    eventName.text = events["eventName"];
    eventDescription.text = events["eventDescription"];
    receiverName.text = events["eventHandler"];
    paymentNumber.text = events["paymentNumber"];
    fees.text = events["fees"];
  }

  updateData() async {
    dynamic data = {
      "eventName": eventName.text.trim(),
      "eventDescription": eventDescription.text.trim(),
      "eventHandler": receiverName.text.trim(),
      "paymentNumber": paymentNumber.text.trim(),
      "fees": fees.text.trim(),
    };
    await updateEvent(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Event Data"),
        centerTitle: true,
      ),
      body: Form(
          key: formKey,
          child: Container(
            margin: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                TextFormField(
                  controller: eventName,
                  readOnly: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), label: Text("Segment Name")),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: eventDescription,
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
                        controller: receiverName,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), label: Text("Receiver Name")),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: paymentNumber,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), label: Text("Bkash Number")),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: fees,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), label: Text("Fees")),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    updateData();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const AllEvents(),
                      ),
                    );
                  },
                  child: const Text("Update"),
                ),
              ],
            ),
          )),
    );
  }
}
