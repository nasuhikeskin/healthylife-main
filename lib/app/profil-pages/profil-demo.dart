import 'package:diyetin_app/app/profil-pages/analiz.dart';
import 'package:diyetin_app/app/profil-pages/bki-hesapla.dart';
import 'package:diyetin_app/app/profil-pages/kilo-takip.dart';
import 'package:diyetin_app/app/profil-pages/profil-ayarlar.dart';
import 'package:diyetin_app/app/profil-pages/su-takip.dart';
import 'package:diyetin_app/routes/fadein-fadeout.dart';
import 'package:flutter/material.dart';

class ProfilDemo extends StatefulWidget {
  @override
  _ProfilDemoState createState() => _ProfilDemoState();
}

class _ProfilDemoState extends State<ProfilDemo>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    controller.addListener(() {
      setState(() {});
    });
    animation =
        ColorTween(begin: Colors.black, end: Colors.lightGreenAccent.shade200)
            .animate(controller);
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
    double ustDeger = (MediaQuery.of(context).size.height / 3) - 50;
    double araDeger = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.bottom +
            MediaQuery.of(context).padding.top +
            ustDeger);

    return Scaffold(
      appBar: AppBar(
        title: Text("Profil"),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
              size: 30,
            ),
            tooltip: 'Profil Ayarları',
            onPressed: () {
              Navigator.push(context,
                  FadeInFadeOutRoute(builder: (context) => ProfilAyarlar()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: ustDeger,
              width: MediaQuery.of(context).size.width,
              //color: Colors.redAccent.shade100,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage("images/asd.jpg"),
                    ),
                  ),
                  Container(
                    //margin: EdgeInsets.all(10),
                    child: Text(
                      "kullanici@gmail.com",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(5),
              height: araDeger,
              child: GridView.count(
                crossAxisCount: 2,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => KiloTakip()));
                    },
                    child: Container(
                      margin: EdgeInsets.all(15),
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: animation.value,
                          borderRadius: BorderRadius.circular(90),
                          border: Border.all(color: Colors.black)),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.padding,
                              size: 30,
                            ),
                            Text("Kilo Takip")
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SuTakip()));
                    },
                    child: Container(
                      margin: EdgeInsets.all(15),
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: animation.value,
                          borderRadius: BorderRadius.circular(90),
                          border: Border.all(color: Colors.black)),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.ac_unit_outlined,
                              size: 30,
                            ),
                            Text("Su Takip")
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BKIHesapla()));
                    },
                    child: Container(
                      margin: EdgeInsets.all(15),
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: animation.value,
                          borderRadius: BorderRadius.circular(90),
                          border: Border.all(color: Colors.black)),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.height,
                              size: 30,
                            ),
                            Text("BKI Hesapla")
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Analiz()));
                    },
                    child: Container(
                      margin: EdgeInsets.all(15),
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: animation.value,
                          borderRadius: BorderRadius.circular(90),
                          border: Border.all(color: Colors.black)),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.map,
                              size: 30,
                            ),
                            Text("Analiz")
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

/*                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilAyarlar()));
                    },
                    child: Container(
                      margin: EdgeInsets.all(15),
                      height: 40,
                      width: 40,
                      color: Colors.lightGreenAccent.shade200,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.settings,
                              size: 30,
                            ),
                            Text("Profil Ayarları")
                          ],
                        ),
                      ),
                    ),
                  )
*/
