import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TabItem {
  Makale,
  KaloriTablosu,
  FaydaliTarif,
  DiyetisyeneSor,
  Profil,
}

class TabItemData {
  final String title;
  final IconData icon;

  TabItemData(this.title, this.icon);

  static Map<TabItem, TabItemData> tumTablar = {
    TabItem.Makale: TabItemData("Makale", Icons.waterfall_chart),
    TabItem.KaloriTablosu: TabItemData("Kalori", Icons.line_weight),
    TabItem.FaydaliTarif: TabItemData("Tarif", Icons.person),
    TabItem.DiyetisyeneSor: TabItemData("Diyetisyene Sor", Icons.chat),
    TabItem.Profil: TabItemData("Profil", Icons.supervised_user_circle),
  };
}
