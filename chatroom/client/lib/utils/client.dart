class Client {
  int _id;
  String _name;
  String _surname;
  String _nickname;

  Client(this._id, this._name, this._surname, this._nickname);

  String getFullName() {
    return _name + ' ' + _surname;
  }

  int get id => this._id;
  String get name => this._name;
  String get surname => this._surname;
  String get nickname => this._nickname;
}