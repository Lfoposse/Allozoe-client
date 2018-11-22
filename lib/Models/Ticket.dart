import 'Restaurant.dart';

class Ticket {

  int _id;
  String _code;
  double _amount;
  Restaurant _restaurant;


  Ticket.empty(){
    this._id = -1;
    this._amount = 0.0;
    this._code = null;
    _restaurant = null;
  }

  Ticket(this._id, this._code, this._restaurant, this._amount);


  int get id => _id;

  set id(int value) {
    _id = value;
  }


  String get code => _code;

  set code(String value) {
    _code = value;
  }

  Ticket.map(dynamic obj) {

    this._id = obj["id"];
    this._code = obj["code"];
    this._amount = double.parse(obj["amount"].toString());
    this._restaurant = Restaurant.map(obj["restaurant"]);
  }


  double get amount => _amount;

  set amount(double value) {
    _amount = value;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = _id;
    map["code"] = _code;
    map["amount"] = _amount;
    map["restaurant"] =  _restaurant.toMap();
    return map;
  }

  Restaurant get restaurant => _restaurant;

  set restaurant(Restaurant value) {
    _restaurant = value;
  }

}