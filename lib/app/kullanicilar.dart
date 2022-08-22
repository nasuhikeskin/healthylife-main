import 'package:diyetin_app/app/konusmalarim_page.dart';
import 'package:diyetin_app/app/sohbet_page.dart';
import 'package:diyetin_app/model/user.dart';
import 'package:diyetin_app/viewmodel/all_user_view_model.dart';
import 'package:diyetin_app/viewmodel/chat_view_model.dart';
import 'package:diyetin_app/viewmodel/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

MyUser _oankidiyetisyen;

class KullanicilarPage extends StatefulWidget {
  @override
  _KullanicilarPageState createState() => _KullanicilarPageState();
}

class _KullanicilarPageState extends State<KullanicilarPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context);
    return Scaffold(
        appBar: AppBar(
          title: _userModel.user.seviye == 1
              ? Text("Danışman")
              : Text("Konuşmalarım"),
        ),
        body: Container(
          child: _userListeElemaniOlustur(),
        ));
  }

  @override
  Widget kullaniciYokUi() {
    SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.supervised_user_circle,
                color: Theme.of(context).primaryColor,
                size: 120,
              ),
              Text(
                "Henüz Kullanıcı Yok",
                style: TextStyle(fontSize: 36),
              )
            ],
          ),
        ),
        height: MediaQuery.of(context).size.height - 150,
      ),
    );
  }

  Future bekleaq() async {
    final _userModel = Provider.of<UserModel>(context);

    AllUserViewModel _AllUserViewModel = new AllUserViewModel();

    _AllUserViewModel.getDiyetisyen(_userModel.user.userID).then((value) {
      if (_oankidiyetisyen == null) {
        setState(() {
          _oankidiyetisyen = value;
          print(_oankidiyetisyen.toString());
        });
      }
    });
  }

  Widget _userListeElemaniOlustur() {
    final _userModel = Provider.of<UserModel>(context, listen: false);

    if (_userModel.user.seviye == 1) {
      bekleaq();
      try {
        if (_oankidiyetisyen.userName == null)
          return Center(child: CircularProgressIndicator());
      } catch (e) {
        return null;
      }
      return GestureDetector(
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(
                create: (context) => ChatViewModel(
                    currentUser: _userModel.user,
                    sohbetEdilenUser: _oankidiyetisyen),
                child: SohbetPage(),
              ),
            ),
          );
        },
        child: Card(
          child: ListTile(
            title: Text(_oankidiyetisyen.userName),
            subtitle: Text(_oankidiyetisyen.email),
            leading: CircleAvatar(
              backgroundColor: Colors.grey.withAlpha(40),
              backgroundImage: NetworkImage(_oankidiyetisyen.profilURL),
            ),
          ),
        ),
      );
    } else {
      return KonusmalarimPage();
    }
  }
}
