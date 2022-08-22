import 'package:flutter/material.dart';

class SocialTextField extends StatelessWidget {
  final String hintText;
  final TextAlign textAlign;
  final bool otoFocus;

  const SocialTextField(
      {@required this.hintText,
      this.textAlign: TextAlign.center,
      this.otoFocus: false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      child: TextField(
        textAlign: textAlign,
        autofocus: otoFocus,
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.greenAccent),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide())),
      ),
    );
  }
}
