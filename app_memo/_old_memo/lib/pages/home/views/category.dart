import 'package:memo/widget/alert.dart';
import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  bool _newCategory;
  int _id;
  String _creationDate;
  String _description;
  String _lastModificationDate;
  String _name;

  TextEditingController _nameController;
  TextEditingController _descriptionController;

  CategoryPage(this._newCategory, this._id, this._name, this._description,
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
        title:
            Text(this._newCategory ? 'Add category' : 'Edit "${this._name}"'),
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
                  labelText: "Title:",
                  counterText: "",
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
