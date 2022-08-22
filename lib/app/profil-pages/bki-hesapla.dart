import 'package:diyetin_app/common_widgets/decoration-customize.dart';
import 'package:flutter/material.dart';

double _boy = 0;
double _kilo = 0;
double _bkiDeger = 0;
TextEditingController _girilenBoy = new TextEditingController();
TextEditingController _girilenKilo = new TextEditingController();

class BKIHesapla extends StatefulWidget {
  @override
  _BKIHesaplaState createState() => _BKIHesaplaState();
}

class _BKIHesaplaState extends State<BKIHesapla> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BKI Hesapla"),
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
                child: TextField(
                  textAlign: TextAlign.center,
                  autofocus: false,
                  controller: _girilenBoy,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Boyunuz (cm)",
                  ),
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
                  controller: _girilenKilo,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Kilonuz (kg)",
                  ),
                ),
              ),
              RaisedButton(
                onPressed: _bkiHesapla,
                color: Colors.lightGreenAccent.shade100,
                shape: buttonShapeBorder(),
                child: Text("Hesapla"),
              ),
              RaisedButton(
                onPressed: () {},
                color: Colors.lightGreenAccent.shade100,
                shape: buttonShapeBorder(),
                child: Text("Analiz Sayfasına Git"),
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 5 / 9,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.fromLTRB(50, 10, 40, 0),
                decoration: containerDecoration(),
                child: Center(
                  child: Text(_bkiDeger == 0 ? "BKI Değeriniz = ??" : "BKI Değeriniz = " + _bkiDeger.toStringAsFixed(3)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _bkiHesapla() {
    _boy = double.parse(_girilenBoy.text) / 100;
    _kilo = double.parse(_girilenKilo.text);
    double sonuc = _kilo / (_boy * _boy);
    setState(() {
      _bkiDeger = sonuc;
    });
  }
}
