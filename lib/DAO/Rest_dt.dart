import 'dart:async';
import 'dart:convert';
import 'NetworkUtil.dart';
import '../Models/Client.dart';
import '../Models/Categorie.dart';
import '../Models/Produit.dart';
import '../Models/Restaurant.dart';
import '../Models/Commande.dart';
import '../Models/StatusCommande.dart';
import '../Database/DatabaseHelper.dart';


class RestDatasource {

  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "http://brservtest.com";
  static final LOGIN_URL = BASE_URL + "/auth/login";
  static final EMAIL_RECOVERY_ACCOUNT_URL = BASE_URL + "/api/security/pass-forget";
  static final RECOVERY_ACCOUNT_CONFIRM_URL = BASE_URL + "/api/security/verification";
  static final SIGNUP_URL = BASE_URL + "/api/clients";
  static final LOAD_CATEGORIE_LIST_URL = BASE_URL + "/api/categories";
  static final LOAD_ALL_MENUS_LIST_URL = BASE_URL + "/api/menus";
  static final LOAD_RESTAURANT_LIST_URL = BASE_URL + "/api/restaurants";
  static final COMMANDS_URL = BASE_URL + "/api/orders";


  ///retourne les informations d'un compte client a partir de ses identifiants
  Future<Client> login(String username, String password, bool checkAccountExists) {
    return _netUtil.post(LOGIN_URL, body: {
      "login": username,
      "pass": password
    }).then((dynamic res) {

      if(checkAccountExists && res["code"] == 4008) return Client.empty();
      else if(res["code"] == 200 && (res["data"]["role"][0].toString() != "ROLE_DELIVER")) return Client.map(res["data"]);
      else return null;

    }).catchError((onError) => new Future.error(new Exception(onError.toString())));
  }


  /// recherche les informations d'un compte
  Future<Client> loadAccountDatas(int clientID) {
    return _netUtil.get(SIGNUP_URL + "/" + clientID.toString()).then((dynamic res) {

      if(res["code"] == 200) return Client.map(res["data"]);
      else return null;

    }).catchError((onError) => new Future.error(new Exception(onError.toString())));
  }


  //Verifie qu'un email est associer a un compte avanr de proceder a la recuperation de compte
  Future<int> emailRecoveryAccount(String email) {
    Map<String, String> lHeaders = {"Content-type": "application/json", "Accept": "application/json"};

    return _netUtil.post(EMAIL_RECOVERY_ACCOUNT_URL, body: jsonEncode({
      "email": email,
    }), headers: lHeaders).then((dynamic res) {

      if(res["code"] == 200) return res["data"]["user_id"] as int;
      else return -1;

    }).catchError((onError) => new Future.error(-1));
  }


  /// valide la creation d'un compte et active le compte en question
  Future<bool> resetPass(int clientID, String password) {
    return _netUtil.put(SIGNUP_URL + "/" + clientID.toString() + "/update-password", body: jsonEncode({
      "password": password,
    })).then((dynamic res) {

      if(res["code"] == 200) return true;
      else return false;

    }).catchError((onError) => new Future.error(false));
  }


  // confirmer la possession d'un compte par le code de validation
  Future<bool> confirmAccount(int clientID, String code) {

    return _netUtil.post(RECOVERY_ACCOUNT_CONFIRM_URL, body: jsonEncode({
      "id" : clientID,
      "code": code
    })).then((dynamic res) {

      if(res["code"] == 200)
        return true;
      else
        return false;

    }).catchError((onError) => new Future.error(false));
  }


  /// valide la creation d'un compte et active le compte en question
  Future<Client> activateAccount(int clientID, String code) {
    Map<String, String> lHeaders = {"Content-type": "application/json", "Accept": "application/json"};
    return _netUtil.post(SIGNUP_URL + "/" + clientID.toString() + "/account-activation", body: jsonEncode({
      "code": code
    }), headers: lHeaders).then((dynamic res) {

      if(res["code"] == 200) return Client.map(res["data"]);
      else return null;

    }).catchError((onError) => new Future.error(new Exception(onError.toString())));
  }


  ///Retourne la liste des produits d'une categorie precise
  Future<List<Produit>> loadCategorieMenus(int categorieID) {
    return _netUtil.get(LOAD_CATEGORIE_LIST_URL + "/" + categorieID.toString() + "/menus").then((dynamic res) {

      if(res["code"] == 200)
        return (res['items'] as List).map((item) => new Produit.map(item)).toList();
      else
        return null as List<Produit>;

    }).catchError((onError) => new Future.error(new Exception(onError.toString())));
  }


  /// retourne la liste des categories
  Future<List<Categorie>> loadCategorieList() {
    return _netUtil.get(LOAD_CATEGORIE_LIST_URL).then((dynamic res) {

      if(res["code"] == 200)
        return (res['items'] as List).map((item) => Categorie.map(item)).toList();
      else
        return null as List<Categorie>;

    }).catchError((onError) => new Future.error(new Exception(onError.toString())));
  }


  ///Retourne la liste de tous les produits
  Future<List<Produit>> loadAllMenus() {
    return _netUtil.get(LOAD_ALL_MENUS_LIST_URL).then((dynamic res) {

      if(res["code"] == 200)
        return (res['items'] as List).map((item) => new Produit.map(item)).toList();
      else
        return null as List<Produit>;

    }).catchError((onError) => new Future.error(new Exception(onError.toString())));
  }


  ///Retourne la liste des restaurants
  Future<List<Restaurant>> loadRestaurants(double latitude, double longitude) {
    return _netUtil.get(LOAD_RESTAURANT_LIST_URL +
        "?latitude=" + latitude.toString() + "&longitude=" + longitude.toString()).then((dynamic res) {

      if(res["code"] == 200 && res['items'] != null)
        return (res['items'] as List).map((item) => new Restaurant.map(item)).toList();
      else
        return null as List<Restaurant>;

    }).catchError((onError) => new Future.error(new Exception(onError.toString())));
  }


  ///Retourne la liste des restaurants appartenant a une categorie precise
  Future<List<Restaurant>> loadCategorieRestaurants(int categorieID) {
    return _netUtil.get(LOAD_CATEGORIE_LIST_URL + "/" + categorieID.toString() + "/restaurants").then((dynamic res) {

      if(res["code"] == 200)
        return (res['items'] as List).map((item) => new Restaurant.map(item)).toList();
      else
        return null as List<Restaurant>;

    }).catchError((onError) => new Future.error(new Exception(onError.toString())));
  }


  ///Retourne la liste des produits d'un restaurant precis
  Future<List<Produit>> loadRestaurantMenus(int restaurantID) {
    return _netUtil.get(LOAD_RESTAURANT_LIST_URL + "/" + restaurantID.toString() + "/menus").then((dynamic res) {

      if(res["code"] == 200)
        return (res['items'] as List).map((item) => new Produit.map(item)).toList();
      else
        return null as List<Produit>;

    }).catchError((onError) => new Future.error(new Exception(onError.toString())));
  }


  ///Retourne la liste des produits d'un restaurant precis appartenant a une categorie precise
  Future<List<Produit>> loadRestaurantCategorieMenus(int restaurantID, categorieID) {
    return _netUtil.get(LOAD_RESTAURANT_LIST_URL + "/" + restaurantID.toString() + "/menus?category=" + categorieID.toString()).then((dynamic res) {

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
      "firstname": client.firstname,
      "lastname": client.lastname,
      "phone_number": client.phone,
      "email":client.email,
      "password": client.password

    }).then((dynamic res) {

      if(res["code"] == 201) return res["data"]["client_id"] as int;
      else return -1;

    }).catchError((onError) => new Future.error(-1));
  }


  /// Effectue la commande des produits selectionnes par un client
  Future<bool> commander(List<Produit> produits, String address, String phone) {
    return DatabaseHelper().loadClient().then((Client client){

      List prods = new List();
      for (Produit prod in produits) prods.add(prod.toMapRequest());
      Map<String, Object> body = {
        "client" : client.id,
        "delivery_address": address,
        "delivery_phone": phone,
        "restaurant": 1,
        "menus": prods
      };

      return _netUtil.post(COMMANDS_URL, body: jsonEncode(body, toEncodable: (prods){

      })).then((dynamic res) {

        if(res["code"] == 201) return true;
        else return false;

      }).catchError((onError){
        print(onError.toString());

        return false;
      });

    });
  }


  ///Retourne la liste des commandes effectuees par un client
  Future<List<Commande>> loadCommandsHistory(int clientID) {
    return _netUtil.get(SIGNUP_URL + "/" + clientID.toString() + "/orders").then((dynamic res) {

      if(res["code"] == 200 && res['items'] != null)
        return (res['items'] as List).map((item) => new Commande.map(item)).toList();
      else
        return null as List<Commande>;

    }).catchError((onError) => new Future.error(new Exception(onError.toString())));
  }


  ///Modifie les informations d'un compte
  Future<bool> updateClient(Client client) async{

    return _netUtil.put(SIGNUP_URL + "/" + client.id.toString(), body: {

      "username": client.username,
      "firstname": client.firstname,
      "lastname": client.lastname,
      "phone_number": client.phone

    }).then((dynamic res) {

        return res["code"] == 200;

    }).catchError((onError) => new Future.error(false));
  }


  Future<List<Produit>> loadOrderDetails(Commande commande) {
    return _netUtil.get(COMMANDS_URL + "/" + commande.id.toString() ).then((dynamic res) {

      if(res["code"] == 200) {
        commande.status = StatusCommande.map(res["data"]["status"]);
        commande.restaurant = Restaurant.map(res["data"]["restaurant"]);
        return (res["data"]['menus'] as List).map((item) => new Produit.map(item)).toList();
      }
      else
        return null as List<Produit>;

    }).catchError((onError) => new Future.error(new Exception(onError.toString())));
  }

}