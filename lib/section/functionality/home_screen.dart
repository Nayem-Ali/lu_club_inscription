import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lu_club_inscription/section/functionality/clubs/initial_club_page.dart';
import 'package:lu_club_inscription/section/functionality/drawer_screen.dart';
import 'package:lu_club_inscription/utility/reusable_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> clubs = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    QuerySnapshot querySnapshot = await firestore.collection("clubs").get();
    clubs = querySnapshot.docs.map((doc) => doc.data()).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "LU Club Inscription",
          style: txtStyle(25, FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 12,
            ),
            Text(
              "Club List",
              style: txtStyle(28, FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              "To explore and register any club tap on the club labeled icon",
              style: txtStyle(18, FontWeight.w400),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            if (clubs.isNotEmpty)
              Expanded(
                child: GridView.builder(
                  itemCount: clubs.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Get.to(() => const InitialClubPage(),arguments: clubs[index]['clubAcronym']);
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        elevation: 10,
                        color: Colors.teal.shade100,
                        child: Center(
                          child: ListTile(
                            title: CircleAvatar(
                              radius: Get.width * 0.15,
                              foregroundImage: NetworkImage(clubs[index]['logoUrl']),
                            ),
                            subtitle: Text(
                              clubs[index]['clubAcronym'],
                              textAlign: TextAlign.center,
                              style: txtStyle(18, FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
          ],
        ),
      ),
      drawer: const DrawerScreen(),
    );
  }
}
