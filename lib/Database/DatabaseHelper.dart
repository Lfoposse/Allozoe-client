import 'dart:async';
import 'dart:io' as io;

import 'package:path/path.dart';
import '../Models/Produit.dart';
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
    String path = join(documentsDirectory.path, "allozoeclient.db");
    var theDb = await openDatabase(path, version: 3, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
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
  }




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
    return res > 0 ? true : false;
  }


  Future<bool> isInCart(Produit produit) async{

    var dbProduit = await db;
    int count = Sqflite
        .firstIntValue(await dbProduit.rawQuery("SELECT COUNT(*) FROM Produit WHERE prod_id = ?", [produit.id]));
    return count > 0;
  }



}