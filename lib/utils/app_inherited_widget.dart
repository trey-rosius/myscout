
import 'package:flutter/material.dart';
import 'package:myscout/utils/app_settings.dart';
import 'package:myscout/utils/app_settings_inherited.dart';


class AppInheritedWidget extends StatefulWidget {

  AppInheritedWidget({
    Key key,
    this.child,
    this.settings,
  }): super(key: key);

  final Widget child;
  final AppSettings settings;
  @override
  _AppInheritedWidgetState createState() => _AppInheritedWidgetState();


}

class _AppInheritedWidgetState extends State<AppInheritedWidget> {


  @override
  Widget build(BuildContext context) {

    return AppSettingsInherited(
      child: widget.child,
      settings:widget.settings ,
    );
  }
}
