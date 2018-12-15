import 'Restaurant.dart';
import 'StatusCommande.dart';
import 'Deliver.dart';

class Commande {

  int _id;
  String _reference;
  String _date;
  String _heure;
  String _deliveryAddress;
  double _prix;
  bool _dejaNoter;
  Restaurant _restaurant;
  StatusCommande _status;
  Deliver _deliver;




  Commande.empty(){
    this._id = -1;
    this._dejaNoter = false;
    this._reference = null;
    this._prix = null;
    this._restaurant = null;
    this._status = null;
    this._date = null;
    this._heure = null;
    this._deliver = null;
    this._deliveryAddress = null;
  }

  Commande.map(dynamic obj) {

    this._id = obj["id"];
    this._dejaNoter = obj["noted"] == 1;
    this._reference = obj["reference"];
    this._deliveryAddress = obj["delivery_address"];
    this._date = obj["date"];
    this._heure = obj["hour"];
    this._prix =  double.parse(obj["amount"].toString());
    this._restaurant = Restaurant.map(obj["restaurant"]);
    this._status = StatusCommande.map(obj["status"]);
  }


  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = _id;
    map["deja-noter"] = _dejaNoter;
    map["reference"] = _reference;
    map["date"] = _date;
    map["hour"] = _heure;
    map["amount"] = _prix;
    map["deliveryAddress"] = _deliveryAddress;
    map["restaurant"] = _restaurant.toMap();
    map["status"] = _status.toMap();

    return map;
  }


  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get deliveryAddress => _deliveryAddress;

  set deliveryAddress(String value) {
    _deliveryAddress = value;
  }


  Deliver get deliver => _deliver;

  set deliver(Deliver value) {
    _deliver = value;
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

  bool get dejaNoter => _dejaNoter;

  set dejaNoter(bool value) {
    _dejaNoter = value;
  }


}