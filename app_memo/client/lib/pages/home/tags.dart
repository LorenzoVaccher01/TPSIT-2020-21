import 'package:app_memo/pages/home/views/tag.dart';
import 'package:app_memo/pages/home/widget/actionButton.dart';
import 'package:app_memo/pages/home/widget/menu.dart';
import 'package:app_memo/utils/models/tag.dart';
import 'package:app_memo/widget/alert.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../main.dart' as App;

class TagsPage extends StatefulWidget {
  @override
  _TagsPageState createState() => _TagsPageState();
}

class _TagsPageState extends State<TagsPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Tag> _tags = [];

  @override
  void initState() {
    _getTags();
    super.initState();
  }

  _getTags() async {
    _tags = await (new Tag()).getTags(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Future<Null> _refreshTags() async {
      print('Refreshing tags...');
      _getTags();
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
                      text: 'Tags',
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
            actions: [],
          ),
          body: Container(
            alignment: Alignment.center,
            child: _tags.length == 0
                ? Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset("assets/img/sad.png",
                            height: 90, width: 90),
                        Padding(padding: EdgeInsets.only(top: 30)),
                        Text('No tags were found!',
                            style: TextStyle(
                                fontSize: 27,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                        Padding(padding: EdgeInsets.only(top: 30)),
                        ElevatedButton.icon(
                            onPressed: () => _refreshTags(),
                            label: Text("Refresh"),
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).accentColor,
                            ),
                            icon: Icon(Icons.refresh))
                      ],
                    ),
                  )
                : RefreshIndicator(
                  onRefresh: _refreshTags,
                  child: ListView.separated(
                    physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                      itemCount: _tags.length,
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(),
                      itemBuilder: (context, index) {
                        return InkWell(
                            child: Container(
                                padding: EdgeInsets.only(
                                    top: 8, left: 15, bottom: 8, right: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        '#' + _tags[index]
                                                .name
                                                .substring(0, 1)
                                                .toUpperCase() +
                                            _tags[index].name.substring(1),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
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
                                              SharedPreferences _prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              final response = await http.delete(
                                                App.SERVER_WEB +
                                                    '/api/deleteTag?id=' +
                                                    _tags[index]
                                                        .id
                                                        .toString(),
                                                headers: <String, String>{
                                                  'Content-Type':
                                                      'application/json; charset=UTF-8',
                                                  'Cookie': _prefs.getString(
                                                      'user.sessionCookie')
                                                },
                                              );

                                              if (response.statusCode == 200) {
                                                final bodyResponse =
                                                    json.decode(response.body);
                                                if (bodyResponse['error'] ==
                                                    200) {
                                                  _tags.removeWhere(
                                                      (tag) =>
                                                          tag.id ==
                                                          _tags[index].id);
                                                  setState(() {});
                                                } else {
                                                  Alert(
                                                    context: context,
                                                    closeButton: false,
                                                    textConfirmButton: 'Ok',
                                                    textCanelButton: "",
                                                    onClick: () {},
                                                    title: 'Error',
                                                    body: Text(
                                                        bodyResponse['message']),
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
                                                  body: Text(
                                                      "General internal error"),
                                                );
                                              }
                                            },
                                            title: 'Alert',
                                            body: Text(
                                                "Do you really want to delete this tag?"),
                                          );
                                        })
                                  ],
                                )),
                            onTap: () async {
                              final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TagPage(
                                          false,
                                          _tags[index].id,
                                          _tags[index].name,
                                          _tags[index].description,
                                          _tags[index].creationDate,
                                          _tags[index].lastModifiedDate)));
                              print(result);
                              if (result != null) {
                                SharedPreferences _prefs =
                                    await SharedPreferences.getInstance();
                                final response = await http.put(
                                  App.SERVER_WEB +
                                      '/api/tag?id=' +
                                      _tags[index].id.toString() +
                                      '&name=' +
                                      result['name'] +
                                      '&description=' +
                                      result['description'],
                                  headers: <String, String>{
                                    'Content-Type':
                                        'application/json; charset=UTF-8',
                                    'Cookie':
                                        _prefs.getString('user.sessionCookie')
                                  },
                                );

                                if (response.statusCode == 200) {
                                  final bodyResponse = json.decode(response.body);
                                  if (bodyResponse['error'] == 200) {
                                    _tags[index].name = result['name'];
                                    _tags[index].description =
                                        result['description'];
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
                            });
                      }),
                ),
          ),
          floatingActionButton: _tags.length != 0 ? HomeActionButton() : null,
        ));
  }
}
