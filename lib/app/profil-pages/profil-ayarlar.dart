import 'package:diyetin_app/app/profil-pages/hakkinda.dart';
import 'package:diyetin_app/app/profil-pages/iletisim.dart';
import 'package:diyetin_app/app/profil-pages/profil-foto-degistir.dart';
import 'package:diyetin_app/app/profil-pages/sifre-degistir.dart';
import 'package:diyetin_app/app/profil-pages/veri-sifirla.dart';
import 'package:diyetin_app/common_widgets/decoration-customize.dart';
import 'package:diyetin_app/common_widgets/platformbasedwidget/platform_based_alert_dialog.dart';
import 'package:diyetin_app/common_widgets/profil-listtile.dart';
import 'package:diyetin_app/viewmodel/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilAyarlar extends StatefulWidget {
  @override
  _ProfilAyarlarState createState() => _ProfilAyarlarState();
}

class _ProfilAyarlarState extends State<ProfilAyarlar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    margin: EdgeInsets.all(5),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage("images/asd.jpg"),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    child: Text(
                      "kullanici@gmail.com",
                      style: TextStyle(fontSize: 21),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(3),
                    child: Text(
                      "Kayıtlı Bir Diyetisyeniniz Yok",
                      style: TextStyle(fontSize: 18),
                    ),
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
                  ProfilListTile(
                      title: "Uygulama Hakkında",
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HakkindaPage()));
                      }),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 2,
              child: RaisedButton(
                onPressed: () => _cikisIcinOnayIste(context),
                shape: buttonShapeBorder(),
                color: Colors.red,
                child: Text(
                  "Çıkış Yap",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
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
