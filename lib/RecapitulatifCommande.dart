import 'package:client_app/Models/Google_place.dart';
import 'package:client_app/PanierScreen.dart';
import 'package:client_app/StringKeys.dart';
import 'package:client_app/Utils/AppSharedPreferences.dart';
import 'package:client_app/Utils/SearchAdresseLocation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';

import 'Database/DatabaseHelper.dart';
import 'Models/Client.dart';
import 'Models/Complement.dart';
import 'Models/CreditCard.dart';
import 'Models/Produit.dart';
import 'Paiements/CardListScreen.dart';
import 'SignInScreen.dart';
import 'Utils/AppBars.dart';
import 'Utils/MyBehavior.dart';
import 'Utils/PriceFormatter.dart';

const kGoogleApiKey = "AIzaSyBNm8cnYw5inbqzgw8LjXyt3rMhFhEVTjY";
// to get places detail (lat/lng)
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
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

class RecapitulatifCommandeState extends State<RecapitulatifCommande> {
  double PADDING_HORIZONTAL = 15.0;
  final phoneKey = new GlobalKey<FormState>();
  String _address, _phone;
  String _deliveryType = "";
  String _deliveryNote = "";
  int _radioValue = 0;
  bool isconnect = false;
  final myController = TextEditingController();
  double latitude = 48.7885281;
  double longitude = 2.5823022;
  var geolocator;
  GooglePlacesItem destinationModel = new GooglePlacesItem();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _address = "";
    geolocator = Geolocator()..forceAndroidLocationManager = false;
    super.initState();
    loadAdresseNearBy();
  }

  ///getPositon of User
  loadAdresseNearBy() async {
    GeolocationStatus geolocationStatus =
        await geolocator.checkGeolocationPermissionStatus();

    if (geolocationStatus == GeolocationStatus.granted) {
      Position position = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      if (position != null) {
        setState(() {
          latitude = position.latitude;
          longitude = position.longitude;
        });
      } else {
        Position pos = await Geolocator()
            .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
        if (pos != null) {
          setState(() {
            latitude = pos.latitude;
            longitude = pos.longitude;
          });
        }
      }
    }
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(getLocaleText(
              context: context, strinKey: StringKeys.AVERTISSEMENT)),
          content: new Text(getLocaleText(
              context: context,
              strinKey: StringKeys.DELIVERY_ADDRESS_REQUIRED)),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  bool checkUser() {
    AppSharedPreferences().isAppLoggedIn().then((bool is_logged) {
      setState(() {
        isconnect = is_logged;
      });
    });
    return isconnect;
  }

  void _submit({@required int paymentMode}) {
    phoneKey.currentState.save();

    if (_address.length == 0 || _phone.length == 0) {
      _showDialog();
    } else {
      AppSharedPreferences().isAppLoggedIn().then((bool is_logged) {
        if (is_logged) {
          new DatabaseHelper().getClientCards().then((List<CreditCard> cards) {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) => CardListScreen(
                    forPaiement: true,
                    paymentMode: paymentMode,
                    montantPaiement: getTotal(false) + widget.fraisLivraison,
                    cards: cards,
                    produits: widget.produits,
                    address: _address,
                    phone: _phone,
                    type: _deliveryType,
                    note: _deliveryNote,
                    langue: getLocaleText(
                        context: context, strinKey: StringKeys.LANGUE))));
          });
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return SignInScreen();
            },
          );
        }
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
                ? getLocaleText(
                    context: context, strinKey: StringKeys.PANIER_OFFERT)
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
                  getLocaleText(
                      context: context, strinKey: StringKeys.PANIER_SUB_TOTAL),
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
                  getLocaleText(
                      context: context,
                      strinKey: StringKeys.PANIER_FRAIS_LIVRAISON),
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
                  getLocaleText(
                      context: context, strinKey: StringKeys.PANIER_TOTAL),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                Text(
                  PriceFormatter.formatPrice(
                      price: getTotal(false) + widget.fraisLivraison),
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

  Widget getCoordonneeLivraison(key, String title, String initialValue,
      String hintText, TextInputType inputType,
      {@required void onTap(position)}) {
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
                    PriceFormatter.formatPrice(
                        price: getItemTotal(index, false)),
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

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          _deliveryType = "HOME";
          break;
        case 1:
          _deliveryType = "ON_ROAD";
          break;
      }
    });
    print(_deliveryType);
  }

  void _addNote(String note) {
    setState(() {
      _deliveryNote = note;
    });
  }

  void _dialogNote() async {
    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                autofocus: true,
                maxLines: null,
                controller: myController,
                keyboardType: TextInputType.multiline,
                decoration: new InputDecoration(
                    labelText: 'Note',
                    hintText: getLocaleText(
                        context: context, strinKey: StringKeys.ADD_NOTE)),
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: Text(getLocaleText(
                  context: context, strinKey: StringKeys.CANCEL_BTN)),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: Text(getLocaleText(
                  context: context,
                  strinKey: StringKeys.PROFILE_ACCOUNT_ENREGISTRER)),
              onPressed: () {
                setState(() {
                  _deliveryNote = myController.text;
                });
                Navigator.pop(context);
              })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: <Widget>[
          Scaffold(
            resizeToAvoidBottomPadding: false,
            key: _scaffoldKey,
            body: Column(
              children: <Widget>[
                HomeAppBar(),
                Expanded(
                    child: Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: PADDING_HORIZONTAL),
                          child: Text(
                            getLocaleText(
                                context: context,
                                strinKey: StringKeys.DELIVERY_ADDRESS),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          )),
                      getCoordonneeLivraison(
                          null,
                          getLocaleText(
                                  context: context,
                                  strinKey: StringKeys.ADDRESS) +
                              ":\t\t",
                          _address,
                          getLocaleText(
                              context: context,
                              strinKey: StringKeys.DELIVERY_ADDRESS),
                          TextInputType.text, onTap: (position) async {
                        destinationModel = await Navigator.of(context)
                            .push(new MaterialPageRoute<GooglePlacesItem>(
                                builder: (BuildContext context) {
                                  return new SearchAdressePage(
                                      latitude: latitude, longitude: longitude);
                                },
                                fullscreenDialog: true));
                        if (destinationModel != null) {
                          setState(() {
                            _address = destinationModel.terms[0].value;
                          });
                        }

//                        Prediction p = await PlacesAutocomplete.show(
//                            context: context,
//                            apiKey: kGoogleApiKey,
//                            mode: Mode.overlay, // Mode.fullscreen
//                            language: "fr",
//                            components: [
//                              new Component(Component.country, "fr")
//                            ]);
//                        if (p != null) {
//                          PlacesDetailsResponse detail =
//                              await _places.getDetailsByPlaceId(p.placeId);
//                          setState(() {
//                            _address = detail.result.formattedAddress;
//                          });
//                        }
                      }),
                      getCoordonneeLivraison(
                          phoneKey,
                          getLocaleText(
                                  context: context,
                                  strinKey: StringKeys.CONTACT) +
                              ":\t\t",
                          widget.client.phone == null ||
                                  widget.client.phone.toString() == "null"
                              ? ""
                              : widget.client.phone,
                          getLocaleText(
                              context: context,
                              strinKey: StringKeys.PHONE_NUMBER),
//                            +
//                            " (" +
//                            getLocaleText(
//                                context: context,
//                                strinKey: StringKeys.FORMAT_INTERNATIONAL) +
//                            ")"

                          TextInputType.text,
                          onTap: null),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Radio(
                              value: 0,
                              groupValue: _radioValue,
                              onChanged: _handleRadioValueChange,
                            ),
                            new Text(getLocaleText(
                                context: context,
                                strinKey: StringKeys.DELIVERY_HOME)),
                            new Radio(
                              value: 1,
                              groupValue: _radioValue,
                              onChanged: _handleRadioValueChange,
                            ),
                            new Text(getLocaleText(
                                context: context,
                                strinKey: StringKeys.DELIVERY_ROAD)),
                            new Container(
                              padding: EdgeInsets.only(right: 10.0),
                            ),
                            FloatingActionButton(
                              backgroundColor: Colors.green,
                              onPressed: _dialogNote,
                              tooltip: 'Show me the value!',
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("note"),
                                  Icon(Icons.create)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 10.0),
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text(
                            getLocaleText(
                                context: context,
                                strinKey: StringKeys.ARTICLE_COMMANDE),
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
                              Expanded(
                                  child: PositionedTapDetector(
                                      onTap: (position) {
                                        _submit(paymentMode: TICKET_RESTAURANT);
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5.0),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.lightGreen,
                                                style: BorderStyle.solid,
                                                width: 1.0),
                                            color: Colors.lightGreen),
                                        child: Text(
                                            getLocaleText(
                                                context: context,
                                                strinKey:
                                                    StringKeys.CARD_TICKET),
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            style: new TextStyle(
                                              color: Colors.white,
                                              decoration: TextDecoration.none,
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.bold,
                                            )),
                                      ))),
                              Expanded(
                                  child: PositionedTapDetector(
                                      onTap: (position) {
                                        _submit(paymentMode: CARTE_BANCAIRE);
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5.0),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.lightGreen,
                                                style: BorderStyle.solid,
                                                width: 1.0),
                                            color: Colors.lightGreen),
                                        child: Text(
                                            getLocaleText(
                                                context: context,
                                                strinKey: StringKeys.PAY),
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
}
