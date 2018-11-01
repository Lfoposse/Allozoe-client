import 'Restaurant.dart';
import 'StatusCommande.dart';

class Commande {

  int _id;
  String _reference;
  String _date;
  String _heure;
  double _prix;
  Restaurant _restaurant;
  StatusCommande _status;



  Commande.empty(){
    this._id = -1;
    this._reference = null;
    this._prix = null;
    this._restaurant = null;
    this._status = null;
    this._date = null;
    this._heure = null;
  }


  Commande(this._id, this._reference, this._date, this._heure, this._prix, this._restaurant,
      this._status);


  int get id => _id;

  set id(int value) {
    _id = value;
  }

  Commande.map(dynamic obj) {

    this._id = obj["id"];
    this._reference = obj["reference"];
    this._date = obj["date"];
    this._heure = obj["hour"];
    this._prix =  double.parse(obj["amount"].toString());
    this._restaurant = Restaurant.map(obj["restaurant"]);
    this._status = StatusCommande.map(obj["status"]);
  }


  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = _id;
    map["reference"] = _reference;
    map["date"] = _date;
    map["hour"] = _heure;
    map["amount"] = _prix;
    map["restaurant"] = _restaurant.toMap();
    map["status"] = _status.toMap();

    return map;
  }

  String get reference => _reference;

  set reference(String value) {
    _reference = value;
  }

  StatusCommande get status => _status;

  set status(StatusCommande value) {
    _status = value;
  }

  Restaurant get restaurant => _restaurant;

  set restaurant(Restaurant value) {
    _restaurant = value;
  }

  double get prix => _prix;

  set prix(double value) {
    _prix = value;
  }

  String get heure => _heure;

  set heure(String value) {
    _heure = value;
  }

  String get date => _date;

  set date(String value) {
    _date = value;
  }

}