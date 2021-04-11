import 'package:flutter/material.dart';

class EntryField extends StatelessWidget {
  String _title;
  Icon _icon;
  bool _isPassword;
  TextEditingController _textEditingController;
  String _hintText;

  EntryField({@required String title, Icon icon, bool isPassword = false, @required TextEditingController controller, String hintText}) {
    this._title = title;
    this._icon = icon;
    this._isPassword = isPassword;
    this._textEditingController = controller;
    this._hintText = hintText;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            this._title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              controller: this._textEditingController,
              autocorrect: false,
              obscureText: this._isPassword,
              decoration: InputDecoration(
                prefixStyle: TextStyle(color: Theme.of(context).primaryColor),
                hintText: this._hintText,
                  prefixIcon: this._icon,
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }
}
