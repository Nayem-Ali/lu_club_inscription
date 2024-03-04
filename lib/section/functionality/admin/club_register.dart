import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lu_club_inscription/services/firebase.dart';
import 'package:lu_club_inscription/utility/reusable_widgets.dart';

class ClubRegistration extends StatefulWidget {
  const ClubRegistration({Key? key}) : super(key: key);

  @override
  State<ClubRegistration> createState() => _ClubRegistrationState();
}

class _ClubRegistrationState extends State<ClubRegistration> {
  FireStoreService fireStoreService = FireStoreService();
  bool advisor = true;
  bool coAdvisor = false;
  bool coAdvisor2 = false;

  Map<String,String> clubInfo = {};
  List<File> images = [];

  final phoneRegex = RegExp(r'^01[3-9][0-9]{8}$');
  final nameRegex =
      RegExp(r'^[a-zA-Z]+ [a-zA-Z]+( [a-zA-Z]+)?( [a-zA-Z]+)?( [a-zA-Z]+)?$');
  final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');


  late File logo;
  late File advisorImage;
  late File coAdvisorImage1;
  late File coAdvisorImage2;
  late File presidentImage;
  late File secretaryImage;

  String logoUrl = "";
  String advisorUrl = "";
  String coAdvisorUrl = "";
  String coAdvisorUrl2 = "";
  String presidentUrl = "";
  String secretaryUrl = "";

  final ImagePicker _picker = ImagePicker();

  TextEditingController clubName = TextEditingController();
  TextEditingController clubAcronym = TextEditingController();
  TextEditingController clubDescription = TextEditingController();
  TextEditingController advisorName = TextEditingController();
  TextEditingController advisorEmail = TextEditingController();
  TextEditingController advisorCell = TextEditingController();
  TextEditingController coAdvisorName = TextEditingController();
  TextEditingController coAdvisorEmail = TextEditingController();
  TextEditingController coAdvisorCell = TextEditingController();
  TextEditingController coAdvisorName1 = TextEditingController();
  TextEditingController coAdvisorEmail1 = TextEditingController();
  TextEditingController coAdvisorCell1 = TextEditingController();
  TextEditingController presidentName = TextEditingController();
  TextEditingController presidentCell = TextEditingController();
  TextEditingController secretaryName = TextEditingController();
  TextEditingController secretaryCell = TextEditingController();

  final formKey = GlobalKey<FormState>();

  pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      return null;
    } else {
      return pickedFile;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Club Registration"),),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Stack(children: [
                    Container(
                      decoration: BoxDecoration(border: Border.all()),
                      height: 100,
                      width: 100,
                      child: logoUrl == ""
                          ? const Text(
                              "Add \nClub \nLogo",
                              textAlign: TextAlign.center,
                            )
                          : Image.file(
                              logo,
                              fit: BoxFit.fill,
                              width: 100,
                              height: 100,
                            ),
                    ),
                    Positioned(
                      right: 25.0,
                      bottom: 0.0,
                      child: IconButton(
                        onPressed: () async {
                          final X = await pickImage();
                          logo = File(X.path);
                          if (await logo.exists()) {
                            setState(() {
                              logoUrl = logo.path;
                            });
                          } else {
                            showToast("Something went wrong");
                          }
                        },
                        icon: const Icon(
                          Icons.photo,
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: clubName,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter club name!";
                      } else if (!nameRegex.hasMatch(value)) {
                        return "Only Character and White Space is Allowed";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: "Club name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: clubAcronym,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter initial!";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: "Club acronym",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: clubDescription,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter club description";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.multiline,
                    minLines: null,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: "Club description",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Advisor"),
                      Checkbox(
                          value: advisor,
                          onChanged: (value) {
                            setState(() {
                              advisor = value!;

                              coAdvisor = false;
                              coAdvisor2 = false;
                            });
                          }),
                      const Text("Co-advisor"),
                      Checkbox(
                          value: coAdvisor,
                          onChanged: (value) {
                            setState(() {
                              coAdvisor = value!;
                              advisor = false;
                              coAdvisor2 = false;
                            });
                          }),
                      const Text("Co-advisor 2"),
                      Checkbox(
                          value: coAdvisor2,
                          onChanged: (value) {
                            setState(() {
                              coAdvisor2 = value!;

                              advisor = false;
                              coAdvisor = false;
                            });
                          }),
                    ],
                  ),
                  if (advisor)
                    Column(
                      children: [
                        Stack(children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              border: Border.all(),
                            ),
                            child: advisorUrl == ""
                                ? const Text(
                              "Add \nAdvisor \nImage",
                              textAlign: TextAlign.center,
                            )
                                : Image.file(
                              advisorImage,
                              fit: BoxFit.fill,
                              width: 100,
                              height: 100,
                            ),
                          ),
                          Positioned(
                            right: 25.0,
                            bottom: 0.0,
                            child: IconButton(
                              onPressed: () async {
                                final X = await pickImage();
                                advisorImage = File(X.path);
                                if (await advisorImage.exists()) {
                                  setState(() {
                                    advisorUrl = advisorImage.path;
                                  });
                                } else {
                                  showToast("Something went wrong");
                                }
                              },
                              icon: const Icon(
                                Icons.photo,
                              ),
                            ),
                          ),
                        ]),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: advisorName,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter name!";
                            } else if (!nameRegex.hasMatch(value)) {
                              return "Only Character and White Space is Allowed";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: "Advisor name",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: advisorEmail,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter your email";
                            } else if (!emailRegex.hasMatch(value)) {
                              return "Enter a valid email";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: "Advisor email",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: advisorCell,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter cell number";
                            } else if (!phoneRegex.hasMatch(value)) {
                              return "Invalid Cell Number";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: "Advisor phone number",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 8),
                  if (coAdvisor)
                    Column(
                      children: [
                        Stack(children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(border: Border.all()),
                            child: coAdvisorUrl == ""
                                ? const Text(
                              "Add \nCo-advisor 1 \nImage",
                              textAlign: TextAlign.center,
                            )
                                : Image.file(
                              coAdvisorImage1,
                              fit: BoxFit.fill,
                              width: 100,
                              height: 100,
                            ),
                          ),
                          Positioned(
                            right: 25.0,
                            bottom: 0.0,
                            child: IconButton(
                              onPressed: () async {
                                final X = await pickImage();
                                coAdvisorImage1 = File(X.path);
                                if (await coAdvisorImage1.exists()) {
                                  setState(() {
                                    coAdvisorUrl = coAdvisorImage1.path;
                                  });
                                } else {
                                  showToast("Something went wrong");
                                }
                              },
                              icon: const Icon(
                                Icons.photo,
                              ),
                            ),
                          ),
                        ]),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: coAdvisorName,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter your name!";
                            } else if (!nameRegex.hasMatch(value)) {
                              return "Only Character and White Space is Allowed";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: "Co-advisor name",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: coAdvisorEmail,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter your email";
                            } else if (!emailRegex.hasMatch(value)) {
                              return "Enter a valid email";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: "Co-advisor email",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: coAdvisorCell,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter cell number";
                            } else if (!phoneRegex.hasMatch(value)) {
                              return "Invalid Cell Number";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: "Co-advisor phone number",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  if (coAdvisor2)
                    Column(
                      children: [
                        Stack(children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(border: Border.all()),
                            child: coAdvisorUrl2 == ""
                                ? const Text(
                              "Add \nCo-advisor 2 \nImage",
                              textAlign: TextAlign.center,
                            )
                                : Image.file(
                              coAdvisorImage2,
                              fit: BoxFit.fill,
                              width: 100,
                              height: 100,
                            ),
                          ),
                          Positioned(
                            right: 25.0,
                            bottom: 0.0,
                            child: IconButton(
                              onPressed: () async {
                                final X = await pickImage();
                                coAdvisorImage2 = File(X.path);
                                if (await coAdvisorImage1.exists()) {
                                  setState(() {
                                    coAdvisorUrl2 = coAdvisorImage2.path;
                                  });
                                } else {
                                  showToast("Something went wrong");
                                }
                              },
                              icon: const Icon(
                                Icons.photo,
                              ),
                            ),
                          ),
                        ]),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: coAdvisorName1,
                          validator: (value) {
                            if (!nameRegex.hasMatch(value!)) {
                              return "Only Character and White Space is Allowed";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: "Co-advisor name",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: coAdvisorEmail1,
                          validator: (value) {
                            if (!emailRegex.hasMatch(value!)) {
                              return "Enter a valid email";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: "Co-advisor email",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: coAdvisorCell1,
                          validator: (value) {
                           if (!phoneRegex.hasMatch(value!)) {
                              return "Invalid Cell Number";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: "Co-advisor phone number",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  const Divider(),
                  Stack(children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(border: Border.all()),
                      child: presidentUrl == ""
                          ? const Text(
                        "Add \nPresident \nImage",
                        textAlign: TextAlign.center,
                      )
                          : Image.file(
                        presidentImage,
                        fit: BoxFit.fill,
                        width: 100,
                        height: 100,
                      ),
                    ),
                    Positioned(
                      right: 25.0,
                      bottom: 0.0,
                      child: IconButton(
                        onPressed: () async {
                          final X = await pickImage();
                          presidentImage = File(X.path);
                          if (await presidentImage.exists()) {
                            setState(() {
                              presidentUrl = presidentImage.path;
                            });
                          } else {
                            showToast("Something went wrong");
                          }
                        },
                        icon: const Icon(
                          Icons.photo,
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: presidentName,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter your name!";
                      } else if (!nameRegex.hasMatch(value)) {
                        return "Only Character and White Space is Allowed";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: "President Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: presidentCell,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter cell number";
                      } else if (!phoneRegex.hasMatch(value)) {
                        return "Invalid Cell Number";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: "President phone number",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const Divider(),
                  Stack(children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(border: Border.all()),
                      child: secretaryUrl == ""
                          ? const Text(
                        "Add \nSecretary \nImage",
                        textAlign: TextAlign.center,
                      )
                          : Image.file(
                        secretaryImage,
                        fit: BoxFit.fill,
                        width: 100,
                        height: 100,
                      ),
                    ),
                    Positioned(
                      right: 25.0,
                      bottom: 0.0,
                      child: IconButton(
                        onPressed: () async {
                          final X = await pickImage();
                          secretaryImage = File(X.path);
                          if (await secretaryImage.exists()) {
                            setState(() {
                              secretaryUrl = secretaryImage.path;
                            });
                          } else {
                            showToast("Something went wrong");
                          }
                        },
                        icon: const Icon(
                          Icons.photo,
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: secretaryName,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter your name!";
                      } else if (!nameRegex.hasMatch(value)) {
                        return "Only Character and White Space is Allowed";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: "Secretary Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: secretaryCell,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter cell number";
                      } else if (!phoneRegex.hasMatch(value)) {
                        return "Invalid Cell Number";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: "Secretary phone number",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      if(formKey.currentState!.validate()){

                        clubInfo['clubName'] = clubName.text.trim();
                        clubInfo['clubAcronym'] = clubAcronym.text.trim();
                        clubInfo['clubDescription'] = clubDescription.text.trim();

                        clubInfo['advisorName'] = advisorName.text.trim();
                        clubInfo['advisorCell'] = advisorCell.text.trim();
                        clubInfo['advisorEmail'] = advisorEmail.text.trim();

                        clubInfo['coAdvisorName'] = coAdvisorName.text.trim();
                        clubInfo['coAdvisorCell'] = coAdvisorCell.text.trim();
                        clubInfo['coAdvisorEmail'] = coAdvisorEmail.text.trim();

                        clubInfo['coAdvisorName1'] = coAdvisorName1.text.trim();
                        clubInfo['coAdvisorCell1'] = coAdvisorCell1.text.trim();
                        clubInfo['coAdvisorEmail1'] = coAdvisorEmail1.text.trim();

                        clubInfo['presidentName'] = presidentName.text.trim();
                        clubInfo['presidentCell'] = presidentCell.text.trim();

                        clubInfo['secretaryName'] = secretaryName.text.trim();
                        clubInfo['secretaryCell'] = secretaryCell.text.trim();

                        clubInfo['logoUrl'] = "";
                        clubInfo['advisorUrl'] = "";
                        clubInfo['coAdvisorUrl1'] = "";
                        clubInfo['coAdvisorUrl2'] = "";
                        clubInfo['presidentUrl'] = "";
                        clubInfo['secretaryUrl'] = "";

                       fireStoreService.addClubInfo(clubInfo);
                      }
                      if(logoUrl == "" || advisorUrl == "" || coAdvisorUrl == "" || presidentUrl == "" || secretaryUrl == ""){
                        showToast("Please add images");
                      }
                      else{
                        images.add(logo);
                        images.add(advisorImage);
                        images.add(coAdvisorImage1);
                        if(coAdvisorUrl2 != ""){
                          images.add( coAdvisorImage2);
                          images.add(presidentImage);
                          images.add(secretaryImage);
                        }
                        else{
                          images.add(presidentImage);
                          images.add(secretaryImage);
                        }
                        print("File Uploading");
                        await fireStoreService.uploadFile(images, clubAcronym.text.trim());
                        print("Uploading Complete");
                      }

                    },
                    child: const Text("Register"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
