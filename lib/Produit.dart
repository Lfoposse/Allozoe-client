import 'package:client_app/DAO/Presenters/RestaurantsCategorizedMenusPresenter.dart';
import 'package:client_app/Database/DatabaseHelper.dart';
import 'package:client_app/Database/PanierPresenter.dart';
import 'package:client_app/Models/Categorie.dart';
import 'package:client_app/Models/Produit.dart';
import 'package:client_app/Models/Restaurant.dart';
import 'package:client_app/ProductDetailScreen.dart';
import 'package:client_app/StringKeys.dart';
import 'package:client_app/Utils/Loading.dart';
import 'package:client_app/Utils/MyBehavior.dart';
import 'package:client_app/Utils/PriceFormatter.dart';
import 'package:flutter/material.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';

class ProduitScreen extends StatefulWidget {
  final Restaurant restaurant;
  final Categorie categories;
  List<Produit> produit = null;
  ProduitScreen(this.restaurant, this.categories, {this.produit = null});
  @override
  State<StatefulWidget> createState() => new ProduitScreenState();
}

class ProduitScreenState extends State<ProduitScreen>
    implements PanierContract {
  List<Produit> produits;
  Categorie categories;
  RestaurantCategorizedMenusPresenter _presenter;
  int stateIndex;
  DatabaseHelper db;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Produit>
      searchResultCommandes; // les commandes du resultat de la recherche
  bool isSearching; // determine si une recherche est en cours ou pas
  final controller = new TextEditingController();
  @override
  void initState() {
    db = new DatabaseHelper();
    categories = widget.categories;
    produits = widget.categories.produits;
    isSearching = false;
    controller.addListener(() {
      String currentText = controller.text;
      if (currentText.length > 0) {
        setState(() {
          searchResultCommandes = new List<Produit>();
          for (Produit produit in produits) {
            // pour chaque commande
            if (produit.name
                .toLowerCase()
                .contains(currentText.toLowerCase())) {
              // si ca commence par le texte taper
              searchResultCommandes
                  .add(produit); // l'ajouter au resultat de recherche
            }
          }
          isSearching = true;
        });
      } else {
        setState(() {
          isSearching = false;
        });
      }
    });
    super.initState();
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  Widget getDivider(double height, {bool horizontal}) {
    return Container(
      width: horizontal ? double.infinity : height,
      height: horizontal ? height : double.infinity,
      color: Color.fromARGB(15, 0, 0, 0),
    );
  }

  Container getItem(itemIndex) {
    return Container(
      margin: EdgeInsets.only(right: 10.0),
      padding: EdgeInsets.all(8.0),
      //color:  db.isInCart(categories.produits[itemIndex]) ? Colors.black12 : Colors.white,
      width: 230.0,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: PositionedTapDetector(
              onTap: (position) {
                // afficher la description du produit selectionner
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(isSearching
                        ? searchResultCommandes[itemIndex]
                        : categories.produits[itemIndex])));
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 4.0),
                child: Image.network(
                  isSearching
                      ? searchResultCommandes[itemIndex].photo
                      : categories.produits[itemIndex].photo,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            flex: 7,
          ),
          Expanded(
            child: Center(
              child: Container(
                width: double.infinity,
                child: new Text(
                    isSearching
                        ? searchResultCommandes[itemIndex].name
                        : categories.produits[itemIndex].name,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: new TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration.none,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
            flex: 1,
          ),
          Expanded(
            child: Center(
              child: Container(
                width: double.infinity,
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: new Text(
                            PriceFormatter.formatPrice(
                                price: isSearching
                                    ? searchResultCommandes[itemIndex].prix
                                    : categories.produits[itemIndex].prix),
                            textAlign: TextAlign.left,
                            style: new TextStyle(
                              color: Colors.black,
                              fontFamily: 'Roboto',
                              decoration: TextDecoration.none,
                              fontSize: 14.0,
                              fontWeight: FontWeight.normal,
                            ))),
                    FutureBuilder(
                        future: db.getProduit(isSearching
                            ? searchResultCommandes[itemIndex].id
                            : categories.produits[itemIndex].id),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            Produit prod = snapshot.data;
                            return prod.id > 0
                                ? Icon(Icons.shopping_cart,
                                    color: Color.fromARGB(255, 255, 215, 0),
                                    size: 20.0)
                                : Container();
                          } else
                            return Container();
                        })
                  ],
                ),
              ),
            ),
            flex: 1,
          ),
          Expanded(
            child: Center(
              child: Container(
                padding: EdgeInsets.only(top: 3.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      decoration: new BoxDecoration(
                          border: new Border.all(
                              color: Colors.lightGreen,
                              style: BorderStyle.solid,
                              width: 0.5)),
                      child: new Text("5-15 min",
                          textAlign: TextAlign.left,
                          style: new TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.none,
                            fontSize: 11.0,
                            fontWeight: FontWeight.normal,
                          )),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 5.0, right: 5.0),
                      decoration: new BoxDecoration(
                          border: new Border.all(
                              color: Colors.lightGreen,
                              style: BorderStyle.solid,
                              width: 0.5)),
                      child: Row(
                        children: <Widget>[
                          new Text(
                              widget.restaurant.note != null
                                  ? (widget.restaurant.note.rating == 0.0
                                      ? "2.5"
                                      : widget.restaurant.note.rating
                                          .toString())
                                  : "2.5",
                              textAlign: TextAlign.left,
                              style: new TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.none,
                                fontSize: 11.0,
                                fontWeight: FontWeight.normal,
                              )),
                          Icon(
                            Icons.star,
                            color: Color.fromARGB(255, 255, 215, 0),
                            size: 10.0,
                          ),
                          new Text(
                              "(" +
                                  (widget.restaurant.note != null
                                      ? (widget.restaurant.note.count == 0
                                          ? "10"
                                          : widget.restaurant.note.count
                                              .toString())
                                      : "10") +
                                  ")",
                              textAlign: TextAlign.left,
                              style: new TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.none,
                                fontSize: 11.0,
                                fontWeight: FontWeight.normal,
                              ))
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      decoration: new BoxDecoration(
                          border: new Border.all(
                              color: Colors.lightGreen,
                              style: BorderStyle.solid,
                              width: 0.5)),
                      child: new Text(
                          getLocaleText(
                              context: context, strinKey: StringKeys.LIVRAISON),
                          textAlign: TextAlign.left,
                          style: new TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.none,
                            fontSize: 11.0,
                            fontWeight: FontWeight.normal,
                          )),
                    )
                  ],
                ),
              ),
            ),
            flex: 1,
          )
        ],
      ),
    );
  }

  Widget getSceneView() {
    switch (stateIndex) {
      case 0:
        return Container(
          color: Colors.white,
          child: ShowLoadingView(),
        );

      case 1:
        return Container(
          color: Colors.white,
          padding: EdgeInsets.only(bottom: 2.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 10.0),
                child: Icon(
                  Icons.remove_shopping_cart,
                  size: 60.0,
                  color: Colors.lightGreen,
                ),
              ),
              Text(
                getLocaleText(
                    context: context, strinKey: StringKeys.PRODUIT_NO_FOUND),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Colors.black),
              )
            ],
          ),
        );

      default:
        return new Container(
          child: isSearching
              ? (searchResultCommandes != null &&
                      searchResultCommandes.length > 0)
                  ? Container(
                      height: 300.0,
                      padding:
                          EdgeInsets.only(top: 5.0, left: 10.0, bottom: 5.0),
                      color: Color.fromARGB(0, 205, 205, 255),
                      margin: EdgeInsets.only(bottom: 5.0),
                      child: ScrollConfiguration(
                        behavior: MyBehavior(),
                        child: new ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: searchResultCommandes == null
                                ? 0
                                : searchResultCommandes.length,
                            itemBuilder: (BuildContext ctxt, int itemIndex) {
                              return getItem(itemIndex);
                            }),
                      ))
                  : Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        getLocaleText(
                            context: context,
                            strinKey: StringKeys.PRODUIT_NO_FOUND),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.black),
                      ))
              : Container(
                  height: 300.0,
                  padding: EdgeInsets.only(top: 5.0, left: 10.0, bottom: 5.0),
                  color: Color.fromARGB(0, 205, 205, 255),
                  margin: EdgeInsets.only(bottom: 5.0),
                  child: ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: widget.produit == null
                        ? new ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.produits == null
                                ? 0
                                : categories.produits.length,
                            itemBuilder: (BuildContext ctxt, int itemIndex) {
                              return getItem(itemIndex);
                            })
                        : new ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.produit == null
                                ? 0
                                : widget.produit.length,
                            itemBuilder: (BuildContext ctxt, int itemIndex) {
                              return getItem(itemIndex);
                            }),
                  )),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        alignment: Alignment.bottomCenter,
        overflow: Overflow.visible,
        children: <Widget>[
          Scaffold(
            resizeToAvoidBottomPadding: false,
            body: Column(
              children: <Widget>[
                // HomeAppBar(),
                // logo allozoe
                Container(
                  child: researchBox(
                      getLocaleText(
                          context: context, strinKey: StringKeys.CHERCHER_ICI),
                      Color.fromARGB(15, 0, 0, 0),
                      Colors.grey,
                      Colors.transparent),
                ),
                Expanded(child: getSceneView())
              ],
            ),
          ),
          /*  Container(
            height: AppBar().preferredSize.height+50,
            child: AppBar(
              iconTheme: IconThemeData(
                color: Colors.black, //change your color here
              ),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
          )*/
        ],
      ),
    );
  }

  Widget researchBox(
      String hintText, Color bgdColor, Color textColor, Color borderColor) {
    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0),
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      decoration: new BoxDecoration(
          color: bgdColor,
          border: new Border(
            top: BorderSide(
                color: borderColor, style: BorderStyle.solid, width: 1.0),
            bottom: BorderSide(
                color: borderColor, style: BorderStyle.solid, width: 1.0),
            left: BorderSide(
                color: borderColor, style: BorderStyle.solid, width: 1.0),
            right: BorderSide(
                color: borderColor, style: BorderStyle.solid, width: 1.0),
          )),
      child: Row(children: [
        Icon(
          Icons.search,
          color: textColor,
          size: 25.0,
        ),
        Expanded(
            child: Container(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: TextFormField(
                    controller: controller,
                    autofocus: false,
                    autocorrect: false,
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: hintText,
                        hintStyle: TextStyle(color: textColor)),
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ))))
      ]),
    );
  }

  @override
  void onLoadingError() {
    setState(() {
      stateIndex = 1;
    });
  }

  @override
  void onLoadingSuccess(List<Produit> produits) {
    setState(() {
      this.produits = produits;
      stateIndex = 2;
    });
  }
}
