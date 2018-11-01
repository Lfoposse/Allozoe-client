import 'package:flutter/material.dart';
import 'Models/Produit.dart';
import 'Utils/AppBars.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';
import 'Utils/MyBehavior.dart';
import 'DAO/Presenters/SendCommandePresenter.dart';
import 'Database/DatabaseHelper.dart';


class RecapitulatifCommande extends StatefulWidget {
  final List<Produit> produits;
  final double fraisLivraison;
  RecapitulatifCommande(
      {@required this.produits, @required this.fraisLivraison});

  @override
  State<StatefulWidget> createState() => new RecapitulatifCommandeState();
}

class RecapitulatifCommandeState extends State<RecapitulatifCommande>
    implements SendCommandeContract{
  double PADDING_HORIZONTAL = 15.0;
  final adressKey = new GlobalKey<FormState>();
  final phoneKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  SendCommandePresenter _presenter;

  bool isLoading;
  String _address, _phone;


  @override
  void initState() {
    isLoading = false;
    _presenter = new SendCommandePresenter(this);
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

  void _submit() {
    adressKey.currentState.save();
    phoneKey.currentState.save();

    if (_address.length == 0 || _phone.length == 0) {
      _showDialog();
    } else {
      setState(() {
        isLoading = true;
      });
      _presenter.commander(widget.produits, _address, _phone);
    }
  }

  Widget getDivider(double height, {bool horizontal}) {
    return Container(
      width: horizontal ? double.infinity : height,
      height: horizontal ? height : double.infinity,
      color: Color.fromARGB(15, 0, 0, 0),
    );
  }

  Widget getItem(int index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: PADDING_HORIZONTAL + 10.0),
      child: Column(
        children: <Widget>[
          Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                widget.produits[index].name,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    widget.produits[index].prix.toString() + "€",
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    " X " + widget.produits[index].nbCmds.toString(),
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
                (widget.produits[index].prix * widget.produits[index].nbCmds)
                    .truncateToDouble()
                    .toString() + "€",
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

  Widget getPricesSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 10.0),
          padding: EdgeInsets.symmetric(horizontal: PADDING_HORIZONTAL),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Sous-total",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                Text(
                  getTotalProduits().truncateToDouble().toString() + "€",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                )
              ]),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: PADDING_HORIZONTAL),
          margin: EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Frais livraison",
                  style: TextStyle(
                      color: Colors.black38,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                Text(
                  widget.fraisLivraison.toString() + "€",
                  style: TextStyle(
                      color: Colors.black38,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                )
              ]),
        ),
        getDivider(2.0, horizontal: true),
        Container(
          padding: EdgeInsets.symmetric(horizontal: PADDING_HORIZONTAL),
          margin: EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Total",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                Text(
                  (getTotalProduits() + widget.fraisLivraison)
                      .truncateToDouble()
                      .toString() + "€",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                )
              ]),
        ),
      ],
    );
  }

  double getTotalProduits() {
    double total = 0.0;
    for (int i = 0; i < widget.produits.length; i++) {
      total = total + widget.produits[i].prix * widget.produits[i].nbCmds;
    }
    return total.truncateToDouble();
  }

  Widget getCoordonneeLivraison(key, String title, String initialValue,
      String hintText, TextInputType inputType) {
    return Container(
      color: Colors.black12,
      margin: EdgeInsets.symmetric(vertical: 3.0),
      padding: EdgeInsets.only(
          left: PADDING_HORIZONTAL + 20.0,
          right: PADDING_HORIZONTAL,
          top: 3.0,
          bottom: 3.0),
      child: Row(
        children: <Widget>[
          Text(title,
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold)),
          Expanded(
            child: Form(
                key: key,
                child: TextFormField(
                    onSaved: (val) {
                      if (key == adressKey)
                        _address = val;
                      else if (key == phoneKey) _phone = val;
                    },
                    textAlign: TextAlign.left,
                    initialValue: initialValue,
                    autofocus: false,
                    autocorrect: false,
                    maxLines: 1,
                    keyboardType: inputType,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: hintText,
                        hintStyle: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold)),
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold))),
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
          itemCount: widget.produits.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return getItem(index);
          }),
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
                            "Coordonnées de livraison",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 26.0,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          )),
                      getCoordonneeLivraison(
                          adressKey,
                          "Adresse:\t\t",
                          "Paris, Rue 405",
                          "Entrer l\'adresse de livraison",
                          TextInputType.text),
                      getCoordonneeLivraison(
                          phoneKey,
                          "Contact:\t\t",
                          "+33356987412",
                          "Enter le contact à appeller",
                          TextInputType.phone),
                      Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 10.0),
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text(
                            "Articles commandés",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 26.0,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          )),
                      Expanded(child: getRecapCommandeSection()),
                      getPricesSection(),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: PADDING_HORIZONTAL),
                        margin: EdgeInsets.only(bottom: 15.0, top: 10.0),
                        child: Center(
                          child: PositionedTapDetector(
                              onTap: (position) {
                                _submit();
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: 15.0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.lightGreen,
                                        style: BorderStyle.solid,
                                        width: 1.0),
                                    color: Colors.lightGreen),
                                child: Text("PAIEMENT",
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
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
            ),
            isLoading
                ? Container(
                    color: Colors.black26,
                    width: double.infinity,
                    height: double.infinity,
                    child: Center(
                      child: new CircularProgressIndicator(),
                    ),
                  )
                : IgnorePointer(ignoring: true)
          ],
        ),
      ),
    );
  }

  @override
  void onCommandError() {
    setState(() {
      isLoading = false;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Echec"),
          content: new Text(
              "La commande n'a pas etre effectuee. Une erreur est survenue. \n\n Reessayez SVP."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Reessayer"),
              onPressed: () {
                Navigator.of(context).pop();
                _submit();
              },
            ),

            new FlatButton(
              child: new Text("Annuler"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  void onCommandSuccess() {
    setState(() {
      isLoading = false;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Succes"),
          content: new Text(
              "Votre commande a ete enregistree avec succes.\n\nVous pouvez suivre son traitrement depuis l'espace commande"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Compris"),
              onPressed: () {
                Navigator.of(context).pop();
                new DatabaseHelper().clearPanier();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  void onConnectionError() {
    setState(() {
      isLoading = false;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Echec de connexion"),
          content: new Text(
              "Aucune connexion a internet. Verifier votre connexion a internet et reessayez."),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),

          ],
        );
      },
    );
  }
}
