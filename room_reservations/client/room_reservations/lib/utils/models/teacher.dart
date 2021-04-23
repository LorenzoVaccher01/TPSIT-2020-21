
class Teacher {
  String _name;
  String _surname;
  String _email;
  String _concourseClass;

  Teacher({String name, String surname, String email, String concourseClass}) {
    this._name = name;
    this._surname = surname;
    this._email = email;
    this._concourseClass = concourseClass;
  }

  String get name => _name;
  set name(String name) => _name = name;
  String get surname => _surname;
  set surname(String surname) => _surname = surname;
  String get email => _email;
  set email(String email) => _email = email;
  String get concourseClass => _concourseClass;
  set concourseClass(String concourseClass) => _concourseClass = concourseClass;

  Teacher.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _surname = json['surname'];
    _email = json['email'];
    _concourseClass = json['concourseClass'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this._name;
    data['surname'] = this._surname;
    data['email'] = this._email;
    data['concourseClass'] = this._concourseClass;
    return data;
  }
}
