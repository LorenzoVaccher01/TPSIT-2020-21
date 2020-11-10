class Client {
  int _id;
  String _name;
  String _surname;

  Client(this._id, this._name, this._surname);

  String getName() {
    return _name + ' ' + _surname;
  }
}