import 'package:app_memo/pages/home/widget/actionButton.dart';
import 'package:app_memo/pages/home/widget/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemoPage extends StatefulWidget {
  @override
  _MemoPageState createState() => _MemoPageState();
}

class _MemoPageState extends State<MemoPage> {
  final String _showTwoCardSettingName = "memo.display";
  bool _showTwoCard = true;

  @override
  void initState() {
    _setSettings();
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

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
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
                onPressed: () async {
                  _showTwoCard = !_showTwoCard;
                  SharedPreferences _prefs = await SharedPreferences.getInstance();
                  _prefs.setBool(_showTwoCardSettingName, _showTwoCard);
                  setState(() {});
                },
                icon: Icon(_showTwoCard
                    ? Icons.horizontal_split_rounded
                    : Icons.dashboard))
          ],
        ),
        drawer: Menu(),
        body: Container(
          child: StaggeredGridView.countBuilder(
            crossAxisCount: (_showTwoCard ? 4 : 2),
            itemCount: 60,
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 8, right: 8),
            staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
            itemBuilder: (BuildContext context, int index) => 
            new Container(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 13),
                    child: Text('Titolo molto titoloso!',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                  ),
                  Text(
                      'Questo è un testo molto testoso per testare l\'applicazione',
                      style: TextStyle(color: Colors.grey[700], fontSize: 14))
                ],
              ),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
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
