import 'package:diyetin_app/app/sign_in/email_sifre_giris_kayit.dart';
import 'package:diyetin_app/common_widgets/platformbasedwidget/platform_based_alert_dialog.dart';
import 'package:diyetin_app/common_widgets/social_log_in_button.dart';
import 'package:diyetin_app/model/user.dart';
import 'package:diyetin_app/viewmodel/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart' as prov;

import '../hata_exception.dart';

PlatformException myHata;

class SignInPage extends StatefulWidget {
  /*void _misafirGirisi(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context);
    User _user = await _userModel.singInAnonymously();
    print("Oturum açan user id:" + _user.userID.toString());
  }*/

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  void _googleIleGiris(BuildContext context) async {
    final _userModel = prov.Provider.of<UserModel>(context, listen: false);
    MyUser _user = await _userModel.signInWithGoogle();
    if (_user != null) print("Oturum açan user id:" + _user.userID.toString());
  }

  void _emailVeSifreGiris(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => EmailveSifreLoginPage(),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (myHata != null)
        PlatformBasedAlertDialog(
          baslik: "Kullanıcı Oluşturma HATA",
          icerik: Hatalar.goster(myHata.code),
          anaButonYazisi: 'Tamam',
        ).goster(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Diyetin"),
        elevation: 0,
      ),
      backgroundColor: Colors.grey.shade200,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: new Alignment(0.1, 0),
                colors: [Colors.lightGreenAccent, Colors.limeAccent],
                tileMode: TileMode.repeated)),
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Oturum Açın",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
            ),
            SizedBox(
              height: 40,
            ),
            SocialLoginButton(
              butonText: "Gmail ile Giriş Yap",
              textColor: Colors.black87,
              butonColor: Colors.white,
              butonIcon: Image.asset("images/google-logo.png"),
              onPressed: () => _googleIleGiris(context),
            ),
            SocialLoginButton(
              onPressed: () => _emailVeSifreGiris(context),
              butonColor: Colors.white,
              textColor: Colors.black87,
              butonIcon: Icon(
                Icons.email,
                color: Colors.black,
                size: 32,
              ),
              butonText: "Email ve Şifre ile Giriş yap",
            ),
            /*SocialLoginButton(
              onPressed: () => _misafirGirisi(context),
              butonColor: Colors.teal,
              butonIcon: Icon(Icons.supervised_user_circle),
              butonText: "Misafir Girişi",
            ),*/
          ],
        ),
      ),
    );
  }
}
