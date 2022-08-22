import 'package:diyetin_app/common_widgets/platformbasedwidget/platform_belirleme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformBasedActionSheet extends PlatformBasedWidget {
  final String baslik;
  PlatformBasedActionSheet({@required this.baslik});

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 4,
      color: Colors.grey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(baslik),
          ElevatedButton(onPressed: () {}, child: Text("kamera")),
          ElevatedButton(onPressed: () {}, child: Text("galeri")),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("vazgeç"))
        ],
      ),
    );
  }

  @override
  Widget buildIOSWidget(BuildContext context) {
    return CupertinoActionSheet(
      title: Text(baslik),
      actions: [
        CupertinoActionSheetAction(onPressed: () {}, child: Text("kamera")),
        CupertinoActionSheetAction(onPressed: () {}, child: Text("galeri"))
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text("vazgeç"),
        isDefaultAction: true,
        onPressed: () {
          Navigator.pop(context, "vazgeç");
        },
      ),
    );
  }
}
