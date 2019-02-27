import 'package:client_app/PanierScreen.dart';
import 'package:client_app/Produit.dart';
import 'package:client_app/StringKeys.dart';
import 'package:flutter/material.dart';

import 'DAO/Presenters/RestaurantsCategorizedMenusPresenter.dart';
import 'Database/DatabaseHelper.dart';
import 'Models/Categorie.dart';
import 'Models/Produit.dart';
import 'Models/Restaurant.dart';
import 'Utils/AppBars.dart';
import 'Utils/Loading.dart';
import 'Utils/MyBehavior.dart';

class RestaurantCategorizedMenus extends StatefulWidget {
  final Restaurant restaurant;
  RestaurantCategorizedMenus(this.restaurant);

  @override
  State<StatefulWidget> createState() => new RestaurantCategorizedMenusState();
}

class RestaurantCategorizedMenusState extends State<RestaurantCategorizedMenus>
    implements RestaurantCategorizedMenusContract {
  int stateIndex;
  List<Categorie> categories;
  RestaurantCategorizedMenusPresenter _presenter;
  DatabaseHelper db;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Categorie> searchResultCategories;
  List<Produit> searchProduit; // les commandes du resultat de la recherche
  bool isSearching; // determine si une recherche est en cours ou pas
  final controller1 = new TextEditingController();
  @override
  void initState() {
    stateIndex = 0;
    db = new DatabaseHelper();
    categories = null;
    _presenter = new RestaurantCategorizedMenusPresenter(this);
    isSearching = false;
    controller1.addListener(() {
      String currentText = controller1.text;
      if (currentText.length > 0) {
        setState(() {
          searchResultCategories = new List<Categorie>();
          searchProduit = new List<Produit>();
          for (Categorie categorie in categories) {
            // pour chaque commande
            if (categorie.name
                .toLowerCase()
                .contains(currentText.toLowerCase())) {
              // si ca commence par le texte taper
              searchResultCategories
                  .add(categorie); // l'ajouter au resultat de recherche
            } else {
              for (Produit produit in categorie.produits) {
                if (produit.name
                    .toLowerCase()
                    .contains(currentText.toLowerCase())) {
                  // si ca commence par le texte taper
                  searchProduit
                      .add(produit); // l'ajouter au resultat de recherche
                }
              }
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
    _presenter.loadCategorieList(widget.restaurant.id);
    super.initState();
  }

  void _onRetryClick() {
    setState(() {
      stateIndex = 0;
      _presenter.loadCategorieList(widget.restaurant.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    /*   Container getItem(int sectionIndex, itemIndex) {
      return Container(
        margin: EdgeInsets.only(right: 10.0),
        padding: EdgeInsets.all(8.0),
        //color:  db.isInCart(categories[sectionIndex].produits[itemIndex]) ? Colors.black12 : Colors.white,
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
                      builder: (context) => ProductDetailScreen(
                          categories[sectionIndex].produits[itemIndex])));
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 4.0),
                  child: Image.network(
                    categories[sectionIndex].produits[itemIndex].photo,
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
                      categories[sectionIndex].produits[itemIndex].name,
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
                                  price: categories[sectionIndex]
                                      .produits[itemIndex]
                                      .prix),
                              textAlign: TextAlign.left,
                              style: new TextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                decoration: TextDecoration.none,
                                fontSize: 14.0,
                                fontWeight: FontWeight.normal,
                              ))),
                      FutureBuilder(
                          future: db.getProduit(
                              categories[sectionIndex].produits[itemIndex].id),
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
                                context: context,
                                strinKey: StringKeys.LIVRAISON),
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

    Widget produit(int sectionIndex) {
      _scaffoldKey.currentState.showBottomSheet<Null>((BuildContext context) {
        return new Container(
            height: 300.0,
            padding: EdgeInsets.only(top: 5.0, left: 10.0, bottom: 5.0),
            color: Color.fromARGB(200, 255, 255, 255),
            margin: EdgeInsets.only(bottom: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: new ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories[sectionIndex].produits == null
                          ? 0
                          : categories[sectionIndex].produits.length,
                      itemBuilder: (BuildContext ctxt, int itemIndex) {
                        return getItem(sectionIndex, itemIndex);
                      }),
                )
              ],
            ));
      });
    }*/

    Container getSection(int sectionIndex) {
      return Container(
        height: 300.0,
        padding: EdgeInsets.only(top: 5.0, left: 10.0, bottom: 5.0),
        color: Color.fromARGB(200, 255, 255, 255),
        margin: EdgeInsets.only(bottom: 5.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 5.0),
              child: new Text(
                isSearching
                    ? searchResultCategories[sectionIndex].name
                    : categories[sectionIndex].name,
                textAlign: TextAlign.left,
                style: new TextStyle(
                  color: Colors.black,
                  decoration: TextDecoration.none,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  _scaffoldKey.currentState
                      .showBottomSheet<Null>((BuildContext context) {
                    return new Container(
                        height: 300.0,
                        child: ProduitScreen(
                            widget.restaurant,
                            isSearching
                                ? searchResultCategories[sectionIndex]
                                : categories[sectionIndex]));
                  }); // afficher la description du produit selectionner
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 4.0),
                  child: Image.network(
                    isSearching
                        ? searchResultCategories[sectionIndex].photo
                        : categories[sectionIndex].photo,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              flex: 7,
            ),
            Container(
              margin: EdgeInsets.only(bottom: 5.0),
              child: new Text(
                categories[sectionIndex].description == null
                    ? "Aucune description"
                    : categories[sectionIndex].description.toString(),
                textAlign: TextAlign.left,
                style: new TextStyle(
                  color: Colors.black38,
                  decoration: TextDecoration.none,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
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
                      controller: controller1,
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

    Widget getAppropriateScene() {
      switch (stateIndex) {
        case 0:
          return ShowLoadingView();

        case 1:
          return ShowLoadingErrorView(_onRetryClick);

        case 2:
          return ShowConnectionErrorView(_onRetryClick);

        default:
          return Column(
            children: <Widget>[
              researchBox(
                  getLocaleText(
                      context: context, strinKey: StringKeys.CHERCHER_ICI),
                  Colors.white70,
                  Colors.black54,
                  Colors.transparent),
              Flexible(
                child: isSearching
                    ? (searchResultCategories != null &&
                            searchResultCategories.length > 0)
                        ? Container(
                            color: Colors.black12,
                            child: ScrollConfiguration(
                              behavior: MyBehavior(),
                              child: new ListView.builder(
                                  padding: EdgeInsets.all(0.0),
                                  scrollDirection: Axis.vertical,
                                  itemCount: searchResultCategories == null
                                      ? 0
                                      : searchResultCategories.length,
                                  itemBuilder:
                                      (BuildContext ctxt, int itemIndex) {
                                    return getSection(itemIndex);
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
                        color: Colors.black12,
                        child: ScrollConfiguration(
                          behavior: MyBehavior(),
                          child: new ListView.builder(
                              padding: EdgeInsets.all(0.0),
                              scrollDirection: Axis.vertical,
                              itemCount:
                                  categories == null ? 0 : categories.length,
                              itemBuilder: (BuildContext ctxt, int itemIndex) {
                                return getSection(itemIndex);
                              }),
                        )),
              )
            ],
          );
      }
    }

    return Material(
      child: Stack(
        children: <Widget>[
          Scaffold(
            key: _scaffoldKey,
            body: Column(
              children: <Widget>[
                HomeAppBar(),
                // logo allozoe

                Expanded(child: getAppropriateScene())
              ],
            ),
          ),
          Container(
            height: AppBar().preferredSize.height + 50,
            child: AppBar(
              iconTheme: IconThemeData(
                color: Colors.black, //change your color here
              ),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              actions: <Widget>[
                new IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () => panier(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget panier() {
    _scaffoldKey.currentState.showBottomSheet<Null>((BuildContext context) {
      return new Container(height: 500.0, child: PanierScreen());
    });
  }

  @override
  void onConnectionError() {
    setState(() {
      stateIndex = 2;
    });
  }

  @override
  void onLoadingError() {
    setState(() {
      stateIndex = 1;
    });
  }

  @override
  void onLoadingSuccess(List<Categorie> categoriesList) {
    setState(() {
      this.categories = categoriesList;
      this.categories.sort((a, b) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
      stateIndex = 3;
    });
  }
}
