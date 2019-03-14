import 'Complement.dart';

class Option {
  int _id;
  String _name;
  int _item_required;
  String _type;
  List<Complement> _complements;
  int posCurrentCpl;

  Option(this._id, this._name);

  Option.empty() {
    this._id = -1;
    this._name = null;
    this._item_required = -1;
    this._type = "NOT REQUIRED";
    this._complements = null;
  }

  Option.map(dynamic obj) {
    this._id = obj["id"];
    this._name = obj["name"];
    this._type = obj["type"];
    this._item_required = obj["item_required"];
    this._complements = (obj['products'] as List)
        .map((item) => new Complement.map(item))
        .toList();
  }

  Option copy() {
    Option option = new Option.empty();
    option.id = _id;
    option.name = _name;
    option._type = _type;
    option.item_required = _item_required;
    option.complements = _complements
        .asMap()
        .map((index, complement) => new MapEntry(index, complement.copy()))
        .values
        .toList();

    return option;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["opt_id"] = _id;
    map["name"] = _name;
    return map;
  }

  Map<String, dynamic> toMapRequest() {
    var map = new Map<String, dynamic>();
    map["option"] = _id;

    List<Map> complements = new List();
    for (Complement complement in _complements)
      complements.add(complement.toMapRequest());
    map["products"] = complements;
    return map;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get type => _type;

  set type(String value) {
    _type = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  int get item_required => _item_required;

  set item_required(int value) {
    _item_required = value;
  }

  List<Complement> get complements => _complements;

  set complements(List<Complement> value) {
    _complements = value;
  }
}
