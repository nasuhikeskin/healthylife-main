import 'package:flutter/material.dart';

class SocialText extends StatelessWidget {
  final String icerik;
  final Color renk;
  final Color arkaPlanRenk;
  final double boyut;

  const SocialText(
      {Key key,
      @required this.icerik,
      this.renk: Colors.lightGreen,
      this.arkaPlanRenk: Colors.white,
      this.boyut: 20});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(5),
      child: Center(
        child: Text(
          icerik,
          style: TextStyle(
              color: renk, backgroundColor: arkaPlanRenk, fontSize: boyut),
        ),
      ),
    );
  }
}
