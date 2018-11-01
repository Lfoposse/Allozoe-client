import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

import 'DAO/Presenters/OrderDetailPresenter.dart';
import 'Models/Commande.dart';
import 'Models/Produit.dart';
import 'package:client_app/Utils/AppBars.dart';
import 'package:client_app/Utils/Loading.dart';
import 'package:client_app/Utils/MyBehavior.dart';
import 'package:flutter/material.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';


_openMap(double lat, double lng, String title) async {
  // Android
  var url = 'geo:0,0?q=' + lat.toString() + ',' + lng.toString()+'($title)';
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


class DetailsCommande extends StatefulWidget{

  final Commande commande;

  const DetailsCommande({@required this.commande});

  @override
  State<StatefulWidget> createState() => new DetailsCommandeState();
}


class DetailsCommandeState extends State<DetailsCommande> implements OrderDetailContract{

  OrderDetailPresenter _presenter;
  List<Produit> produits;
  int stateIndex;
  double PADDING_HORIZONTAL = 20.0;


  @override
  void initState() {

    stateIndex = 0;
    produits = null;
    _presenter = new OrderDetailPresenter(this);
    _presenter.loadOrderDetails(widget.commande);
    super.initState();
  }

  void _onRetryClick(){
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

  Widget researchBox(String hintText, Color bgdColor, Color textColor, Color borderColor) {
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

  Widget getRecapCommandeSection() {
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: new ListView.builder(
          padding: EdgeInsets.all(0.0),
          scrollDirection: Axis.vertical,
          itemCount: produits.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return getItem(index);
          }),
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
                  "Total",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                Text(
                  widget.commande.prix.toString() + "€",
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
      padding: EdgeInsets.only(
          left: 15.0,
          right: 15.0
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold)),
          Container(
            margin: EdgeInsets.only(top: 10.0),
            child: Text(value,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }


  Widget getAppropriateView() {
    switch(stateIndex){

      case 0 : return ShowLoadingView();

      case 1 : return ShowLoadingErrorView(_onRetryClick);

      case 2 : return ShowConnectionErrorView(_onRetryClick);

      default: return Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: PADDING_HORIZONTAL),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 15.0),
                child: Text(
                  "Détail de la commande",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                )),
            Expanded(child: getRecapCommandeSection()),
            getPricesSection(),
            getInfos("Nom du restaurant : ", widget.commande.restaurant.name),
            getInfos("Adresse du restaurant : ",  widget.commande.restaurant.city + ", " + widget.commande.restaurant.address),
//            Container(margin: EdgeInsets.only(top: 15.0), child: getDivider(3.0, horizontal: true)),
//            getInfos("Téléphone du livreur : ", "+33784499400"),
//            Container(margin: EdgeInsets.only(top: 15.0), child: getDivider(3.0, horizontal: true)),
            Container(
              margin: EdgeInsets.only(bottom: 15.0, top: 30.0),
              child: Center(
                child: PositionedTapDetector(
                    onTap: (position) {
                      _openMap(widget.commande.restaurant.latitude, widget.commande.restaurant.longitude, widget.commande.restaurant.name);
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
                          color: Colors.lightGreen),
                      child: Text("TRACKING",
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                            color: Colors.white,
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

  Widget getItem(int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        getDivider(3.0, horizontal: true),
        Container(
          height: 150.0,
          margin: EdgeInsets.symmetric(horizontal: 15.0),
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(right: 3.0),
                  child: Image.network(
                    produits[index].photo,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.fill,
                  ),
                ), flex: 2,),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 15.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(produits[index].name,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          maxLines: 2,
                          style: new TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          )),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 3.0),
                        child: Text("Quantité: " + produits[index].nbCmds.toString(),
                            maxLines: 1,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            style: new TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      Text(produits[index].prix.toString() + "€",
                          maxLines: 1,
                          textAlign: TextAlign.left,
                          style: new TextStyle(
                            color: Colors.lightGreen,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ))

                    ],
                  ),
                ), flex: 3,)
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return Material(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                HomeAppBar(),
                Expanded(child: getAppropriateView())
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
            ),
//            isLoading
//                ? Container(
//              color: Colors.black26,
//              width: double.infinity,
//              height: double.infinity,
//              child: Center(
//                child: new CircularProgressIndicator(),
//              ),
//            )
//                : IgnorePointer(ignoring: true)
          ],
        ),
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
      stateIndex = 3;
      this.produits = produits;
    });
  }
}