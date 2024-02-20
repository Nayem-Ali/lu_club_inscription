import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lu_club_inscription/servcies/firebase.dart';

class MembersManagement extends StatefulWidget {
  const MembersManagement({Key? key}) : super(key: key);

  @override
  State<MembersManagement> createState() => _MembersManagementState();
}

class _MembersManagementState extends State<MembersManagement> {
  final String url = "https://www.google"
      ".com/search?q=profile+picture+logo&tbm=isch&ved=2ahUKEwjL3qXN4LmEAxWewKACHc3EDukQ2-cCegQIABAA&oq=profile+picture+logo&gs_lp=EgNpbWciFHByb2ZpbGUgcGljdHVyZSBsb2dvMgUQABiABDIFEAAYgAQyBRAAGIAEMgUQABiABDIFEAAYgAQyBRAAGIAEMgUQABiABDIFEAAYgAQyBRAAGIAEMgUQABiABEiWGlCnBlj-FHABeACQAQCYAbwBoAGkCaoBAzAuN7gBA8gBAPgBAYoCC2d3cy13aXotaW1nwgIEECMYJ8ICEBAAGIAEGIoFGEMYsQMYgwHCAgoQABiABBiKBRhDwgILEAAYgAQYsQMYgwGIBgE&sclient=img&ei=84TUZYuZEp6Bg8UPzYm7yA4&bih=911&biw=1920&rlz=1C1ONGR_enBD1012BD1012#imgrc=Qk95hvMUrzdm6M";
  FireStoreService fireStoreService = FireStoreService();
  int currentIndex = 0;
  late String clubAcronym;
  dynamic allMembers = [];
  dynamic approved = [];
  dynamic pending = [];

  showInfo(int index) async {
    Get.bottomSheet(
      backgroundColor: Colors.white,
      Column(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(pending[index]['img'] ?? url, scale: 20),
            radius: 45,
          ),
          Text("Name: ${pending[index]['name']}"),
          Text("ID: ${pending[index]['id']}"),
          Text("Department: ${pending[index]['dept']}"),
          Text("Batch: ${pending[index]['batch']} Section: ${pending[index]['section']}"),
          Text("Mobile: ${pending[index]['cell']}"),
          Text("Email: ${pending[index]['email']}"),
          Text("Amount: ${pending[index]['amount']}"),
          Text("Transaction ID: ${pending[index]['tid']}"),
          // Text("Transaction ID: ${pending[index]['uid']}"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    await fireStoreService.updateMemberRegistrationStatus(
                      clubAcronym,
                      pending[index]['uid'],
                      'approved',
                    );
                    await getAllMembers();
                    Get.back();
                  },
                  child: const Text("Approve")),
              ElevatedButton(
                  onPressed: () async {
                    await fireStoreService.updateMemberRegistrationStatus(
                      clubAcronym,
                      pending[index]['uid'],
                      'rejected',
                    );
                    await getAllMembers();
                    Get.back();
                  },
                  child: const Text("Reject")),
            ],
          )
        ],
      ),
    );
  }

  getAllMembers() async {
    clubAcronym = await fireStoreService.clubAcronym();
    allMembers = await fireStoreService.getClubMember(clubAcronym);
    approved.clear();
    pending.clear();
    for (var member in allMembers) {
      if (member['status'] == 'approved') {
        approved.add(member);
      } else {
        pending.add(member);
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllMembers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Members"),
        centerTitle: true,
      ),
      body: currentIndex == 0
          ? GridView.builder(
              itemCount: approved.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                return Card(
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(approved[index]['img'] ?? url, scale: 20),
                        radius: 45,
                      ),
                      Text("Name: ${approved[index]['name']}"),
                      Text("ID: ${approved[index]['id']}"),
                      Text("Department: ${approved[index]['dept']}"),
                      Text(
                        "Batch: ${approved[index]['batch']} Section: ${approved[index]['section']}",
                      ),
                      Text("Mobile: ${approved[index]['cell']}"),
                    ],
                  ),
                );
              },
            )
          : ListView.builder(
              itemCount: pending.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    showInfo(index);
                  },
                  child: Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(pending[index]['img'] ?? url),
                      ),
                      title: Text("${pending[index]['name']}"),
                      subtitle: Text("Request ${pending[index]['status']}".toUpperCase()),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: CurvedNavigationBar(
        index: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        items: const [
          Icon(
            Icons.list,
            color: Colors.white,
          ),
          Icon(
            Icons.pending,
            color: Colors.white,
          )
        ],
        height: Get.height * 0.07,
        color: Colors.teal,
        backgroundColor: Colors.white,
      ),
    );
  }
}
