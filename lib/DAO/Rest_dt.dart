import 'dart:async';
import 'NetworkUtil.dart';
import '../Models/Client.dart';
import '../Models/Categorie.dart';
import '../Models/Produit.dart';

class RestDatasource {

  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "http://brservtest.com";
  static final LOGIN_URL = BASE_URL + "/auth/login";
  static final LOAD_CATEGORIE_LIST_URL = BASE_URL + "/api/categories";
  static final LOAD_ALL_MENUS_LIST_URL = BASE_URL + "/api/menus";



  ///retourne les informations d'un compte client a partir de ses identifiants
  Future<Client> login(String username, String password, bool checkAccountExists) {
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


   ///Retourne la liste des produits d'une categorie precise
  Future<List<Produit>> loadCategorieMenus(int categorieID) {
    return _netUtil.get(LOAD_CATEGORIE_LIST_URL + "/" + categorieID.toString() + "/menus").then((dynamic res) {

      print(res.toString());
      if(res["code"] == 200)
        return (res['items'] as List).map((item) => new Produit.map(item)).toList();
      else
        return null as List<Produit>;

    }).catchError((onError) => new Future.error(new Exception(onError.toString())));
  }


  /// retourne la liste des categories
  Future<List<Categorie>> loadCategorieList() {
    return _netUtil.get(LOAD_CATEGORIE_LIST_URL).then((dynamic res) {

      print(res.toString());
      if(res["code"] == 200)
        return (res['items'] as List).map((item) => Categorie.map(item)).toList();
      else
        return null as List<Categorie>;

    }).catchError((onError) => new Future.error(new Exception(onError.toString())));
  }


  ///Retourne la liste de tous les produits
  Future<List<Produit>> loadAllMenus() {
    return _netUtil.get(LOAD_ALL_MENUS_LIST_URL).then((dynamic res) {

      print(res.toString());
      if(res["code"] == 200)
        return (res['items'] as List).map((item) => new Produit.map(item)).toList();
      else
        return null as List<Produit>;

    }).catchError((onError) => new Future.error(new Exception(onError.toString())));
  }

}