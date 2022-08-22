import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diyetin_app/common_widgets/decoration-customize.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;
TextEditingController _arananBaslik = new TextEditingController();
TextEditingController _arananIcerik = new TextEditingController();

class FaydaliTarifEkle extends StatefulWidget {
  @override
  _FaydaliTarifEkleState createState() => _FaydaliTarifEkleState();
}

class _FaydaliTarifEkleState extends State<FaydaliTarifEkle> {
  File _image;
  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Faydali Tarif Ekle"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 15),
                padding: EdgeInsets.only(left: 15, right: 10),
                decoration: containerDecoration(),
                child: TextField(
                  autofocus: false,
                  controller: _arananBaslik,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Tarifin İsmini Giriniz",
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15, bottom: 10),
                padding: EdgeInsets.only(left: 15, right: 10),
                decoration: containerDecoration(),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  autofocus: false,
                  controller: _arananIcerik,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Tarifin İçeriğini Giriniz",
                  ),
                ),
              ),
              RaisedButton(
                onPressed: getImage,
                color: Colors.lightGreenAccent.shade100,
                shape: buttonShapeBorder(),
                child: Text("Resim Seç"),
              ),
              Center(
                child: _image == null ? Image.asset("images/asd.jpg") : Image.file(_image),
              ),
              SizedBox(
                height: 15,
              ),
              RaisedButton(
                onPressed: _tarifKayit,
                color: Colors.lightGreenAccent.shade100,
                shape: buttonShapeBorder(),
                child: Text("Tarifi Kaydet"),
              ),
              SizedBox(
                height: 150,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _tarifKayit() async {
    var ref = FirebaseStorage.instance.ref().child("tarifler").child(_arananBaslik.text);
    var donus = await ref.putFile(_image);

    final Directory systemTempDir = Directory.systemTemp;
    final File tempFile = File('${systemTempDir.path}/temp-${ref.name}');
    if (tempFile.existsSync()) await tempFile.delete();

    await ref.writeToFile(tempFile);
    String downloadURL = await FirebaseStorage.instance.ref(donus.ref.fullPath).getDownloadURL();
    await _firestore
        .collection("tarifler")
        .add({"baslik": _arananBaslik.text, "icerik": _arananIcerik.text, "indirmeLinki": downloadURL});
    _arananIcerik.text = "";
    _arananBaslik.text = "";
    _image.delete();
    Navigator.pop(context);

    //if(donus.)
    /*var ref = FirebaseStorage.instance.ref().child("user").child("hasan").child("profil.png");
    StorageUploadTask uploadTask = ref.putFile(File(_image.path));

    var url = await (await uploadTask.onComplete).ref.getDownloadURL();
    debugPrint("upload edilen resmin urlsi : " + url);*/
  }
}
