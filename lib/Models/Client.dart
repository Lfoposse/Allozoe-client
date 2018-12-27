
class Client {

  int _id;

  String _email;
  String _password;

  String _username;
  String _firstname;
  String _lastname;
  String _phone;
  bool _active;
  String _photo;


  Client.empty(){
    this._id = -1;
    this._username = null;
    this._firstname = null;
    this._lastname = null;
    this._email = null;
    this._phone = null;
    this._password = null;
    this._active = false;
  }


  Client(this._id, this._username, this._password, this._lastname, this._email, this._phone, this._active, this._firstname);


  Client.map(dynamic obj) {

    this._id = obj["id"];
    this._username = obj["username"];
    this._password = obj["password"];
    this._firstname = obj["firstname"];
    this._lastname = obj["lastname"];
    this._email = obj["email"];
    this._phone = obj["phone"];
    this._active = obj["active"];

  }



  int get id => _id;
  String get username => _username;
  String get password => _password;
  String get lastname => _lastname;
  String get email => _email;
  String get phone => _phone;
  bool get active => _active;
  String get firstname => _firstname;


  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["client_id"] = _id;
    map["username"] = _username;
    //map["password"] = _password;
    map["lastname"] = _lastname;
    map["firstname"] = _firstname;
    map["email"] = _email;
    map["phone"] = _phone;

    return map;
  }


  set active(bool value) {
    _active = value;
  }


  set phone(String value) {
    _phone = value;
  }

  set id(int value) {
    _id = value;
  }

  set firstname(String value) {
    _firstname = value;
  }

  set email(String value) {
    _email = value;
  }

  set lastname(String value) {
    _lastname = value;
  }

  set username(String value) {
    _username = value;
  }

  set password(String value) {
    _password = value;
  }

}