import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../db_services/firebase.dart';




class ChatForClubs extends StatefulWidget {
  final String clubAcronym;
  const ChatForClubs({
    Key? key, required this.clubAcronym,

  }) : super(key: key);

  @override
  State<ChatForClubs> createState() => _ChatForClubsState();
}

class _ChatForClubsState extends State<ChatForClubs> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  late Map<String, dynamic> userDetails = {};
  FireStoreService fireStoreService = FireStoreService();
  dynamic clubData = {};
  List<Map<String, dynamic>> allPosts = [];

  void postMessage() async {
    if (textController.text.isNotEmpty) {
      await fireStore
          .collection("clubs")
          .doc(clubData['clubAcronym'])
          .collection("chats")
          .add({
        'UserEmail': currentUser.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
        'name': userDetails['name']==null?clubData['clubAcronym']:userDetails['name'],
      });
    }

    setState(() {
      textController.clear();
    });
  }

  getData() async {
    //userDetails = await fireStoreService.getUserData();
    clubData = await fireStoreService.getClubData(widget.clubAcronym);
    allPosts = await fireStoreService.getChats(clubData['clubAcronym']);
    print(userDetails);
    print(clubData);
    setState(() {});
  }

  String formatDate(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    String year = dateTime.year.toString();
    String month = dateTime.month.toString();
    String day = dateTime.day.toString();

    String formattedData = '$day/$month/$year';

    return formattedData;
  }

  deleteChats(int index) async {
    List<String>? allData = [];

    final querySnapshot = await fireStore
        .collection('clubs')
        .doc(clubData['clubAcronym'])
        .collection('chats').orderBy("TimeStamp", descending: false)
        .get();
    allData = querySnapshot.docs.map((doc) => doc.id).toList();
    await fireStore
        .collection('clubs')
        .doc(clubData['clubAcronym'])
        .collection('chats')
        .doc(allData[index])
        .delete();
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: clubData['clubAcronym'] != null
            ? Text(
          clubData['clubAcronym'],
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        )
            : const Text(""),
        centerTitle: true,
      ),
      body: /*userDetails.isNotEmpty
          ?*/ Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: allPosts.length,
                  itemBuilder: (context, index) {
                    return Container(

                      decoration: BoxDecoration(
                        color: Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      margin: const EdgeInsets.only(
                          top: 20, left: 20, right: 20),
                      padding: const EdgeInsets.only(
                          top: 10, left: 20, right: 20, bottom: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Text(
                                    allPosts[index]['Message'],
                                    softWrap: true,
                                  )),
                              if ((userDetails["name"] !=
                                  allPosts[index]['name'])||(clubData['clubAcronym']!=allPosts[index]['name']))
                                IconButton(
                                    onPressed: () {
                                      deleteChats(index);
                                      getData();
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      size: 30,
                                    )),
                            ],
                          ),
                          (userDetails["name"] ==
                              allPosts[index]['name'])||(clubData['clubAcronym']==allPosts[index]['name'])?SizedBox(height: 13,):SizedBox(height: 0,),
                          Row(
                            children: [
                              Text(
                                allPosts[index]['name'],
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              Text(
                                " . ",
                                style: TextStyle(color: Colors.grey[500]),
                              ),
                              Text(
                                formatDate(allPosts[index]["TimeStamp"]),
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(children: [
                Flexible(
                  child: TextField(
                    controller: textController,
                    obscureText: false,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide:
                          const BorderSide(color: Colors.teal),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide:
                          const BorderSide(color: Colors.teal),
                        ),
                        //fillColor: Colors.grey.shade200,
                        filled: true,
                        fillColor: Colors.teal.shade50,
                        hintText: "Write Something...",
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                        )),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    postMessage();
                    getData();
                  },
                  icon: const Icon(
                    Icons.arrow_circle_up,
                    color: Colors.teal,
                    size: 35,
                  ),
                ),
              ]),
            ),
          ],
        ),
      )
          //: const Center(child: CircularProgressIndicator()),
    );
  }
}
