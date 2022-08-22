import 'package:flutter/material.dart';

class HakkindaPage extends StatefulWidget {
  @override
  _HakkindaPageState createState() => _HakkindaPageState();
}

class _HakkindaPageState extends State<HakkindaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Uygulama Hakkında"),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
        child: Center(
          child: Column(
            children: [
              Image(
                image: AssetImage("images/kku_logo.jpeg"),
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                "Bu uygulama Doç. Dr. Atilla Ergüzen tarafından yürütülen Proje - 2 kapsamında 160255056  numaralı Gizem Bilgiç tarafından 10 Haziran 2021 günü tamamlanmıştır.",
                style: TextStyle(fontSize: 22),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
