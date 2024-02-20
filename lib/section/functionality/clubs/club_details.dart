import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../servcies/firebase.dart';

class ClubDetails extends StatefulWidget {
  final String clubAcronym;

  const ClubDetails({Key? key, required this.clubAcronym}) : super(key: key);

  @override
  State<ClubDetails> createState() => _ClubDetailsState();
}

class _ClubDetailsState extends State<ClubDetails> {
  FireStoreService fireStoreService = FireStoreService();
  dynamic clubData = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
  }

  getData() async {
    clubData = await fireStoreService.getClubData(widget.clubAcronym);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: clubData.length == 0 ? const Text("Loading...") : Text(clubData['clubName']),
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
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      clubData['clubDescription'],
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  const SizedBox(height: 15),
                  CircleAvatar(
                    backgroundImage: NetworkImage(clubData['advisorUrl']),
                    radius: Get.width * 0.2,
                  ),
                  // Center(
                  //   child: SizedBox(
                  //     height: screenSize.height * 0.3,
                  //     width: screenSize.width * 0.4,
                  //     child: Image.network(),
                  //   ),
                  // ),
                  const SizedBox(height: 5),
                  Text(
                    clubData['advisorName'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Mobile: ${clubData['advisorCell']}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Email: ${clubData['advisorEmail']}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 15),
                  CircleAvatar(
                    backgroundImage: NetworkImage(clubData['coAdvisorUrl1']),
                    radius: Get.width * 0.2,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    clubData['coAdvisorName'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Mobile: ${clubData['coAdvisorCell']}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Email: ${clubData['coAdvisorEmail']}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (clubData.containsKey("coAdvisorName1"))
                    Column(
                      children: [
                        const SizedBox(height: 15),
                        CircleAvatar(
                          backgroundImage: NetworkImage(clubData['coAdvisorUrl2']),
                          radius: Get.width * 0.2,
                        ),
                        // Center(
                        //   child: SizedBox(
                        //     height: screenSize.height * 0.3,
                        //     width: screenSize.width * 0.4,
                        //     child: Image.network(clubData['coAdvisorUrl2']),
                        //   ),
                        // ),
                        const SizedBox(height: 5),
                        Text(
                          clubData['coAdvisorName1'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Mobile: ${clubData['coAdvisorCell1']}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Email: ${clubData['coAdvisorEmail1']}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 15),

                  CircleAvatar(
                    backgroundImage: NetworkImage(clubData['presidentUrl']),
                    radius: Get.width * 0.2,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    clubData['presidentName'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Mobile: ${clubData['presidentCell']}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 15),
                  CircleAvatar(
                    backgroundImage: NetworkImage(clubData['secretaryUrl']),
                    radius: Get.width * 0.2,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    clubData['secretaryName'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Mobile: ${clubData['secretaryCell']}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
    );
  }
}
