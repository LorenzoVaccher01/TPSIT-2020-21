import 'package:app_memo/pages/home/views/memo.dart';
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

class MemosPage extends StatefulWidget {
  @override
  _MemosPageState createState() => _MemosPageState();
}

class _MemosPageState extends State<MemosPage> {
  final String _showTwoCardSettingName = "memo.display";
  bool _showTwoCard = true;
  List<Memo> _memos = [];
  bool _searching = false;

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
    _memos = await (new Memo()).getMemos(context, attributes);
    setState(() {});
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

    Future<Null> _refreshMemos() async {
      _searching = false;
      print('Refreshing memos...');
      _getMemos();
    }

    String _trimString(String string, String type) {
      switch (type) {
        case 'title':
          if (string.length >= 28) if (_showTwoCard)
            return string.substring(0, 28).trim() + '...';
          else {
            if (string.length >= 75)
              return string.substring(0, 75).trim() + '...';
          }
          break;
        case 'category':
          if (string.length >= 17) if (_showTwoCard)
            return string.substring(0, 17).trim() + '...';
          else {
            if (string.length >= 45)
              return string.substring(0, 45).trim() + '...';
          }
          break;
        case 'body':
          if (string.length >= 260) if (_showTwoCard)
            return string.substring(0, 260).trim() + '...';
          else {
            if (string.length >= 800)
              return string.substring(0, 800).trim() + '...';
          }
      }
      return string.trim();
    }

    Future<void> _searchMemo() {
      TextEditingController _controller = new TextEditingController();
      return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                title: Text("Search memo"),
                content: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        counterText: "",
                        labelText: "Search...",
                        labelStyle:
                            TextStyle(color: Colors.grey, fontSize: 22)),
                    maxLength: 60,
                    style: TextStyle(color: Colors.black)),
                actions: [
                  FlatButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text("Search"),
                    onPressed: () {
                      _searching = true;
                      Navigator.of(context).pop();
                      _getMemos(attributes: 'search=' + _controller.text);
                    },
                  ),
                ],
              );
            });
          });
    }

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
            Visibility(
              visible: !_searching,
              child: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _searchMemo();
                  }),
            ),
            Visibility(
              visible: !_searching,
              child: IconButton(
                  icon: Icon(Icons.sort),
                  onPressed: () {
                    //TODO: realizzare il sistema per il sorting
                  }),
            ),
            Visibility(
                visible: _searching,
                child: IconButton(icon: Icon(Icons.close), onPressed: () {
                  _searching = false;
                  _getMemos();
                })),
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
              ? Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset("assets/img/sad.png", height: 90, width: 90),
                      Padding(padding: EdgeInsets.only(top: 30)),
                      Text('No memos were found!',
                          style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey)),
                      Padding(padding: EdgeInsets.only(top: 30)),
                      ElevatedButton.icon(
                          onPressed: () => _refreshMemos(),
                          label: Text("Refresh"),
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).accentColor,
                          ),
                          icon: Icon(Icons.refresh))
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _refreshMemos,
                  child: StaggeredGridView.countBuilder(
                    physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    controller: ScrollController(),
                    crossAxisCount: (_showTwoCard ? 4 : 2),
                    itemCount: _memos.length,
                    padding:
                        EdgeInsets.only(top: 10, bottom: 10, left: 8, right: 8),
                    staggeredTileBuilder: (int index) =>
                        new StaggeredTile.fit(2),
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                    itemBuilder: (BuildContext context, int index) => InkWell(
                      onTap: () async {
                        final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MemoPage(false, _memos[index])));
                        print(result);
                        //TODO: comunicare dati al server
                      },
                      child: new Container(
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 13),
                              child: Text(
                                  _trimString(_memos[index].title, 'title'),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Text(_trimString(_memos[index].body, 'body'),
                                style: TextStyle(
                                    color: Colors.grey[700], fontSize: 14)),
                            Padding(padding: EdgeInsets.only(top: 15)),
                            _memos[index].category.id != 1
                                ? Container(
                                    child: Text(_trimString(
                                        _memos[index].category.name,
                                        'category')),
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.transparent,
                                      boxShadow: [
                                        BoxShadow(
                                            color: _darken(
                                                _memos[index].color, 0.09),
                                            spreadRadius: 0.3),
                                      ],
                                    ),
                                  )
                                : Container()
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
                ),
        ),
        floatingActionButton: _memos.length != 0 ? HomeActionButton() : null,
      ),
    );
  }
}
