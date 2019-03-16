import 'dart:async';
import 'dart:io';

import 'package:client_app/Models/Complement.dart';
import 'package:client_app/PanierScreen.dart';
import 'package:client_app/StringKeys.dart';
import 'package:client_app/Utils/Loading.dart';
import 'package:client_app/Utils/MyBehavior.dart';
import 'package:flutter/material.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';

import 'DAO/Presenters/ProductDetailPresenter.dart';
import 'Database/DatabaseHelper.dart';
import 'Models/Produit.dart';
import 'Utils/AppBars.dart';
import 'Utils/PriceFormatter.dart';

class ProductDetailScreen extends StatefulWidget {
  ProductDetailScreen(this.produit);
  final Produit produit;

  @override
  State<StatefulWidget> createState() => new ProductDetailScreenState();
}

class ProductDetailScreenState extends State<ProductDetailScreen>
    implements ProductDetailContract {
  bool isProductInCart;
  DatabaseHelper db;
  int stateIndex;
  ProductDetailPresenter _presenter;
  Produit produit;
  bool requirechoice = false;

  Complement complement;
  List<Complement> listComplements = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    stateIndex = 0;
    produit = null;
    db = new DatabaseHelper();
    _presenter = new ProductDetailPresenter(this);
    _presenter.loadProductDetails(widget.produit.id);
    super.initState();
  }

  void _onRetryClick() {
    setState(() {
      stateIndex = 0;
      _presenter.loadProductDetails(widget.produit.id);
    });
  }

  Widget getDivider(double height, {bool horizontal}) {
    return Container(
      width: horizontal ? double.infinity : height,
      height: horizontal ? height : double.infinity,
      color: Color.fromARGB(15, 0, 0, 0),
    );
  }

  Widget getOptionsSection() {
    return Container(
        child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: ListView.builder(
                padding: EdgeInsets.all(0.0),
                scrollDirection: Axis.vertical,
                itemCount: this.produit.options.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return this.produit.options[index].item_required == 1
                      ? getRadioOpt(index)
                      : getCheckoxOpt(index);
                })));
  }

  Widget getRadioItem(int optIndex, int cplIndex) {
    void _handleRadioValueChange1(int value) {
      setState(() {
        this.produit.options[optIndex].posCurrentCpl = value;
        requirechoice = false;
        print(this.produit.options[optIndex].complements[value].id);
        for (var i = 0;
            i < this.produit.options[optIndex].complements.length;
            i++) {
          this.produit.options[optIndex].complements[i].selected = false;
        }
        this.produit.options[optIndex].complements[value].selected = true;
      });
      if (isProductInCart) {
        db.deleteProduit(this.produit);
        db.addProduit(this.produit).then((insertedId) {
          setState(() {});
        }).catchError((error) {
          print("Erreur : " + error.toString());
        });
      }
    }

    return Container(
      height: 80.0,
      margin: EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Radio(
            activeColor: Colors.blueGrey,
            groupValue: this.produit.options[optIndex].posCurrentCpl,
            value: cplIndex,
            onChanged: (active) {
              print("Valeur");
              print(this.produit.options[optIndex].posCurrentCpl);
              print(cplIndex);
              print(optIndex);
              _handleRadioValueChange1(active);
            },
          ),
          Expanded(
            child: Image.network(
              this.produit.options[optIndex].complements[cplIndex].image,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            flex: 2,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              height: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                      this.produit.options[optIndex].complements[cplIndex].name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0)),
                  Text(
                      this
                                  .produit
                                  .options[optIndex]
                                  .complements[cplIndex]
                                  .price ==
                              0
                          ? getLocaleText(
                              context: context,
                              strinKey: StringKeys.PANIER_OFFERT)
                          : PriceFormatter.formatPrice(
                              price: this
                                  .produit
                                  .options[optIndex]
                                  .complements[cplIndex]
                                  .price),
                      style: TextStyle(
                          color: Colors.lightGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0))
                ],
              ),
            ),
            flex: 3,
          )
        ],
      ),
    );
  }

  Widget getCheckboxItem(int optIndex, int cplIndex) {
    return Container(
      height: 80.0,
      margin: EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Checkbox(
              activeColor: Colors.blueGrey,
              value:
                  this.produit.options[optIndex].complements[cplIndex].selected,
              onChanged: (active) {
                this.produit.options[optIndex].complements[cplIndex].selected =
                    !this
                        .produit
                        .options[optIndex]
                        .complements[cplIndex]
                        .selected;
                if (isProductInCart) {
                  db.deleteProduit(this.produit);
                  db.addProduit(this.produit).then((insertedId) {
                    setState(() {});
                  }).catchError((error) {
                    print("Erreur : " + error.toString());
                  });
                } else
                  setState(() {});
              }),
          Expanded(
            child: Image.network(
              this.produit.options[optIndex].complements[cplIndex].image,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            flex: 2,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              height: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                      this.produit.options[optIndex].complements[cplIndex].name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0)),
                  Text(
                      this
                                  .produit
                                  .options[optIndex]
                                  .complements[cplIndex]
                                  .price ==
                              0
                          ? getLocaleText(
                              context: context,
                              strinKey: StringKeys.PANIER_OFFERT)
                          : PriceFormatter.formatPrice(
                              price: this
                                  .produit
                                  .options[optIndex]
                                  .complements[cplIndex]
                                  .price),
                      style: TextStyle(
                          color: Colors.lightGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0))
                ],
              ),
            ),
            flex: 3,
          )
        ],
      ),
    );
  }

//  Widget getComplementItem(int optIndex, int cplIndex) {
//    void _handleRadioValueChange1(Complement value) {
//      setState(() {
////        _radioValue1 = value;
//        complement = value;
//        print(this.produit.options[optIndex].complements[cplIndex].id);
//        for (var i = 0;
//        i < this.produit.options[optIndex].complements.length;
//        i++) {
//          this.produit.options[optIndex].complements[i].selected = false;
//        }
//        this.produit.options[optIndex].complements[cplIndex].selected = true;
//      });
//      if (isProductInCart) {
//        db.deleteProduit(this.produit);
//        db.addProduit(this.produit).then((insertedId) {
//          setState(() {});
//        }).catchError((error) {
//          print("Erreur : " + error.toString());
//        });
//      }
//    }
//
//    List<Complement> getComplementOblig() {
//      for (var i = 0;
//      i < this.produit.options[optIndex].complements.length;
//      i++) {
//        if (this.produit.options[optIndex].item_required == 1) {
//          listComplements.add(this.produit.options[optIndex].complements[i]);
//          print("complements");
//          print(this.produit.options[optIndex].complements[i]);
//        }
//      }
//      print("taille");
//      print(listComplements);
//      return listComplements;
//    }
//
//    return Container(
//      height: 80.0,
//      margin: EdgeInsets.symmetric(vertical: 5.0),
//      child: Row(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: <Widget>[
//          this.produit.options[optIndex].item_required == 1
//              ? Radio(
//              activeColor: Colors.blueGrey,
//              groupValue: optIndex,
//              value: this.produit.options[optIndex].complements[cplIndex],
//              onChanged: (active) {
//                print("optIndex");
//                print(optIndex);
//                _handleRadioValueChange1(active);
//              })
//              : Checkbox(
//              activeColor: Colors.blueGrey,
//              value: this
//                  .produit
//                  .options[optIndex]
//                  .complements[cplIndex]
//                  .selected,
//              onChanged: (active) {
//                this
//                    .produit
//                    .options[optIndex]
//                    .complements[cplIndex]
//                    .selected =
//                !this
//                    .produit
//                    .options[optIndex]
//                    .complements[cplIndex]
//                    .selected;
//                if (isProductInCart) {
//                  db.deleteProduit(this.produit);
//                  db.addProduit(this.produit).then((insertedId) {
//                    setState(() {});
//                  }).catchError((error) {
//                    print("Erreur : " + error.toString());
//                  });
//                } else
//                  setState(() {});
//              }),
//          Expanded(
//            child: Image.network(
//              this.produit.options[optIndex].complements[cplIndex].image,
//              width: double.infinity,
//              height: double.infinity,
//              fit: BoxFit.cover,
//            ),
//            flex: 2,
//          ),
//          Expanded(
//            child: Container(
//              margin: EdgeInsets.symmetric(horizontal: 10.0),
//              height: double.infinity,
//              child: Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                mainAxisSize: MainAxisSize.max,
//                children: <Widget>[
//                  Text(
//                      this.produit.options[optIndex].complements[cplIndex].name,
//                      maxLines: 2,
//                      overflow: TextOverflow.ellipsis,
//                      style: TextStyle(
//                          color: Colors.grey,
//                          fontWeight: FontWeight.bold,
//                          fontSize: 18.0)),
//                  Text(
//                      this
//                          .produit
//                          .options[optIndex]
//                          .complements[cplIndex]
//                          .price ==
//                          0
//                          ? getLocaleText(
//                          context: context,
//                          strinKey: StringKeys.PANIER_OFFERT)
//                          : PriceFormatter.formatPrice(
//                          price: this
//                              .produit
//                              .options[optIndex]
//                              .complements[cplIndex]
//                              .price),
//                      style: TextStyle(
//                          color: Colors.lightGreen,
//                          fontWeight: FontWeight.bold,
//                          fontSize: 18.0))
//                ],
//              ),
//            ),
//            flex: 3,
//          )
//        ],
//      ),
//    );
//  }
//  Widget getRadioOpt(int optIndex) {
//    return Container(
//      margin: EdgeInsets.only(bottom: 20.0),
//      child: Column(
//        mainAxisSize: MainAxisSize.min,
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: <Widget>[
//          Row(
//            crossAxisAlignment: CrossAxisAlignment.start,
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//            mainAxisSize: MainAxisSize.max,
//            children: <Widget>[
//              Column(
//                children: <Widget>[
//                  Text(
//                    this.produit.options[optIndex].name,
//                    style: TextStyle(
//                        color: Colors.black,
//                        fontWeight: FontWeight.bold,
//                        fontSize: 20.0),
//                  ),
//                  Text(
//                    "(Choisissez " +
//                        this
//                            .produit
//                            .options[optIndex]
//                            .item_required
//                            .toString() +
//                        ")",
//                    style: TextStyle(
//                        color: Colors.black38,
//                        fontWeight: FontWeight.bold,
//                        fontSize: 16.0),
//                  ),
//                ],
//              ),
//              this.produit.options[optIndex].item_required == 1
//                  ? Container(
//                child: Text(
//                  "Obligatoire",
//                  style: requirechoice
//                      ? TextStyle(
//                      color: Colors.redAccent,
//                      fontWeight: FontWeight.bold,
//                      fontSize: 16.0)
//                      : TextStyle(
//                      color: Colors.lightGreen,
//                      fontWeight: FontWeight.bold,
//                      fontSize: 16.0),
//                ),
//              )
//                  : Container(
//                child: Text(
//                  "Facultatif",
//                  style: TextStyle(
//                      color: Colors.lightGreen,
//                      fontWeight: FontWeight.bold,
//                      fontSize: 16.0),
//                ),
//              )
//            ],
//          ),
//          Container(
//              child: ScrollConfiguration(
//                  behavior: MyBehavior(),
//                  child: ListView.builder(
//                      padding: EdgeInsets.all(0.0),
//                      scrollDirection: Axis.vertical,
//                      physics: NeverScrollableScrollPhysics(),
//                      shrinkWrap: true,
//                      itemCount:
//                      this.produit.options[optIndex].complements.length,
//                      itemBuilder: (BuildContext ctxt, int index) {
//                        return getComplementItem(optIndex, index);
//                      })))
//        ],
//      ),
//    );
//  }
//RadioOptions
  Widget getRadioOpt(int optIndex) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    this.produit.options[optIndex].name,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                  Text(
                    "(" +
                        getLocaleText(
                            context: context, strinKey: StringKeys.CHOOSE) +
                        this
                            .produit
                            .options[optIndex]
                            .item_required
                            .toString() +
                        ")",
                    style: TextStyle(
                        color: Colors.black38,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                ],
              ),
              Container(
                child: Text(
                  getLocaleText(
                      context: context, strinKey: StringKeys.REQUIRED),
                  style: requirechoice
                      ? TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0)
                      : TextStyle(
                          color: Colors.lightGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                ),
              )
            ],
          ),
          Container(
              child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: ListView.builder(
                      padding: EdgeInsets.all(0.0),
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          this.produit.options[optIndex].complements.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return getRadioItem(optIndex, index);
                      })))
        ],
      ),
    );
  }

//Checkbox options
  Widget getCheckoxOpt(int optIndex) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    this.produit.options[optIndex].name,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                ],
              ),
              Container(
                child: Text(
                  getLocaleText(
                      context: context, strinKey: StringKeys.OPTIONAL),
                  style: TextStyle(
                      color: Colors.lightGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0),
                ),
              )
            ],
          ),
          Container(
              child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: ListView.builder(
                      padding: EdgeInsets.all(0.0),
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          this.produit.options[optIndex].complements.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return getCheckboxItem(optIndex, index);
                      })))
        ],
      ),
    );
  }

  double getTotal() {
    double total = this.produit.prix;
    if (this.produit.options == null || this.produit.options.length == 0)
      return total * this.produit.nbCmds;
    for (int i = 0; i < this.produit.options.length; i++) {
      if (this.produit.options[i].complements == null ||
          this.produit.options[i].complements.length == 0) continue;
      for (int j = 0; j < this.produit.options[i].complements.length; j++) {
        if (this.produit.options[i].complements[j].selected)
          total += this.produit.options[i].complements[j].price;
      }
    }
    return total * this.produit.nbCmds;
  }

  bool _isIPhoneX(MediaQueryData mediaQuery) {
    if (Platform.isIOS) {
      var size = mediaQuery.size;
      if (size.height >= 812.0 || size.width <= 375.0) {
        return true;
      }
    }
    return false;
  }

  Widget getContent() {
    return Container(
      padding: !_isIPhoneX(MediaQuery.of(context))
          ? EdgeInsets.only(bottom: 5.0)
          : EdgeInsets.only(bottom: 15.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 5.0, bottom: 20.0),
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                          child: Container(
                        child: Center(
                          child: Text(this.produit.name,
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold)),
                        ),
                      )),
                      Icon(
                        Icons.restaurant,
                        size: 40.0,
                        color: Colors.red,
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Image.network(
                        this.produit.photo,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.contain,
                      ),
                    ),
                    flex: 1,
                  ),
//                  description du produit
                  Center(
                    child: Text(this.produit.description,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold)),
                  ),
                  getDivider(1.0, horizontal: true),
                  this.produit.options != null &&
                          this.produit.options.length > 0
                      ? Expanded(
                          child: getOptionsSection(),
                          flex: 1,
                        )
                      : Container(),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              getLocaleText(
                                  context: context, strinKey: StringKeys.PRICE),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                              ),
                            ),
                            Text(
                              getLocaleText(
                                  context: context,
                                  strinKey: StringKeys.QUANTITE),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                              ),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                PriceFormatter.formatPrice(price: getTotal()),
                                style: TextStyle(
                                    color: Colors.lightGreen,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    PositionedTapDetector(
                                      onTap: (position) {
                                        if (this.produit.nbCmds > 1) {
                                          this.produit.qteCmder =
                                              this.produit.nbCmds - 1;
                                          if (isProductInCart)
                                            db.updateQuantite(this.produit);
                                          setState(() {});
                                        }
                                      },
                                      child: Container(
                                        decoration: new BoxDecoration(
                                          color: Colors.lightGreen,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                          size: 25.0,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      padding: EdgeInsets.only(
                                          left: 10.0, right: 10.0),
                                      decoration: new BoxDecoration(
                                          border: new Border.all(
                                              color: Colors.lightGreen,
                                              style: BorderStyle.solid,
                                              width: 0.5)),
                                      child: new Text(
                                          this.produit.nbCmds.toString(),
                                          textAlign: TextAlign.left,
                                          style: new TextStyle(
                                            color: Colors.black,
                                            decoration: TextDecoration.none,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                    PositionedTapDetector(
                                      onTap: (position) {
                                        this.produit.qteCmder =
                                            this.produit.nbCmds + 1;
                                        if (isProductInCart)
                                          db.updateQuantite(this.produit);
                                        setState(() {});
                                      },
                                      child: Container(
                                        decoration: new BoxDecoration(
                                          color: Colors.lightGreen,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 25.0,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            flex: 6,
          ),
          getDivider(6.0, horizontal: true),
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 5.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    onPressed: () {
                      if (isProductInCart) {
                        setState(() {
                          db.deleteProduit(this.produit);
                        });
                      } else {
                        db
                            .isRestaurantDifferentFromCartOne(
                                this.produit.restaurant)
                            .then((isDifferent) {
                          // si le produit a ajouter est different de celui des produits deja present dans le panier
                          if (isDifferent) {
                            for (int i = 0;
                                i < this.produit.options.length;
                                i++) {
                              if (this.produit.options[i].item_required == 1) {
                                if (this.produit.options[i].posCurrentCpl ==
                                    null) {
                                  setState(() {
                                    requirechoice = true;
                                  });
                                  return;
                                }
                              }
                            }
                            if (requirechoice == false) {
                              showDialog<Null>(
                                context: context,
                                builder: (BuildContext context) {
                                  return new AlertDialog(
                                    title: new Text(getLocaleText(
                                        context: context,
                                        strinKey: StringKeys.AVERTISSEMENT)),
                                    content: new SingleChildScrollView(
                                      child: new ListBody(
                                        children: <Widget>[
                                          new Text(getLocaleText(
                                              context: context,
                                              strinKey: StringKeys
                                                  .AVERTISEMENT_CHANGE_RESTAURANT)),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      new FlatButton(
                                        child: new Text(
                                            getLocaleText(
                                                context: context,
                                                strinKey:
                                                    StringKeys.CANCEL_BTN),
                                            style: TextStyle(
                                                color: Colors.lightGreen)),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      new FlatButton(
                                        child: new Text(
                                            getLocaleText(
                                                context: context,
                                                strinKey:
                                                    StringKeys.AJOUTER_PANIER),
                                            style: TextStyle(
                                                color: Colors.lightGreen)),
                                        onPressed: () {
                                          db.clearPanier(); // on vide le panier avant d'y ajouter le nouveau produit
                                          db
                                              .addProduit(this.produit)
                                              .then((insertedId) {
                                            Navigator.of(context).pop();
                                            setState(() {});
                                          }).catchError((error) {
                                            print(
                                                "Erreur : " + error.toString());
                                          });
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          } else {
                            // sinon on ajoute le produit au panier
                            // faire un test pour les choix facultatif/obligatoire
                            for (int i = 0;
                                i < this.produit.options.length;
                                i++) {
                              if (this.produit.options[i].item_required == 1) {
                                if (this.produit.options[i].posCurrentCpl ==
                                    null) {
                                  setState(() {
                                    requirechoice = true;
                                  });
                                  return;
                                }
                              }
                            }
                            if (requirechoice == false) {
                              db.addProduit(this.produit).then((insertedId) {
                                setState(() {});
                              }).catchError((error) {
                                print("Erreur : " + error.toString());
                              });
                            }
                          }
                        }).catchError((error) {
                          print("Erreur : " + error.toString());
                        });
                      }
                    },
                    child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          isProductInCart
                              ? getLocaleText(
                                  context: context,
                                  strinKey: StringKeys.RETIRER_PANIER_BTN)
                              : getLocaleText(
                                  context: context,
                                  strinKey: StringKeys.AJOUTER_PANIER_BTN),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        )),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(0.0)),
                    textColor: Colors.white,
                    color: isProductInCart ? Colors.grey : Colors.lightGreen,
                    elevation: 1.0,
                  ),
                  flex: 2,
                ),
                Expanded(
                    child: RaisedButton(
                  onPressed: () {
                    panier();
                  },
                  child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        getLocaleText(
                            context: context,
                            strinKey: StringKeys.PANIER_MON_PANIER),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      )),
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(0.0)),
                  textColor: Colors.white,
                  color: Colors.redAccent,
                  elevation: 1.0,
                ))
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

  Future<bool> actualize(Produit dbProd) async {
    this.produit.qteCmder = dbProd.nbCmds;
    if (this.produit.options == null || this.produit.options.length == 0)
      return true;
    for (int i = 0; i < this.produit.options.length; i++) {
      if (this.produit.options[i].complements == null ||
          this.produit.options[i].complements.length == 0) continue;
      for (int j = 0; j < this.produit.options[i].complements.length; j++)
        this.produit.options[i].complements[j].selected =
            await db.isComplementInCart(
                opt_id: this.produit.options[i].id,
                cp_id: this.produit.options[i].complements[j].id);
    }

    return true;
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
        return FutureBuilder(
            future: db.getProduit(widget.produit.id),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                Produit prod = snapshot.data;

                if (prod.id < 0) {
                  // si le produit n'est pas dans le panier
                  isProductInCart = false;
                  return getContent();
                } else {
                  isProductInCart = true;
                  return FutureBuilder(
                      future: actualize(prod),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return getContent();
                        } else
                          return Container(
                              height: double.infinity,
                              width: double.infinity,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ));
                      });
                }
              } else
                return Container(
                    height: double.infinity,
                    width: double.infinity,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ));
            });
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
  void onLoadingSuccess(Produit produit) {
    setState(() {
      this.produit = produit;
      stateIndex = 3;
    });
  }
}
