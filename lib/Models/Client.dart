
class Client {

  int _id;

  String _email;
  String _password;

  String _username;
  String _lastname;
  String _phone;

 // List<String> _roles;


  Client.empty(){
    this._username = null;
    this._lastname = null;
    this._email = null;
    this._phone = null;
    this._password = null;
  }

  Client(this._id, this._username, this._password, this._lastname, this._email, this._phone);

  Client.map(dynamic obj) {

    this._id = obj["id"];
    this._username = obj["username"];
    this._password = obj["password"];
    this._lastname = obj["lastname"];
    this._email = obj["email"];
    this._phone = obj["phone"];
    //this._roles = obj["role"];
  }

  int get id => _id;
  String get username => _username;
  String get password => _password;
  String get lastname => _lastname;
  String get email => _email;
  String get phone => _phone;



  //List<String> get roles => _roles;


  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = _password;
    map["username"] = _username;
    map["password"] = _password;
    map["lastname"] = _lastname;
    map["email"] = _email;
    map["phone"] = _phone;
    //map["roles"] = _roles;

    return map;
  }

  set phone(String value) {
    _phone = value;
  }

  set id(int value) {
    _id = value;
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