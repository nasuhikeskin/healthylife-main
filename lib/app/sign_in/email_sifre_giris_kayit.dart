import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diyetin_app/common_widgets/platformbasedwidget/platform_based_alert_dialog.dart';
import 'package:diyetin_app/common_widgets/social_log_in_button.dart';
import 'package:diyetin_app/model/user.dart';
import 'package:diyetin_app/viewmodel/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../hata_exception.dart';

enum FormType { Register, LogIn }
FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

class EmailveSifreLoginPage extends StatefulWidget {
  @override
  _EmailveSifreLoginPageState createState() => _EmailveSifreLoginPageState();
}

class _EmailveSifreLoginPageState extends State<EmailveSifreLoginPage> {
  String _email, _sifre;
  String _butonText, _linkText;
  var _formType = FormType.LogIn;
  bool isloading = false;
  @override
  void initState() {
    // TODO: implement initState
  }

  final _formKey = GlobalKey<FormState>();

  void _formSubmit() async {
    _formKey.currentState.save();
    debugPrint("email :" + _email + " şifre:" + _sifre);

    final _userModel = Provider.of<UserModel>(context, listen: false);

    if (_formType == FormType.LogIn) {
      try {
        MyUser _girisYapanUser =
            await _userModel.signInWithEmailandPassword(_email, _sifre);
        await _firebaseFirestore
            .collection("users")
            .get()
            .then((querySnapshots) {
          for (int i = 0; i < querySnapshots.docs.length; i++) {
            if (querySnapshots.docs[i]['email'] == _email) {
              _girisYapanUser.seviye = querySnapshots.docs[i]['seviye'];
              _girisYapanUser.profilURL = querySnapshots.docs[i]['profilURL'];
            }
          }
        });
        //if (_girisYapanUser != null)
        //print("Oturum açan user id:" + _girisYapanUser.userID.toString());
      } on FirebaseAuthException catch (e) {
        print("hata ${e.code}");
        PlatformBasedAlertDialog(
          baslik: "Oturum Açma HATA",
          icerik: Hatalar.goster(e.code),
          anaButonYazisi: 'Tamam',
        ).goster(context);
      }
    } else {
      try {
        MyUser _olusturulanUser =
            await _userModel.createUserWithEmailandPassword(_email, _sifre);
        /* if (_olusturulanUser != null)
          print("Oturum açan user id:" + _olusturulanUser.userID.toString());*/
      } on FirebaseAuthException catch (e) {
        print("hata ${e.code}");
        PlatformBasedAlertDialog(
          baslik: "Kullanıcı Oluşturma HATA",
          icerik: Hatalar.goster(e.code),
          anaButonYazisi: 'Tamam',
        ).goster(context);
      }
    }
  }

  void _degistir() {
    setState(() {
      _formType =
          _formType == FormType.LogIn ? FormType.Register : FormType.LogIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    _butonText = _formType == FormType.LogIn ? "Giriş Yap " : "Kayıt Ol";
    _linkText = _formType == FormType.LogIn
        ? "Hesabınız Yok Mu? Kayıt Olun"
        : "Hesabınız Var Mı? Giriş Yapın";
    final _userModel = Provider.of<UserModel>(context);

    if (_userModel.user != null) {
      Future.delayed(Duration(milliseconds: 1), () {
        Navigator.of(context).popUntil(ModalRoute.withName("/"));
      });
    }
    void _yenile() async {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }));
      await Future.delayed(Duration(seconds: 1));
      Navigator.pop(context);
      _degistir();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Giriş / Kayıt"),
      ),
      body: _userModel.state == ViewState.Idle
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            errorText: _userModel.emailHataMesaji != null
                                ? _userModel.emailHataMesaji
                                : null,
                            prefixIcon: Icon(Icons.mail),
                            hintText: 'Email',
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          onSaved: (String girilenEmail) {
                            _email = girilenEmail;
                          },
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            errorText: _userModel.sifreHataMesaji != null
                                ? _userModel.sifreHataMesaji
                                : null,
                            prefixIcon: Icon(Icons.lock),
                            hintText: 'Sifre',
                            labelText: 'Sifre',
                            border: OutlineInputBorder(),
                          ),
                          onSaved: (String girilenSifre) {
                            _sifre = girilenSifre;
                          },
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        SocialLoginButton(
                          butonText: _butonText,
                          butonColor: Theme.of(context).primaryColor,
                          radius: 10,
                          onPressed: () => _formSubmit(),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        FlatButton(
                          onPressed: _yenile,
                          child: Text(_linkText),
                        ),
                      ],
                    )),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
