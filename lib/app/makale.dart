import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diyetin_app/app/makale-detay.dart';
import 'package:diyetin_app/app/profil-pages/farkli-tasarim.dart';
import 'package:diyetin_app/model/makale-model.dart';
import 'package:diyetin_app/routes/fadein-fadeout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;
List<Makale> _list = new List<Makale>();
List<Makale> _list1 = [
  Makale("Çok Önemli Konuasdasdasdas asdsadasdasd asdasdsad asdasdsa", "gelenIcerik"),
  Makale("O Kadar Önemli Değil", "gelenIcerik"),
  Makale("Olsada Olur", "gelenIcerik"),
  Makale("Çok Önemli Konu", "gelenIcerik"),
  Makale("O Kadar Önemli Değil", "gelenIcerik"),
  Makale("Olsada Olur", "gelenIcerik"),
  Makale("Çok Önemli Konu", "gelenIcerik"),
  Makale("O Kadar Önemli Değil", "gelenIcerik"),
  Makale("Olsada Olur", "gelenIcerik"),
  Makale("Çok Önemli Konu", "gelenIcerik"),
  Makale("O Kadar Önemli Değil", "gelenIcerik"),
  Makale("Olsada Olur", "gelenIcerik"),
];

class MakalePage extends StatefulWidget {
  @override
  _MakalePageState createState() => _MakalePageState();
}

class _MakalePageState extends State<MakalePage> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animationGreen;
  Animation animationLime;
  Animation animationSize;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _makaleleriGetir();
    controller = AnimationController(duration: Duration(seconds: 2), vsync: this);
    controller.addListener(() {
      setState(() {});
    });

    animationGreen = ColorTween(begin: Colors.white, end: Colors.lightGreenAccent).animate(controller);
    animationLime = ColorTween(begin: Colors.white, end: Colors.limeAccent).animate(controller);
    animationSize = CurvedAnimation(parent: controller, curve: Curves.linear);
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Keşfet"),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
              size: 30,
            ),
            tooltip: 'Profil Ayarları',
            onPressed: () {
              Navigator.push(context, FadeInFadeOutRoute(builder: (context) => FarliProfilTasarimi()));
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              child: Image.asset(
                "images/logo_makale2.gif",
                fit: BoxFit.cover,
              ),
              width: MediaQuery.of(context).size.width,
            ),
            Expanded(
                child: ListView.builder(
              itemCount: _list.length,
              itemBuilder: (BuildContext context, int index) {
                return _cardOlustur(_list[index], index);
              },
            ))
          ],
        ),
      ),
    );
  }

  void _makaleleriGetir() {
    _list.clear();
    _firestore.collection("makale").get().then((querySnapshots) {
      debugPrint("Koleksiyonundaki Eleman Sayısı: " + querySnapshots.docs.length.toString());
      for (int i = 0; i < querySnapshots.docs.length; i++) {
        String baslik = querySnapshots.docs[i]['baslik'].toString();
        String icerik = querySnapshots.docs[i]['icerik'].toString();
        Makale makale = new Makale(baslik, icerik);
        setState(() {
          _list.add(makale);
        });
      }
    });
  }

  Widget _cardOlustur(Makale makale, int index) {
    return Container(
      decoration: index % 2 == 0
          ? BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.center,
                  colors: [animationGreen.value, animationLime.value],
                  tileMode: TileMode.mirror))
          : BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.center,
                  colors: [animationLime.value, animationGreen.value],
                  tileMode: TileMode.mirror)),
      child: Card(
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Center(
          child: ListTile(
            title: makale.baslik.length > 35
                ? Center(
                    child: Text(
                      makale.baslik.substring(0, (animationSize.value * 35).toInt()) + " ...",
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                : Center(
                    child: Text(
                      makale.baslik.substring(0, (animationSize.value * makale.baslik.length).toInt()),
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
            trailing: GestureDetector(
              child: Icon(
                Icons.arrow_forward,
                color: Colors.black,
              ),
              onTap: () {
                //_secilenElemanGoster(index);
                Navigator.push(context, MaterialPageRoute(builder: (context) => MakaleDetay(makale: makale)));
              },
            ),
          ),
        ),
      ),
    );
  }

  void _launchURL() async {
    const url = 'https://bandevsoft.com/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
