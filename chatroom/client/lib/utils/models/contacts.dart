class Contact {
  int _id;
  String _name;
  String _surname;
  String _nickname;
  int _imageId;

  Contact({int id, String name, String surname, String nickname, int imageId}) {
    this._id = id;
    this._name = name;
    this._surname = surname;
    this._nickname = nickname;
    this._imageId = imageId;
  }

  int get id => _id;
  String get name => _name;
  String get surname => _surname;
  String get nickname => _nickname;
  int get imageId => _imageId;

  Contact.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = (json['name']).toString().split(" ").map((str) => str.substring(0, 1).toUpperCase() + str.substring(1)).join(" ");
    _surname = (json['surname']).toString().split(" ").map((str) => str.substring(0, 1).toUpperCase() + str.substring(1)).join(" ");
    _nickname = json['nickname'];
    _imageId = json['imageId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['surname'] = this._surname;
    data['nickname'] = this._nickname;
    data['imageId'] = this._imageId;
    return data;
  }
}