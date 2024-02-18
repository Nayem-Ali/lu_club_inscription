import 'package:flutter/material.dart';

class MemberRegistration extends StatefulWidget {
  const MemberRegistration({Key? key}) : super(key: key);

  @override
  State<MemberRegistration> createState() => _MemberRegistrationState();
}

class _MemberRegistrationState extends State<MemberRegistration> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Event Registration"),
      ),
    );
  }
}
