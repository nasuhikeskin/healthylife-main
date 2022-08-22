import 'package:flutter/cupertino.dart';

class BesinV2 {
  String isim;
  String kaloriGram;
  String kaloriPorsiyon;
  String protein;
  String karbonhidrat;
  String yag;
  String resim;

  BesinV2(
      {@required String isim,
      @required String kaloriGram,
      @required String kaloriPorsiyon,
      @required String protein,
      @required String karbonhidrat,
      @required String yag,
      @required String resim}) {
    this.isim = isim;
    this.kaloriGram = kaloriGram;
    this.kaloriPorsiyon = kaloriPorsiyon;
    this.protein = protein;
    this.karbonhidrat = karbonhidrat;
    this.yag = yag;
    this.resim = resim;
  }
}
