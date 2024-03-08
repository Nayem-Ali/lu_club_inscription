import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lu_club_inscription/section/functionality/admin/club_details.dart';
import '../../../db_services/firebase.dart';
import '../../../utility/reusable_widgets.dart';

class EditClubData extends StatefulWidget {
  dynamic clubDetails = {};

  EditClubData({Key? key, required this.clubDetails}) : super(key: key);

  @override
  State<EditClubData> createState() => _EditClubDataState();
}

class _EditClubDataState extends State<EditClubData> {
  FireStoreService fireStoreService = FireStoreService();
  bool advisor = false;
  bool coAdvisor = false;
  bool coAdvisor2 = false;

  dynamic clubInfo = {};
  List<File> images = [];

  final phoneRegex = RegExp(r'^01[3-9][0-9]{8}$');
  final nameRegex = RegExp(r'^[a-zA-Z]+ [a-zA-Z]+( [a-zA-Z]+)?( [a-zA-Z]+)?( [a-zA-Z]+)?$');
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setData();
  }

  setData() {
    setState(() {
      clubInfo = widget.clubDetails;
      clubName.text = clubInfo['clubName'];
      clubAcronym.text = clubInfo['clubAcronym'];
      clubDescription.text = clubInfo['clubDescription'];
      advisorName.text = clubInfo['advisorName'];
      advisorEmail.text = clubInfo['advisorEmail'];
      advisorCell.text = clubInfo['advisorCell'];
      coAdvisorName.text = clubInfo['coAdvisorName'];
      coAdvisorEmail.text = clubInfo['coAdvisorEmail'];
      coAdvisorCell.text = clubInfo['coAdvisorCell'];
      coAdvisorName1.text = clubInfo['coAdvisorName1'];
      coAdvisorEmail1.text = clubInfo['coAdvisorEmail1'];
      coAdvisorCell1.text = clubInfo['coAdvisorCell1'];
      presidentName.text = clubInfo['presidentName'];
      presidentCell.text = clubInfo['presidentCell'];
      secretaryName.text = clubInfo['secretaryName'];
      secretaryCell.text = clubInfo['secretaryCell'];
    });
  }

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
        appBar: AppBar(
          title: const Text("Update Club Details"),
        ),
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
                          ? Image.network(clubInfo['logoUrl'])
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
                            await fireStoreService.updatePhoto(
                                logo, clubAcronym.text.trim(), "logoUrl", "logo");
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
                                ? Image.network(clubInfo['advisorUrl'])
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
                                  await fireStoreService.updatePhoto(advisorImage,
                                      clubAcronym.text.trim(), "advisorUrl", "advisor");
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
                                ? Image.network(clubInfo['coAdvisorUrl1'])
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
                                  await fireStoreService.updatePhoto(coAdvisorImage1,
                                      clubAcronym.text.trim(), "coAdvisorUrl1", "coAdvisor1");
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
                                ? Image.network(clubInfo['coAdvisorUrl2'])
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
                                if (await coAdvisorImage2.exists()) {
                                  setState(() {
                                    coAdvisorUrl2 = coAdvisorImage2.path;
                                  });
                                  await fireStoreService.updatePhoto(coAdvisorImage2,
                                      clubAcronym.text.trim(), "coAdvisorUrl2", "coAdvisor2");
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
                          ? Image.network(clubInfo['presidentUrl'])
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
                            await fireStoreService.updatePhoto(presidentImage, clubAcronym.text
                                .trim(),
                                "presidentUrl", "president");
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
                          ? Image.network(clubInfo['secretaryUrl'])
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
                            await fireStoreService.updatePhoto(secretaryImage, clubAcronym.text
                                .trim(),
                                "secretaryUrl", "secretary");
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
                      if (formKey.currentState!.validate()) {
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
                        //
                        // clubInfo['logoUrl'] = "";
                        // clubInfo['advisorUrl'] = "";
                        // clubInfo['coAdvisorUrl1'] = "";
                        // clubInfo['coAdvisorUrl2'] = "";
                        // clubInfo['presidentUrl'] = "";
                        // clubInfo['secretaryUrl'] = "";

                        await fireStoreService.updateClubInfo(clubInfo);
                        Get.off(() => const ClubDetails());

                      }
                      // if (logoUrl == "" ||
                      //     advisorUrl == "" ||
                      //     coAdvisorUrl == "" ||
                      //     presidentUrl == "" ||
                      //     secretaryUrl == "") {
                      //
                      //   // clubInfo['logoUrl'] = "";
                      //   // clubInfo['advisorUrl'] = "";
                      //   // clubInfo['coAdvisorUrl1'] = "";
                      //   // clubInfo['coAdvisorUrl2'] = "";
                      //   // clubInfo['presidentUrl'] = "";
                      //   // clubInfo['secretaryUrl'] = "";
                      //
                      //   showToast("Please add images");
                      // } else {
                      //   images.add(logo);
                      //   images.add(advisorImage);
                      //   images.add(coAdvisorImage1);
                      //   if (coAdvisorUrl2 != "") {
                      //     // print("COADVISOR2");
                      //     images.add(coAdvisorImage2);
                      //     images.add(presidentImage);
                      //     images.add(secretaryImage);
                      //   } else {
                      //     images.add(presidentImage);
                      //     images.add(secretaryImage);
                      //   }
                      //   print("File Uploading");
                      //   print(images.length);
                      //   await uploadFile(images, clubAcronym.text.trim());
                      //   print("Uploading Complete");
                      //   images.clear();
                      //
                      //}
                    },
                    child: const Text("Update"),
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
