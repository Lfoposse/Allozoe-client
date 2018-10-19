import 'Produit.dart';
class Categorie {

  int _id;
  String _name;
  List<Produit> _produits;

  Categorie.empty(){
    this._id = -1;
    this._name = null;
    this._produits = null;
  }

  Categorie(this._id, this._name, this._produits);

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }


  List<Produit> get produits => _produits;

  set produits(List<Produit> value) {
    _produits = value;
  }

  Categorie.map(dynamic obj) {
    this._id = obj["id"];
    this._name = obj["name"];
  }


  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = _id;
    map["name"] = _name;
    map["produits"] = _produits;
    return map;
  }
}