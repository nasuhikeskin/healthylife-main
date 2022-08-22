import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:diyetin_app/common_widgets/decoration-customize.dart';
import 'package:diyetin_app/common_widgets/platformbasedwidget/platform_based_alert_dialog.dart';
import 'package:diyetin_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
FirebaseAuth _auth = FirebaseAuth.instance;

TextEditingController _dogrulama = new TextEditingController();

class VeriSifirla extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Verileri Sıfırla",
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Center(
              child: Text(
                "Dikkat !!!",
                style: TextStyle(color: Colors.red, fontSize: 24),
              ),
            ),
            Center(
              child: Text(
                "Bu İşlem Geri Alınamaz",
                style: TextStyle(color: Colors.red, fontSize: 24),
              ),
            ),
            Divider(
              color: Colors.red,
              thickness: 5,
            ),
            Center(
              child: Text(
                "Veri Silme İşlemini Gerçekleştirmek İçin Aşağıdaki Kutucuğa Büyük Harflerle TAMAM Yazınız",
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width * 5 / 9,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), border: Border.all(color: Colors.red)),
              child: TextField(
                textAlign: TextAlign.center,
                autofocus: false,
                controller: _dogrulama,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                  hintText: "TAMAM",
                  //border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0), borderSide: BorderSide())),
                ),
              ),
            ),
            RaisedButton(
              onPressed: () {
                _veriSil(context);
              },
              color: Colors.red,
              shape: buttonShapeBorder(),
              child: Text(
                "Verileri Sil",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _veriSil(BuildContext context) async {
    if (_dogrulama.text == "TAMAM") {
      final sonuc = await PlatformBasedAlertDialog(
        baslik: "Dikkat",
        icerik: "Verileriniz Tamamen Silinecek\nBu İşlem Geri Alınamaz",
        anaButonYazisi: "Tamam",
        iptalButonYazisi: "Vazgeç",
      ).goster(context);

      print(sonuc);
      print(_dogrulama.text);
      if (sonuc == true) {
        _yap(context);
      } else {
        _dogrulama.text = " ";
      }
    } else {
      await PlatformBasedAlertDialog(
        baslik: "Hata Oluştu !",
        icerik: "Lütfen Yaptığınız İşlemi Tekrar Kontrol Ediniz",
        anaButonYazisi: "Evet",
      ).goster(context);
      _dogrulama.text = " ";
    }
  }

  void _yap(BuildContext context) async {
    String mail = _auth.currentUser.email;
    _dogrulama.text = "";
    var time = formatDate(DateTime.now(), [dd, '-', mm, '-', yyyy]);
    //firestoredan silme işlemi
    await _firestore.doc("su/$mail").delete().then((aa) {
      print("silme işlemi başarıyla gerçekleşti => Su");
    }).catchError((e) => debugPrint("Silerken hata cıktı" + e.toString()));
    await _firestore.doc("kilo/$mail").delete().then((aa) {
      print("silme işlemi başarıyla gerçekleşti => Kilo");
    }).catchError((e) => debugPrint("Silerken hata cıktı" + e.toString()));
    //hata çıkmaması için default değerler oluşturduk
    await _firestore.collection("kilo").doc(mail).set({time: "0"});
    await _firestore.collection("su").doc(mail).set({time: "0"});
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => App()));
  }
}
