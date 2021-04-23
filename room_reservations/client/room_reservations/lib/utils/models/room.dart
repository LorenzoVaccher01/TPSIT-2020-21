
class Room {
  int _id;
  String _identificator;

  Room({int id, String identificator}) {
    this._id = id;
    this._identificator = identificator;
  }

  int get id => _id;
  set id(int id) => _id = id;
  String get identificator => _identificator;
  set identificator(String identificator) => _identificator = identificator;

  Room.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _identificator = json['identificator'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['identificator'] = this._identificator;
    return data;
  }
}
