import 'dart:async';

import 'package:client_app/Login/LoginScreenPresenter.dart';

import 'NetworkUtil.dart';
import '../Models/Client.dart';

class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "http://brservtest.com";
  static final LOGIN_URL = BASE_URL + "/auth/login";

  Future<Client> login(String username, String password, bool checkAccountExists, LoginScreenContract callback) {
    return _netUtil.post(LOGIN_URL, body: {
      "login": username,
      "pass": password
    }).then((dynamic res) {

      print(res.toString());
      if(checkAccountExists && res["code"] == 4008) return Client.empty();
      else if(res["code"] == 200) return Client.map(res["data"]);
      else return null;

    }).catchError((onError) => new Future.error(new Exception(onError.toString())));
  }
}