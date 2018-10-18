
class Client {

  int _id;

  String _username;
  String _password;

  String _lastname;
  String _email;
 // List<String> _roles;


  Client.empty(){
    this._username = null;
    this._password = null;
  }

  Client(this._id, this._username, this._password, this._lastname, this._email);

  Client.map(dynamic obj) {

    this._id = obj["id"];
    this._username = obj["username"];
    this._password = obj["password"];
    this._lastname = obj["lastname"];
    this._email = obj["email"];
    //this._roles = obj["role"];
  }

  int get id => _id;
  String get username => _username;
  String get password => _password;
  String get lastname => _lastname;
  String get email => _email;
  //List<String> get roles => _roles;


  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = _password;
    map["username"] = _username;
    map["password"] = _password;
    map["lastname"] = _lastname;
    map["email"] = _email;
    //map["roles"] = _roles;

    return map;
  }
}