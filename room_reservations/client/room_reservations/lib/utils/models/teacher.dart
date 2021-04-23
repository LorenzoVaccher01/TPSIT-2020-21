
class Teacher {
  int _id;
  String _name;
  String _email;
  String _concourseClass;
  String _profileImage;

  Teacher(
      {int id,
      String name,
      String email,
      String concourseClass,
      String profileImage}) {
    this._id = id;
    this._name = name;
    this._email = email;
    this._concourseClass = concourseClass;
    this._profileImage = profileImage;
  }

  int get id => _id;
  set id(int id) => _id = id;
  String get name => _name;
  set name(String name) => _name = name;
  String get email => _email;
  set email(String email) => _email = email;
  String get concourseClass => _concourseClass;
  set concourseClass(String concourseClass) => _concourseClass = concourseClass;
  String get profileImage => _profileImage;
  set profileImage(String profileImage) => _profileImage = profileImage;

  Teacher.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _email = json['email'];
    _concourseClass = json['concourseClass'];
    _profileImage = json['profileImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['email'] = this._email;
    data['concourseClass'] = this._concourseClass;
    data['profileImage'] = this._profileImage;
    return data;
  }
}
