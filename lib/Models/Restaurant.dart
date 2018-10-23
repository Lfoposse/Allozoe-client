
class Restaurant {

  int _id;
  String _name;
  String _photo;

  Restaurant.empty(){
    this._id = -1;
    this._name = null;
    this._photo = null;
  }

  Restaurant(this._id, this._name, this._photo);

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get photo => _photo;

  set photo(String value) {
    _photo = value;
  }

  Restaurant.map(dynamic obj) {

    this._id = obj["id"];
    this._name = obj["name"];
    this._photo = obj["image"];
  }


  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = _id;
    map["name"] = _name;
    map["photo"] = _photo;
    return map;
  }

}