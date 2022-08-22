import 'package:diyetin_app/common_widgets/decoration-customize.dart';
import 'package:diyetin_app/common_widgets/platformbasedwidget/platform_based_alert_dialog.dart';
import 'package:diyetin_app/viewmodel/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

TextEditingController _ilkSifre = new TextEditingController();
TextEditingController _ikinciSifre = new TextEditingController();

class SifreDegistir extends StatefulWidget {
  @override
  _SifreDegistirState createState() => _SifreDegistirState();
}

class _SifreDegistirState extends State<SifreDegistir> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Şifre Değiştir"),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width * 5 / 9,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(20),
              decoration: containerDecoration(),
              child: TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                autofocus: false,
                controller: _ilkSifre,
                decoration: InputDecoration(
                  hintText: "Yeni Şifre",
                  //border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0), borderSide: BorderSide())),
                ),
              ),
            ),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width * 5 / 9,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(20),
              decoration: containerDecoration(),
              child: TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                autofocus: false,
                controller: _ikinciSifre,
                decoration: InputDecoration(
                  hintText: "Tekrar",
                  //border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0), borderSide: BorderSide())),
                ),
              ),
            ),
            RaisedButton(
              onPressed: _sifreDegistir,
              color: Colors.lightGreenAccent.shade100,
              shape: buttonShapeBorder(),
              child: Text("Şifremi Değiştir"),
            )
          ],
        ),
      ),
    );
  }

  void _sifreDegistir() async {
    if (_ilkSifre.text == _ikinciSifre.text) {
      final sonuc = await PlatformBasedAlertDialog(
        baslik: "Şifre Değiştirme İşlemi Başarıyla Gerçekleşti",
        icerik: "Onaylıyormusunuz ?",
        anaButonYazisi: "Evet",
        iptalButonYazisi: "Vazgeç",
      ).goster(context);

      if (sonuc == true) {
        _auth.currentUser.updatePassword(_ilkSifre.text);
        _ilkSifre.text = "";
        _ikinciSifre.text = "";
        final _userModel = Provider.of<UserModel>(context, listen: false);
        _userModel.signOut();
      } else {
        _ilkSifre.text = "";
        _ikinciSifre.text = "";
      }
    } else {
      PlatformBasedAlertDialog(
        baslik: "Şifre Değiştirme İşleminde Hata Oldu",
        icerik: "Lütfen Girdiğiniz Değerlerin Eşleştiğinden Emin Olun",
        anaButonYazisi: "Tamam",
      ).goster(context);
      _ilkSifre.text = "";
      _ikinciSifre.text = "";
    }
  }
}
