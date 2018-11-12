
class Deliver{

  int _id;
  double _lat, _lng;
  String _phone;


  Deliver(this._id,  this._lat, this._lng, this._phone);

  Deliver.empty(){
    this._id = -1;
    this._lat = 0.0;
    this._lng = 0.0;
    this._phone = null;
  }

  Deliver.map(dynamic obj) {

    this._id = obj["id"];
    this._lat = double.parse(obj["latitude"].toString());
    this._lng = double.parse(obj["longitude"].toString());
    this._phone = obj["phone"];
  }

  Deliver mapForTrackingMode(dynamic obj) {

    this._id = obj["id"];
    this._lat = double.parse(obj["position"]["latitude"].toString());
    this._lng = double.parse(obj["position"]["longitude"].toString());
    return this;
  }


  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = _id;
    map["latitude"] = _lat;
    map["longitude"] = _lng;
    map["phone"] = _phone;
    return map;
  }


  get lng => _lng;

  set lng(value) {
    _lng = value;
  }

  double get lat => _lat;

  set lat(double value) {
    _lat = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get phone => _phone;

  set phone(String value) {
    _phone = value;
  }


}