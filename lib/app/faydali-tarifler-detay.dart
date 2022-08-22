import 'package:diyetin_app/model/tarif.dart';
import 'package:flutter/material.dart';

class TarifDetay extends StatefulWidget {
  final Tarif yemekTarifi;
  TarifDetay({Key key, @required this.yemekTarifi}) : super(key: key);

  @override
  _TarifDetayState createState() => _TarifDetayState();
}

class _TarifDetayState extends State<TarifDetay> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    controller.addListener(() {
      setState(() {});
    });
    animation = CurvedAnimation(parent: controller, curve: Curves.linear);
    controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.yemekTarifi.isim),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                //margin: EdgeInsets.only(bottom: 15),
                width: animation.value * MediaQuery.of(context).size.width,
                //height: MediaQuery.of(context).size.height * 2 / 3,
                child: Image.network(widget.yemekTarifi.resim),
              ),
              ListTile(
                //tileColor: Colors.lightGreenAccent,
                title: Center(
                  child: Text(
                    widget.yemekTarifi.isim,
                    style: TextStyle(fontSize: 15 + animation.value * 10),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                padding: EdgeInsets.only(bottom: 20),
                color: Colors.grey.shade200,
                child: Text(widget.yemekTarifi.tarif, style: TextStyle(fontSize: 10 + animation.value * 8)),
              ),
              SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}
