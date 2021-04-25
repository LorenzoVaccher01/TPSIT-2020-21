import 'package:flutter/material.dart';

class Alert {
  BuildContext _context;
  String _title;
  Widget _body;
  Function _onClick;
  bool _closeButton;
  String _textConfirmButton;
  String _textCanelButton;

  Alert(
      {String title,
      Widget body,
      Function onClick,
      bool closeButton,
      String textConfirmButton,
      String textCanelButton,
      BuildContext context}) {
    this._title = title;
    this._body = body;
    this._onClick = onClick;
    this._closeButton = closeButton;
    this._textConfirmButton = textConfirmButton;
    this._textCanelButton = textCanelButton;
    this._context = context;

    _build(_context);
  }

  Future<void> _build(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(_title),
            content: _body,
            actions: [
              Visibility(
                visible: _closeButton,
                child: TextButton(
                  child: Text(_textCanelButton, style: TextStyle(color: Colors.red)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              TextButton(
                child: Text(_textConfirmButton),
                onPressed: () {
                  Navigator.of(context).pop();
                  _onClick.call();
                },
              )
            ],
          );
        });
  }
}
