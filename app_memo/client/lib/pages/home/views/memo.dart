import 'package:app_memo/pages/home/widget/actionButton.dart';
import 'package:app_memo/utils/models/category.dart';
import 'package:app_memo/utils/models/memo.dart';
import 'package:app_memo/utils/models/tag.dart';
import 'package:app_memo/widget/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../main.dart' as App;

class MemoPage extends StatefulWidget {
  bool _newMemo;
  Memo _memo;

  MemoPage(this._newMemo, this._memo);

  @override
  _MemoPageState createState() => _MemoPageState();
}

class _MemoPageState extends State<MemoPage> {
  TextEditingController _titleController;
  TextEditingController _bodyController;

  List<Color> _colors = [
    Colors.white,
    Colors.pink[200],
    Colors.pinkAccent[100],
    Colors.red[200],
    Colors.redAccent[100],
    Colors.deepOrange[200],
    Colors.deepOrangeAccent[100],
    Colors.orange[200],
    Colors.orangeAccent[100],
    Colors.amber[200],
    Colors.amberAccent[100],
    Colors.yellow[200],
    Colors.yellowAccent[100],
    Colors.lime[200],
    Colors.limeAccent[100],
    Colors.lightGreen[200],
    Colors.lightGreenAccent[100],
    Colors.green[200],
    Colors.greenAccent[100],
    Colors.teal[200],
    Colors.tealAccent[100],
    Colors.cyan[200],
    Colors.cyanAccent[100],
    Colors.lightBlue[200],
    Colors.lightBlueAccent[100],
    Colors.blue[200],
    Colors.blueAccent[100],
    Colors.indigo[200],
    Colors.indigoAccent[100],
    Colors.purple[200],
    Colors.purpleAccent[100],
    Colors.deepPurple[200],
    Colors.deepPurpleAccent[100],
    Colors.blueGrey[200],
    Colors.brown[200],
    Colors.grey[200]
  ];
  List<Category> _categories = [];
  List<Tag> _tags = [];

  Color _selectedColor;
  Category _selectedCategory;
  List<Tag> _selectedTags;
  List<String> _sharers;

  @override
  void initState() {
    _selectedColor = this.widget._memo != null ? this.widget._memo.color : _colors[0];
    this.widget._memo != null ? _getSharers() : null;
    _sharers = ["tommaso.rizzo@itiszuccante.edu.it", "jiahao.ruan@itiszuccante.edu.it", "elia.coro@itiszuccante.edu.it"];
    super.initState();
  }

  //TODO: ottenere tutti quelli che hanno accesso a questo account
  void _getSharers() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      App.SERVER_WEB + '/api/sharers?memoId' + this.widget._memo.id.toString(),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Cookie': _prefs.getString('user.sessionCookie')
      },
    );

    if (response.statusCode == 200) {
      final bodyResponse = json.decode(response.body);
      if (bodyResponse['error'] == 200) {
        _sharers.clear();
        for (var i = 0; i < bodyResponse['data'].length; i++)
          _sharers.add((bodyResponse['data'][i]));
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

  @override
  Widget build(BuildContext context) {
    _titleController = TextEditingController(
        text: this.widget._newMemo ? '' : this.widget._memo.title);
    _bodyController = TextEditingController(
        text: this.widget._newMemo ? '' : this.widget._memo.body);

    Future<void> _openColorsMenu() {
      return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                title: Text("Select a color"),
                content: ListView.builder(
                    itemCount: _colors.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            (_selectedColor == _colors[index]
                                ? Icon(Icons.check)
                                : Container()),
                            Container(
                              margin: index != 0
                                  ? EdgeInsets.only(top: 15)
                                  : EdgeInsets.all(0),
                              height: 40,
                              width: 180,
                              decoration: BoxDecoration(
                                  color: _colors[index],
                                  border: Border.all(color: Colors.grey[300]),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                          ],
                        ),
                        onTap: () {
                          _selectedColor = _colors[index];
                          setState(() {});
                        },
                      );
                    }),
                actions: [
                  FlatButton(
                    child: Text("Done"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
          });
    }

    Future<void> _openCategoriesMenu() async {
      _categories = await (new Category()).getCategories(context);
      _categories.insert(
          0,
          new Category(
              id: 1,
              name: 'No category',
              description: '',
              creationDate: '',
              lastModifiedDate: ''));
      _selectedCategory = this.widget._memo != null
          ? this.widget._memo.category
          : _categories[0];
      return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                title: Text("Select a category"),
                content: ListView.separated(
                    itemCount: _categories.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(),
                    itemBuilder: (context, index) {
                      return InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: (_selectedCategory == _categories[index]
                                  ? Icon(Icons.check)
                                  : Container()),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 10,
                                  bottom: 10,
                                  left: (_selectedCategory == _categories[index]
                                      ? 10
                                      : 30)),
                              child: Text(
                                _categories[index].name,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          _selectedCategory = _categories[index];
                          setState(() {});
                        },
                      );
                    }),
                actions: [
                  FlatButton(
                    child: Text("Done"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
          });
    }

    Future<void> _openTagsMenu() async {
      _tags = await (new Tag()).getTags(context);

      _selectedTags = this.widget._memo != null ? this.widget._memo.tags : [];
      return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                title: Text("Select tags"),
                content: ListView.separated(
                    itemCount: _tags.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(),
                    itemBuilder: (context, index) {
                      return InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: (_selectedTags.contains(_tags[index])
                                  ? Icon(Icons.check)
                                  : Container()),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 10,
                                  bottom: 10,
                                  left: (_selectedTags.contains(_tags[index])
                                      ? 10
                                      : 30)),
                              child: Text(
                                '#' + _tags[index].name,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          if (_selectedTags.contains(_tags[index]))
                            _selectedTags.remove(_tags[index]);
                          else
                            _selectedTags.add(_tags[index]);
                          setState(() {});
                        },
                      );
                    }),
                actions: [
                  FlatButton(
                    child: Text("Done"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
          });
    }

    Future<void> _openShareMenu() async {
      return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                title: Text("Share memo"),
                content: ListView.separated(
                    itemCount: _sharers.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(),
                    itemBuilder: (context, index) {
                      return InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: (_sharers.contains(_sharers[index])
                                  ? Icon(Icons.check)
                                  : Container()),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 10,
                                  bottom: 10,
                                  left: (_selectedTags.contains(_tags[index])
                                      ? 10
                                      : 30)),
                              child: Text(
                                '#' + _tags[index].name,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          if (_selectedTags.contains(_tags[index]))
                            _selectedTags.remove(_tags[index]);
                          else
                            _selectedTags.add(_tags[index]);
                          setState(() {});
                        },
                      );
                    }),
                actions: [
                  FlatButton(
                    child: Text("Done"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
          });
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 8.0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(this.widget._newMemo
            ? 'Add memo'
            : 'Edit "${this.widget._memo.title}"'),
        leading: IconButton(
          iconSize: 25,
          icon: Icon(Icons.arrow_back_outlined),
          onPressed: () {
            /*if (_titleController.text != this._memo.title ||
                _bodyController.text != this._memo.body) {*/
            Alert(
              context: context,
              closeButton: true,
              textConfirmButton: 'Yes',
              textCanelButton: "No",
              onClick: () {
                Navigator.of(context).pop();
              },
              title: 'Warning',
              body:
                  Text("Are you sure you want to exit without saving changes?"),
            );
            /*} else {
              Navigator.of(context).pop();
            }*/
          },
        ),
        actions: [
          (this.widget._newMemo
              ? Container()
              : IconButton(
                  iconSize: 25,
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    //TODO: eliminare memo
                  })),
          IconButton(
            iconSize: 25,
            icon: Icon(Icons.save),
            onPressed: () => Navigator.pop(context,
                {"name": _titleController.text, "body": _bodyController.text}),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.grey[600],
        unselectedItemColor: Colors.grey[600],
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.color_lens_rounded), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.tag), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.send), label: '')
        ],
        onTap: (int index) async {
          switch (index) {
            case 0:
              await _openColorsMenu();
              break;
            case 1:
              await _openCategoriesMenu();
              break;
            case 2:
              await _openTagsMenu();
              break;
            case 3:
              print('asdasdasdasd');
              break;
          }
        },
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          TextField(
              controller: _titleController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  counterText: "",
                  labelText: "Title:",
                  labelStyle: TextStyle(color: Colors.grey, fontSize: 22)),
              maxLength: 35,
              style: TextStyle(color: Colors.black)),
          TextField(
            controller: _bodyController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
                border: InputBorder.none,
                labelText: "Body:",
                labelStyle: TextStyle(color: Colors.grey, fontSize: 22)),
            maxLength: 65535,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
