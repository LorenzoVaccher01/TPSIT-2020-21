class Chat {
  int _id;
  int _imageId;
  String _name;
  String _surname;
  Message _message;

  Chat({int id, int imageId, String name, String surname, Message message}) {
    this._id = id;
    this._imageId = imageId;
    this._name = name;
    this._surname = surname;
    this._message = message;
  }

  int get id => _id;
  set id(int id) => _id = id;
  int get imageId => _imageId;
  set imageId(int imageId) => _imageId = imageId;
  String get name => _name;
  set name(String name) => _name = name;
  String get surname => _surname;
  set surname(String surname) => _surname = surname;
  Message get message => _message;
  set message(Message message) => _message = message;

  Chat.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _imageId = json['imageId'];
    _name = json['name'];
    _surname = json['surname'];
    _message =
        json['message'] != null ? new Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['imageId'] = this._imageId;
    data['name'] = this._name;
    data['surname'] = this._surname;
    if (this._message != null) {
      data['message'] = this._message.toJson();
    }
    return data;
  }
}

class Message {
  String _text;
  String _date;

  Message({String text, String date}) {
    this._text = text;
    this._date = date;
  }

  String get text => _text;
  set text(String text) => _text = text;
  String get date => _date;
  set date(String date) => _date = date;

  Message.fromJson(Map<String, dynamic> json) {
    _text = json['text'];
    _date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this._text;
    data['date'] = this._date;
    return data;
  }
}