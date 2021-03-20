import 'package:app_memo/utils/models/category.dart';
import 'package:app_memo/utils/models/memo.dart';
import 'package:app_memo/utils/models/tag.dart';
import 'package:app_memo/widget/alert.dart';
import 'package:flutter/material.dart';

class MemoPage extends StatefulWidget {
  bool _newMemo;
  Memo _memo;
  Color _selectedColor;
  Category _selectedCategory;
  List<Tag> _selectedTags = [];
  List<String> _sharers;

  MemoPage(this._newMemo, this._memo);

  @override
  _MemoPageState createState() => _MemoPageState();
}

class _MemoPageState extends State<MemoPage> {
  TextEditingController _titleController;
  TextEditingController _bodyController;
  FocusNode _focusNodeTitle = FocusNode();
  FocusNode _focusNodeBoby = FocusNode();

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

  @override
  void initState() {
    widget._selectedColor =
        this.widget._memo != null ? this.widget._memo.color : _colors[0];

    _categories.insert(
        0,
        new Category(
            id: 1,
            name: 'No category',
            description: '',
            creationDate: '',
            lastModifiedDate: ''));

    widget._selectedCategory = this.widget._memo != null
        ? this.widget._memo.category.id == 1
            ? _categories[0]
            : this.widget._memo.category
        : _categories[0];

    if (this.widget._memo != null) {
      (this.widget._memo.tags).forEach((element) {
        this.widget._selectedTags.add(element);
      });
    }

    //this.widget._memo != null ? _getSharers() : null; //TODO: decommentare una volta finito il sistema per la condivisione
    widget._sharers = [
      "tommaso.rizzo@itiszuccante.edu.it",
      "jiahao.ruan@itiszuccante.edu.it",
      "elia.coro@itiszuccante.edu.it",
      "giacomo.davanzo@itiszuccante.edu.it",
      "valentin.necula@itiszuccante.edu.it"
    ];
    super.initState();
  }

  //TODO: ottenere tutti quelli che hanno accesso a questo account
  void _getSharers() async {
    /*SharedPreferences _prefs = await SharedPreferences.getInstance();
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
        widget._sharers.clear();
        for (var i = 0; i < bodyResponse['data'].length; i++)
          widget._sharers.add((bodyResponse['data'][i]));
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
    }*/
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
                            (widget._selectedColor == _colors[index]
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
                          widget._selectedColor = _colors[index];
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
      _categories = _categories.sublist(0, 1);
      (await Category.get(context)).forEach((element) {
        _categories.add(element);
      });

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
                              child: (widget._selectedCategory.id ==
                                      _categories[index].id
                                  ? Icon(Icons.check)
                                  : Container()),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 10,
                                  bottom: 10,
                                  left: (widget._selectedCategory.id ==
                                          _categories[index].id
                                      ? 5
                                      : 30)),
                              child: Text(
                                _categories[index].name,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          widget._selectedCategory = _categories[index];
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
      _tags = await Tag.get(context);

      if (this.widget._memo != null)
        _tags.forEach((tag) {
          (widget._memo.tags).forEach((memoTag) {
            if (tag.id == memoTag.id) {
              widget._selectedTags.add(tag);
            }
          });
        });

      bool _check(Tag tag) {
        bool status = false;

        (widget._selectedTags)
            .forEach((element) => {if (element.id == tag.id) status = true});
        return status;
      }

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
                              child: _check(_tags[index])
                                  ? Icon(Icons.check)
                                  : Container(),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 10,
                                  bottom: 10,
                                  left: _check(_tags[index]) ? 10 : 30),
                              child: Text(
                                '#' + _tags[index].name,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          if ((widget._selectedTags)
                                  .where((element) =>
                                      element.id == _tags[index].id)
                                  .length >
                              0) {
                            for (int i = 0;
                                i < (widget._selectedTags).length;
                                i++) {
                              if ((widget._selectedTags)[i].id ==
                                  _tags[index].id)
                                widget._selectedTags
                                    .remove((widget._selectedTags)[i]);
                            }
                          } else {
                            widget._selectedTags.add(_tags[index]);
                          }
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
      TextEditingController _emailController = new TextEditingController();
      return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                title: Text("Share memo"),
                content: ListView.separated(
                    itemCount: widget._sharers.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(),
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          /*index == 0
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      TextField(
                                          controller: _emailController,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              counterText: "",
                                              labelText: "Email:",
                                              labelStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 18)),
                                          maxLength: 35,
                                          style:
                                              TextStyle(color: Colors.black)),
                                      InkWell(
                                          child: Icon(Icons.add,
                                              size: 30, color: Colors.green),
                                          onTap: () {
                                            print('TODO');
                                          })
                                    ])
                              : Container(),*/
                          InkWell(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                index != 0
                                    ? Padding(padding: EdgeInsets.only(top: 20))
                                    : Container(),
                                Text(widget._sharers[index].length >= 23
                                    ? widget._sharers[index].substring(0, 23) +
                                        '...'
                                    : widget._sharers[index]),
                                InkWell(
                                    child: Icon(Icons.delete,
                                        size: 30, color: Colors.grey),
                                    onTap: () {
                                      Alert(
                                        context: context,
                                        closeButton: true,
                                        textConfirmButton: "Yes",
                                        textCanelButton: "No",
                                        onClick: () async {
                                          print('TODO');
                                          //TODO: inviare richiesta al server per eliminazione utente condiviso
                                        },
                                        title: 'Alert',
                                        body: Text(
                                            "Do you really want to delete this tag?"),
                                      );
                                    })
                              ],
                            ),
                            onTap: () {
                              if (widget._selectedTags.contains(_tags[index]))
                                widget._selectedTags.remove(_tags[index]);
                              else
                                widget._selectedTags.add(_tags[index]);
                              setState(() {});
                            },
                          ),
                        ],
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

    void _unfocusTextFields() {
      _focusNodeTitle.unfocus();
      _focusNodeBoby.unfocus();
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 8.0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(this.widget._newMemo
            ? 'Add memo'
            : 'Edit "${this.widget._memo.title.length >= 11 ? this.widget._memo.title.substring(0, 11) + '...' : this.widget._memo.title}"'),
        leading: IconButton(
          iconSize: 25,
          icon: Icon(Icons.arrow_back_outlined),
          onPressed: () {
            void _showDialog() {
              Alert(
                context: context,
                closeButton: true,
                textConfirmButton: 'Yes',
                textCanelButton: "No",
                onClick: () {
                  Navigator.of(context).pop();
                },
                title: 'Warning',
                body: Text(
                    "Are you sure you want to exit without saving changes?"),
              );
            }

            if (this.widget._memo == null) {
              if (_titleController.text != '' ||
                  _bodyController.text != '' ||
                  widget._selectedCategory.id != 1 ||
                  widget._selectedColor != Colors.white) {
                //TODO: controllare anche tags e collaboratori
                _showDialog();
              } else {
                Navigator.of(context).pop();
              }
            } else {
              if (_titleController.text != widget._memo.title ||
                  _bodyController.text != widget._memo.body ||
                  widget._selectedColor != widget._memo.color ||
                  widget._selectedCategory != widget._memo.category) {
                //TODO: controllare anche tags e collaboratori
                _showDialog();
              } else {
                Navigator.of(context).pop();
              }
            }
          },
        ),
        actions: [
          (this.widget._newMemo
              ? Container()
              : IconButton(
                  iconSize: 25,
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    Alert(
                      context: context,
                      closeButton: true,
                      textConfirmButton: 'Yes!',
                      textCanelButton: "No",
                      onClick: () async {
                        await (Memo.delete(context, this.widget._memo));
                      },
                      title: 'Warning',
                      body: Text("Are you sure you want to delete this memo?"),
                    );
                  })),
          IconButton(
              iconSize: 25,
              icon: Icon(Icons.save),
              onPressed: () {
                if (this.widget._memo == null)
                  Navigator.pop(context, {
                    "name": _titleController.text,
                    "body": _bodyController.text,
                    "color": "#" +
                        widget._selectedColor.value
                            .toRadixString(16)
                            .substring(2),
                    "category": widget._selectedCategory,
                    "tags": widget._selectedTags,
                    "accounts": widget._sharers
                  });
                else
                  Navigator.pop(context, {
                    "id": this.widget._memo.id,
                    "name": _titleController.text,
                    "body": _bodyController.text,
                    "color": "#" +
                        widget._selectedColor.value
                            .toRadixString(16)
                            .substring(2),
                    "category": widget._selectedCategory,
                    "tags": widget._selectedTags,
                    "accounts": widget._sharers
                  });
              }),
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
              _unfocusTextFields();
              await _openColorsMenu();
              break;
            case 1:
              _unfocusTextFields();
              await _openCategoriesMenu();
              break;
            case 2:
              _unfocusTextFields();
              await _openTagsMenu();
              break;
            case 3:
              _unfocusTextFields();
              await _openShareMenu();
              break;
          }
        },
      ),
      body: GestureDetector(
        onTap: () {
          _unfocusTextFields();
        },
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TextField(
                controller: _titleController,
                focusNode: _focusNodeTitle,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    counterText: "",
                    labelText: "Title:",
                    labelStyle: TextStyle(color: Colors.grey, fontSize: 22)),
                maxLength: 35,
                style: TextStyle(color: Colors.black)),
            TextField(
              controller: _bodyController,
              focusNode: _focusNodeBoby,
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
      ),
    );
  }
}
