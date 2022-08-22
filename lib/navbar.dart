import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class DenemeSayfasi extends StatefulWidget {
  @override
  _DenemeSayfasiState createState() => _DenemeSayfasiState();
}

class _DenemeSayfasiState extends State<DenemeSayfasi> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _txtdenGetir();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Center(
          child: Text("Txt İşlemleri"),
        ),
      ),
    );
  }

  void _txtdenGetir() async {
    String data = await getFileData("besindeger.txt");
    List<String> liste = data.split("\n");
    for (String deger in liste) {
      print(deger);
    }
  }

  Future<String> getFileData(String path) async {
    return await rootBundle.loadString(path);
  }
}
