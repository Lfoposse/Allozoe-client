import 'Complement.dart';
import 'Option.dart';
import 'Restaurant.dart';

class Produit {
  int _qteCmder;
  bool _favoris;
  bool inCard = false;
  int _id;
  String _name;
  String _description;
  String _photo;
  double _prix;
  Restaurant _restaurant;
  List<Option> _options;

  Produit.empty() {
    this._id = -1;
    this._qteCmder = 1;
    this._name = null;
    this._description = null;
    this._photo = null;
    this._prix = null;
    this._favoris = false;
    this._restaurant = null;
    this._options = null;
  }

  Produit copy() {
    Produit produit = new Produit.empty();
    produit.id = _id;
    produit._name = _name;
    produit._description = _description;
    produit.photo = _photo;
    produit.prix = _prix;
    produit.qteCmder = nbCmds;
    produit.favoris = _favoris;
    produit.restaurant = _restaurant.copy();
    produit.options = _options
        .asMap()
        .map((index, option) => new MapEntry(index, option.copy()))
        .values
        .toList();

    return produit;
  }

  Produit(
    this._qteCmder,
    this._favoris,
    this._id,
    this._name,
    this._description,
    this._photo,
    this._prix,
    this._restaurant,
    this._options,
  );

  Produit.map(dynamic obj) {
    this._qteCmder = obj["quantity"] != null ? obj["quantity"] : 1;
    this._favoris = false;
    this._id = obj["id"];
    this._name = obj["name"];
    this._description = obj["description"];
    this._photo = obj["image"];
    this._prix = double.parse(obj["price"].toString());
    this._restaurant =
        obj["restaurant"] != null ? Restaurant.map(obj["restaurant"]) : null;
    this._options = obj["options"] != null
        ? (obj['options'] as List).map((item) => new Option.map(item)).toList()
        : null;

    if (_options == null && obj["products"] != null) {
      Option option = Option.empty();
      option.complements = (obj['products'] as List)
          .map((item) => new Complement.map(item))
          .toList();

      this._options = new List();
      this._options.add(option);
    }
  }

  int get id => _id;
  int get nbCmds => _qteCmder;
  String get name => _name;
  String get description => _description;
  double get prix => _prix;
  String get photo => _photo;
  bool get isFavoris => _favoris;

  set id(int value) {
    _id = value;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["prod_id"] = _id;
    map["name"] = _name;
    map["description"] = _description;
    map["prix"] = _prix;
    map["photo"] = _photo;
    map["favoris"] = _favoris;
    map["nbCmds"] = _qteCmder;
    return map;
  }

  Map<String, dynamic> toMapRequest() {
    var map = new Map<String, dynamic>();
    map["id"] = _id;
    map["quantity"] = _qteCmder;

    List<Map> options = new List();
    if (_options != null)
      for (Option option in _options) options.add(option.toMapRequest());

    map["options"] = options;
    return map;
  }

  set qteCmder(int value) {
    _qteCmder = value;
  }

  set name(String value) {
    _name = value;
  }

  set description(String value) {
    _description = value;
  }

  set photo(String value) {
    _photo = value;
  }

  set prix(double value) {
    _prix = value;
  }

  set favoris(bool value) {
    _favoris = value;
  }

  List<Option> get options => _options;

  set options(List<Option> value) {
    _options = value;
  }

  Restaurant get restaurant => _restaurant;

  set restaurant(Restaurant value) {
    _restaurant = value;
  }
}
