import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:diyetin_app/app/profil-pages/analiz.dart';
import 'package:diyetin_app/common_widgets/decoration-customize.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;
FirebaseAuth _auth = FirebaseAuth.instance;
String mail = _auth.currentUser.email;
var time = formatDate(DateTime.now(), [dd, '-', mm, '-', yyyy]);
//text işlemleri
String _eklenecekDeger = "0.0";
String _gunlukSuDegeri = "0.0";
TextEditingController _arananKelime = new TextEditingController();

class SuTakip extends StatefulWidget {
  @override
  _SuTakipState createState() => _SuTakipState();
}

class _SuTakipState extends State<SuTakip> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _gunlukSuDegeriGetir();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Su Takip"),
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
                  children: [Text("Günlük Hedefiniz :"), Text("3.4 lt")],
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
                  children: [
                    Text("Bugünkü Değeriniz :"),
                    Text(_gunlukSuDegeri == "null" ? "0.0 lt" : "$_gunlukSuDegeri lt")
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      _arananKelime.text = "";
                      _eklenecekDegerHesapla(0.2);
                    },
                    child: Container(
                      //height: 50,
                      width: MediaQuery.of(context).size.width * 4 / 18,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.fromLTRB(50, 10, 5, 0),
                      decoration: containerDecoration(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image(
                            height: 50,
                            image: NetworkImage(
                                "https://cdn03.ciceksepeti.com/cicek/kc708353-1/XL/lav-liberty-su-bardak---su-mesrubat-bardagi-6-li-lbr320-kc708353-1-80e1a707298d4eb999d23c07a5f83d0b.jpg"),
                          ),
                          Text("0.2 lt")
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _arananKelime.text = "";
                      _eklenecekDegerHesapla(0.5);
                    },
                    child: Container(
                      //height: 50,
                      width: MediaQuery.of(context).size.width * 4 / 18,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.fromLTRB(5, 10, 40, 0),
                      decoration: containerDecoration(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image(
                            height: 50,
                            image: NetworkImage(
                                "https://images.ofix.com/product-image/Erikli-Su-500-Ml-12-Li-Paket_RI23495FT1MF130547.jpg"),
                          ),
                          Text("0.5 lt")
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 5 / 9,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.fromLTRB(50, 10, 40, 0),
                decoration: containerDecoration(),
                child: TextField(
                  onChanged: (text) {
                    _eklenecekDegerHesapla(double.parse(text));
                  },
                  textAlign: TextAlign.center,
                  autofocus: false,
                  controller: _arananKelime,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "El ile Giriş (litre)",
                    //border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0), borderSide: BorderSide())),
                  ),
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
                  children: [Text("Eklenecek Değer :"), Text(_eklenecekDeger + " lt")],
                ),
              ),
              RaisedButton(
                onPressed: _veriEkle,
                color: Colors.lightGreenAccent.shade100,
                shape: buttonShapeBorder(),
                child: Text("Ekle"),
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

  void _eklenecekDegerHesapla(double eklenecekDeger) {
    setState(() {
      _eklenecekDeger = eklenecekDeger.toStringAsFixed(1);
    });
  }

  void _veriEkle() async {
    //ne kadar su içtiğini anlamak için
    DocumentSnapshot documentSnapshot = await _firestore.doc("su/$mail").get();
    var gelenSuMiktari = documentSnapshot.data()[time].toString();
    gelenSuMiktari == "null" ? _gunlukSuDegeri = "0.0" : _gunlukSuDegeri = gelenSuMiktari;
    double toplam = double.parse(_gunlukSuDegeri) + double.parse(_eklenecekDeger);
    await _firestore.collection("su").doc(mail).update({"$time": toplam.toStringAsFixed(1)});

    setState(() {
      _gunlukSuDegeri = toplam.toStringAsFixed(1);
      _arananKelime.text = "";
      _eklenecekDeger = "0.0";
    });
  }

  void _gunlukSuDegeriGetir() async {
    DocumentSnapshot documentSnapshot = await _firestore.doc("su/$mail").get();
    var gelenSuMiktari = documentSnapshot.data()[time].toString();
    setState(() {
      _gunlukSuDegeri = gelenSuMiktari;
    });
  }
}
