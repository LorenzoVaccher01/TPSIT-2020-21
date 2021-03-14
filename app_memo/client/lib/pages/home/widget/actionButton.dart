import 'package:app_memo/pages/home/views/category.dart';
import 'package:app_memo/pages/home/views/tag.dart';
import 'package:app_memo/pages/home/views/memo.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:app_memo/widget/alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../main.dart' as App;

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
              onTap: () async {
                final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TagPage(true, null, null, null, null, null)));
                if (result != null) {
                  SharedPreferences _prefs =
                      await SharedPreferences.getInstance();
                  final response = await http.post(
                    App.SERVER_WEB +
                        '/api/tag?name=' +
                        result['name'] +
                        '&description=' +
                        result['description'],
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                      'Cookie': _prefs.getString('user.sessionCookie')
                    },
                  );
                  print(response.statusCode);
                  if (response.statusCode == 200) {
                    final bodyResponse = json.decode(response.body);
                    if (bodyResponse['error'] == 200) {
                      if (ModalRoute.of(context).settings.name == '/tags')
                        Navigator.pushNamed(
                            context, ModalRoute.of(context).settings.name);
                    } else {
                      Alert(
                        context: context,
                        closeButton: false,
                        textConfirmButton: 'Ok',
                        textCanelButton: "",
                        onClick: () {},
                        title: 'Error',
                        body: Text(bodyResponse['message']),
                      );
                    }
                  } else {
                    Alert(
                      context: context,
                      closeButton: false,
                      textConfirmButton: 'Ok',
                      textCanelButton: "",
                      onClick: () {},
                      title: 'Error',
                      body: Text("General internal error"),
                    );
                  }
                }
              }),
          SpeedDialChild(
              child: Icon(Icons.category),
              label: 'Category',
              backgroundColor: Colors.cyan,
              onTap: () async {
                final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CategoryPage(true, null, null, null, null, null)));
                if (result != null) {
                  SharedPreferences _prefs =
                      await SharedPreferences.getInstance();
                  final response = await http.post(
                    App.SERVER_WEB +
                        '/api/category?name=' +
                        result['name'] +
                        '&description=' +
                        result['description'],
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                      'Cookie': _prefs.getString('user.sessionCookie')
                    },
                  );
                  print(response.statusCode);
                  if (response.statusCode == 200) {
                    final bodyResponse = json.decode(response.body);
                    if (bodyResponse['error'] == 200) {
                      if (ModalRoute.of(context).settings.name == '/categories')
                        Navigator.pushNamed(
                            context, ModalRoute.of(context).settings.name);
                    } else {
                      Alert(
                        context: context,
                        closeButton: false,
                        textConfirmButton: 'Ok',
                        textCanelButton: "",
                        onClick: () {},
                        title: 'Error',
                        body: Text(bodyResponse['message']),
                      );
                    }
                  } else {
                    Alert(
                      context: context,
                      closeButton: false,
                      textConfirmButton: 'Ok',
                      textCanelButton: "",
                      onClick: () {},
                      title: 'Error',
                      body: Text("General internal error"),
                    );
                  }
                }
              }),
          SpeedDialChild(
              child: Icon(Icons.note_add),
              label: 'Memo',
              backgroundColor: Colors.amber,
              onTap: () async {
                final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MemoPage(true, null)));
                if (result != null) {
                  SharedPreferences _prefs =
                      await SharedPreferences.getInstance();
                  final response = await http.post(
                    App.SERVER_WEB +
                        '/api/memo?name=' + //TODO: inserire tutti i campi
                        result['name'] +
                        '&description=' +
                        result['description'],
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                      'Cookie': _prefs.getString('user.sessionCookie')
                    },
                  );
                  print(response.statusCode);
                  if (response.statusCode == 200) {
                    final bodyResponse = json.decode(response.body);
                    if (bodyResponse['error'] == 200) {
                      if (ModalRoute.of(context).settings.name == '/home')
                        Navigator.pushNamed(
                            context, ModalRoute.of(context).settings.name);
                    } else {
                      Alert(
                        context: context,
                        closeButton: false,
                        textConfirmButton: 'Ok',
                        textCanelButton: "",
                        onClick: () {},
                        title: 'Error',
                        body: Text(bodyResponse['message']),
                      );
                    }
                  } else {
                    Alert(
                      context: context,
                      closeButton: false,
                      textConfirmButton: 'Ok',
                      textCanelButton: "",
                      onClick: () {},
                      title: 'Error',
                      body: Text("General internal error"),
                    );
                  }
                }
              }),
        ]);
  }
}
