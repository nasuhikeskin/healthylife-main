import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:diyetin_app/model/besinv2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;
FirebaseAuth _auth = FirebaseAuth.instance;

class KaloriDetayV2 extends StatefulWidget {
  final BesinV2 besin;
  KaloriDetayV2({Key key, @required this.besin}) : super(key: key);
  @override
  _KaloriDetayV2State createState() => _KaloriDetayV2State();
}

class _KaloriDetayV2State extends State<KaloriDetayV2> with SingleTickerProviderStateMixin {
  String dropdownValue = 'Sabah';
  AnimationController controller;
  Animation animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    controller.addListener(() {
      setState(() {});
    });
    animation = CurvedAnimation(parent: controller, curve: Curves.linear);
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
        title: Text(widget.besin.isim),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10),
              height: animation.value * (MediaQuery.of(context).size.height / 4),
              width: animation.value * (MediaQuery.of(context).size.width - 40),
              decoration:
                  BoxDecoration(image: DecorationImage(image: NetworkImage(widget.besin.resim), fit: BoxFit.cover)),
              //child: Image.network(widget.besin.resim),
            ),
            animation.isCompleted
                ? Card(
                    elevation: 8,
                    child: Container(
                      margin: EdgeInsets.only(top: 15, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text("Protein"),
                              SizedBox(
                                height: 10,
                              ),
                              Text(widget.besin.protein + " g")
                            ],
                          ),
                          Column(
                            children: [
                              Text("Karbonhidrat"),
                              SizedBox(
                                height: 10,
                              ),
                              Text(widget.besin.karbonhidrat + " g")
                            ],
                          ),
                          Column(
                            children: [
                              Text("Yağ"),
                              SizedBox(
                                height: 10,
                              ),
                              Text(widget.besin.yag + " g")
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                : Text(""),
            animation.isCompleted
                ? Card(
                    elevation: 8,
                    child: Container(
                      margin: EdgeInsets.only(top: 15, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text("kalori (100 g)"),
                              SizedBox(
                                height: 10,
                              ),
                              Text(widget.besin.kaloriGram + " kcal")
                            ],
                          ),
                          Column(
                            children: [
                              Text("kalori (porsiyon)"),
                              SizedBox(
                                height: 10,
                              ),
                              Text(widget.besin.kaloriPorsiyon + " kcal")
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                : Text(""),
            Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DropdownButton<String>(
                    value: dropdownValue,
                    //underline: SizedBox(),
                    icon: Icon(Icons.arrow_downward),
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValue = newValue;
                      });
                    },
                    items:
                        <String>['Sabah', 'Öğlen', 'Akşam', 'Ara Öğün'].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 15),
                        ),
                      );
                    }).toList(),
                  ),
                  GestureDetector(
                    onTap: _yolla,
                    child: CircleAvatar(
                      child: Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                      backgroundColor: Colors.lightGreenAccent.shade200,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _yolla() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Scaffold(
                  appBar: AppBar(),
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                )));
    var time = formatDate(DateTime.now(), [dd, '-', mm, '-', yyyy]);
    DocumentSnapshot documentsnapchot = await _firestore.collection("gunlukkalori").doc(_auth.currentUser.email).get();
    if (documentsnapchot.data()[time] == null) {
      Map<String, dynamic> gunlukKaloriEkle = Map();
      gunlukKaloriEkle["Sabah"] = [];
      gunlukKaloriEkle["Öğlen"] = [];
      gunlukKaloriEkle["Akşam"] = [];
      gunlukKaloriEkle["Ara Öğün"] = [];
      gunlukKaloriEkle["Toplam"] = "0";

      List<dynamic> list = gunlukKaloriEkle[dropdownValue];
      list.add(widget.besin.isim);
      gunlukKaloriEkle[dropdownValue] = list;

      int toplam = int.parse(gunlukKaloriEkle["Toplam"]);
      toplam += int.parse(widget.besin.kaloriGram);
      gunlukKaloriEkle["Toplam"] = toplam.toString();

      await _firestore.collection("gunlukkalori").doc(_auth.currentUser.email).update({time: gunlukKaloriEkle});
    } else {
      Map<String, dynamic> gunlukKaloriEkle = Map();
      gunlukKaloriEkle = documentsnapchot.data()[time];
      List<dynamic> list = gunlukKaloriEkle[dropdownValue];
      list.add(widget.besin.isim);
      gunlukKaloriEkle[dropdownValue] = list;

      int toplam = int.parse(gunlukKaloriEkle["Toplam"]);
      toplam += int.parse(widget.besin.kaloriGram);
      gunlukKaloriEkle["Toplam"] = toplam.toString();

      await _firestore.collection("gunlukkalori").doc(_auth.currentUser.email).update({time: gunlukKaloriEkle});
    }
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context);
    });
  }
}
