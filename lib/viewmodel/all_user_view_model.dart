import 'package:diyetin_app/locator.dart';
import 'package:diyetin_app/model/user.dart';
import 'package:diyetin_app/repository/user_repository.dart';
import 'package:flutter/material.dart';

enum AllUserViewState { Idle, Loaded, Busy }

class AllUserViewModel with ChangeNotifier {
  AllUserViewState _state = AllUserViewState.Idle;
  List<MyUser> _tumKullanicilar;
  MyUser _enSonGetirilenUser;
  MyUser _myDiyetisyen;

  static final sayfaBasinaGonderiSayisi = 10;
  bool _hasMore = true;

  bool get hasMoreLoading => _hasMore;

  UserRepository _userRepository = locator<UserRepository>();
  List<MyUser> get kullanicilarListesi => _tumKullanicilar;
  MyUser get diyetisyen => _myDiyetisyen;

  AllUserViewState get state => _state;

  set state(AllUserViewState value) {
    _state = value;
    notifyListeners();
  }

  AllUserViewModel() {
    _tumKullanicilar = [];
    _enSonGetirilenUser = null;
    _myDiyetisyen = null;
    //getUserWithPagination(_enSonGetirilenUser, false);
  }

  //refresh ve sayfalama için
  //yenielemanlar getir true yapılır
  //ilk açılıs için yenielemanlar için false deger verilir.

  Future<MyUser> getDiyetisyen(String userID) async {
    var diyetisyen = await _userRepository.getDiyetisten(userID);
    return diyetisyen;
  }
}
