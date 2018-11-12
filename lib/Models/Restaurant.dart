class Restaurant {
  int _id;
  String _name;
  String _photo;
  String _city;
  String _address;
  double _latitude;
  double _longitude;

  Restaurant.empty() {
    this._id = -1;
    this._name = null;
    this._photo = null;
    this._city = null;
    this._address = null;
    this._latitude = 0.0;
    this._longitude = 0.0;
  }


  Restaurant(this._id, this._name);


  Restaurant copy(){

    Restaurant restaurant = new Restaurant.empty();
    restaurant.id = _id;
    restaurant._name = _name;
    restaurant.photo = _photo;
    restaurant.city = _city;
    restaurant.address = _address;
    restaurant.latitude = _latitude;
    restaurant.longitude = _longitude;

    return restaurant;
  }

  Restaurant.map(dynamic obj) {

    if(obj is String) return;

    this._id = obj["id"];
    this._name = obj["name"];
    this._photo = obj["image"];
    this._city = obj["city"];
    this._address = obj["address"];
    this._latitude = obj["position"] != null ? double.parse(obj["position"]["latitude"]) : 0.0;
    this._longitude = obj["position"] != null ? double.parse(obj["position"]["longitude"]) : 0.0;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["restaurant_id"] = _id;
    map["name"] = _name;
    return map;
  }

  String get name => _name;

  int get id => _id;

  String get address => _address;

  double get longitude => _longitude;

  double get latitude => _latitude;

  String get photo => _photo;

  String get city => _city;



  set longitude(double value) {
    _longitude = value;
  }

  set latitude(double value) {
    _latitude = value;
  }

  set address(String value) {
    _address = value;
  }

  set id(int value) {
    _id = value;
  }

  set photo(String value) {
    _photo = value;
  }

  set city(String value) {
    _city = value;
  }

  set name(String value) {
    _name = value;
  }
}
