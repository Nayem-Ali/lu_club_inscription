import 'package:flutter/material.dart';

class PendingRequest extends StatefulWidget {
  const PendingRequest({Key? key}) : super(key: key);

  @override
  State<PendingRequest> createState() => _PendingRequestState();
}

class _PendingRequestState extends State<PendingRequest> {
  List<dynamic> req = [
    {"name": "Abu Talha", "id": 2012020016, "batch": 53},
    {"name": "MD Taha", "id": 2112020016, "batch": 57},
    {"name": "Yesmin Begum", "id": 01882312020016, "batch": 62},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("All Request"),centerTitle: true,),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          itemCount: req.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text("Name: " + req[index]["name"]),
              subtitle: Row(
                children: [ 
                  Text("ID: " + req[index]["id"].toString()),
                  Spacer(),
                  Text("Batch: " + req[index]["batch"].toString()),
                ],
              ),
              trailing:
                  IconButton(onPressed: (){}, icon: Icon(Icons.done)),

            );
          },
        ),
      ),
    );
  }
}
