class Client {
  int _id;
  String _name;
  String _surname;
  String _nickname;
  String _token;

  Client({int id, String name, String surname, String nickname, String token}) {
    this._id = id;
    this._name = name;
    this._surname = surname;
    this._nickname = nickname;
    this._token = token;
  }

  int get id => _id;
  String get name => _name;
  String get surname => _surname;
  String get nickname => _nickname;
  String get token => _token;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['surname'] = this._surname;
    data['nickname'] = this._nickname;
    data['token'] = this._token;
    return data;
  }
}