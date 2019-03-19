import 'package:client_app/PanierScreen.dart';
import 'package:client_app/StringKeys.dart';
import 'package:client_app/Utils/MyBehavior.dart';
import 'package:flutter/material.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';

import 'DAO/Presenters/RestaurantMenusPresenter.dart';
import 'Database/DatabaseHelper.dart';
import 'Models/Categorie.dart';
import 'Models/Produit.dart';
import 'Models/Restaurant.dart';
import 'ProductDetailScreen.dart';
import 'Utils/AppBars.dart';
import 'Utils/Loading.dart';
import 'Utils/PriceFormatter.dart';

class RestaurantMenusScreen extends StatefulWidget {
  final Restaurant restaurant;
  final Categorie categorie;
  RestaurantMenusScreen(this.restaurant, this.categorie);

  @override
  State<StatefulWidget> createState() => new RestaurantMenusScreenState();
}

class RestaurantMenusScreenState extends State<RestaurantMenusScreen>
    implements RestaurantMenusContract {
  int stateIndex;
  List<Produit> produits, searchResultProduits;
  RestaurantMenusPresenter _presenter;
  DatabaseHelper db;

//  ajouter pour le scrool
  ScrollController _scrollController = new ScrollController();
  bool isProductInCart;

  bool isSearching; // determine si une recherche est en cours ou pas
  final controller = new TextEditingController();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    stateIndex = 0;
    db = new DatabaseHelper();
    _presenter = new RestaurantMenusPresenter(this);
    isSearching = false;
    isProductInCart = false;
    controller.addListener(() {
      String currentText = controller.text;
      if (currentText.length > 0) {
        setState(() {
          searchResultProduits = new List<Produit>();
          for (Produit produit in produits) {
            // pour chaque commande
            if (produit.name
                .toLowerCase()
                .contains(currentText.toLowerCase())) {
              // si ca commence par le texte taper
              searchResultProduits
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
    _presenter.loadRestaurantCategorieMenusList(
        widget.restaurant.id, widget.categorie.id);

    super.initState();

    //ajouter pour le scroll
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print(produits.length);
      }
    });
  }

//  ajouter pour le scroll
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onRetryClick() {
    setState(() {
      stateIndex = 0;
      _presenter.loadRestaurantCategorieMenusList(
          widget.restaurant.id, widget.categorie.id);
    });
  }

  Widget getDivider(double height, {bool horizontal}) {
    return Container(
      width: horizontal ? double.infinity : height,
      height: horizontal ? height : double.infinity,
      color: Color.fromARGB(15, 0, 0, 0),
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

  Widget getHeader() {
    return Expanded(
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.only(bottom: 40.0),
            child: Image.network(
              widget.restaurant.photo,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: EdgeInsets.only(right: 10.0, top: 15.0),
              child: Icon(
                Icons.favorite_border,
                size: 40.0,
                color: Colors.lightGreen,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 232, 243, 253),
              ),
              margin: EdgeInsets.symmetric(horizontal: 30.0),
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    widget.restaurant.name,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 26.0,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5.0),
                    child: Text(
                      widget.categorie != null
                          ? widget.categorie.name
                          : getLocaleText(
                              context: context,
                              strinKey: StringKeys.UNKNOW_CATEGORY),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 3.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
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
                          margin: EdgeInsets.symmetric(horizontal: 10.0),
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
                  )
                ],
              ),
            ),
          )
        ],
      ),
      flex: 4,
    );
  }

  Widget getItem(itemIndex) {
//    return FutureBuilder(
//        future: db.getProduit(isSearching
//            ? searchResultProduits[itemIndex].id
//            : produits[itemIndex].id),
//        builder: (BuildContext context, AsyncSnapshot snapshot) {
//          if (snapshot.hasData) {
//            Produit prod = snapshot.data;
//            bool isProductInCart;
//
//            if (prod.id < 0) {
//              // si le produit n'est pas dans le panier
//              isProductInCart = false;
//            } else {
//              isProductInCart = true;
//
//              if (isSearching)
//                searchResultProduits[itemIndex].qteCmder = prod.nbCmds;
//              else
//                produits[itemIndex].qteCmder = prod.nbCmds;
//            }
    // db.getProduit(produits[itemIndex].id).then((Produit produit) {
    //  if (produit != null) {
    //    if (produit.id < 0) {
    //     setState(() {
    //       this.produits[itemIndex].inCard = false;
    //     });
    //    } else {
    //     setState(() {
    //       this.produits[itemIndex].inCard = true;
    //   });

    //    if (isSearching) {
    //       searchResultProduits[itemIndex].qteCmder = produit.nbCmds;
    //     } else {
    //       produits[itemIndex].qteCmder = produit.nbCmds;
    //     }
    //   }
    //  }
    //});

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        getDivider(1.0, horizontal: true),
        Container(
          height: 150.0,
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: PositionedTapDetector(
            onTap: (position) {
              // afficher la description du produit selectionner
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(isSearching
                      ? searchResultProduits[itemIndex]
                      : produits[itemIndex])));
            },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: 15.0, left: 3.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                            isSearching
                                ? searchResultProduits[itemIndex].name
                                : produits[itemIndex].name,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            maxLines: 2,
                            style: new TextStyle(
                              color: Colors.black87,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            )),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 3.0),
                          child: Text(
                              ((isSearching
                                      ? (searchResultProduits[itemIndex]
                                                  .description ==
                                              null ||
                                          searchResultProduits[itemIndex]
                                                  .description
                                                  .length ==
                                              0)
                                      : (produits[itemIndex].description ==
                                              null ||
                                          produits[itemIndex]
                                                  .description
                                                  .length ==
                                              0))
                                  ? getLocaleText(
                                      context: context,
                                      strinKey:
                                          StringKeys.PRODUIT_NO_DESCRIPTION)
                                  : (isSearching
                                      ? searchResultProduits[itemIndex]
                                          .description
                                      : produits[itemIndex].description)),
                              maxLines: 3,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              style: new TextStyle(
                                color: Colors.black54,
                                fontSize: 15.0,
                                fontWeight: FontWeight.normal,
                              )),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Expanded(
                                child: Text(
                                    PriceFormatter.formatPrice(
                                        price: isSearching
                                            ? searchResultProduits[itemIndex]
                                                .prix
                                            : produits[itemIndex].prix),
                                    textAlign: TextAlign.left,
                                    style: new TextStyle(
                                      color: Colors.lightGreen,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ))),
                            this.produits[itemIndex].inCard
                                ? Icon(
                                    Icons.shopping_cart,
                                    color: Color.fromARGB(255, 255, 215, 0),
                                    size: 25.0,
                                  )
                                : Container()
                          ],
                        )
                      ],
                    ),
                  ),
                  flex: 3,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(right: 3.0),
                    child: Image.network(
                      isSearching
                          ? searchResultProduits[itemIndex].photo
                          : produits[itemIndex].photo,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),
                  flex: 2,
                )
              ],
            ),
          ),
        )
      ],
    );
//          } else
    return Container(
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: CircularProgressIndicator(),
        ));
//        });
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
        return Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                getHeader(),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  child: researchBox(
                      getLocaleText(
                          context: context, strinKey: StringKeys.CHERCHER_ICI),
                      Color.fromARGB(15, 0, 0, 0),
                      Colors.grey,
                      Colors.transparent),
                ),
//                new Row(
//                  children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 15.0),
                    child: ScrollConfiguration(
                      behavior: MyBehavior(),
                      child: new ListView.builder(
                          controller: _scrollController,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          padding: EdgeInsets.all(0.0),
                          scrollDirection: Axis.vertical,
                          itemCount: isSearching
                              ? searchResultProduits.length
                              : produits.length,
                          itemBuilder: (BuildContext context, int index) {
                            return getItem(index);
                          }),
                    ),
                  ),
                  flex: 5,
                )
//                  ],
//                ),
              ],
            ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: <Widget>[
          Scaffold(
              key: _scaffoldKey,
              body: Column(
                children: <Widget>[
                  HomeAppBar(),
                  Expanded(
                    child: getAppropriateScene(),
                  ),
                ],
              )),
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
  void onLoadingSuccess(List<Produit> produits) {
    setState(() {
      this.produits = produits;
      stateIndex = 3;

      for (int i = 0; i < this.produits.length; i++) {
        db.getProduit(produits[i].id).then((Produit produit) {
          if (produit != null) {
            if (produit.id < 0) {
              setState(() {
                this.produits[i].inCard = false;
              });
            } else {
              setState(() {
                this.produits[i].inCard = true;
              });

              if (isSearching) {
                searchResultProduits[i].qteCmder = produit.nbCmds;
              } else {
                produits[i].qteCmder = produit.nbCmds;
              }
            }
          }
        });
      }
    });
  }
}
