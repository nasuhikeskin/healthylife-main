import 'package:diyetin_app/app/profil-pages/analiz.dart';
import 'package:diyetin_app/app/profil-pages/bki-hesapla.dart';
import 'package:diyetin_app/app/profil-pages/iletisim.dart';
import 'package:diyetin_app/app/profil-pages/kilo-takip.dart';
import 'package:diyetin_app/app/profil-pages/profil-foto-degistir.dart';
import 'package:diyetin_app/app/profil-pages/sifre-degistir.dart';
import 'package:diyetin_app/app/profil-pages/su-takip.dart';
import 'package:diyetin_app/app/profil-pages/veri-sifirla.dart';
import 'package:diyetin_app/common_widgets/decoration-customize.dart';
import 'package:diyetin_app/common_widgets/platformbasedwidget/platform_based_alert_dialog.dart';
import 'package:diyetin_app/common_widgets/profil-listtile.dart';
import 'package:diyetin_app/viewmodel/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FarliProfilTasarimi extends StatefulWidget {
  @override
  _FarliProfilTasarimiState createState() => _FarliProfilTasarimiState();
}

class _FarliProfilTasarimiState extends State<FarliProfilTasarimi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text("Profil Ayarları"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              //color: Colors.redAccent.shade100,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage("images/asd.jpg"),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      "kullanici@gmail.com",
                      style: TextStyle(fontSize: 21),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    thickness: 2,
                    indent: 50,
                    endIndent: 50,
                  ),
                  ListTile(
                    title: Text("Kişisel Veriler"),
                  ),
                  ProfilListTile(
                      title: "Kilo Ekle",
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => KiloTakip()));
                      }),
                  ProfilListTile(
                      title: "Su Ekle",
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SuTakip()));
                      }),
                  ProfilListTile(
                      title: "BKI Hesapla",
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BKIHesapla()));
                      }),
                  ProfilListTile(
                      title: "Analiz Sayfası",
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Analiz()));
                      }),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    thickness: 2,
                    indent: 50,
                    endIndent: 50,
                  ),
                  ListTile(
                    title: Text("Profil Ayarları"),
                  ),
                  ProfilListTile(
                      title: "Şifre Değiştir",
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SifreDegistir()));
                      }),
                  ProfilListTile(
                      title: "Profil Resim Değiştir",
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilFotoDegistir()));
                      }),
                  ProfilListTile(
                      title: "Verileri Sıfırla",
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VeriSifirla()));
                      }),
                  ProfilListTile(
                      title: "Kişisel Diyetisyen Edin ",
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BilgiPage()));
                      }),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 2,
              child: Column(
                children: [
                  Divider(
                    thickness: 2,
                  ),
                  RaisedButton(
                    onPressed: () => _cikisIcinOnayIste(context),
                    shape: buttonShapeBorder(),
                    color: Colors.red,
                    child: Text(
                      "Çıkış Yap",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 5,
            )
          ],
        ),
      ),
    );
  }

  Future<bool> _cikisYap(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    bool sonuc = await _userModel.signOut();
    return sonuc;
  }

  Future _cikisIcinOnayIste(BuildContext context) async {
    final sonuc = await PlatformBasedAlertDialog(
      baslik: "Emin Misiniz?",
      icerik: "Çıkmak istediğinizden emin misiniz?",
      anaButonYazisi: "Evet",
      iptalButonYazisi: "Vazgeç",
    ).goster(context);

    if (sonuc == true) {
      _cikisYap(context);
    }
  }
}
