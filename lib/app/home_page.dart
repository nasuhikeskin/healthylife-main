import 'package:diyetin_app/app/faydali-tarifler.dart';
import 'package:diyetin_app/app/kalori-tablosu-v2.dart';
import 'package:diyetin_app/app/kullanicilar.dart';
import 'package:diyetin_app/app/makale.dart';
import 'package:diyetin_app/app/my_custom_bottom_navi.dart';
import 'package:diyetin_app/app/profil-pages/profil-demo.dart';
import 'package:diyetin_app/app/tab_items.dart';
import 'package:diyetin_app/model/user.dart';
import 'package:diyetin_app/notification_handler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'tab_items.dart';

class HomePage extends StatefulWidget {
  final MyUser user;

  HomePage({Key key, @required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NotificationHandler().initializeFCMNotification(context);
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  TabItem _currentTab = TabItem.Makale;

  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.Makale: GlobalKey<NavigatorState>(),
    TabItem.KaloriTablosu: GlobalKey<NavigatorState>(),
    TabItem.FaydaliTarif: GlobalKey<NavigatorState>(),
    TabItem.DiyetisyeneSor: GlobalKey<NavigatorState>(),
    TabItem.Profil: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, Widget> tumSayfalar() {
    return {
      TabItem.Makale: MakalePage(),
      TabItem.KaloriTablosu: KaloriTablosu2(),
      TabItem.FaydaliTarif: FaydaliTarifler(),
      TabItem.DiyetisyeneSor: KullanicilarPage(),
      TabItem.Profil: ProfilDemo(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: MyCustomBottomNavigation(
        sayfaOlusturucu: tumSayfalar(),
        navigatorKeys: navigatorKeys,
        currentTab: _currentTab,
        onSelectedTab: (secilenTab) {
          if (secilenTab == _currentTab) {
            navigatorKeys[secilenTab].currentState.popUntil((route) => route.isFirst);
          } else {
            setState(() {
              _currentTab = secilenTab;
            });
          }
        },
      ),
    );
  }
}
