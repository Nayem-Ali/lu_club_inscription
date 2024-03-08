import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class Logo extends StatelessWidget {
  
  final double height;
  final double width;
  final double fontSize;

  const Logo({
    super.key,
    required this.height,
    required this.width,
    required this.fontSize
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image(
          image: const AssetImage("images/logo.png"),
          height: height,
          width: width,
        ),
        Text("LU Club Inscription",
          style: GoogleFonts.lato(
            color: Colors.teal.shade700,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            letterSpacing: 2
          ),
        ),
      ],
    );
  }
}
