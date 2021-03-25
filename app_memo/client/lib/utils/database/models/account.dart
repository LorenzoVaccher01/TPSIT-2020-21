import 'package:floor/floor.dart';

@entity
class Account {
  @PrimaryKey(autoGenerate: true)
  int _id;
  String _name;
  String _surname;
  String _email;
  String _registrationDate;
  String _lastAccessDate;

  Account(this._id, this._name, this._surname, this._email, this._registrationDate, this._lastAccessDate);
}
