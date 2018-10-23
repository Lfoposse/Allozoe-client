import 'Models/Produit.dart';
import 'Models/Categorie.dart';
import 'package:flutter/material.dart';
import 'Models/Restaurant.dart';
import 'Utils/AppBars.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';
import 'DAO/Presenters/RestaurantMenusPresenter.dart';
import 'Utils/Loading.dart';
import 'Utils/MyBehavior.dart';
import 'ProductDetailScreen.dart';
import 'Database/DatabaseHelper.dart';

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
  List<Produit> produits;
  RestaurantMenusPresenter _presenter;
  DatabaseHelper db;

  @override
  void initState() {
    db = new DatabaseHelper();
    stateIndex = 0;
    _presenter = new RestaurantMenusPresenter(this);
    _presenter.loadRestaurantMenusList(widget.restaurant.id);
    super.initState();
  }

  void _onRetryClick() {
    setState(() {
      stateIndex = 0;
      _presenter.loadRestaurantMenusList(widget.restaurant.id);
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
                      widget.categorie != null ? widget.categorie.name : "Catégorie inconnu",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold
                      ),
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
                              new Text("4.5",
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
                              new Text("(243)",
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
                          child: new Text("Livraison",
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

  Column getItem(itemIndex) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        getDivider(1.0, horizontal: true),
        Container(
          height: 150.0,
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: PositionedTapDetector(
            onTap: (position){
              // afficher la description du produit selectionner
              db.isInCart(produits[itemIndex]).then((inCart){

                if(!inCart) // si le produit n'a pas encore ete ajouter au panier
                  Navigator.of(context).push(
                      new MaterialPageRoute(builder: (context) => ProductDetailScreen(produits[itemIndex])));
              });

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
                        Text(produits[itemIndex].name,
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
                          child: Text(produits[itemIndex].description == null || produits[itemIndex].description.length == 0 ?
                              "Aucune description donnée sur ce produit": produits[itemIndex].description,
                              maxLines: 3,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              style: new TextStyle(
                                color: Colors.black54,
                                fontSize: 15.0,
                                fontWeight: FontWeight.normal,
                              )),
                        ),
                        Text(produits[itemIndex].prix.toString(),
                            textAlign: TextAlign.left,
                            style: new TextStyle(
                              color: Colors.lightGreen,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ))
                      ],
                    ),
                  ), flex: 3,),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(right: 3.0),
                    child: Image.network(
                      produits[itemIndex].photo,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ), flex: 2,)
              ],
            ),
          ),
        )
      ],
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
        return Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              getHeader(),
              Container(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: researchBox("Chercher ici", Color.fromARGB(15, 0, 0, 0),
                    Colors.grey, Colors.transparent),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15.0),
                  child: ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: new ListView.builder(
                        padding: EdgeInsets.all(0.0),
                        scrollDirection: Axis.vertical,
                        itemCount: produits == null ? 0 : produits.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return getItem(index);
                        }),
                  ),
                ),
                flex: 5,
              )
            ],
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              HomeAppBar(),
              Expanded(
                child: getAppropriateScene(),
              ),
            ],
          ),
          Container(
            height: AppBar().preferredSize.height,
            child: AppBar(
              iconTheme: IconThemeData(
                color: Colors.black, //change your color here
              ),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
          )
        ],
      ),
    );
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
    });
  }
}
