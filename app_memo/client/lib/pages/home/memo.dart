import 'package:app_memo/pages/home/widget/actionButton.dart';
import 'package:app_memo/pages/home/widget/appBar.dart';
import 'package:app_memo/pages/home/widget/menu.dart';
import 'package:app_memo/utils/models/memo.dart';
import 'package:app_memo/widget/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../main.dart' as App;

class MemoPage extends StatefulWidget {
  @override
  _MemoPageState createState() => _MemoPageState();
}

class _MemoPageState extends State<MemoPage> {
  final String _showTwoCardSettingName = "memo.display";
  bool _showTwoCard = true;
  List<Memo> _memos = [];
  
  @override
  void initState() {
    _setSettings();
    _getMemos();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _setSettings() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _showTwoCard = _prefs.getBool(_showTwoCardSettingName) ?? _showTwoCard;
    setState(() {});
  }

  _getMemos({String attributes = ''}) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final response = await http.get(App.SERVER_WEB + '/api/memo?' + attributes,
    headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Cookie': _prefs.getString('user.sessionCookie')
      },
    );

    if (response.statusCode == 200) {
      final bodyResponse = json.decode(response.body);
      if (bodyResponse['error'] == 200) {
        _memos.clear();
        for (var i = 0; i < bodyResponse['data'].length; i++)
          _memos.add(new Memo.fromJson( bodyResponse['data'][i]));
        setState(() {});
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

  Color _darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Menu(),
        appBar: AppBar(
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
              icon: Icon(_showTwoCard
                  ? Icons.horizontal_split_rounded
                  : Icons.dashboard),
              onPressed: () async {
                _showTwoCard = !_showTwoCard;
                SharedPreferences _prefs =
                    await SharedPreferences.getInstance();
                _prefs.setBool(_showTwoCardSettingName, _showTwoCard);
                setState(() {});
              },
            ),
          ],
        ),
        body: Container(
          alignment: Alignment.center,
          child: _memos.length == 0
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/img/sad.png",
                        height: 90, width: 90),
                    Padding(padding: EdgeInsets.only(top: 30)),
                    Text('No memos were found!', style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold, color: Colors.grey))
                    ],
                )
              : StaggeredGridView.countBuilder(
                  crossAxisCount: (_showTwoCard ? 4 : 2),
                  itemCount: _memos.length,
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 8, right: 8),
                  staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  itemBuilder: (BuildContext context, int index) =>
                      new Container(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 13),
                          child: Text(_memos[index].title,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Text(
                            _memos[index].body,
                            style: TextStyle(
                                color: Colors.grey[700], fontSize: 14)),
                        Padding(padding: EdgeInsets.only(top: 15)),
                        _memos[index].category.id != 1 ? 
                        Container(
                          child: Text(_memos[index].category.name),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.transparent,
                            boxShadow: [
                              BoxShadow(color: _darken(_memos[index].color, 0.09), spreadRadius: 0.3),
                            ],
                          ),
                        ) : Container()
                      ],
                    ),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: _memos[index].color,
                      boxShadow: [
                        BoxShadow(color: Colors.grey, spreadRadius: 0.3),
                      ],
                    ),
                  ),
                ),
        ),
        floatingActionButton: HomeActionButton(),
      ),
    );
  }
}
