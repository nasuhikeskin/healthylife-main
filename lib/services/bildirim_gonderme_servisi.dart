import 'package:diyetin_app/model/mesaj.dart';
import 'package:diyetin_app/model/user.dart';
import 'package:http/http.dart' as http;

class BildirimGondermeServis {
  Future<bool> bildirimGonder(
      Mesaj gonderilecekBildirim, MyUser gonderenUser, String token) async {
    String endURL = "https://fcm.googleapis.com/fcm/send";
    String firebaseKey =
        "AAAAZh-gWF4:APA91bE8K5o5nlkwlB1kGvfje_Gaq5ArHL8q0Tv-emsXuZKS-juBGcafQ21DyugYfTJXchnBKar3nlY5-5A6Ktq7KDCYsXGhnKkeyCzwfF-reMCQuB-2UwvcMbrM6t5Klct6wA96qnfr";
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "key=$firebaseKey"
    };

    String json =
        '{ "to" : "$token", "data" : { "message" : "${gonderilecekBildirim.mesaj}", "title": "${gonderenUser.userName} yeni mesaj", "profilURL": "${gonderenUser.profilURL}", "gonderenUserID" : "${gonderenUser.userID}" } }';

    http.Response response =
        await http.post(endURL, headers: headers, body: json);

    if (response.statusCode == 200) {
      print("işlem basarılı");
    } else {
      /*print("işlem basarısız:" + response.statusCode.toString());
      print("jsonumuz:" + json);*/
    }
  }
}
