import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diyetin_app/model/kilo-su-takip.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;
FirebaseAuth _auth = FirebaseAuth.instance;
List<KiloSuTakipClass> listKilo;
List<KiloSuTakipClass> listSu;
bool listKiloBosMu = true;
bool listSuBosMu = true;

class Analiz extends StatefulWidget {
  @override
  _AnalizState createState() => _AnalizState();
}

class _AnalizState extends State<Analiz> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verileriGetir();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Analiz Sayfası"),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 30),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              height: 200,
              child: listKiloBosMu == true
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : SimpleBarChart(_createSampleDataKilo()),
            ),
            Text(
              "Kilo Grafiği",
              style: TextStyle(fontSize: 20),
            ),
            Divider(
              color: Colors.green,
              thickness: 3,
              indent: 20,
              endIndent: 20,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              height: 200,
              child: listSuBosMu == true
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : SimpleLineChart(_createSampleDataSu()),
            ),
            Text(
              "Su Grafiği",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  void _verileriGetir() async {
    //kilo için liste oluşturma
    var dokumanlarKilo = await _firestore.collection("kilo").doc(_auth.currentUser.email).get();
    Map<String, dynamic> mapKilo = dokumanlarKilo.data();
    listKilo = mapKilo.entries.map((e) => KiloSuTakipClass(e.key, e.value)).toList();
    //listi sıralama işlemi
    List<String> list1Kilo = [];
    List<String> list2Kilo = [];

    for (int i = 0; i < listKilo.length; i++) {
      list1Kilo = listKilo[i].tarih.split("-");
      for (int j = i + 1; j < listKilo.length; j++) {
        list2Kilo = listKilo[j].tarih.split("-");
        if (int.parse(list1Kilo[2]) > int.parse(list2Kilo[2])) {
          var swap = listKilo[j];
          listKilo[j] = listKilo[i];
          listKilo[i] = swap;
          list1Kilo = listKilo[i].tarih.split("-");
          list2Kilo = listKilo[j].tarih.split("-");
        } else {
          if (int.parse(list1Kilo[1]) > int.parse(list2Kilo[1]) && int.parse(list1Kilo[2]) >= int.parse(list2Kilo[2])) {
            var swap = listKilo[j];
            listKilo[j] = listKilo[i];
            listKilo[i] = swap;
            list1Kilo = listKilo[i].tarih.split("-");
            list2Kilo = listKilo[j].tarih.split("-");
          } else {
            if (int.parse(list1Kilo[0]) > int.parse(list2Kilo[0]) &&
                int.parse(list1Kilo[1]) >= int.parse(list2Kilo[1]) &&
                int.parse(list1Kilo[2]) >= int.parse(list2Kilo[2])) {
              var swap = listKilo[j];
              listKilo[j] = listKilo[i];
              listKilo[i] = swap;
              list1Kilo = listKilo[i].tarih.split("-");
              list2Kilo = listKilo[j].tarih.split("-");
            }
          }
        }
      }
    }
    listKiloBosMu = false;
    setState(() {
      listKilo;
    });
    //su için liste oluşturma
    var dokumanlarSu = await _firestore.collection("su").doc(_auth.currentUser.email).get();
    Map<String, dynamic> mapSu = dokumanlarSu.data();
    listSu = mapSu.entries.map((e) => KiloSuTakipClass(e.key, e.value)).toList();
    //listi sıralama işlemi
    List<String> list1Su = [];
    List<String> list2Su = [];

    for (int i = 0; i < listSu.length; i++) {
      list1Su = listSu[i].tarih.split("-");
      for (int j = i + 1; j < listSu.length; j++) {
        list2Su = listSu[j].tarih.split("-");
        if (int.parse(list1Su[2]) > int.parse(list2Su[2])) {
          var swap = listSu[j];
          listSu[j] = listSu[i];
          listSu[i] = swap;
          list1Su = listSu[i].tarih.split("-");
          list2Su = listSu[j].tarih.split("-");
        } else {
          if (int.parse(list1Su[1]) > int.parse(list2Su[1]) && int.parse(list1Su[2]) >= int.parse(list2Su[2])) {
            var swap = listSu[j];
            listSu[j] = listSu[i];
            listSu[i] = swap;
            list1Su = listSu[i].tarih.split("-");
            list2Su = listSu[j].tarih.split("-");
          } else {
            if (int.parse(list1Su[0]) > int.parse(list2Su[0]) &&
                int.parse(list1Su[1]) >= int.parse(list2Su[1]) &&
                int.parse(list1Su[2]) >= int.parse(list2Su[2])) {
              var swap = listSu[j];
              listSu[j] = listSu[i];
              listSu[i] = swap;
              list1Su = listSu[i].tarih.split("-");
              list2Su = listSu[j].tarih.split("-");
            }
          }
        }
      }
    }
    listSuBosMu = false;
    setState(() {
      listSu;
    });
  }
}

//
/// Bar chart example
//

List<charts.Series<OrdinalSales, String>> _createSampleDataKilo() {
  final data = <OrdinalSales>[];
  for (int i = 0; i < listKilo.length; i++) {
    List geciciList = listKilo[i].tarih.split("-");
    String year = geciciList[2];
    int value = int.parse(listKilo[i].deger);
    data.add(new OrdinalSales(listKilo[i].tarih, value));
  }
  /*final data = [
    new OrdinalSales('2014', 98),
    new OrdinalSales('2015', 96),
    new OrdinalSales('2016', 92),
    new OrdinalSales('2017', 89),
    new OrdinalSales('2018', 93),
    new OrdinalSales('2019', 91),
    new OrdinalSales('2020', 90),
    new OrdinalSales('2021', 88),
    new OrdinalSales('2022', 88),
    new OrdinalSales('2023', 87),
    new OrdinalSales('2024', 84),
    new OrdinalSales('2025', 80),
  ];*/

  return [
    new charts.Series<OrdinalSales, String>(
      id: 'Sales',
      colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
      domainFn: (OrdinalSales sales, _) => sales.year,
      measureFn: (OrdinalSales sales, _) => sales.sales,
      data: data,
    )
  ];
}

//class
class SimpleBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleBarChart(this.seriesList, {this.animate});

  /// Creates a [BarChart] with sample data and no transition.
  factory SimpleBarChart.withSampleData() {
    return new SimpleBarChart(
      _createSampleDataKilo(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      primaryMeasureAxis:
          new charts.NumericAxisSpec(tickProviderSpec: new charts.BasicNumericTickProviderSpec(dataIsInWholeNumbers: true, desiredTickCount: 5)),
    );
  }

  /// Create one series with sample hard coded data.
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}

//
/// Example of a simple line chart.
//

List<charts.Series<LinearSales, int>> _createSampleDataSu() {
  final data = <LinearSales>[];
  for (int i = 0; i < listSu.length; i++) {
    double value = double.parse(listSu[i].deger);
    data.add(new LinearSales(i, value));
  }
  /*final data = [
    new LinearSales(0, 98),
    new LinearSales(1, 96),
    new LinearSales(2, 92),
    new LinearSales(3, 89),
    new LinearSales(4, 93),
    new LinearSales(5, 91),
    new LinearSales(6, 90),
    new LinearSales(7, 88),
    new LinearSales(8, 88),
    new LinearSales(9, 87),
    new LinearSales(10, 84),
    new LinearSales(11, 80),
  ];*/

  return [
    new charts.Series<LinearSales, int>(
      id: 'Sales',
      colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
      domainFn: (LinearSales sales, _) => sales.year,
      measureFn: (LinearSales sales, _) => sales.sales,
      data: data,
    )
  ];
}

///class
class SimpleLineChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleLineChart(this.seriesList, {this.animate});

  /// Creates a [LineChart] with sample data and no transition.
  factory SimpleLineChart.withSampleData() {
    return new SimpleLineChart(
      _createSampleDataSu(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(
      seriesList,
      animate: animate,
      primaryMeasureAxis:
          new charts.NumericAxisSpec(tickProviderSpec: new charts.BasicNumericTickProviderSpec(dataIsInWholeNumbers: true, desiredTickCount: 4)),
      defaultRenderer: new charts.LineRendererConfig(
        includePoints: true,
        includeArea: true,
        layoutPaintOrder: charts.LayoutViewPaintOrder.line,
        areaOpacity: 0.5,
      ),
    );
  }

  /// Create one series with sample hard coded data.
}

/// Sample linear data type.
class LinearSales {
  final int year;
  final double sales;

  LinearSales(this.year, this.sales);
}
