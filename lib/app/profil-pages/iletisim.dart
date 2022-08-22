import 'package:flutter/material.dart';

class BilgiPage extends StatefulWidget {
  @override
  _BilgiPageState createState() => _BilgiPageState();
}

class _BilgiPageState extends State<BilgiPage>
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
        title: Text("İletişim"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                height: animation.value * 200,
                width:
                    animation.value * (MediaQuery.of(context).size.width - 40),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://dinamikozelders.com/wp/wp-content/uploads/2018/02/webp.net-compress-image-53.jpg"),
                        fit: BoxFit.cover)),
              ),
              SizedBox(
                height: 20,
              ),
              Stack(
                children: <Widget>[
                  // Stroked text as border.
                  Text(
                    'Healthy Life Diyet Merkezi',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 6
                        ..color = Colors.green[500],
                    ),
                  ),
                  // Solid text as fill.
                  Text(
                    'Healthy Life Diyet Merkezi',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.green[600],
                thickness: 3,
              ),
              Stack(
                children: <Widget>[
                  // Stroked text as border.
                  Text(
                    'Ardıçlı, İsmetpaşa Cad, 42250 Selçuklu/Konya',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 6
                        ..color = Colors.green[500],
                    ),
                  ),
                  // Solid text as fill.
                  Text(
                    'Ardıçlı, İsmetpaşa Cad, 42250 Selçuklu/Konya',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.green[600],
                thickness: 3,
              ),
              Stack(
                children: <Widget>[
                  // Stroked text as border.
                  Text(
                    '(0332) 241 00 41',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 6
                        ..color = Colors.green[500],
                    ),
                  ),
                  // Solid text as fill.
                  Text(
                    '(0332) 241 00 41',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
