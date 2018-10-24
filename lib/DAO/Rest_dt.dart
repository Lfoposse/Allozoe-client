import 'dart:async';
import 'NetworkUtil.dart';
import '../Models/Client.dart';
import '../Models/Categorie.dart';
import '../Models/Produit.dart';
import '../Models/Restaurant.dart';

class RestDatasource {

  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "http://brservtest.com";
  static final LOGIN_URL = BASE_URL + "/auth/login";
  static final SIGNUP_URL = BASE_URL + "/api/clients";
  static final CONFIRM_ACCOUNT_URL = BASE_URL + "/api/clients/";
  static final LOAD_CATEGORIE_LIST_URL = BASE_URL + "/api/categories";
  static final LOAD_ALL_MENUS_LIST_URL = BASE_URL + "/api/menus";
  static final LOAD_RESTAURANT_LIST_URL = BASE_URL + "/api/restaurants";
  static final LOAD_CATEGORIE_RESTAURANTS_URL = BASE_URL + "/api/restaurants";


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


  // confirmer la possession d'un compte par le code de validation
  Future<bool> confirmAccount(int clientID, String code) {
    print("clientID : " + clientID.toString() + ", code : " + code);
    return _netUtil.post(CONFIRM_ACCOUNT_URL + clientID.toString() + "/account-activation", body: {
      "code": code,
    }).then((dynamic res) {

      print(res.toString());
      if(res["code"] == 200) return true;
      else return false;

    }).catchError((onError) => new Future.error(false));
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


  ///Retourne la liste des restaurants
  Future<List<Restaurant>> loadRestaurants() {
    return _netUtil.get(LOAD_RESTAURANT_LIST_URL).then((dynamic res) {

      print(res.toString());
      if(res["code"] == 200)
        return (res['items'] as List).map((item) => new Restaurant.map(item)).toList();
      else
        return null as List<Restaurant>;

    }).catchError((onError) => new Future.error(new Exception(onError.toString())));
  }


  ///Retourne la liste des restaurants appartenant a une categorie precise
  Future<List<Restaurant>> loadCategorieRestaurants(int categorieID) {
    return _netUtil.get(LOAD_CATEGORIE_LIST_URL + "/" + categorieID.toString() + "/restaurants").then((dynamic res) {

      print(res.toString());
      if(res["code"] == 200)
        return (res['items'] as List).map((item) => new Restaurant.map(item)).toList();
      else
        return null as List<Restaurant>;

    }).catchError((onError) => new Future.error(new Exception(onError.toString())));
  }


  ///Retourne la liste des produits d'un restaurant precis
  Future<List<Produit>> loadRestaurantMenus(int restaurantID) {
    return _netUtil.get(LOAD_RESTAURANT_LIST_URL + "/" + restaurantID.toString() + "/menus").then((dynamic res) {

      print(res.toString());
      if(res["code"] == 200)
        return (res['items'] as List).map((item) => new Produit.map(item)).toList();
      else
        return null as List<Produit>;

    }).catchError((onError) => new Future.error(new Exception(onError.toString())));
  }


  ///Retourne la liste des produits d'un restaurant precis appartenant a une categorie precise
  Future<List<Produit>> loadRestaurantCategorieMenus(int restaurantID, categorieID) {
    return _netUtil.get(LOAD_RESTAURANT_LIST_URL + "/" + restaurantID.toString() + "/menus?category=" + categorieID.toString()).then((dynamic res) {

      print(res.toString());
      if(res["code"] == 200)
        return (res['items'] as List).map((item) => new Produit.map(item)).toList();
      else
        return null as List<Produit>;

    }).catchError((onError) => new Future.error(new Exception(onError.toString())));
  }


  ///Creer un compte et retourne son identifiant
  Future<int> signup(Client client) {
    return _netUtil.post(SIGNUP_URL, body: {

      "username": client.username,
      "firstname": client.lastname,
      "phone_number": client.phone,
      "email":client.email,
      "password": client.password

    }).then((dynamic res) {
      print(res.toString());
      if(res["code"] == 201) return res["data"]["client_id"] as int;
      else return -1;

    }).catchError((onError) => new Future.error(-1));
  }

}