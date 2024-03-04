import 'package:flutter/material.dart';
import 'package:lu_club_inscription/section/functionality/admin/club_register.dart';
import 'package:lu_club_inscription/section/functionality/admin/edit_club_details.dart';
import 'package:lu_club_inscription/utility/reusable_widgets.dart';

import '../../../services/firebase.dart';

class ClubDetails extends StatefulWidget {
  const ClubDetails({Key? key}) : super(key: key);

  @override
  State<ClubDetails> createState() => _ClubDetailsState();
}

class _ClubDetailsState extends State<ClubDetails> {
  FireStoreService fireStoreService = FireStoreService();
  dynamic clubData = {};
  late String clubAcronym;
  dynamic adminData = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    adminData = await fireStoreService.getAdminData();
    clubAcronym = adminData['clubAcronym'];
    clubData = await fireStoreService.getClubData(clubAcronym);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: clubData.length == 0 ? const Text("Loading...") : Text(clubData['clubName']),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditClubData(clubDetails: clubData),
                    ));
              },
              icon: const Icon(Icons.edit))
        ],
      ),
      body: clubData.length == 0
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      height: screenSize.height * 0.2,
                      width: screenSize.width * 0.4,
                      child: Image.network(
                        clubData['logoUrl'],
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    clubData['clubName'],
                    style: txtStyle(20, FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      clubData['clubDescription'],
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  const Divider(thickness: 2),
                  const Text(
                    "Advisor",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(thickness: 2),
                  Center(
                    child: SizedBox(
                      height: screenSize.height * 0.2,
                      width: screenSize.width * 0.4,
                      child: Image.network(clubData['advisorUrl']),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    clubData['advisorName'],
                    style: txtStyle(18, FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    clubData['advisorCell'],
                    style: txtStyle(18, FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    clubData['advisorEmail'],
                    style: txtStyle(18, FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  const Divider(thickness: 2),
                  const Text(
                    "Co - advisor",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(thickness: 2),
                  Center(
                    child: SizedBox(
                      height: screenSize.height * 0.2,
                      width: screenSize.width * 0.4,
                      child: Image.network(clubData['coAdvisorUrl1']),
                    ),
                  ),

                  Text(
                    clubData['coAdvisorName'],
                    style: txtStyle(18, FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    clubData['coAdvisorCell'],
                    style: txtStyle(18, FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    clubData['coAdvisorEmail'],
                    style: txtStyle(18, FontWeight.bold),
                  ),
                  if (clubData.containsKey("coAdvisorName1"))
                    Column(
                      children: [
                        const Divider(thickness: 2),
                        const Text(
                          "Co - advisor",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.teal,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(thickness: 2),
                        Center(
                          child: SizedBox(
                            height: screenSize.height * 0.2,
                            width: screenSize.width * 0.4,
                            child: Image.network(clubData['coAdvisorUrl2']),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          clubData['coAdvisorName1'],
                          style: txtStyle(18, FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          clubData['coAdvisorCell1'],
                          style: txtStyle(18, FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          clubData['coAdvisorEmail1'],
                          style: txtStyle(18, FontWeight.bold),
                        ),
                      ],
                    ),
                  const Divider(thickness: 2),
                  const Text(
                    "President",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(thickness: 2),
                  Center(
                    child: SizedBox(
                      height: screenSize.height * 0.2,
                      width: screenSize.width * 0.4,
                      child: Image.network(clubData['presidentUrl']),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    clubData['presidentName'],
                    style: txtStyle(18, FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    clubData['presidentCell'],
                    style: txtStyle(18, FontWeight.bold),
                  ),
                  const Divider(thickness: 2),
                  const Text(
                    "Secretary",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(thickness: 2),
                  Center(
                    child: SizedBox(
                      height: screenSize.height * 0.2,
                      width: screenSize.width * 0.4,
                      child: Image.network(clubData['secretaryUrl']),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    clubData['secretaryName'],
                    style: txtStyle(18, FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    clubData['secretaryCell'],
                    style: txtStyle(18, FontWeight.bold),
                  ),
                ],
              ),
            ),
    );
  }
}
