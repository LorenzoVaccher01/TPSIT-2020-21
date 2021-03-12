import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class HomeActionButton extends StatefulWidget {
  @override
  _HomeActionButtonState createState() => _HomeActionButtonState();
}

class _HomeActionButtonState extends State<HomeActionButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
        tooltip: 'Add',
        icon: Icons.add,
        activeIcon: Icons.remove,
        iconTheme: IconThemeData(color: Colors.white, size: 30),
        backgroundColor: Theme.of(context).accentColor,
        foregroundColor: Colors.white,
        overlayOpacity: 0,
        children: [
          SpeedDialChild(
            child: Icon(Icons.tag),
            label: 'Tag',
            backgroundColor: Colors.deepOrange,
          ),
          SpeedDialChild(
            child: Icon(Icons.category),
            label: 'Category',
            backgroundColor: Colors.cyan,
          ),
          SpeedDialChild(
            child: Icon(Icons.note_add),
            label: 'Memo',
            backgroundColor: Colors.amber,
          ),
        ]);
  }
}
