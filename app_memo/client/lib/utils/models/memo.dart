import 'package:app_memo/utils/models/tag.dart';
import 'package:app_memo/utils/models/category.dart';
import 'package:app_memo/widget/alert.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../main.dart' as App;
/*

*/

class Memo {
  int _id;
  bool _isOwner;
  int _permission;
  String _title;
  Color _color;
  String _body;
  String _creationDate;
  String _lastModifiedDate;
  Category _category;
  List<Tag> _tags;

  Memo(
      {int id,
      bool isOwner,
      int permission,
      String title,
      Color color,
      String body,
      String creationDate,
      String lastModifiedDate,
      Category category,
      List<Tag> tags}) {
    this._id = id;
    this._isOwner = isOwner;
    this._permission = permission;
    this._title = title;
    this._color = color;
    this._body = body;
    this._creationDate = creationDate;
    this._lastModifiedDate = lastModifiedDate;
    this._category = category;
    this._tags = tags;
  }

  int get id => _id;
  set id(int id) => _id = id;
  bool get isOwner => _isOwner;
  set isOwner(bool isOwner) => _isOwner = isOwner;
  int get permission => _permission;
  set permission(int permission) => _permission = permission;
  String get title => _title;
  set title(String title) => _title = title;
  Color get color => _color;
  set color(Color color) => _color = color;
  String get body => _body;
  set body(String body) => _body = body;
  String get creationDate => _creationDate;
  set creationDate(String creationDate) => _creationDate = creationDate;
  String get lastModifiedDate => _lastModifiedDate;
  set lastModifiedDate(String lastModifiedDate) =>
      _lastModifiedDate = lastModifiedDate;
  Category get category => _category;
  set category(Category category) => _category = category;
  List<Tag> get tags => _tags;
  set tags(List<Tag> tags) => _tags = tags;

  static Future<void> add(
      BuildContext context,
      String name,
      String body,
      Category category,
      String color,
      List<Tag> tags,
      List<String> accounts) async {
    List<String> _tags = [];
    List<String> _accounts = [];

    tags.forEach((tag) {
      _tags.add(tag.id.toString());
    });

    //TODO: creare stesso meccanismo anche per gli utenti come per i tags

    String attr = "color=" +
        color.toString().replaceAll('#', '') +
        "&title=" +
        name +
        "&body=" +
        body +
        "&tags=${_tags.join(',')}" /*+ _tags*/ +
        "&category=" +
        (category != null ? category.id.toString() : "1") +
        "&accounts=${_accounts.join(',')}" /*+ _accounts*/;

    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final response = await http
        .post(App.SERVER_WEB + '/api/memo?' + attr, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Cookie': _prefs.getString('user.sessionCookie')
    });
    if (response.statusCode == 200) {
      final bodyResponse = json.decode(response.body);
      if (bodyResponse['error'] == 200) {
        if (ModalRoute.of(context).settings.name == '/home')
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

  static Future<List<Memo>> get(BuildContext context, String attributes) async {
    List<Memo> _memos = [];
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      App.SERVER_WEB + '/api/memo?' + attributes,
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
          _memos.add(new Memo.fromJson(bodyResponse['data'][i]));
        return _memos;
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

  static Future<int> put(
      BuildContext context,
      int id,
      String title,
      String body,
      Category category,
      String color,
      List<Tag> tags,
      List<String> accounts) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    List<String> _tags = [];
    List<String> _accounts = [];

    print(tags);

    tags.forEach((tag) {
      _tags.add(tag.id.toString());
    });

    print(tags);

    final response = await http.put(
        App.SERVER_WEB + '/api/memo?id=${id.toString()}&title=${title}&body=${body}&color=${color.replaceAll(RegExp('#'), '')}&categoryId=${category.id}&tags=${_tags}&accounts=${accounts}',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Cookie': _prefs.getString('user.sessionCookie')
        });
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

  static Future<void> delete(BuildContext context, Memo memo) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final response = await http.delete(
        App.SERVER_WEB + '/api/deleteMemo?id=' + memo.id.toString(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Cookie': _prefs.getString('user.sessionCookie')
        });
    if (response.statusCode == 200) {
      final bodyResponse = json.decode(response.body);
      if (bodyResponse['error'] == 200) {
        Navigator.pushNamed(context, '/home');
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

  Memo.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _isOwner = json['isOwner'];
    _permission = json['permission'];
    _title = json['title'];
    _color = _hexToColor(json['color']);
    _body = json['body'];
    _creationDate = json['creationDate'];
    _lastModifiedDate = json['lastModifiedDate'];
    _category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    if (json['tags'] != null) {
      _tags = new List<Tag>();
      json['tags'].forEach((v) {
        _tags.add(new Tag.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['isOwner'] = this._isOwner;
    data['permission'] = this._permission;
    data['title'] = this._title;
    data['color'] = this._color;
    data['body'] = this._body;
    data['creationDate'] = this._creationDate;
    data['lastModifiedDate'] = this._lastModifiedDate;
    if (this._category != null) {
      data['category'] = this._category.toJson();
    }
    if (this._tags != null) {
      data['tags'] = this._tags.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Color _hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
}
