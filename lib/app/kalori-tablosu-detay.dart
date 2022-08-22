import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:diyetin_app/common_widgets/decoration-customize.dart';
import 'package:diyetin_app/model/besin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;
FirebaseAuth _auth = FirebaseAuth.instance;

class KaloriDetayTablosu extends StatefulWidget {
  final Besin besin;
  KaloriDetayTablosu({Key key, @required this.besin}) : super(key: key);

  @override
  _KaloriDetayTablosuState createState() => _KaloriDetayTablosuState();
}

class _KaloriDetayTablosuState extends State<KaloriDetayTablosu> {
  String dropdownValue = 'Sabah';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.besin.isim),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 20),
              height: MediaQuery.of(context).size.height / 4,
              color: Colors.amberAccent,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: containerDecoration(),
                  child: Center(
                    child: Text("Protein"),
                  ),
                ),
                Container(
                  height: 100,
                  width: 100,
                  decoration: containerDecoration(),
                  child: Center(
                    child: Text("Karbonhidrat"),
                  ),
                ),
                Container(
                  height: 100,
                  width: 100,
                  decoration: containerDecoration(),
                  child: Center(
                    child: Text("Yağ"),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [Text("Porsiyon"), Text(widget.besin.kalori + " kcal")],
            ),
            SizedBox(
              height: 20,
            ),
            DropdownButton<String>(
              value: dropdownValue,
              icon: Icon(Icons.access_alarm),
              elevation: 16,
              onChanged: (String newValue) {
                setState(() {
                  dropdownValue = newValue;
                });
              },
              items: <String>['Sabah', 'Öğlen', 'Akşam', 'Gece'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            RaisedButton(
              onPressed: () {
                _showMyDialog(context, dropdownValue, widget.besin);
              },
              shape: buttonShapeBorder(),
              color: Colors.lightGreenAccent,
              child: Text("Ekle"),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog(BuildContext context, String deger, Besin besin) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text("gisim"),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("porsiyon miktarı : " + "gporsiyon"),
                Text("kalori miktarı : " + "gkalori"),
                Text(deger),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Yoksay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Ekle'),
              onPressed: () {
                _gunlukKaloriEkle(besin, deger);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _gunlukKaloriEkle(Besin besin, String deger) {
    var time = formatDate(DateTime.now(), [dd, '-', mm, '-', yyyy]);
    String bilgi = "$deger : " + besin.isim;
    Map<String, dynamic> gunlukKalori = Map();
    gunlukKalori['Sabah'] = ["yumurta", "ekmek", "çay", "tereyağ"];
    gunlukKalori['Öğle'] = ["lahmacun", "ayran"];
    gunlukKalori['Akşam'] = ["çorba", "pilav", "sulu yemek", "salata", "hoşaf"];
    gunlukKalori['Toplam'] = 1450;

    _firestore.collection("gunlukkalori").doc(_auth.currentUser.email).update({time: gunlukKalori});
  }
}
