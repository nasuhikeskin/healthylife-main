import 'package:diyetin_app/common_widgets/platformbasedwidget/platform_belirleme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformBasedDatePicker extends PlatformBasedWidget {
  @override
  Widget buildAndroidWidget(BuildContext context) {
    final Future<DateTime> secilenTarih = showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2010),
        lastDate: DateTime(2030));
    return Text(secilenTarih.toString());
  }

  @override
  Widget buildIOSWidget(BuildContext context) {
    return CupertinoDatePicker(
      onDateTimeChanged: (val) {
        String secilenTarih = val.toString();
      },
      initialDateTime: DateTime.now(),
    );
  }
}
