/*import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../main.dart' as App;

class AppBarPage extends StatefulWidget implements PreferredSizeWidget {
  AppBarPage({Key key})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _AppBarPageState createState() => _AppBarPageState();
}

class _AppBarPageState extends State<AppBarPage> {
  final String _showTwoCardSettingName = "memo.display";
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _showTwoCard = true;

  _setSettings() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _showTwoCard = _prefs.getBool(_showTwoCardSettingName) ?? _showTwoCard;
    setState(() {});
  }

  @override
  void initState() {
    _setSettings();
    super.initState();
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  AppBar build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: false,
      elevation: 8.0,
      backgroundColor: Theme.of(context).primaryColor,
      title: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
                text: 'Memos',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.menu),
        iconSize: 25.0,
        color: Colors.white,
        onPressed: () {
          _scaffoldKey.currentState.openDrawer();
        },
      ),
      actions: [
        IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              //TODO: realizzare sistema per la ricerca
            }),
        IconButton(
            icon: Icon(Icons.sort),
            onPressed: () {
              //TODO: realizzare il sistema per il sorting
            }),
        IconButton(
          icon: Icon(
              _showTwoCard ? Icons.horizontal_split_rounded : Icons.dashboard),
          onPressed: () async {
            _showTwoCard = !_showTwoCard;
            SharedPreferences _prefs = await SharedPreferences.getInstance();
            _prefs.setBool(_showTwoCardSettingName, _showTwoCard);
            setState(() {});
          },
        ),
      ],
    );
  }
}
*/