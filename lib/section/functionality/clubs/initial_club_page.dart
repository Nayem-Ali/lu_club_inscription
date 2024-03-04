import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lu_club_inscription/section/functionality/chats.dart';
import 'package:lu_club_inscription/section/functionality/chats/chat_page.dart';
import 'package:lu_club_inscription/section/functionality/clubs/club_details.dart';
import 'package:lu_club_inscription/section/functionality/clubs/club_events.dart';
import 'package:lu_club_inscription/section/functionality/clubs/member_registration.dart';
import '../../../services/firebase.dart';

class InitialClubPage extends StatefulWidget {
  const InitialClubPage({
    Key? key,
  }) : super(key: key);

  @override
  State<InitialClubPage> createState() => _InitialClubPageState();
}

class _InitialClubPageState extends State<InitialClubPage> {

  FireStoreService fireStoreService = FireStoreService();
  Map<String, dynamic> myClubData = {};
  dynamic clubData = {};
  var _page = 0;
  final page = [

    ClubEvents(clubAcronym: Get.arguments),
    ClubDetails(clubAcronym: Get.arguments),
    MemberRegistration(clubAcronym: Get.arguments),

  ];

  getData()async{
    //clubData = await fireStoreService.getClubData(widget.clubAcronym);
    myClubData = await fireStoreService.getIndividualClubData(Get.arguments);
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
      bottomNavigationBar: CurvedNavigationBar(
        index: 0,
        height: MediaQuery.of(context).size.height * 0.07,
        backgroundColor: Colors.white,
        color: Colors.teal,
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        items: [
          const Icon(
            Icons.event,
            color: Colors.white,
          ),
          const Icon(
            Icons.info,
            color: Colors.white,
          ),
          myClubData['isApproved']==true?const Icon(
            Icons.message,
            color: Colors.white,
          ):const Icon(
            Icons.app_registration,
            color: Colors.white,
          ),
        ],
      ),
      body: page[_page],
    );
  }
}
