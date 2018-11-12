
class Complement{

  int _id;
  String _name;
  double _price;
  String _image;
  bool _selected;


  Complement(this._id, this._name, this._price, this._image, this._selected);

  Complement.empty(){
    this._id = -1;
    this._name = null;
    this._image = null;
    this._price = 0.0;
    this._selected = false;
  }

  Complement.map(dynamic obj) {

    this._selected = false;
    this._id = obj["id"];
    this._name = obj["name"];
    this._image = obj["image"];
    this._price =  double.parse(obj["price"].toString());
  }


  Complement copy(){

    Complement complement = new Complement.empty();
    complement.id = _id;
    complement.name = _name;
    complement.price = _price;
    complement.image = _image;
    complement.selected = _selected;

    return complement;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["cp_id"] = _id;
    map["name"] = _name;
    map["image"] = _image;
    map["price"] = _price;
    return map;
  }


  Map<String, dynamic> toMapRequest() {
    var map = new Map<String, dynamic>();
    map["id"] = _id;
    return map;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get name => _name;

  String get image => _image;

  set image(String value) {
    _image = value;
  }

  double get price => _price;

  set price(double value) {
    _price = value;
  }

  set name(String value) {
    _name = value;
  }

  bool get selected => _selected;

  set selected(bool value) {
    _selected = value;
  }


}