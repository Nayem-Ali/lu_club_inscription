import 'package:flutter/material.dart';

import '../../../servcies/firebase.dart';


class ClubDetails extends StatefulWidget {
  final String clubAcronym;
  const ClubDetails({Key? key, required this.clubAcronym}) : super(key: key);

  @override
  State<ClubDetails> createState() => _ClubDetailsState();
}

class _ClubDetailsState extends State<ClubDetails> {
  dynamic clubData = {};


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
  }

  getData() async {

    clubData = await getClubData(widget.clubAcronym);
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: clubData.length == 0 ?const Text("Loading...") : Text(clubData['clubName']),),
      body: clubData.length == 0 ? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                height: screenSize.height*0.2,
                width: screenSize.width*0.4,
                child: Image.network(clubData['logoUrl'],fit: BoxFit.fill,),
              ),
            ),
            const SizedBox(height: 5),
            Text(clubData['clubName']),
            const SizedBox(height: 5),
            Text(clubData['clubDescription']),
            Center(
              child: SizedBox(
                height: screenSize.height*0.3,
                width: screenSize.width*0.4,
                child: Image.network(clubData['advisorUrl']),
              ),
            ),
            const SizedBox(height: 5),
            Text(clubData['advisorName']),
            const SizedBox(height: 5),
            Text(clubData['advisorCell']),
            const SizedBox(height: 5),
            Text(clubData['advisorEmail']),
            Center(
              child: SizedBox(
                height: screenSize.height*0.3,
                width: screenSize.width*0.4,
                child: Image.network(clubData['coAdvisorUrl1']),
              ),
            ),
            const SizedBox(height: 5),
            Text(clubData['coAdvisorName']),
            const SizedBox(height: 5),
            Text(clubData['coAdvisorCell']),
            const SizedBox(height: 5),
            Text(clubData['coAdvisorEmail']),
            if(clubData.containsKey("coAdvisorName1"))
            Column(
              children: [
                Center(
                  child: SizedBox(
                    height: screenSize.height*0.3,
                    width: screenSize.width*0.4,
                    child: Image.network(clubData['coAdvisorUrl2']),
                  ),
                ),
                const SizedBox(height: 5),
                Text(clubData['coAdvisorName1']),
                const SizedBox(height: 5),
                Text(clubData['coAdvisorCell1']),
                const SizedBox(height: 5),
                Text(clubData['coAdvisorEmail1']),
              ],
            ),
            Center(
              child: SizedBox(
                height: screenSize.height*0.3,
                width: screenSize.width*0.4,
                child: Image.network(clubData['presidentUrl']),
              ),
            ),
            const SizedBox(height: 5),
            Text(clubData['presidentName']),
            const SizedBox(height: 5),
            Text(clubData['presidentCell']),
            Center(
              child: SizedBox(
                height: screenSize.height*0.3,
                width: screenSize.width*0.4,
                child: Image.network(clubData['secretaryUrl']),
              ),
            ),
            const SizedBox(height: 5),
            Text(clubData['secretaryName']),
            const SizedBox(height: 5),
            Text(clubData['secretaryCell']),
          ],
        ),
      ),
    );
  }
}
