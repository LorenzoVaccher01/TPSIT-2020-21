import 'package:app_memo/pages/home/widget/actionButton.dart';
import 'package:app_memo/pages/home/widget/menu.dart';
import 'package:app_memo/utils/models/category.dart';
import 'package:app_memo/utils/models/memo.dart';
import 'package:app_memo/widget/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../main.dart' as App;

class TagPage extends StatelessWidget {
  bool _newTag;
  int _id;
  String _creationDate;
  String _description;
  String _lastModificationDate;
  String _name;

  TextEditingController _nameController;
  TextEditingController _descriptionController;

  TagPage(this._newTag, this._id, this._name, this._description,
      this._creationDate, this._lastModificationDate);

  @override
  Widget build(BuildContext context) {
    _nameController = TextEditingController(text: this._name);
    _descriptionController = TextEditingController(text: this._description);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 8.0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(this._newTag ? 'Add tag' : 'Edit "#${this._name}"'),
        leading: IconButton(
          iconSize: 25,
          icon: Icon(Icons.arrow_back_outlined),
          onPressed: () {
            if (_nameController.text != this._name ||
                _descriptionController.text != this._description) {
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
              "description": _descriptionController.text
            }),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          TextField(
              controller: _nameController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  counterText: "",
                  labelText: "Title:",
                  labelStyle: TextStyle(color: Colors.grey, fontSize: 22)),
              maxLength: 35,
              style: TextStyle(color: Colors.black)),
          TextField(
            controller: _descriptionController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
                border: InputBorder.none,
                labelText: "Description:",
                labelStyle: TextStyle(color: Colors.grey, fontSize: 22)),
            maxLength: 350,
            style: TextStyle(color: Colors.black),
          )
        ],
      ),
    );
  }
}
