import 'package:app_memo/widget/alert.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../main.dart' as App;

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

  Future<List<Category>> getCategories(BuildContext context) async {
    List<Category> _categories = [];

    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      App.SERVER_WEB + '/api/category',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Cookie': _prefs.getString('user.sessionCookie')
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
