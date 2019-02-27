import 'dart:io';

import 'package:client_app/StringKeys.dart';
import 'package:client_app/Utils/AppBars.dart';
import 'package:client_app/Utils/Loading.dart';
import 'package:client_app/Utils/MyBehavior.dart';
import 'package:flutter/material.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';
import 'package:url_launcher/url_launcher.dart';

import 'DAO/Presenters/OrderDetailPresenter.dart';
import 'Models/Commande.dart';
import 'Models/Complement.dart';
import 'Models/Produit.dart';
import 'TrackingCommandScreen.dart';
import 'Utils/PriceFormatter.dart';

import 'package:client_app/PanierScreen.dart';

_openMap(double lat, double lng, String title) async {
  // Android
  var url = 'geo:0,0?q=' + lat.toString() + ',' + lng.toString() + '($title)';
  if (Platform.isIOS) {
    // iOS
    url = 'maps://?q=' + lat.toString() + ',' + lng.toString();
  }
  if (await canLaunch(url)) {
    print("launching");
    await launch(url);
  } else {
    print("Could not launch");
    throw 'Could not launch $url';
  }
}

class DetailsCommande extends StatefulWidget {
  final Commande commande;

  const DetailsCommande({@required this.commande});

  @override
  State<StatefulWidget> createState() => new DetailsCommandeState();
}

class DetailsCommandeState extends State<DetailsCommande>
    implements OrderDetailContract {
  OrderDetailPresenter _presenter;
  List<Produit> produits;
  int stateIndex;
  double PADDING_HORIZONTAL = 20.0;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    stateIndex = 0;
    produits = null;
    _presenter = new OrderDetailPresenter(this);
    _presenter.loadOrderDetails(widget.commande);
    super.initState();
  }

  void _onRetryClick() {
    setState(() {
      stateIndex = 0;
      _presenter.loadOrderDetails(widget.commande);
    });
  }

  Widget getDivider(double height, {bool horizontal}) {
    return Container(
      width: horizontal ? double.infinity : height,
      height: horizontal ? height : double.infinity,
      color: Color.fromARGB(15, 0, 0, 0),
    );
  }

  Widget getPricesSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        getDivider(3.0, horizontal: true),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  getLocaleText(
                      context: context, strinKey: StringKeys.PANIER_TOTAL),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                Text(
                  PriceFormatter.formatPrice(price: widget.commande.prix),
                  style: TextStyle(
                      color: Colors.lightGreen,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                )
              ]),
        ),
        getDivider(3.0, horizontal: true)
      ],
    );
  }

  Widget getInfos(String title, String value) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 10.0),
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold)),
          Container(
            margin: EdgeInsets.only(top: 10.0, left: 10.0),
            child: Text(value,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget getRecapCommandeSection() {
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: new ListView.builder(
          padding: EdgeInsets.all(0.0),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: produits.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return getItem(index);
          }),
    );
  }

  Widget getComplementItem(Complement complement) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
              child: Container(
                  child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                " - ",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              Expanded(
                  child: Text(
                complement.name,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
              ))
            ],
          ))),
          Text(
            complement.price == 0
                ? getLocaleText(
                    context: context, strinKey: StringKeys.PANIER_OFFERT)
                : PriceFormatter.formatPrice(price: complement.price),
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
                fontSize: 16.0,
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  double getItemTotal(int index, bool all) {
    double total = produits[index].prix;
    if (produits[index].options == null || produits[index].options.length == 0)
      return all ? total * produits[index].nbCmds : total;

    for (int j = 0; j < produits[index].options[0].complements.length; j++)
      total += produits[index].options[0].complements[j].price;
    return all ? total * produits[index].nbCmds : total;
  }

  Widget getItem(int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0),
      padding: EdgeInsets.symmetric(horizontal: PADDING_HORIZONTAL + 10.0),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(right: 10.0),
                      child: Text(
                        produits[index].name,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ))),
              Text(
                PriceFormatter.formatPrice(price: produits[index].prix),
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          produits[index].options == null || produits[index].options.length == 0
              ? Container(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                )
              : Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: ScrollConfiguration(
                      behavior: MyBehavior(),
                      child: ListView.builder(
                          padding: EdgeInsets.all(0.0),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount:
                              produits[index].options[0].complements.length,
                          itemBuilder: (BuildContext ctxt, int indexe) {
                            return getComplementItem(
                                produits[index].options[0].complements[indexe]);
                          })),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    PriceFormatter.formatPrice(
                        price: getItemTotal(index, false)),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    " X " + produits[index].nbCmds.toString(),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.lightGreen,
                        fontWeight: FontWeight.bold),
                  )
                ],
              )),
              Text(
                PriceFormatter.formatPrice(price: getItemTotal(index, true)),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.lightGreen,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 5.0),
            child: getDivider(2.0, horizontal: true),
          )
        ],
      ),
    );
  }

  Widget getAppropriateView() {
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
          padding: EdgeInsets.symmetric(horizontal: PADDING_HORIZONTAL),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 15.0),
                  child: Text(
                    getLocaleText(
                        context: context, strinKey: StringKeys.DETAIL_COMMANDE),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 22.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  )),
              Expanded(child: getRecapCommandeSection()),
              getPricesSection(),
              getInfos(
                  getLocaleText(
                      context: context, strinKey: StringKeys.RESTAURANT_INFO),
                  widget.commande.restaurant.name +
                      "\n" +
                      widget.commande.restaurant.city +
                      ", " +
                      widget.commande.restaurant.address),
              getInfos(
                  getLocaleText(
                          context: context,
                          strinKey: StringKeys.DELIVERY_ADDRESS) +
                      " : ",
                  widget.commande.deliveryAddress),
              Container(
                margin: EdgeInsets.only(bottom: 15.0, top: 30.0),
                child: Center(
                  child: PositionedTapDetector(
                      onTap: (position) {
                        if (widget.commande.deliver != null &&
                            widget.commande.status.id != 4)
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (context) => TrackingCommandeScreen(
                                    deliveryAdress:
                                        widget.commande.deliveryAddress,
                                    deliver: widget.commande.deliver,
                                    restaurant: widget.commande.restaurant,
                                  )));
                      },
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 35.0),
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.lightGreen,
                                style: BorderStyle.solid,
                                width: 1.0),
                            color: widget.commande.status.id != 4
                                ? Colors.lightGreen
                                : Colors.black38),
                        child: Text("TRACKING",
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                              color: widget.commande.status.id != 4
                                  ? Colors.white
                                  : Colors.black54,
                              decoration: TextDecoration.none,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            )),
                      )),
                ),
              )
            ],
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                HomeAppBar(),
                Expanded(child: getAppropriateView())
              ],
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
      stateIndex = 3;
      this.produits = produits;
    });
  }
}
