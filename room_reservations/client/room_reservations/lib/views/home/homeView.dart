import 'package:flutter/material.dart';
import 'package:room_reservations/views/home/components/menu.dart';

class HomeView extends StatelessWidget {
  final List<String> _weekDays = ["S", "M", "T", "W", "T", "F", "S"];

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Menu(),
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.menu),
            iconSize: 25.0,
            color: Colors.white,
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            },
          ),
        ),
      ),
      
    );
  }
}