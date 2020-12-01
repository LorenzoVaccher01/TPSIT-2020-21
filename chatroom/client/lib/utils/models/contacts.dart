class Contact {
  int _id;
  String _name;
  String _surname;
  String _nickname;
  int _imageId;
  int _chatId;

  Contact(
      {int id,
      String name,
      String surname,
      String nickname,
      int imageId,
      int chatId}) {
    this._id = id;
    this._name = name;
    this._surname = surname;
    this._nickname = nickname;
    this._imageId = imageId;
    this._chatId = chatId;
  }

  int get id => _id;
  set id(int id) => _id = id;
  String get name => _name;
  set name(String name) => _name = name;
  String get surname => _surname;
  set surname(String surname) => _surname = surname;
  String get nickname => _nickname;
  set nickname(String nickname) => _nickname = nickname;
  int get imageId => _imageId;
  set imageId(int imageId) => _imageId = imageId;
  int get chatId => _chatId;
  set chatId(int chatId) => _chatId = chatId;

  Contact.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _surname = json['surname'];
    _nickname = json['nickname'];
    _imageId = json['imageId'];
    _chatId = json['chatId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['surname'] = this._surname;
    data['nickname'] = this._nickname;
    data['imageId'] = this._imageId;
    data['chatId'] = this._chatId;
    return data;
  }
}