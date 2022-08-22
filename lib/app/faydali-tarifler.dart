import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diyetin_app/app/faydali-tarif-ekle.dart';
import 'package:diyetin_app/app/faydali-tarifler-detay.dart';
import 'package:diyetin_app/model/tarif.dart';
import 'package:diyetin_app/routes/fadein-fadeout.dart';
import 'package:flutter/material.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;
List<Tarif> _listTarif = new List<Tarif>();
List<String> _list = [
  "tarif 1",
  "tarif 2",
  "tarif 3",
  "tarif 4",
  "tarif 5",
  "tarif 6",
  "tarif 7",
  "tarif 8",
  "tarif 9",
  "tarif 10",
  "tarif 11",
  "tarif 12",
  "tarif 13",
  "tarif 14",
  "tarif 15"
];

class FaydaliTarifler extends StatefulWidget {
  @override
  _FaydaliTariflerState createState() => _FaydaliTariflerState();
}

class _FaydaliTariflerState extends State<FaydaliTarifler> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _veriGetir();
    controller = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
    );
    controller.addListener(() {
      setState(() {});
    });
    animation = CurvedAnimation(parent: controller, curve: Curves.easeInOutExpo);
    controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller.forward();
    Widget _widgetOlustur(Tarif tarif) {
      return GestureDetector(
        onTap: () {
          Navigator.push(context, FadeInFadeOutRoute(builder: (context) => TarifDetay(yemekTarifi: tarif)));
        },
        child: Container(
          height: 80,
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(tarif.resim), fit: BoxFit.cover)),
          child: Center(
            child: Text(
              tarif.isim,
              style: TextStyle(fontSize: animation.value * 20, color: Colors.white),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Faydalı Tarifler"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => FaydaliTarifEkle()));
        },
        backgroundColor: Colors.lightGreenAccent,
        child: Icon(
          Icons.add,
          size: 30,
          color: Colors.black,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: Container(
        margin: EdgeInsets.only(top: 30),
        child: _listTarif.length == 0
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: _listTarif.length,
                itemBuilder: (BuildContext context, int index) {
                  return _widgetOlustur(_listTarif[index]);
                },
              ),
      ),
    );
  }

  void _veriGetir() async {
    _listTarif.clear();
    _firestore.collection("tarifler").get().then((querySnapshots) {
      debugPrint("Koleksiyonundaki Eleman Sayısı: " + querySnapshots.docs.length.toString());
      for (int i = 0; i < querySnapshots.docs.length; i++) {
        String isim = querySnapshots.docs[i]['baslik'].toString();
        String tarif = querySnapshots.docs[i]['icerik'].toString();
        String resim = querySnapshots.docs[i]['indirmeLinki'].toString();
        Tarif trf = new Tarif(isim, tarif, resim);
        setState(() {
          _listTarif.add(trf);
        });
      }
    });
  }
}
