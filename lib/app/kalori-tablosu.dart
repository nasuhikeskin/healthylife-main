import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diyetin_app/app/kalori-tablosu-detay.dart';
import 'package:diyetin_app/model/besin.dart';
import 'package:flutter/material.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;
List<Besin> list = new List<Besin>();
List<Besin> list1 = [
  Besin("domates", "100"),
  Besin("biber", "200"),
  Besin("patlıcan", "150"),
  Besin("soğan", "100"),
  Besin("maydonoz", "200"),
  Besin("pırasa", "150"),
  Besin("kereviz", "100"),
  Besin("brokoli", "200"),
  Besin("salatalık", "150"),
  Besin("kara hindiba", "100"),
  Besin("kıvırcık", "200"),
  Besin("turp", "150")
];
List<Besin> listBesin = new List<Besin>();

TextEditingController _arananKelime = new TextEditingController();

class KaloriListPage extends StatefulWidget {
  @override
  _KaloriListPageState createState() => _KaloriListPageState();
}

class _KaloriListPageState extends State<KaloriListPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _kaloriGetir();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kalori Tablosu"),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              height: 100,
              margin: EdgeInsets.only(left: 5, right: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      child: TextFormField(
                    onTap: () {
                      //listArama.clear();
                    },
                    onChanged: (text) {
                      _doIt();
                    },
                    autofocus: false,
                    //textAlign: TextAlign.center,
                    controller: _arananKelime,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: "Aranacak Ürünü Girin",
                        border:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(25.0), borderSide: BorderSide())),
                    //onSaved: (deger) => currentKilo = deger,
                  )),
                ],
              ),
            ),
            Divider(
              thickness: 2,
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: _itemCountHesapla(),
                    itemBuilder: (BuildContext context, int index) {
                      if (listBesin.length == 0 && _arananKelime.text.length != 0)
                        return elemanBulunamadi();
                      else if (listBesin.length == 0)
                        return listElemaniEkle(list[index].isim, list[index].kalori, index);
                      else
                        return listElemaniEkle(listBesin[index].isim, listBesin[index].kalori, index);
                    }))
          ],
        ),
      ),
    );
  }

  void _kaloriGetir() async {
    list.clear();
    for (int z = 0; z < 50; z++) {
      DocumentSnapshot documentSnapshot = await _firestore.doc("yemekler/yemeklers").get();
      documentSnapshot.data().forEach((key, deger) {
        Besin besin = new Besin(key, deger);
        setState(() {
          list.add(besin);
        });
      });
    }
    print("+++++++++++++++++++++++++++++" + list.length.toString() + "++++++++++++++++++++++++++++++++");
  }

  Widget listElemaniEkle(String isim, String kalori, int index) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => KaloriDetayTablosu(besin: list[index])));
          },
          leading: Icon(Icons.fastfood),
          title: Text(isim),
          trailing: Text(kalori + " kcal"),
        ),
        Divider(
          thickness: 2,
        )
      ],
    );
  }

  void _doIt() async {
    String arananKelime = _arananKelime.text;
    /*var dokumanlar = await _firestore.collection("yemekler").doc("yemeklers").get();
    final Map<dynamic, dynamic> doc = dokumanlar.data() as Map<dynamic, dynamic>;
    Map<String, dynamic> mapBesin = dokumanlar.data();
    listBesin = mapBesin.entries.map((e) => Besin(e.key, e.value)).toList();
    print("++++++++++++++++++++" + listBesin.length.toString() + "++++++++++++++");*/
    //print(doc);
    setState(() {
      listBesin.clear();
    });
    for (var besin in list) {
      if (besin.isim.contains(arananKelime)) {
        Besin bsn = new Besin(besin.isim, besin.kalori);
        setState(() {
          listBesin.add(bsn);
        });
      }
    }
  }

  int _itemCountHesapla() {
    if (listBesin.length == 0 && _arananKelime.text.length != 0)
      return 1;
    else if (listBesin.length == 0)
      return list.length;
    else
      return listBesin.length;
  }

  Widget elemanBulunamadi() {
    return Container(
      height: 50,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(45), color: Colors.grey, boxShadow: [BoxShadow(spreadRadius: 2)]),
      child: Center(
        child: Text("Besin Bulunamadı ..."),
      ),
    );
  }
}
