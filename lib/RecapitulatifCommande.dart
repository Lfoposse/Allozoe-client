import 'Paiements/CardListScreen.dart';
import 'Models/CreditCard.dart';

import 'Models/Complement.dart';
import 'package:flutter/material.dart';
import 'Models/Produit.dart';
import 'Models/Client.dart';
import 'Utils/AppBars.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';
import 'Utils/MyBehavior.dart';
import 'DAO/Presenters/SendCommandePresenter.dart';
import 'Database/DatabaseHelper.dart';
import 'package:flutter_google_places_autocomplete/flutter_google_places_autocomplete.dart';
import 'Utils/PriceFormatter.dart';

const kGoogleApiKey = "AIzaSyBNm8cnYw5inbqzgw8LjXyt3rMhFhEVTjY";
GoogleMapsPlaces _places = new GoogleMapsPlaces(apiKey : kGoogleApiKey); // to get places detail (lat/lng)

int TICKET_RESTAURANT = 2, CARTE_BANCAIRE = 1;

class RecapitulatifCommande extends StatefulWidget {
  final List<Produit> produits;
  final double fraisLivraison;
  final Client client;

  RecapitulatifCommande(
      {@required this.produits,
      @required this.fraisLivraison,
      @required this.client});

  @override
  State<StatefulWidget> createState() => new RecapitulatifCommandeState();
}

class RecapitulatifCommandeState extends State<RecapitulatifCommande>{
  double PADDING_HORIZONTAL = 15.0;
  final phoneKey = new GlobalKey<FormState>();
  String _address, _phone;

  @override
  void initState() {
    _address = "";
    super.initState();
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Avertissement"),
          content: new Text(
              "Vous devez fournir l'adresse de le livraison et le contact à appeller"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Compris"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _submit({@required int paymentMode}) {
    phoneKey.currentState.save();


    if (_address.length == 0 || _phone.length == 0) {
      _showDialog();
    } else {

      new DatabaseHelper().getClientCards().then((List<CreditCard> cards) {
        Navigator.of(context).push(
            new MaterialPageRoute(builder: (context) =>
                CardListScreen(
                  forPaiement: true,
                  paymentMode: paymentMode,
                  montantPaiement: getTotal(false) + widget.fraisLivraison,
                  cards: cards,
                  produits: widget.produits,
                  address: _address,
                  phone: _phone,
                )));
      });
    }
  }

  Widget getDivider(double height, {bool horizontal}) {
    return Container(
      width: horizontal ? double.infinity : height,
      height: horizontal ? height : double.infinity,
      color: Color.fromARGB(15, 0, 0, 0),
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
                    fontSize: 13.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              Expanded(
                  child: Text(
                complement.name,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 13.0,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
              ))
            ],
          ))),
          Text(
            complement.price == 0
                ? "Offert"
                : PriceFormatter.formatPrice(price: complement.price),
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
                fontSize: 13.0,
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  double getTotal(bool sousTotal) {
    double total = 0.0;
    for (int i = 0; i < widget.produits.length; i++) {
      total = total + getItemTotal(i, true);
    }
    return sousTotal ? total : total + widget.fraisLivraison;
  }

  double getItemTotal(int index, bool all) {
    double total = widget.produits[index].prix;
    if (widget.produits[index].options == null ||
        widget.produits[index].options.length == 0)
      return all ? total * widget.produits[index].nbCmds : total;
    for (int i = 0; i < widget.produits[index].options.length; i++) {
      if (widget.produits[index].options[i].complements == null ||
          widget.produits[index].options[i].complements.length == 0) continue;
      for (int j = 0;
          j < widget.produits[index].options[i].complements.length;
          j++) total += widget.produits[index].options[i].complements[j].price;
    }
    return all ? total * widget.produits[index].nbCmds : total;
  }

  Widget getPricesSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: PADDING_HORIZONTAL),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Sous-total",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                Text(
                  PriceFormatter.formatPrice(price: getTotal(true)),
                  style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                )
              ]),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: PADDING_HORIZONTAL),
          margin: EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Frais livraison",
                  style: TextStyle(
                      color: Colors.black38,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                Text(
                  PriceFormatter.formatPrice(price: widget.fraisLivraison),
                  style: TextStyle(
                      color: Colors.black38,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                )
              ]),
        ),
        getDivider(2.0, horizontal: true),
        Container(
          padding: EdgeInsets.symmetric(horizontal: PADDING_HORIZONTAL),
          margin: EdgeInsets.only(top: 10.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Total",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                Text(
                  PriceFormatter.formatPrice(price: getTotal(false) + widget.fraisLivraison),
                  style: TextStyle(
                      color: Colors.lightGreen,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                )
              ]),
        ),
      ],
    );
  }

  Widget getCoordonneeLivraison(key, String title, String initialValue, String hintText, TextInputType inputType, {@required void onTap(position)}) {
    return Container(
      color: Colors.black12,
      margin: EdgeInsets.symmetric(vertical: 3.0),
      padding: EdgeInsets.only(
          left: PADDING_HORIZONTAL + 10.0,
          right: PADDING_HORIZONTAL + 10.0,
          top: 8.0,
          bottom: 8.0),
      child: Row(
        children: <Widget>[
          Text(title,
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold)),
          Expanded(
            child: Form(
                key: key,
                child: onTap == null
                    ? TextFormField(
                        onSaved: (val) {
                          if (key == phoneKey) _phone = val;
                        },
                        textAlign: TextAlign.left,
                        initialValue: initialValue,
                        autofocus: false,
                        autocorrect: false,
                        maxLines: 1,
                        keyboardType: inputType,
                        decoration: InputDecoration(
                            contentPadding: new EdgeInsets.all(0.0),
                            border: InputBorder.none,
                            hintText: hintText,
                            hintStyle: TextStyle(
                                fontSize: 13.0,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold)),
                        style: TextStyle(
                            fontSize: 13.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold))
                    : PositionedTapDetector(
                        onTap: onTap,
                        child: Text(
                            initialValue == "" ? hintText : initialValue,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 13.0,
                                color: initialValue == ""
                                    ? Colors.grey
                                    : Colors.black,
                                fontWeight: FontWeight.bold)))),
            flex: 1,
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
          itemCount: widget.produits.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return getItem(index);
          }),
    );
  }

  Widget getItem(int index) {
    List<Complement> complements = new List();
    for (int i = 0; i < widget.produits[index].options.length; i++)
      for (int j = 0;
          j < widget.produits[index].options[i].complements.length;
          j++)
        complements.add(widget.produits[index].options[i].complements[j]);

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
                        widget.produits[index].name,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ))),
              Text(
                PriceFormatter.formatPrice(price: widget.produits[index].prix),
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          widget.produits[index].options == null ||
                  widget.produits[index].options.length == 0
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
                          itemCount: complements.length,
                          itemBuilder: (BuildContext ctxt, int indexe) {
                            return getComplementItem(complements[indexe]);
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
                        fontSize: 14.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    " X " + widget.produits[index].nbCmds.toString(),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: 14.0,
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
                    fontSize: 14.0,
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

  @override
  Widget build(BuildContext context) {
    return Material(
      child:  Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              HomeAppBar(),
              Expanded(child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            horizontal: PADDING_HORIZONTAL),
                        child: Text(
                          "Coordonnées de livraison",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        )),
                    getCoordonneeLivraison(
                        null,
                        "Adresse:\t\t",
                        _address,
                        "adresse de livraison",
                        TextInputType.text, onTap: (position) async {
                      Prediction p = await showGooglePlacesAutocomplete(
                          context: context,
                          apiKey: kGoogleApiKey,
                          onError: (res) {
                            print(res.errorMessage);
                          },
                          mode: Mode.overlay,
                          language: "fr",
                          components: [
                            new Component(Component.country, "fr")
                          ]);
                      if (p != null) {
                        PlacesDetailsResponse detail =
                        await _places.getDetailsByPlaceId(p.placeId);
                        setState(() {
                          _address = detail.result.formattedAddress;
                        });
                      }
                    }),
                    getCoordonneeLivraison(
                        phoneKey,
                        "Contact:\t\t",
                        widget.client.phone == null ||
                            widget.client.phone.toString() == "null"
                            ? ""
                            : widget.client.phone,
                        "contact (format international)",
                        TextInputType.phone,
                        onTap: null),
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 10.0),
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          "Articles commandés",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        )),
                    Expanded(child: getRecapCommandeSection()),
                    getPricesSection(),
                    Container(
                      margin: EdgeInsets.only(bottom: 10.0, top: 15.0),
                      child: Center(
                        child: Row(
                          children: <Widget>[
                            Expanded(child: PositionedTapDetector(
                                onTap: (position) {
                                  _submit(paymentMode: TICKET_RESTAURANT);
                                },
                                child: Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                                  padding: EdgeInsets.symmetric(vertical: 5.0),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.lightGreen,
                                          style: BorderStyle.solid,
                                          width: 1.0),
                                      color: Colors.lightGreen),
                                  child: Text("TICKET RESTAURANT",
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: new TextStyle(
                                        color: Colors.white,
                                        decoration: TextDecoration.none,
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ))),
                            Expanded(child: PositionedTapDetector(
                                onTap: (position) {
                                  _submit(paymentMode: CARTE_BANCAIRE);
                                },
                                child: Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                                  padding: EdgeInsets.symmetric(vertical: 5.0),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.lightGreen,
                                          style: BorderStyle.solid,
                                          width: 1.0),
                                      color: Colors.lightGreen),
                                  child: Text("CARTE BANCAIRE",
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: new TextStyle(
                                        color: Colors.white,
                                        decoration: TextDecoration.none,
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold,
                                      )),
                                )))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )),
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
}
