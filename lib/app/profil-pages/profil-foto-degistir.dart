import 'dart:io';

import 'package:diyetin_app/common_widgets/decoration-customize.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilFotoDegistir extends StatefulWidget {
  @override
  _ProfilFotoDegistirState createState() => _ProfilFotoDegistirState();
}

class _ProfilFotoDegistirState extends State<ProfilFotoDegistir> {
  File _profilFoto;
  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil Foto Değiştir"),
      ),
      body: Container(
        margin: EdgeInsets.all(25),
        child: Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 75,
                backgroundColor: Colors.white,
                backgroundImage: _profilFoto == null ? AssetImage("images/asd.jpg") : FileImage(_profilFoto),
              ),
              SizedBox(
                height: 30,
              ),
              RaisedButton(
                onPressed: _galeridenResimSec,
                child: Text("Resmi Değiştir"),
                color: Colors.lightGreenAccent.shade100,
                shape: buttonShapeBorder(),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _galeridenResimSec() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _profilFoto = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
}
