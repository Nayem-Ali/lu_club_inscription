import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lu_club_inscription/section/functionality/admin/adminDashboard.dart';
import 'package:lu_club_inscription/section/functionality/clubs/home_screen.dart';
import 'package:lu_club_inscription/section/functionality/clubs/profile_screen.dart';
import 'package:lu_club_inscription/utility/reusable_widgets.dart';


class NavigatorScreen extends StatefulWidget {
  const NavigatorScreen({Key? key}) : super(key: key);

  @override
  State<NavigatorScreen> createState() => _NavigatorScreenState();
}

class _NavigatorScreenState extends State<NavigatorScreen> {
  bool isAdmin = false;

  var _page = 0;
  final page = [const HomeScreen(), const ProfileScreen()];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   fetchUserData();
  }

  fetchUserData() async {
    dynamic data = {};
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid;
    try{
        await fireStore
            .collection("user")
            .doc(uid)
            .get()
            .then((value) => {
          data = value.data(),
          isAdmin = data!['admin']
        });

    }
    catch(e){
      // showToast("You are wrong");
        await fireStore
            .collection("admin")
            .doc(uid)
            .get()
            .then((value) => {
          data = value.data(),
          isAdmin = data!['admin']
        });

    }

   setState(() {
   });
  }

  @override
  Widget build(BuildContext context) {
    return isAdmin == false ? Scaffold(
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
        items: const [
          Icon(Icons.home, color: Colors.white,),
          Icon(Icons.person, color: Colors.white,),
        ],
      ),
      body:  page[_page],
    ): const AdminDashboard();
  }
}
