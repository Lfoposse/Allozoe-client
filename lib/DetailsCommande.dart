import 'dart:io';
import 'Models/Deliver.dart';
import 'Models/Complement.dart';
import 'package:url_launcher/url_launcher.dart';
import 'DAO/Presenters/OrderDetailPresenter.dart';
import 'Models/Commande.dart';
import 'Models/Produit.dart';
import 'package:client_app/Utils/AppBars.dart';
import 'package:client_app/Utils/Loading.dart';
import 'package:client_app/Utils/MyBehavior.dart';
import 'package:flutter/material.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';
import 'TrackingCommandScreen.dart';
import 'Utils/CommandStatusHelper.dart';
import 'Utils/PriceFormatter.dart';


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


  Widget getComplementItem(Complement complement){

    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(child: Container(
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
                  Expanded(child: Text(
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
            complement.price == 0 ? "Offert" : PriceFormatter.formatPrice(price: complement.price),
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


  double getItemTotal(int index, bool all){

    double total = produits[index].prix;
    if(produits[index].options == null || produits[index].options.length == 0) return all ? total * produits[index].nbCmds : total;

    for(int j = 0; j < produits[index].options[0].complements.length; j++)
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
              Expanded(child: Container(
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
          produits[index].options == null || produits[index].options.length == 0 ? Container(padding: EdgeInsets.symmetric(vertical: 5.0),) :
          Container(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: ListView.builder(
                    padding: EdgeInsets.all(0.0),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: produits[index].options[0].complements.length,
                    itemBuilder: (BuildContext ctxt, int indexe) {
                      return getComplementItem(produits[index].options[0].complements[indexe]);
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
                        PriceFormatter.formatPrice(price: getItemTotal(index, false)),
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
            getInfos("Restaurant : ", widget.commande.restaurant.name + "\n" + widget.commande.restaurant.city + ", " + widget.commande.restaurant.address),
            getInfos("Contact du livreur : ",  widget.commande.deliver == null || widget.commande.deliver.phone == null? "+337484849900" : widget.commande.deliver.phone),
            Container(
              margin: EdgeInsets.only(bottom: 15.0, top: 30.0),
              child: Center(
                child: PositionedTapDetector(
                    onTap: (position) {

                      if(widget.commande.deliver != null/*canCommandBeTracked(widget.commande.status)*/)
                        Navigator.of(context).push(
                            new MaterialPageRoute(builder: (context) => TrackingCommandeScreen(deliveryAdress: widget.commande.deliveryAddress, deliver: widget.commande.deliver, restaurant: widget.commande.restaurant,)));
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
                          color: /*canCommandBeTracked(widget.commande.status)*/ widget.commande.deliver != null ? Colors.lightGreen : Colors.black38),
                      child: Text("TRACKING",
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                            color: /*canCommandBeTracked(widget.commande.status)*/ widget.commande.deliver != null ? Colors.white : Colors.black54,
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
            )
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


//    Deliver deliver = Deliver.empty();
//    deliver.id = 9;
//    deliver.lat = 4.0043917;
//    deliver.lng = 9.7693786;
//    widget.commande.deliver = deliver;
    widget.commande.deliveryAddress = "Rue Principale, 37510 Villandry, France";

    setState(() {
      stateIndex = 3;
      this.produits = produits;
    });
  }
}