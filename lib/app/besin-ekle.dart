import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diyetin_app/common_widgets/decoration-customize.dart';
import 'package:flutter/material.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;
TextEditingController _isim = new TextEditingController();
TextEditingController _kalorigram = new TextEditingController();
TextEditingController _kaloriporsiyon = new TextEditingController();
TextEditingController _protein = new TextEditingController();
TextEditingController _karbonhidrat = new TextEditingController();
TextEditingController _yag = new TextEditingController();
TextEditingController _resim = new TextEditingController();

class BesinEklePage extends StatefulWidget {
  @override
  _BesinEklePageState createState() => _BesinEklePageState();
}

class _BesinEklePageState extends State<BesinEklePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Besin Ekle"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 15),
              padding: EdgeInsets.only(left: 15, right: 10),
              decoration: containerDecoration(),
              child: TextField(
                autofocus: false,
                controller: _isim,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "İsim",
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              padding: EdgeInsets.only(left: 15, right: 10),
              decoration: containerDecoration(),
              child: TextField(
                autofocus: false,
                keyboardType: TextInputType.number,
                controller: _kalorigram,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "kalori (gram)",
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              padding: EdgeInsets.only(left: 15, right: 10),
              decoration: containerDecoration(),
              child: TextField(
                autofocus: false,
                keyboardType: TextInputType.number,
                controller: _kaloriporsiyon,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "kalori (porsiyon)",
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              padding: EdgeInsets.only(left: 15, right: 10),
              decoration: containerDecoration(),
              child: TextField(
                autofocus: false,
                keyboardType: TextInputType.number,
                controller: _protein,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "protein",
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              padding: EdgeInsets.only(left: 15, right: 10),
              decoration: containerDecoration(),
              child: TextField(
                autofocus: false,
                keyboardType: TextInputType.number,
                controller: _karbonhidrat,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "karbonhidrat",
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              padding: EdgeInsets.only(left: 15, right: 10),
              decoration: containerDecoration(),
              child: TextField(
                autofocus: false,
                keyboardType: TextInputType.number,
                controller: _yag,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "yağ",
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              padding: EdgeInsets.only(left: 15, right: 10),
              decoration: containerDecoration(),
              child: TextField(
                autofocus: false,
                controller: _resim,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "resim",
                ),
              ),
            ),
            RaisedButton(
              onPressed: _kaydet,
              color: Colors.tealAccent,
              shape: buttonShapeBorder(),
              child: Text("kaydet"),
            )
          ],
        ),
      ),
    );
  }

  void _kaydet() async {
    Map<String, dynamic> besin = Map();
    besin = {
      "kalorigram": _kalorigram.text,
      "kaloriporsiyon": _kaloriporsiyon.text,
      "protein": _protein.text,
      "karbonhidrat": _karbonhidrat.text,
      "yağ": _yag.text,
      "resim": _resim.text
    };
    await _firestore.collection("besin").doc("besinler").update({_isim.text: besin});
    _isim.text = "";
    _kalorigram.text = "";
    _kaloriporsiyon.text = "";
    _protein.text = "";
    _karbonhidrat.text = "";
    _yag.text = "";
    _resim.text = "";
    Navigator.pop(context);
  }
}
