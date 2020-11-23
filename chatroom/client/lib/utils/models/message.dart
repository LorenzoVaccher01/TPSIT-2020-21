class Message {
  int _id;
  String _text;
  String _date;
  int _userId;

  Message({int id, String text, String date, int userId}) {
    this._id = id;
    this._text = text;
    this._date = date;
    this._userId = userId;
  }

  int get id => _id;
  String get text => _text;
  String get date => _date;
  int get userId => _userId;

  Message.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _text = json['text'];
    _date = json['date'];
    _userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['text'] = this._text;
    data['date'] = this._date;
    data['userId'] = this._userId;
    return data;
  }
}