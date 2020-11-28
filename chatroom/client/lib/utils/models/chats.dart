class Chat {
  int _id;
  bool _isGroup;
  String _groupName;
  String _groupDescription;
  Message _message;
  List<Users> _users;

  Chat(
      {int id,
      bool isGroup,
      String groupName,
      String groupDescription,
      Message message,
      List<Users> users}) {
    this._id = id;
    this._isGroup = isGroup;
    this._groupName = groupName;
    this._groupDescription = groupDescription;
    this._message = message;
    this._users = users;
  }

  int get id => _id;
  set id(int id) => _id = id;
  bool get isGroup => _isGroup;
  set isGroup(bool isGroup) => _isGroup = isGroup;
  String get groupName => _groupName;
  set groupName(String groupName) => _groupName = groupName;
  String get groupDescription => _groupDescription;
  set groupDescription(String groupDescription) =>
      _groupDescription = groupDescription;
  Message get message => _message;
  set message(Message message) => _message = message;
  List<Users> get users => _users;
  set users(List<Users> users) => _users = users;

  Chat.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _isGroup = json['isGroup'];
    _groupName = json['groupName'];
    _groupDescription = json['groupDescription'];
    _message =
        json['message'] != null ? new Message.fromJson(json['message']) : null;
    if (json['users'] != null) {
      _users = new List<Users>();
      json['users'].forEach((v) {
        _users.add(new Users.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['isGroup'] = this._isGroup;
    data['groupName'] = this._groupName;
    data['groupDescription'] = this._groupDescription;
    if (this._message != null) {
      data['message'] = this._message.toJson();
    }
    if (this._users != null) {
      data['users'] = this._users.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Message {
  int _id;
  String _date;
  String _text;
  int _userId;
  Sender _sender;

  Message({int id, String date, String text, int userId, Sender sender}) {
    this._id = id;
    this._date = date;
    this._text = text;
    this._userId = userId;
    this._sender = sender;
  }

  int get id => _id;
  set id(int id) => _id = id;
  String get date => _date;
  set date(String date) => _date = date;
  String get text => _text;
  set text(String text) => _text = text;
  int get userId => _userId;
  set userId(int userId) => _userId = userId;
  Sender get sender => _sender;
  set sender(Sender sender) => _sender = sender;

  Message.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _date = json['date'];
    _text = json['text'];
    _userId = json['userId'];
    _sender =
        json['sender'] != null ? new Sender.fromJson(json['sender']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['date'] = this._date;
    data['text'] = this._text;
    data['userId'] = this._userId;
    if (this._sender != null) {
      data['sender'] = this._sender.toJson();
    }
    return data;
  }
}

class Sender {
  String _name;
  String _surname;
  int _id;
  String _nickname;
  int _imageId;

  Sender({String name, String surname, int id, String nickname, int imageId}) {
    this._name = name;
    this._surname = surname;
    this._id = id;
    this._nickname = nickname;
    this._imageId = imageId;
  }

  String get name => _name;
  set name(String name) => _name = name;
  String get surname => _surname;
  set surname(String surname) => _surname = surname;
  int get id => _id;
  set id(int id) => _id = id;
  String get nickname => _nickname;
  set nickname(String nickname) => _nickname = nickname;
  int get imageId => _imageId;
  set imageId(int imageId) => _imageId = imageId;

  Sender.fromJson(Map<String, dynamic> json) {
    _name = (json['name']).toString().split(" ").map((str) => str.substring(0, 1).toUpperCase() + str.substring(1)).join(" ");
    _surname = (json['surname']).toString().split(" ").map((str) => str.substring(0, 1).toUpperCase() + str.substring(1)).join(" ");
    _id = json['id'];
    _nickname = json['nickname'];
    _imageId = json['imageId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this._name;
    data['surname'] = this._surname;
    data['id'] = this._id;
    data['nickname'] = this._nickname;
    data['imageId'] = this._imageId;
    return data;
  }
}

class Users {
  int _id;
  int _imageId;
  String _name;
  String _surname;

  Users({int id, int imageId, String name, String surname}) {
    this._id = id;
    this._imageId = imageId;
    this._name = name;
    this._surname = surname;
  }

  int get id => _id;
  set id(int id) => _id = id;
  int get imageId => _imageId;
  set imageId(int imageId) => _imageId = imageId;
  String get name => _name;
  set name(String name) => _name = name;
  String get surname => _surname;
  set surname(String surname) => _surname = surname;

  Users.fromJson(Map<String, dynamic> json) {
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