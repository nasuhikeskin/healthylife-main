import 'package:flutter/material.dart';

//özel container border yapısı
containerDecoration() {
  return BoxDecoration(borderRadius: BorderRadius.circular(40), border: Border.all(color: Colors.green));
}

//profil page için container decoration
containerProfilDecoration() {
  return BoxDecoration(
      color: Colors.lightGreenAccent.shade200,
      borderRadius: BorderRadius.circular(90),
      border: Border.all(color: Colors.black));
}

//geçişli renk container
containerGradientRenk() {
  return BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.center,
          colors: [Colors.lightGreenAccent, Colors.yellowAccent],
          tileMode: TileMode.mirror),
      borderRadius: BorderRadius.circular(90),
      border: Border.all(color: Colors.black));
}

//özel button shape yapısı
buttonShapeBorder() {
  return new RoundedRectangleBorder(
    borderRadius: new BorderRadius.circular(30.0),
  );
}

//özel textfield border yapısı
textFieldBorder() {
  return OutlineInputBorder(borderRadius: BorderRadius.circular(25.0), borderSide: BorderSide());
}
