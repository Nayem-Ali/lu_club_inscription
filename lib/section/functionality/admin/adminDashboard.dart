import 'package:flutter/material.dart';
import 'package:lu_club_inscription/section/functionality/admin/add_events.dart';
import 'package:lu_club_inscription/section/functionality/admin/club_details.dart';
import 'package:lu_club_inscription/section/functionality/admin/club_register.dart';
import 'package:lu_club_inscription/section/functionality/admin/all_events.dart';
import 'package:lu_club_inscription/section/functionality/admin/pending_request.dart';

import '../../../utility/reusable_widgets.dart';
import '../../../servcies/firebase.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  dynamic adminData = {};
  dynamic clubData = {};
  bool hasClub = false;
  late String clubAcronym;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    adminData = await getAdminData();
    hasClub = adminData['hasClub'];
    clubAcronym = adminData['clubAcronym'];
    clubData = await getClubData(clubAcronym);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        actions: [
          IconButton(
              onPressed: () {
                logoutUser(context);
              },
              icon: const Icon(Icons.logout))
        ],
        centerTitle: true,
      ),
      body: clubData.isNotEmpty
          ? Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ClubDetails(),));
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(300, 80)
                    ),
                    icon: const Icon(Icons.info,size: 40,),
                    label: Text("Club Details",style: txtStyle(24, FontWeight.bold),),
                  ),
                  const SizedBox(height: 40,),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AllEvents(),));
                    },
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(300, 80)
                    ),
                    icon: const Icon(Icons.event,size: 40,),
                    label: Text("Events",style: txtStyle(24, FontWeight.bold),),
                  ),
                  const SizedBox(height: 40,),
                  ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(300, 80)
                    ),
                    icon: const Icon(Icons.people,size: 40,),
                    label: Text("Members",style: txtStyle(24, FontWeight.bold),),
                  ),
                ],
              ),
          )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Divider(),
                hasClub ? Text(hasClub.toString()) : CircularProgressIndicator(),
                // Text("${adminData['name']}"),
                // Text("${adminData['admin']}"),
                // Text("${adminData['hasClub']}"),
                Text(
                  "You are not admin of any club.",
                  style: txtStyle(20, FontWeight.bold),
                ),
                Text(
                  "Tap on the add a club button\n for being admin of an club",
                  style: txtStyle(20, FontWeight.bold),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ClubRegistration(),
                      ),
                    );
                  },
                  style: elevated(),
                  child: const Text("Create a club"),
                ),
              ],
            ),
    );
  }
}
