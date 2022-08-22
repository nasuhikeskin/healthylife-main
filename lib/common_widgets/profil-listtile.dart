import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ProfilListTile extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const ProfilListTile({Key key, @required this.title, @required this.onPressed})
      : assert(title != null, onPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            onTap: () {
              onPressed();
            },
            title: Text(title),
            trailing: Icon(
              Icons.arrow_forward_ios,
            ),
          )
        ],
      ),
    );
  }
}
