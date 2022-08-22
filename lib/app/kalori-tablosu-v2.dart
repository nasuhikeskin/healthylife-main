import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diyetin_app/app/kalori-detay-v2.dart';
import 'package:diyetin_app/model/besinv2.dart';
import 'package:diyetin_app/routes/fadein-fadeout.dart';
import 'package:flutter/material.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;
List<BesinV2> listBesinV2 = new List<BesinV2>();
List<BesinV2> listBesin = new List<BesinV2>();
TextEditingController _arananKelime = new TextEditingController();

class KaloriTablosu2 extends StatefulWidget {
  @override
  _KaloriTablosu2State createState() => _KaloriTablosu2State();
}

class _KaloriTablosu2State extends State<KaloriTablosu2> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _veriGetir();
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
                        return listElemaniEkle(listBesinV2[index]);
                      else
                        return listElemaniEkle(listBesin[index]);
                    }))
          ],
        ),
      ),
    );
  }

  Widget listElemaniEkle(BesinV2 besin) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            //Navigator.push(context, MaterialPageRoute(builder: (context) => KaloriDetayTablosu(besin: list[index])));
            Navigator.push(context, FadeInFadeOutRoute(builder: (context) => KaloriDetayV2(besin: besin)));
          },
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(besin.resim),
          ),
          title: Text(besin.isim),
          trailing: Text(besin.kaloriGram + " kcal"),
        ),
        Divider(
          thickness: 2,
        )
      ],
    );
  }

  Widget elemanBulunamadi() {
    return Container(
      height: 50,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(45),
          color: Colors.grey.shade300,
          boxShadow: [BoxShadow(spreadRadius: 2)]),
      child: Center(
        child: Text("Besin Bulunamadı ..."),
      ),
    );
  }

  _itemCountHesapla() {
    if (listBesin.length == 0 && _arananKelime.text.length != 0)
      return 1;
    else if (listBesin.length == 0)
      return listBesinV2.length;
    else
      return listBesin.length;
  }

  void _veriGetir() async {
    DocumentSnapshot documentSnapshot = await _firestore.doc("besin/besinler").get();
    documentSnapshot.data().forEach((key, value) {
      BesinV2 besinV2 = new BesinV2(
          isim: key,
          kaloriGram: value["kalorigram"],
          kaloriPorsiyon: value["kaloriporsiyon"],
          protein: value["protein"],
          karbonhidrat: value["karbonhidrat"],
          yag: value["yağ"],
          resim: value["resim"]);
      setState(() {
        listBesinV2.add(besinV2);
      });
    });
  }

  void _doIt() {
    String arananKelime = _arananKelime.text;
    setState(() {
      listBesin.clear();
    });
    for (var besin in listBesinV2) {
      if (besin.isim.contains(arananKelime)) {
        BesinV2 bsn = besin;
        setState(() {
          listBesin.add(bsn);
        });
      }
    }
  }
}
