import 'dart:io';

import 'package:diyetin_app/locator.dart';
import 'package:diyetin_app/model/konusma.dart';
import 'package:diyetin_app/model/mesaj.dart';
import 'package:diyetin_app/model/user.dart';
import 'package:diyetin_app/services/auth_base.dart';
import 'package:diyetin_app/services/bildirim_gonderme_servisi.dart';
import 'package:diyetin_app/services/firebase_auth_service.dart';
import 'package:diyetin_app/services/firebase_db_service.dart';
import 'package:diyetin_app/services/firebase_storage_service.dart';
import 'package:timeago/timeago.dart' as timeago;

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FirestoreDBService _firestoreDBService = locator<FirestoreDBService>();
  FirebaseStorageService _firebaseStorageService =
      locator<FirebaseStorageService>();
  BildirimGondermeServis _bildirimGondermeServis =
      locator<BildirimGondermeServis>();

  AppMode appMode = AppMode.RELEASE;
  List<MyUser> tumKullaniciListesi = [];
  String myDiyetisyenID;

  Map<String, String> kullaniciToken = Map<String, String>();

  @override
  Future<MyUser> getCurrentUser() async {
    MyUser _user = await _firebaseAuthService.getCurrentUser();

    if (_user != null) {
      myDiyetisyenID = _user.diyetisyen;
      return await _firestoreDBService.readUser(_user.userID);
    } else
      return null;
  }

  @override
  Future<bool> signOut() async {
    return await _firebaseAuthService.signOut();
  }
/*
  @override
  Future<MyUser> singInAnonymously() async {
    return await _firebaseAuthService.singInAnonymously();
  }*/

  @override
  Future<MyUser> signInWithGoogle() async {
    MyUser _user = await _firebaseAuthService.signInWithGoogle();
    if (_user != null) {
      bool _sonuc = await _firestoreDBService.saveUser(_user);
      if (_sonuc) {
        return await _firestoreDBService.readUser(_user.userID);
      } else {
        await _firebaseAuthService.signOut();
        return null;
      }
    } else
      return null;
  }

  @override
  Future<MyUser> createUserWithEmailandPassword(
      String email, String sifre) async {
    MyUser _user =
        await _firebaseAuthService.createUserWithEmailandPassword(email, sifre);
    bool _sonuc = await _firestoreDBService.saveUser(_user);
    if (_sonuc) {
      return await _firestoreDBService.readUser(_user.userID);
    } else
      return null;
  }

  @override
  Future<MyUser> signInWithEmailandPassword(String email, String sifre) async {
    MyUser _user =
        await _firebaseAuthService.signInWithEmailandPassword(email, sifre);

    return await _firestoreDBService.readUser(_user.userID);
  }

  Future<bool> updateUserName(String userID, String yeniUserName) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
      return await _firestoreDBService.updateUserName(userID, yeniUserName);
    }
  }

  Future<String> uploadFile(
      String userID, String fileType, File profilFoto) async {
    if (appMode == AppMode.DEBUG) {
      return "dosya_indirme_linki";
    } else {
      var profilFotoURL = await _firebaseStorageService.uploadFile(
          userID, fileType, profilFoto);
      await _firestoreDBService.updateProfilFoto(userID, profilFotoURL);
      return profilFotoURL;
    }
  }

  Stream<List<Mesaj>> getMessages(
      String currentUserID, String sohbetEdilenUserID) {
    if (appMode == AppMode.DEBUG) {
      return Stream.empty();
    } else {
      return _firestoreDBService.getMessages(currentUserID, sohbetEdilenUserID);
    }
  }

  Future<bool> saveMessage(Mesaj kaydedilecekMesaj, MyUser currentUser) async {
    if (appMode == AppMode.DEBUG) {
      return true;
    } else {
      var dbYazmaIslemi =
          await _firestoreDBService.saveMessage(kaydedilecekMesaj);

      if (dbYazmaIslemi) {
        var token = "";
        if (kullaniciToken.containsKey(kaydedilecekMesaj.kime)) {
          token = kullaniciToken[kaydedilecekMesaj.kime];
          //print("Localden geldi:" + token);
        } else {
          token = await _firestoreDBService.tokenGetir(kaydedilecekMesaj.kime);
          if (token != null) kullaniciToken[kaydedilecekMesaj.kime] = token;
          //print("Veri taban??ndan geldi:" + token);
        }

        if (token != null)
          await _bildirimGondermeServis.bildirimGonder(
              kaydedilecekMesaj, currentUser, token);

        return true;
      } else
        return false;
    }
  }

  Future<List<Konusma>> getAllConversations(String userID) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      DateTime _zaman = await _firestoreDBService.saatiGoster(userID);

      var konusmaListesi =
          await _firestoreDBService.getAllConversations(userID);

      for (var oankiKonusma in konusmaListesi) {
        var userListesindekiKullanici =
            listedeUserBul(oankiKonusma.kimle_konusuyor);

        if (userListesindekiKullanici != null) {
          //print("VERILER LOCAL CACHEDEN OKUNDU");
          oankiKonusma.konusulanUserName = userListesindekiKullanici.userName;
          oankiKonusma.konusulanUserProfilURL =
              userListesindekiKullanici.profilURL;
        } else {
          //print("VERILER VERITABANINDAN OKUNDU");
          /*print(
              "aran??lan user daha ??nceden veritaban??ndan getirilmemi??, o y??zden veritaban??ndan bu degeri okumal??y??z");*/
          var _veritabanindanOkunanUser =
              await _firestoreDBService.readUser(oankiKonusma.kimle_konusuyor);
          oankiKonusma.konusulanUserName = _veritabanindanOkunanUser.userName;
          oankiKonusma.konusulanUserProfilURL =
              _veritabanindanOkunanUser.profilURL;
        }

        timeagoHesapla(oankiKonusma, _zaman);
      }

      return konusmaListesi;
    }
  }

  Future<MyUser> getDiyetisten(String userID) async {
    MyUser okunanUser;
    okunanUser = await _firestoreDBService.getDiyetisyen(userID);
    return okunanUser;
  }

  MyUser listedeUserBul(String userID) {
    for (int i = 0; i < tumKullaniciListesi.length; i++) {
      if (tumKullaniciListesi[i].userID == userID) {
        return tumKullaniciListesi[i];
      }
    }
  }

  void timeagoHesapla(Konusma oankiKonusma, DateTime zaman) {
    oankiKonusma.sonOkunmaZamani = zaman;

    timeago.setLocaleMessages("tr", timeago.TrMessages());

    var _duration = zaman.difference(oankiKonusma.olusturulma_tarihi.toDate());
    oankiKonusma.aradakiFark =
        timeago.format(zaman.subtract(_duration), locale: "tr");
  }

  Future<List<MyUser>> getUserwithPagination(
      MyUser enSonGetirilenUser, int getirilecekElemanSayisi) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      List<MyUser> _userList = await _firestoreDBService.getUserwithPagination(
          enSonGetirilenUser, getirilecekElemanSayisi);
      tumKullaniciListesi.addAll(_userList);
      return _userList;
    }
  }

  Future<List<Mesaj>> getMessageWithPagination(
      String currentUserID,
      String sohbetEdilenUserID,
      Mesaj enSonGetirilenMesaj,
      int getirilecekElemanSayisi) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      return await _firestoreDBService.getMessagewithPagination(currentUserID,
          sohbetEdilenUserID, enSonGetirilenMesaj, getirilecekElemanSayisi);
    }
  }

  @override
  Future<MyUser> currentUser() async {
    MyUser _user = await _firebaseAuthService.getCurrentUser();
    if (_user != null)
      return await _firestoreDBService.readUser(_user.userID);
    else
      return null;
  }
}
