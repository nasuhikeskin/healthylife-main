import 'package:diyetin_app/model/makale-model.dart';
import 'package:flutter/material.dart';

class MakaleDetay extends StatelessWidget {
  final Makale makale;
  MakaleDetay({Key key, @required this.makale}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String title = "Makale Detay";
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              color: Colors.grey,
              height: MediaQuery.of(context).size.height / 4,
              child: Center(
                child: Text(
                  makale.baslik,
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ),
            Container(
              color: Colors.lightGreen,
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(10),
              child: Text(makale.icerik, style: TextStyle(fontSize: 18)),
            )
          ],
        ),
      ),
    );
  }
}
