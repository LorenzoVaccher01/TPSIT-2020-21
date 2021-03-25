import 'package:memo/widget/alert.dart';
import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../main.dart' as App;
import 'package:floor/floor.dart';

class Category {
  int _id;
  String _name;
  String _description;
  String _creationDate;
  String _lastModifiedDate;

  Category(
      {int id,
      String name,
      String description,
      String creationDate,
      String lastModifiedDate}) {
    this._id = id;
    this._name = name;
    this._description = description;
    this._creationDate = creationDate;
    this._lastModifiedDate = lastModifiedDate;
  }

  int get id => _id;
  set id(int id) => _id = id;
  String get name => _name;
  set name(String name) => _name = name;
  String get description => _description;
  set description(String description) => _description = description;
  String get creationDate => _creationDate;
  set creationDate(String creationDate) => _creationDate = creationDate;
  String get lastModifiedDate => _lastModifiedDate;
  set lastModifiedDate(String lastModifiedDate) =>
      _lastModifiedDate = lastModifiedDate;

  static Future<List<Category>> get(BuildContext context) async {
    List<Category> _categories = [];
    //TODO: commento shared_pref
    //SharedPreferences _prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      App.SERVER_WEB + '/api/category',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Cookie': /*_prefs.getString('user.sessionCookie')*/ App.client.sessionCookie
      },
    );

    if (response.statusCode == 200) {
      final bodyResponse = json.decode(response.body);
      if (bodyResponse['error'] == 200) {
        _categories.clear();
        for (var i = 0; i < bodyResponse['data'].length; i++)
          _categories.add(new Category.fromJson(bodyResponse['data'][i]));
        return _categories;
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
    return [];
  }

  static Future<void> add(
      BuildContext context, String name, String description) async {
    //SharedPreferences _prefs = await SharedPreferences.getInstance();
    final response = await http.post(
      App.SERVER_WEB +
          '/api/category?name=' +
          name +
          '&description=' +
          description,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Cookie': /*_prefs.getString('user.sessionCookie')*/ App.client.sessionCookie
      },
    );
    if (response.statusCode == 200) {
      final bodyResponse = json.decode(response.body);
      if (bodyResponse['error'] == 200) {
        if (ModalRoute.of(context).settings.name == '/categories')
          Navigator.pushNamed(context, ModalRoute.of(context).settings.name);
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

  static Future<int> delete(BuildContext context, Category category) async {
    //SharedPreferences _prefs = await SharedPreferences.getInstance();
    final response = await http.delete(
      App.SERVER_WEB +
          '/api/deleteCategory?id=' +
          category.id.toString(),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Cookie': /*_prefs.getString('user.sessionCookie')*/ App.client.sessionCookie
      },
    );

    if (response.statusCode == 200) {
      final bodyResponse = json.decode(response.body);
      if (bodyResponse['error'] == 200) {
        return 1;
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

    return -1;
  }

  static Future<int> put(BuildContext context, int id, String name, String description) async {
    //SharedPreferences _prefs = await SharedPreferences.getInstance();
    final response = await http.put(
      App.SERVER_WEB +
          '/api/category?id=' +
          id.toString() +
          '&name=' +
          name +
          '&description=' +
          description,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Cookie': /*_prefs.getString('user.sessionCookie')*/ App.client.sessionCookie
      },
    );

    if (response.statusCode == 200) {
      final bodyResponse = json.decode(response.body);
      print(bodyResponse);
      if (bodyResponse['error'] == 200) {
        return 1;
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
    return -1;
  }

  Category.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _description = json['description'];
    _creationDate = json['creationDate'];
    _lastModifiedDate = json['lastModifiedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['description'] = this._description;
    data['creationDate'] = this._creationDate;
    data['lastModifiedDate'] = this._lastModifiedDate;
    return data;
  }
}
