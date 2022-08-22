import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:diyetin_app/app/profil-pages/analiz.dart';
import 'package:diyetin_app/common_widgets/decoration-customize.dart';
import 'package:diyetin_app/model/kilo-su-takip.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;
FirebaseAuth _auth = FirebaseAuth.instance;
TextEditingController _arananKelime = new TextEditingController();
//text elemanları
String _sonGirilenDeger = "0";
String _ilkGirilenDeger = "0";

class KiloTakip extends StatefulWidget {
  @override
  _KiloTakipState createState() => _KiloTakipState();
}

class _KiloTakipState extends State<KiloTakip> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _sonKiloDegeriniGetir();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kilo Takip"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 5 / 9,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.fromLTRB(50, 10, 40, 0),
                decoration: containerDecoration(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("Başlangıç Kilonuz : "), Text(_ilkGirilenDeger)],
                ),
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 5 / 9,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.fromLTRB(50, 10, 40, 0),
                decoration: containerDecoration(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("En Son Girinlen Kilonuz : "), Text(_sonGirilenDeger)],
                ),
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 5 / 9,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.fromLTRB(50, 10, 40, 0),
                decoration: containerDecoration(),
                child: TextField(
                  textAlign: TextAlign.center,
                  autofocus: false,
                  controller: _arananKelime,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Güncel Kilonuzu Girin",
                    //border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0), borderSide: BorderSide())),
                  ),
                ),
              ),
              RaisedButton(
                onPressed: _kayit,
                color: Colors.lightGreenAccent.shade100,
                shape: buttonShapeBorder(),
                child: Text("Kaydet"),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Analiz()));
                },
                color: Colors.lightGreenAccent.shade100,
                shape: buttonShapeBorder(),
                child: Text("Analiz Sayfasına Git"),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _kayit() async {
    String mail = _auth.currentUser.email;
    var time = formatDate(DateTime.now(), [dd, '-', mm, '-', yyyy]);
    await _firestore.collection("kilo").doc(mail).update({"$time": _arananKelime.text});
    setState(() {
      _sonGirilenDeger = _arananKelime.text;
      _arananKelime.text = "";
    });
    _sonKiloDegeriniGetir();
  }

  void _sonKiloDegeriniGetir() async {
    var dokumanlar = await _firestore.collection("kilo").doc(_auth.currentUser.email).get();
    Map<String, dynamic> map = dokumanlar.data();
    List<KiloSuTakipClass> list = map.entries.map((e) => KiloSuTakipClass(e.key, e.value)).toList();
    //listeyi tarihe göre sıralıyoruz
    _listiTariheGoreSirala(list);
  }

  void _listiTariheGoreSirala(List<KiloSuTakipClass> list) {
    List<String> list1 = [];
    List<String> list2 = [];
    for (int i = 0; i < list.length; i++) {
      list1 = list[i].tarih.split("-");
      for (int j = i + 1; j < list.length; j++) {
        list2 = list[j].tarih.split("-");
        if (int.parse(list1[2]) > int.parse(list2[2])) {
          var swap = list[j];
          list[j] = list[i];
          list[i] = swap;
          list1 = list[i].tarih.split("-");
          list2 = list[j].tarih.split("-");
        } else {
          if (int.parse(list1[1]) > int.parse(list2[1]) && int.parse(list1[2]) >= int.parse(list2[2])) {
            var swap = list[j];
            list[j] = list[i];
            list[i] = swap;
            list1 = list[i].tarih.split("-");
            list2 = list[j].tarih.split("-");
          } else {
            if (int.parse(list1[0]) > int.parse(list2[0]) &&
                int.parse(list1[1]) >= int.parse(list2[1]) &&
                int.parse(list1[2]) >= int.parse(list2[2])) {
              var swap = list[j];
              list[j] = list[i];
              list[i] = swap;
              list1 = list[i].tarih.split("-");
              list2 = list[j].tarih.split("-");
            }
          }
        }
      }
    }
    setState(() {
      _sonGirilenDeger = list[list.length - 1].deger;
      _ilkGirilenDeger = list[0].deger;
    });
  }
}
