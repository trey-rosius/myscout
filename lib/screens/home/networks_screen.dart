
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myscout/screens/home/placeholder.dart';



const Color _kKeyUmbraOpacity = Color(0x33000000); // alpha = 0.2
const Color _kKeyPenumbraOpacity = Color(0x24000000); // alpha = 0.14
const Color _kAmbientShadowOpacity = Color(0x1F000000); // alpha = 0.12

class NetworkScreen extends StatefulWidget {
  static const String routeName = 'cupertino/segmented_control';

  @override
  _NetworkScreenState createState() => _NetworkScreenState();
}

class _NetworkScreenState extends State<NetworkScreen> {
  final Map<int, Widget> children = const <int, Widget>{
    0: Text('Midnight'),
    1: Text('Viridian'),
    2: Text('Cerulean'),
  };

  final Map<int, Widget> icons =  <int, Widget>{
    0: Center(
      child: PlaceholderWidget(
         Colors.indigo

      ),
    ),
    1: Center(
      child: PlaceholderWidget(
          Colors.indigo

      ),
    ),
    2: Center(
        child: PlaceholderWidget(
            Colors.indigo

        ),
    )
  };

  int sharedValue = 0;

  @override
  Widget build(BuildContext context) {
    return  DefaultTextStyle(
        style: CupertinoTheme.of(context).textTheme.textStyle,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(16.0),
              ),
              SizedBox(
                width: 500.0,
                child: CupertinoSegmentedControl<int>(
                  children: children,
                  onValueChanged: (int newValue) {
                    setState(() {
                      sharedValue = newValue;
                    });
                  },
                  groupValue: sharedValue,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 32.0,
                    horizontal: 16.0,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 64.0,
                      horizontal: 16.0,
                    ),
                    decoration: BoxDecoration(
                      color: CupertinoTheme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(3.0),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          offset: Offset(0.0, 3.0),
                          blurRadius: 5.0,
                          spreadRadius: -1.0,
                          color: _kKeyUmbraOpacity,
                        ),
                        BoxShadow(
                          offset: Offset(0.0, 6.0),
                          blurRadius: 10.0,
                          spreadRadius: 0.0,
                          color: _kKeyPenumbraOpacity,
                        ),
                        BoxShadow(
                          offset: Offset(0.0, 1.0),
                          blurRadius: 18.0,
                          spreadRadius: 0.0,
                          color: _kAmbientShadowOpacity,
                        ),
                      ],
                    ),
                    child: icons[sharedValue],
                  ),
                ),
              ),
            ],
          ),
        ),

    );
  }
}