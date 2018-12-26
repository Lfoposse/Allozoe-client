import 'package:client_app/Models/Client.dart';

import '../DAO/Presenters/SendCommandePresenter.dart';
import '../Database/DatabaseHelper.dart';
import '../Models/Produit.dart';

import '../Models/CreditCard.dart';
import 'package:client_app/Utils/AppBars.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';
import 'package:flutter/material.dart';
import '../Utils/PriceFormatter.dart';
import 'package:stripe_payment/stripe_payment.dart';
import '../DAO/Presenters/AddCardPresenter.dart';

class CardListScreen extends StatefulWidget {
  final bool forPaiement;
  final double montantPaiement;
  List<CreditCard> cards;
  final List<Produit> produits;
  final String address, phone;
  final int paymentMode;

  CardListScreen(
      {@required this.forPaiement,
      this.montantPaiement,
      this.cards,
      this.produits,
      this.address,
      this.phone,
      this.paymentMode});

  createState() => new CardListScreenState();
}

class CardListScreenState extends State<CardListScreen>
    implements SendCommandeContract, AddCardContract {
  int indexSelected;
  bool isLoading;
  int paiementModeIndex; // 1 = carte bancaire et 2 = ticket restaurant
  String paiementModeName;
  SendCommandePresenter _presenter;
  List<DropdownMenuItem<String>> _dropDownMenuItems;

  final montantKey = new GlobalKey<FormState>();
  String _montant;

  @override
  void initState() {
    super.initState();
    paiementModeIndex = widget.paymentMode;
    _dropDownMenuItems = getDropDownMenuItems();
    paiementModeName = _dropDownMenuItems[paiementModeIndex == 1 ? 0 : 1].value;
    indexSelected = 0;
    isLoading = false;
    _presenter = new SendCommandePresenter(this);
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    List _paymentModes = ["Carte Bancaire", "Ticket Restaurant"];
    for (String paymentMode in _paymentModes) {
      items.add(new DropdownMenuItem(
          value: paymentMode, child: new Text(paymentMode)));
    }
    return items;
  }

  void changedDropDownItem(String paymentMode) {
    setState(() {
      paiementModeIndex = paymentMode == "Carte Bancaire" ? 1 : 2;
      paiementModeName = paymentMode;
      if (paymentMode != "Carte Bancaire") indexSelected = 0;
    });
  }

  void _showDialog(String title) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Avertissement"),
          content: new Text(title),
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
    double prix = 0.0;

    if (paiementModeIndex == 2) {
      montantKey.currentState.save();

      if (_montant.length == 0) {
        _showDialog("Vous devez fournir le montant du ticket");
        return;
      }

      try {
        prix = double.parse(_montant);
      } catch (error) {
        _showDialog("montant invalide");
        return;
      }

      if (prix < widget.montantPaiement) {
        _showDialog(
            "Votre ticket restaurant est insuffisant pour payer votre commande");
        return;
      }

    }else if(paiementModeIndex == 1){

      if(widget.cards == null || widget.cards.length == 0){
        return;
      }
    }



    setState(() {
      isLoading = true;
    });

    // TODO : formatter l'envoi des commandes selon les restaurants si necessaires ici
    _presenter.commander(
        widget.produits,
        widget.address,
        widget.phone,
        {"id": paiementModeIndex == 1 ? widget.cards[indexSelected].id : -1},
        {
          "id": -1,
          "value": paiementModeIndex == 2 ? double.parse(_montant) : 0.0
        },
        paiementModeIndex,
      false
    );
  }

  Widget getCardItem(int index) {
    return Container(
      height: 60.0,
      margin: EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.0),
      ),
      padding:
          EdgeInsets.only(left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.credit_card,
            size: 30.0,
          ),
          Expanded(
              child: Container(
            margin: EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              "Numero de la carte \n" + "**** **** **** " + widget.cards[index].card_number,
              style: TextStyle(fontSize: 16.0),
            ),
          )),
          widget.forPaiement
              ? PositionedTapDetector(
                  onTap: (position) {
                    setState(() {
                      indexSelected = index;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: indexSelected == index
                            ? Colors.lightGreen
                            : Colors.transparent,
                        border: Border.all(color: Colors.grey, width: 1.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: indexSelected == index
                          ? Icon(
                              Icons.check,
                              size: 10.0,
                              color: Colors.white,
                            )
                          : Icon(
                              Icons.check_box_outline_blank,
                              size: 10.0,
                              color: Colors.transparent,
                            ),
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  Widget getCardPaiementContent() {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: 10.0, bottom: 5.0),
          child: Text(
              widget.cards == null || widget.cards.length == 0
                  ? "Aucune carte de paiement enregistrée"
                  : (widget.forPaiement
                      ? "Sélectionnez la carte"
                      : "Vos cartes de paiement"),
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 17.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),
        ),
        widget.cards != null && widget.cards.length > 0
            ? Flexible(
                child: SingleChildScrollView(
                  child: ListView.builder(
                      padding: EdgeInsets.all(0.0),
                      itemCount: widget.cards.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return getCardItem(index);
                      }),
                ),
              )
            : Container(),
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 5.0),
          margin: EdgeInsets.only(bottom: 20.0),
          child: PositionedTapDetector(
            onTap: (position) {

              StripeSource.setPublishableKey(
                  apiKey: "pk_live_eo4MYvhD0gazKbeMzchjmrSU");
              StripeSource.addSource().then((String token) {
                print(token); //your stripe card source token

                setState(() {
                  isLoading = true;
                });

                if(widget.forPaiement){

                  new DatabaseHelper().loadClient().then((Client client) {
                    _presenter.commander(
                        widget.produits,
                        widget.address,
                        widget.phone,
                        {
                          "id": 0,
                          "token_stripe" : token
                        },
                        {
                          "id": -1,
                        },
                        1,
                      true
                    );
                  });

                }else{

                  new DatabaseHelper().loadClient().then((Client client) {
                    new AddCardPresenter(this).addCreditCard(
                        clientID: client.id,
                        token_stripe: token
                    );
                  });
                }

              });
            },
            child: Text(widget.forPaiement? "+ Utiliser une nouvelle carte" : "+ Ajouter une nouvelle carte",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 17.0,
                    color: Colors.lightGreen,
                    fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget getTicketPaiementContent() {
    return ListView(
      children: <Widget>[
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 20.0),
          child: Text("Entrer le montant de votre ticket",
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 17.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),
        ),
        Container(
            padding: EdgeInsets.only(top: 15.0, bottom: 20.0),
            child: Form(
                key: montantKey,
                child: TextFormField(
                    onSaved: (val) {
                      _montant = val;
                    },
                    textAlign: TextAlign.left,
                    autofocus: false,
                    autocorrect: false,
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        contentPadding: new EdgeInsets.all(0.0),
                        //border: InputBorder.none,
                        hintText: "Montant du ticket",
                        hintStyle: TextStyle(
                            fontSize: 13.0,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold)),
                    style: TextStyle(
                        fontSize: 13.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold))))
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
                widget.forPaiement
                    ? Container(
                        color: Colors.white,
                        padding: EdgeInsets.only(top: 20.0),
                        width: double.infinity,
                        child: Text(
                            "Montant à payer : " +
                                PriceFormatter.formatPrice(
                                    price: widget.montantPaiement),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 17.0,
                                color: Colors.lightGreen,
                                fontWeight: FontWeight.bold)),
                      )
                    : Container(),
                widget.forPaiement
                    ? Container(
                        width: double.infinity,
                        color: Colors.white,
                        child: Center(
                          child: DropdownButton(
                            value: paiementModeName,
                            items: _dropDownMenuItems,
                            onChanged: changedDropDownItem,
                          ),
                        ),
                      )
                    : Container(),
                Expanded(
                    child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: paiementModeIndex == 1
                      ? getCardPaiementContent()
                      : getTicketPaiementContent(),
                )),
                widget.forPaiement
                    ? Container(
                        padding: EdgeInsets.only(
                            left: 20.0, right: 20.0, bottom: 10.0),
                        color: Colors.white,
                        child: PositionedTapDetector(
                            onTap: (position) {
                              _submit();
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.lightGreen,
                                      style: BorderStyle.solid,
                                      width: 1.0),
                                  color: paiementModeIndex == 1 && (widget.cards == null || widget.cards.length == 0) ? Colors.black38 : Colors.lightGreen),
                              child: Text("PAYER",
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: new TextStyle(
                                    color: paiementModeIndex == 1 && (widget.cards == null || widget.cards.length == 0) ? Colors.black54 : Colors.white,
                                    decoration: TextDecoration.none,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  )),
                            )),
                      )
                    : Container()
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
    new DatabaseHelper().clearPanier(); // vide la panier

    new DatabaseHelper().getClientCards().then((List<CreditCard> cards){

      widget.cards = cards;
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
                  Navigator.of(context).pop(); // ferme le dialogue
                  Navigator.of(context).pop(); // rentre au recapitulatif
                  Navigator.of(context).pop(); // rentre au panier
                },
              )
            ],
          );
        },
      );
    });

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

  @override
  void onRequestError() {
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
              "Erreur survenue. \n\n Reessayez SVP."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Compris"),
              onPressed: () {
                Navigator.of(context).pop();
                _submit();
              },
            )
          ],
        );
      },
    );
  }

  @override
  void onRequestSuccess() {

    new DatabaseHelper().getClientCards().then((List<CreditCard> cards){
      widget.cards = cards;
      setState(() {
        isLoading = false;
      });

    });
  }
}
