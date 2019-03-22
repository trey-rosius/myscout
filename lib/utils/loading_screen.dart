
import 'package:flutter/cupertino.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "loading",
        style: new TextStyle(
          fontSize: 20.0,

        ),
      ),
    ));
  }
}
