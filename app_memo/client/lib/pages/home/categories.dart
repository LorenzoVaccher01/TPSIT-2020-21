import 'package:app_memo/pages/home/views/category.dart';
import 'package:app_memo/pages/home/widget/actionButton.dart';
import 'package:app_memo/pages/home/widget/menu.dart';
import 'package:app_memo/utils/models/category.dart';
import 'package:app_memo/widget/alert.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../main.dart' as App;
import './views/category.dart';

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Category> _categories = [];

  @override
  void initState() {
    _getCategories();
    super.initState();
  }

  _getCategories() async {
    _categories = await (new Category()).getCategories(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Future<Null> _refreshCategories() async {
      print('Refreshing categories...');
      _getCategories();
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
                      text: 'Categories',
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
            child: _categories.length == 0
                ? Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset("assets/img/sad.png",
                            height: 90, width: 90),
                        Padding(padding: EdgeInsets.only(top: 30)),
                        Text('No categories were found!',
                            style: TextStyle(
                                fontSize: 27,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                        Padding(padding: EdgeInsets.only(top: 30)),
                        ElevatedButton.icon(
                            onPressed: () => _refreshCategories(),
                            label: Text("Refresh"),
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).accentColor,
                            ),
                            icon: Icon(Icons.refresh))
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _refreshCategories,
                    child: ListView.separated(
                        physics: BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        itemCount: _categories.length,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          _categories[index]
                                                  .name
                                                  .substring(0, 1)
                                                  .toUpperCase() +
                                              _categories[index]
                                                  .name
                                                  .substring(1),
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
                                                final response =
                                                    await http.delete(
                                                  App.SERVER_WEB +
                                                      '/api/deleteCategory?id=' +
                                                      _categories[index]
                                                          .id
                                                          .toString(),
                                                  headers: <String, String>{
                                                    'Content-Type':
                                                        'application/json; charset=UTF-8',
                                                    'Cookie': _prefs.getString(
                                                        'user.sessionCookie')
                                                  },
                                                );

                                                if (response.statusCode ==
                                                    200) {
                                                  final bodyResponse = json
                                                      .decode(response.body);
                                                  if (bodyResponse['error'] ==
                                                      200) {
                                                    _categories.removeWhere(
                                                        (category) =>
                                                            category.id ==
                                                            _categories[index]
                                                                .id);
                                                    setState(() {});
                                                  } else {
                                                    Alert(
                                                      context: context,
                                                      closeButton: false,
                                                      textConfirmButton: 'Ok',
                                                      textCanelButton: "",
                                                      onClick: () {},
                                                      title: 'Error',
                                                      body: Text(bodyResponse[
                                                          'message']),
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
                                                  "Do you really want to delete this category?"),
                                            );
                                          })
                                    ],
                                  )),
                              onTap: () async {
                                final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CategoryPage(
                                            false,
                                            _categories[index].id,
                                            _categories[index].name,
                                            _categories[index].description,
                                            _categories[index].creationDate,
                                            _categories[index]
                                                .lastModifiedDate)));

                                if (result != null) {
                                  SharedPreferences _prefs =
                                      await SharedPreferences.getInstance();
                                  final response = await http.put(
                                    App.SERVER_WEB +
                                        '/api/category?id=' +
                                        _categories[index].id.toString() +
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
                                    final bodyResponse =
                                        json.decode(response.body);
                                    if (bodyResponse['error'] == 200) {
                                      _categories[index].name = result['name'];
                                      _categories[index].description =
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
          floatingActionButton: _categories.length != 0 ? HomeActionButton() : null,
        ));
  }
}
