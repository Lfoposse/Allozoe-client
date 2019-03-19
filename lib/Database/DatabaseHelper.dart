import 'dart:async';
import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../Models/Client.dart';
import '../Models/Complement.dart';
import '../Models/CreditCard.dart';
import '../Models/Option.dart';
import '../Models/Produit.dart';
import '../Models/Restaurant.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "allozoe25db.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    await theDb.execute("PRAGMA foreign_keys = ON;");
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the database tables

    // drop every existing tables of the database
    await db.execute("DROP TABLE IF EXISTS Cards");
    await db.execute("DROP TABLE IF EXISTS Client");
    await db.execute("DROP TABLE IF EXISTS Complement");
    await db.execute("DROP TABLE IF EXISTS Option");
    await db.execute("DROP TABLE IF EXISTS Produit");
    await db.execute("DROP TABLE IF EXISTS Restaurant");

    // create table credits cards where store the client credits cards informations
    await db.execute("CREATE TABLE Cards("
        "id INTEGER PRIMARY KEY, "
        "card_id INTEGER NOT NULL UNIQUE, "
        "card_number TEXT NOT NULL "
        ")");

    // create table client where store the connected account informations
    await db.execute("CREATE TABLE Client("
        "id INTEGER PRIMARY KEY, "
        "client_id INTEGER NOT NULL UNIQUE, "
        "username TEXT, "
        "firstname TEXT, "
        "lastname TEXT, "
        "email TEXT NOT NULL, "
        "phone TEXT "
        ")");

    // create table Restaurant
    await db.execute("CREATE TABLE Restaurant("
        "id INTEGER PRIMARY KEY, "
        "restaurant_id INTEGER UNIQUE , "
        "name TEXT "
        ")");

    // create table produit where store the cart products
    await db.execute("CREATE TABLE Produit("
        "id INTEGER PRIMARY KEY, "
        "prod_id INTEGER UNIQUE, "
        "name TEXT, "
        "description TEXT, "
        "prix REAL, "
        "photo TEXT, "
        "favoris INTEGER, "
        "nbCmds INTEGER, "
        "restaurant_id INTEGER NOT NULL, "
        "FOREIGN KEY (restaurant_id) REFERENCES Restaurant(restaurant_id) "
        "ON UPDATE CASCADE "
        "ON DELETE CASCADE "
        ")");

    // create table Option
    await db.execute("CREATE TABLE Option("
        "id INTEGER PRIMARY KEY, "
        "opt_id INTEGER UNIQUE , "
        "name TEXT, "
        "prod_id INTEGER NOT NULL, "
        "FOREIGN KEY (prod_id) REFERENCES Produit(prod_id) "
        "ON UPDATE CASCADE "
        "ON DELETE CASCADE "
        ")");

    // create table complement
    await db.execute("CREATE TABLE Complement("
        "id INTEGER PRIMARY KEY, "
        "cp_id INTEGER UNIQUE , "
        "name TEXT, "
        "price REAL, "
        "image TEXT, "
        "opt_id INTEGER NOT NULL, "
        "FOREIGN KEY (opt_id) REFERENCES Option(opt_id) "
        "ON UPDATE CASCADE "
        "ON DELETE CASCADE "
        ")");
  }

  /// FONCTIONS TO DEAL WITH CLIENT CREDITS CARDS INFOS
  Future<int> addCard(CreditCard card) async {
    var dbInsert = await db;
    return await dbInsert.insert("Cards", card.toMap()).catchError((onError) {
      onError.toString();
    });
  }

  Future<List<CreditCard>> getClientCards() async {
    var dbProduit = await db;
    List<Map> list =
        await dbProduit.rawQuery('SELECT * FROM Cards ORDER BY card_id DESC ');
    List<CreditCard> cards = new List();
    for (int i = 0; i < list.length; i++)
      cards.add(new CreditCard(list[i]["card_id"], list[i]["card_number"]));

    return cards;
  }

  Future<int> deleteCard(int card_id) async {
    var dbProduit = await db;
    await dbProduit.rawDelete('DELETE FROM Cards WHERE card_id = ?', [card_id]);

    return 0;
  }

  /// FONCTION TO DEAL WITH THE CLIENT TABLE
  Future<Client> loadClient() async {
    var dbClient = await db;
    List<Map> list = await dbClient
        .rawQuery('SELECT * FROM Client order by id desc limit 1');
    debugPrint(list.toString());
    if (list.length == 1)
      return new Client(
          list[0]["client_id"],
          list[0]["username"],
          null,
          list[0]["lastname"],
          list[0]["email"],
          list[0]["phone"].toString(),
          true,
          list[0]["firstname"]);
    return null as Future<Client>;
  }

  Future<int> clearClient() async {
    var dbProduit = await db;
    await dbProduit.rawDelete("DELETE FROM Cards");
    await dbProduit.rawDelete("DELETE FROM Client");
    await dbProduit.rawDelete("DELETE FROM Complement");
    await dbProduit.rawDelete("DELETE FROM Option");
    await dbProduit.rawDelete("DELETE FROM Produit");
    await dbProduit.rawDelete("DELETE FROM Restaurant");

    return 0;
  }

  Future<int> saveClient(Client client) async {
    var dbProduit = await db;
    int res = await dbProduit.insert("Client", client.toMap());
    return res;
  }

  Future<bool> updateClient(Client client) async {
    print("update client  = " + client.toMap().toString());
    var dbProduit = await db;
    int res = await dbProduit.update("Client", client.toMap(),
        where: "client_id = ?", whereArgs: <int>[client.id]);
    return res > 0;
  }

  /// verifie si le restaurant different de celui des produits actuelement dans le panier ou non
  Future<bool> isRestaurantDifferentFromCartOne(Restaurant restaurant) async {
    var dbInsert = await db;

    List<Map> list = await dbInsert.rawQuery(
        'SELECT * FROM Restaurant WHERE restaurant_id = ? ', [restaurant.id]);
    List<Map> all = await dbInsert.rawQuery('SELECT * FROM Restaurant');
    return !(all.length == 0 || list.length > 0);
  }

  /// FONCTION TO DEAL WITH THE PRODUIT TABLE
  Future<int> addProduit(Produit produit) async {
    var dbInsert = await db;
    Map<String, dynamic> map;

    // insert product restaurant if not exist
    List<Map> list = await dbInsert.rawQuery(
        'SELECT * FROM Restaurant WHERE restaurant_id = ? ',
        [produit.restaurant.id]);
    if (list.length == 0)
      await dbInsert.insert("Restaurant", produit.restaurant.toMap());

    // add restaurant id and save product
    map = new Map<String, dynamic>();
    map["restaurant_id"] = produit.restaurant.id;
    map.addAll(produit.toMap());
    await dbInsert.insert("Produit", map).catchError((onError) {
      onError.toString();
    });

    // Sauvegarder les options des complements choisies par le client ainsi que les complements eux memes
    if (produit.options == null) return 0;
    for (int i = 0; i < produit.options.length; i++) {
      List<Complement> complements = new List();

      for (int j = 0;
          j <
              (produit.options[i].complements == null
                  ? 0
                  : produit.options[i].complements.length);
          j++)
        if (produit.options[i].complements[j].selected)
          complements.add(produit.options[i].complements[j]);

      if (complements.length > 0) {
        // sauvegarder les infos de l'option
        map = new Map<String, dynamic>();
        map["prod_id"] = produit.id;
        map.addAll(produit.options[i].toMap());
        await dbInsert.insert("Option", map).catchError((onError) {
          onError.toString();
        });

        // sauvegarder les elements choisies de l'option
        for (Complement complement in complements) {
          map = new Map<String, dynamic>();
          map["opt_id"] = produit.options[i].id;
          map.addAll(complement.toMap());
          await dbInsert.insert("Complement", map).catchError((onError) {
            onError.toString();
          });
        }
      }
    }

    return 0;
  }

  Future<List<Produit>> getPanier() async {
    var dbProduit = await db;
    List<Map> list = await dbProduit
        .rawQuery('SELECT prod_id FROM Produit ORDER BY id DESC ');
    List<Produit> panier = new List();
    for (int i = 0; i < list.length; i++)
      panier.add(await getProduit(list[i]["prod_id"]));
    return panier;
  }

  Future<int> deleteProduit(Produit produit) async {
    var dbProduit = await db;
    await dbProduit
        .rawDelete('DELETE FROM Produit WHERE prod_id = ?', [produit.id]);

    return 0;
  }

  Future<Produit> getProduit(int produitID) async {
    var dbProduit = await db;
    List<Map> list = await dbProduit
        .rawQuery('SELECT * FROM Produit WHERE prod_id = ?', [produitID]);
    print('produits');
    print(list);
    if (list.length > 0) {
      Produit produit = new Produit(
        list[0]["nbCmds"],
        list[0]["favoris"] == 1,
        list[0]["prod_id"],
        list[0]["name"],
        list[0]["description"],
        list[0]["photo"],
        list[0]["prix"],
        null,
        null,
      );

      // charge son restaurant
      produit.restaurant = await getRestaurant(list[0]["restaurant_id"]);

      // charge ses options de menus
      produit.options = await getOptions(produit.id);

      return produit;
    }
    return new Produit.empty();
  }

  Future<int> clearPanier() async {
    var dbProduit = await db;
    await dbProduit.rawDelete('DELETE FROM Produit');
    await dbProduit.rawDelete('DELETE FROM Restaurant');
    await dbProduit.rawDelete('DELETE FROM Option');
    await dbProduit.rawDelete('DELETE FROM Complement');
    return 0;
  }

  Future<bool> updateQuantite(Produit produit) async {
    var dbProduit = await db;
    int res = await dbProduit.update("Produit", produit.toMap(),
        where: "prod_id = ?", whereArgs: <int>[produit.id]);
    return res > 0;
  }

  Future<bool> isComplementInCart(
      {@required int opt_id, @required int cp_id}) async {
    var dbLoad = await db;
    List<Map> list = await dbLoad.rawQuery(
        'SELECT * FROM Complement WHERE opt_id = ? AND cp_id = ? ',
        [opt_id, cp_id]);
    return list.length > 0;
  }

  // FONCTIONS TO DEAL WITH RESTAURANT, OPTION AND COMPLEMENT TABLES
  // find a restaurant with his id
  Future<Restaurant> getRestaurant(int restaurantID) async {
    var dbLoad = await db;
    List<Map> list = await dbLoad.rawQuery(
        'SELECT * FROM Restaurant WHERE restaurant_id = ?', [restaurantID]);
    print(list.toString());
    if (list.length > 0)
      return new Restaurant(list[0]["restaurant_id"], list[0]["name"]);
    return null;
  }

  // find a product options
  Future<List<Option>> getOptions(int produitID) async {
    var dbLoad = await db;
    List<Map> list = await dbLoad.rawQuery(
        'SELECT * FROM Option WHERE prod_id = ? ORDER BY id ASC ', [produitID]);
    List<Option> options = new List();
    for (int i = 0; i < list.length; i++) {
      var option = new Option(list[i]["opt_id"], list[i]["name"]);
      option.complements = await getComplements(option.id);
      options.add(option);
    }
    return options;
  }

  // find an option complements
  Future<List<Complement>> getComplements(int optionID) async {
    var dbLoad = await db;
    List<Map> list = await dbLoad.rawQuery(
        'SELECT * FROM Complement WHERE opt_id = ? ORDER BY id ASC ',
        [optionID]);
    List<Complement> complements = new List();
    for (int i = 0; i < list.length; i++) {
      var complement = new Complement(list[i]["cp_id"], list[i]["name"],
          list[i]["price"], list[i]["image"], true);
      complements.add(complement);
    }
    return complements;
  }
}
