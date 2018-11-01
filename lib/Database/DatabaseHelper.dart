import 'dart:async';
import 'dart:io' as io;

import 'package:path/path.dart';
import '../Models/Produit.dart';
import '../Models/Client.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if(_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "allozoeclientdb.db");
    var theDb = await openDatabase(path, version: 2, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the database tables

    // create table produit where store the cart products
    await db.execute(
        "CREATE TABLE Produit("
            "id INTEGER PRIMARY KEY, "
            "prod_id INTEGER UNIQUE, "
            "name TEXT, "
            "description TEXT, "
            "prix REAL, "
            "photo TEXT, "
            "favoris INTEGER, "
            "nbCmds INTEGER "
            ")"
    );


    // create table client where store the connected account informations
    await db.execute(
        "CREATE TABLE Client("
            "id INTEGER PRIMARY KEY, "
            "client_id INTEGER NOT NULL UNIQUE, "
            "username TEXT, "
            "firstname TEXT, "
            "lastname TEXT, "
            "email TEXT NOT NULL, "
            "phone TEXT "
            ")"
    );
  }


  /// FONCTION TO DEAL WITH THE CLIENT TABLE
  Future<Client> loadClient() async {
    var dbProduit = await db;
    List<Map> list = await dbProduit.rawQuery('SELECT * FROM Client ');
    print(list.toString());
    if(list.length == 1)
      return new Client(list[0]["client_id"], list[0]["username"], null, list[0]["lastname"], list[0]["email"], list[0]["phone"].toString(), true,
          list[0]["firstname"]);
    return null as Future<Client>;
  }


  Future<int> clearClient() async {
    var dbProduit = await db;
    int res = await dbProduit.rawDelete('DELETE FROM Client');
    return res;
  }


  Future<int> saveClient(Client client) async {
    var dbProduit = await db;
    int res = await dbProduit.insert("Client", client.toMap());
    print("saved client id = " + res.toString());
    return res;
  }


  Future<bool> updateClient(Client client) async {
    print("update client  = " + client.toMap().toString());
    var dbProduit = await db;
    int res =   await dbProduit.update("Client", client.toMap(),
        where: "client_id = ?", whereArgs: <int>[client.id]);
    return res > 0 ;
  }





  /// FONCTION TO DEAL WITH THE PRODUIT TABLE
  Future<int> addProduit(Produit produit) async {
    var dbProduit = await db;
    int res = await dbProduit.insert("Produit", produit.toMap());
    return res;
  }


  Future<List<Produit>> getPanier() async {
    var dbProduit = await db;
    List<Map> list = await dbProduit.rawQuery('SELECT * FROM Produit ORDER BY id DESC ');
    List<Produit> panier = new List();
    for (int i = 0; i < list.length; i++) {
      var produit = new Produit(list[i]["nbCmds"], list[i]["favoris"] == 1, list[i]["prod_id"], list[i]["name"], list[i]["description"],
          list[i]["photo"], list[i]["prix"]);
      panier.add(produit);
    }
    return panier;
  }


  Future<Produit> getProduit(int produitID) async {
    var dbProduit = await db;
    List<Map> list = await dbProduit.rawQuery('SELECT * FROM Produit WHERE prod_id = ?', [produitID]);
    print(list.toString());
    if(list.length > 0)
    return new Produit(list[0]["nbCmds"], list[0]["favoris"] == 1, list[0]["prod_id"], list[0]["name"], list[0]["description"],
        list[0]["photo"], list[0]["prix"]);
    return new Produit.empty();
  }


  Future<int> deleteProduit(Produit produit) async {
    var dbProduit = await db;
    int res = await dbProduit.rawDelete('DELETE FROM Produit WHERE prod_id = ?', [produit.id]);
    return res;
  }


  Future<int> clearPanier() async {
    var dbProduit = await db;
    int res = await dbProduit.rawDelete('DELETE FROM Produit');
    return res;
  }


  Future<bool> updateQuantite(Produit produit) async {
    var dbProduit = await db;
    int res =   await dbProduit.update("Produit", produit.toMap(),
        where: "prod_id = ?", whereArgs: <int>[produit.id]);
    return res > 0;
  }


  Future<bool> isInCart(Produit produit) async{

    var dbProduit = await db;
    int count = Sqflite
        .firstIntValue(await dbProduit.rawQuery("SELECT COUNT(*) FROM Produit WHERE prod_id = ?", [produit.id]));
    return count > 0;
  }



}