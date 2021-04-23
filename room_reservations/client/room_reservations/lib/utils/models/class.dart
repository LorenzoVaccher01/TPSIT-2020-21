
class SchoolClass {
  int _id;
  String _section;
  int _year;

  SchoolClass({int id, String section, int year}) {
    this._id = id;
    this._section = section;
    this._year = year;
  }

  int get id => _id;
  set id(int id) => _id = id;
  String get section => _section;
  set section(String section) => _section = section;
  int get year => _year;
  set year(int year) => _year = year;

  SchoolClass.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _section = json['section'];
    _year = json['year'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['section'] = this._section;
    data['year'] = this._year;
    return data;
  }
}
