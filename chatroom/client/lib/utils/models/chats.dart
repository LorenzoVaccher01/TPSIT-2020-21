class Chat {
  int _id;
  Message _message;
  User _user;

  Chat({int id, Message message, User user}) {
    this._id = id;
    this._message = message;
    this._user = user;
  }

  int get id => _id;
  Message get message => _message;
  User get user => _user;

  Chat.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _message =
        json['message'] != null ? new Message.fromJson(json['message']) : null;
    _user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    if (this._message != null) {
      data['message'] = this._message.toJson();
    }
    if (this._user != null) {
      data['user'] = this._user.toJson();
    }
    return data;
  }
}

class Message {
  int _id;
  String _date;
  String _text;
  int _userId;

  Message({int id, String date, String text, int userId}) {
    this._id = id;
    this._date = date;
    this._text = text.substring(0, 1).toUpperCase() + text.substring(1);
    this._userId = userId;
  }

  int get id => _id;
  String get date => _date;
  String get text => _text;
  int get userId => _userId;

  Message.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _date = json['date'];
    _text = (json['text']).toString().substring(0, 1).toUpperCase() + (json['text']).toString().substring(1);
    _userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['date'] = this._date;
    data['text'] = this._text;
    data['userId'] = this._userId;
    return data;
  }
}

class User {
  int _id;
  int _imageId;
  String _name;
  String _surname;

  User({int id, int imageId, String name, String surname}) {
    this._id = id;
    this._imageId = imageId;
    this._name = name.split(" ").map((str) => str.substring(0, 1).toUpperCase() + str.substring(1)).join(" ");
    this._surname = surname.split(" ").map((str) => str.substring(0, 1).toUpperCase() + str.substring(1)).join(" ");
  }

  int get id => _id;
  int get imageId => _imageId;
  String get name => _name;
  String get surname => _surname;

  User.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _imageId = json['imageId'];
    _name = (json['name']).toString().split(" ").map((str) => str.substring(0, 1).toUpperCase() + str.substring(1)).join(" ");
    _surname = (json['surname']).toString().split(" ").map((str) => str.substring(0, 1).toUpperCase() + str.substring(1)).join(" ");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['imageId'] = this._imageId;
    data['name'] = this._name;
    data['surname'] = this._surname;
    return data;
  }
}
