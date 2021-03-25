class Client {
  int _id;
  String _name;
  String _surname;
  String _email;
  String _sessionCookie;

  Client(
      {int id,
      String name,
      String surname,
      String email,
      String sessionCookie}) {
    this._id = id;
    this._name = name;
    this._surname = surname;
    this._email = email;
    this._sessionCookie = sessionCookie;
  }

  int get id => _id;
  String get name => _name;
  String get surname => _surname;
  String get email => _email;
  String get sessionCookie => _sessionCookie;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['surname'] = this._surname;
    data['email'] = this._email;
    data['sessionCookie'] = this._sessionCookie;
    return data;
  }
}
