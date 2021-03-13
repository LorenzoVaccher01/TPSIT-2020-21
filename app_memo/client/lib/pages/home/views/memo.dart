import 'package:app_memo/pages/home/widget/actionButton.dart';
import 'package:app_memo/utils/models/tag.dart';
import 'package:app_memo/widget/alert.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../main.dart' as App;

class MemoPage extends StatelessWidget {
  bool _newMemo;
  int _id;
  String _title;
  String _body;
  String _categoryId;
  Color _color;
  List<Tag> _tags;
  String _creationDate;
  String _lastModificationDate;

  TextEditingController _nameController;
  TextEditingController _bodyController;

  MemoPage(this._newMemo, this._id, this._title, this._body, this._categoryId, this._color, this._tags, this._creationDate, this._lastModificationDate);

  @override
  Widget build(BuildContext context) {
    _nameController = TextEditingController(text: this._title);
    _bodyController = TextEditingController(text: this._body);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 8.0,
        backgroundColor: Theme.of(context).primaryColor,
        title:
            Text(this._newMemo ? 'Add memo' : 'Edit "${this._title}"'),
        leading: IconButton(
          iconSize: 25,
          icon: Icon(Icons.arrow_back_outlined),
          onPressed: () {
            if (_nameController.text != this._title ||
                _bodyController.text != this._body) {
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
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        actions: [
          IconButton(
            iconSize: 25,
            icon: Icon(Icons.save),
            onPressed: () => Navigator.pop(context, {
              "name": _nameController.text,
              "body": _bodyController.text
            }),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          //TODO: creare pagina per memo
        ],
      ),
    );
  }
}