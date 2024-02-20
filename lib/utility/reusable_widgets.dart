import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';


  InputDecoration textInputDecoration(String hintText, IconData icon) {
    InputDecoration inputDecoration = InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(icon, color: Colors.black),
      border: const OutlineInputBorder()
    );
    return inputDecoration;
  }

  TextStyle txtStyle(double fontSize, FontWeight fontWeight){
    TextStyle textStyle = GoogleFonts.lato(
      fontSize: fontSize,
      fontWeight: fontWeight
    );
    return textStyle;
  }

  ButtonStyle elevated() {
    ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
      elevation: 10,

      minimumSize: const Size(250, 50),
      textStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );

    
    return elevatedButtonStyle;
  }

Future<bool?> showToast(String message){
    return Fluttertoast.showToast(msg: message);
}