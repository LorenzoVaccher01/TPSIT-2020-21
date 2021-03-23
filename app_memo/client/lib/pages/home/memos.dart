import 'package:app_memo/pages/home/views/memo.dart';
import 'package:app_memo/pages/home/widget/actionButton.dart';
import 'package:app_memo/pages/home/widget/menu.dart';
import 'package:app_memo/utils/models/memo.dart';
import 'package:app_memo/utils/models/tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemosPage extends StatefulWidget {
  @override
  _MemosPageState createState() => _MemosPageState();
}

class _MemosPageState extends State<MemosPage> {
  final String _showTwoCardSettingName = "memo.display";
  final String _sortSettingName = "memo.sort";
  bool _showTwoCard = true;
  bool _sortValue = true; //true → a to z
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
    _sortValue = _prefs.getBool(_sortSettingName) ?? _sortValue;
    _showTwoCard = _prefs.getBool(_showTwoCardSettingName) ?? _showTwoCard;
  }

  _getMemos({String attributes = ''}) async {
    _memos = await Memo.get(context, attributes);
    await _sortMemos(refresh: false);
    setState(() {});
  }

  Future<void> _sortMemos({bool refresh}) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if (_sortValue)
      _memos.sort((a, b) =>
          a.title.split(' ').join('').compareTo(b.title.split(' ').join('')));
    else
      _memos.sort((a, b) =>
          b.title.split(' ').join('').compareTo(a.title.split(' ').join('')));

    if (refresh) setState(() {});
  }

  Future<Null> _refreshMemos() async {
    _searching = false;
    print('Refreshing memos...');
    _getMemos();
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

    String _getDate(String inputDate) {
      List<String> date = inputDate.split('T')[0].split('-');
      List<String> time = inputDate.split('T')[1].split(':');
      time.removeAt(2);

      return "${date[2]}/${date[1]}/${date[0]} ${(int.parse(time[0]) + 1).toString()}:${time[1]}";
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

    String _getMemoTags(List<Tag> tags) {
      String _tagsReturn = "";
      int count = 0;

      tags.forEach((tag) {
        if (count >= 6) return;
        _tagsReturn += "#" + tag.name + " ";
        count++;
      });

      return _tagsReturn;
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
                  icon: Icon(Icons.sort_by_alpha),
                  onPressed: () async {
                    SharedPreferences _prefs =
                        await SharedPreferences.getInstance();
                    _sortValue = !_sortValue;
                    _prefs.setBool(_sortSettingName, _sortValue);
                    _sortMemos(refresh: true);
                  }),
            ),
            Visibility(
                visible: _searching,
                child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
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
                        dynamic status = await Memo.put(
                            context,
                            result['id'],
                            result['name'],
                            result['body'],
                            result['category'],
                            result['color'],
                            result['tags'],
                            result['accounts']);

                        if (status['error'] == 1 || status['error'] == 404) {
                          _memos[index].title = result['name'];
                          _memos[index].body = result['body'];
                          _memos[index].category = result['category'];
                          _memos[index].color = new Color(int.parse(
                                  result['color'].substring(1, 7),
                                  radix: 16) +
                              0xFF000000);
                          _memos[index].tags = result['tags'];
                          _memos[index].sharers =
                              new List<String>.from(status['accounts']);
                          setState(() {});
                        }
                      },
                      child: new Container(
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: !_memos[index].isOwner
                                ? Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Icon(Icons.people,
                                        color: Colors.black54, size: 22))
                                : Container(),
                            ),
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
                            _memos[index].category.id != 1
                                ? Padding(
                                    padding: EdgeInsets.only(top: 15),
                                    child: Container(
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
                                                  _memos[index].color, 0.2),
                                              spreadRadius: 0.3),
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(),
                            _memos[index].tags.length != 0
                                ? Padding(
                                    padding: EdgeInsets.only(top: 15),
                                    child: Text(
                                        _getMemoTags(_memos[index].tags),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                  )
                                : Container(),
                            Padding(
                              padding: EdgeInsets.only(top: 15),
                              child: Text(_getDate(_memos[index].creationDate),
                                  style: TextStyle(
                                      color: Colors.grey[700], fontSize: 12)),
                            ),
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
        floatingActionButton: HomeActionButton(),
      ),
    );
  }
}
