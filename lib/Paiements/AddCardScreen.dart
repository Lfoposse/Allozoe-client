import '../Database/DatabaseHelper.dart';
import '../Models/Produit.dart';
import '../Models/CreditCard.dart';
import 'package:client_app/Utils/AppBars.dart';
import 'package:flutter/material.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';
import '../DAO/Presenters/AddCardPresenter.dart';
import '../DAO/Presenters/SendCommandePresenter.dart';
import '../Models/Client.dart';

class AddCardScreen extends StatefulWidget {
  final bool forPaiement;
  final List<Produit> produits;
  final String address, phone;
  final double montantPaiement;


  AddCardScreen({@required this.forPaiement, this.montantPaiement, this.produits, this.address, this.phone});

  createState() => new AddCardScreenState();
}

class AddCardScreenState extends State<AddCardScreen> implements AddCardContract, SendCommandeContract {
  bool saveCard;
  final nameKey = new GlobalKey<FormState>();
  final numCardKey1 = new GlobalKey<FormState>();
  final numCardKey2 = new GlobalKey<FormState>();
  final numCardKey3 = new GlobalKey<FormState>();
  final numCardKey4 = new GlobalKey<FormState>();
  final expireKey = new GlobalKey<FormState>();
  final securityKey = new GlobalKey<FormState>();

  String ownerName, card1, card2, card3, card4, expireDate, security;

  bool isLoading, isCommandLoading;
  String errorMsg;
  SendCommandePresenter _presenter;

  @override
  void initState() {
    saveCard = isLoading = isCommandLoading = false;
    errorMsg = "";
    _presenter = new SendCommandePresenter(this);
    super.initState();
  }

   _submit() {

     nameKey.currentState.save();
     numCardKey1.currentState.save();
     numCardKey2.currentState.save();
     numCardKey3.currentState.save();
     numCardKey4.currentState.save();
     expireKey.currentState.save();
     securityKey.currentState.save();

     if (card1.length != 4 || card2.length != 4 || card3.length != 4 || card4.length != 4 || security.length != 3 || expireDate.length != 7) {
       setState(() {
         errorMsg = "Renseigner correctement tous les champs";
       });
     }else {

       int month, year;
       month = year = 0;
       try{

         month = int.parse(expireDate.substring(0, 2));
         year = int.parse(expireDate.substring(3));
         int.parse(card1);
         int.parse(card2);
         int.parse(card3);
         int.parse(card4);
         int.parse(security);

       }catch(onError){

         setState(() {
           errorMsg = "Renseigner correctement tous les champs";
         });
         return;
       }

       if(month < 1 || month > 31 || year < 2018){
         setState(() {
           errorMsg = "Renseigner correctement la date d'expiration";
         });
         return;
       }

       if (widget.forPaiement) {

         setState(() {
           isCommandLoading = true;
         });
         // TODO : formatter l'envoi des commandes selon les restaurants si necessaires ici
         new DatabaseHelper().loadClient().then((Client client){
           _presenter.commander(widget.produits, widget.address, widget.phone,
               {
                 "id" : 0,
                 "name" : ownerName.length == 0 ? client.username : ownerName,
                 "card_number" : card1 + card2 + card3 + card4,
                 "month" : month.toString(),
                 "year" :year.toString(),
                 "security" : security,
                 "save_card" : saveCard
               }
           );
         });


       } else {
         setState(() {
           isLoading = true;
         });

         new DatabaseHelper().loadClient().then((Client client) {
           new AddCardPresenter(this).addCreditCard(
               clientID: client.id,
               ownerName: ownerName.length == 0 ? client.username : ownerName,
               cardNumber: card1 + card2 + card3 + card4,
               month: month.toString(),
               year: year.toString(),
               security: security
           );
         });
       }
     }
  }

  Widget getAddCardForm() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            child: Text("Non du possesseur",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold)),
          ),
          Form(
              key: nameKey,
              child: TextFormField(
                  onSaved: (val) {
                    ownerName = val;
                  },
                  autofocus: false,
                  autocorrect: false,
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "Jimmy Fallon",
                  ),
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ))),
          Container(
              margin: EdgeInsets.only(top: 20.0),
              width: double.infinity,
              child: Text("Numéro de la carte",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold))),
          Row(
            children: <Widget>[
              Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Form(
                        key: numCardKey1,
                        child: TextFormField(
                            onSaved: (val) {
                              card1 = val;
                            },
                            autofocus: false,
                            autocorrect: false,
                            maxLines: 1,
                            maxLength: 4,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: "0000",
                              counterText: "",
                            ),
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ))),
                  ),
                  flex: 1),
              Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Form(
                        key: numCardKey2,
                        child: TextFormField(
                            onSaved: (val) {
                              card2 = val;
                            },
                            autofocus: false,
                            autocorrect: false,
                            maxLines: 1,
                            maxLength: 4,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: "0000",
                              counterText: "",
                            ),
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ))),
                  ),
                  flex: 1),
              Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Form(
                        key: numCardKey3,
                        child: TextFormField(
                            onSaved: (val) {
                              card3 = val;
                            },
                            autofocus: false,
                            autocorrect: false,
                            maxLines: 1,
                            maxLength: 4,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: "0000",
                              counterText: "",
                            ),
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ))),
                  ),
                  flex: 1),
              Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Form(
                        key: numCardKey4,
                        child: TextFormField(
                            onSaved: (val) {
                              card4 = val;
                            },
                            autofocus: false,
                            autocorrect: false,
                            maxLines: 1,
                            maxLength: 4,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: "0000",
                              counterText: "",
                            ),
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ))),
                  ),
                  flex: 1)
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 5.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Container(
                  margin: EdgeInsets.only(right: 15.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        child: Text("Date expiration",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.bold)),
                      ),
                      Form(
                          key: expireKey,
                          child: TextFormField(
                              onSaved: (val) {
                                expireDate = val;
                              },
                              autofocus: false,
                              autocorrect: false,
                              maxLines: 1,
                              maxLength: 7,
                              keyboardType: TextInputType.text,
                              textAlign: TextAlign.left,
                              decoration: InputDecoration(
                                hintText: "12/2035",
                                counterText: "",
                              ),
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              )))
                    ],
                  ),
                )),
                Expanded(
                    child: Container(
                  margin: EdgeInsets.only(left: 15.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        child: Text("Code CVV",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.bold)),
                      ),
                      Form(
                          key: securityKey,
                          child: TextFormField(
                              onSaved: (val) {
                                security = val;
                              },
                              autofocus: false,
                              autocorrect: false,
                              maxLines: 1,
                              maxLength: 3,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "000",
                                counterText: "",
                              ),
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              )))
                    ],
                  ),
                ))
              ],
            ),
          )
        ],
      ),
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
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        widget.forPaiement
                            ? Container(
                                margin: EdgeInsets.symmetric(vertical: 25.0),
                                child: Text("Montant à payer : " + widget.montantPaiement.toString() +"€",
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        color: Colors.lightGreen,
                                        fontWeight: FontWeight.bold)),
                              )
                            : Container(),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(bottom: 40.0, top: 20.0),
                          child: Text(
                              widget.forPaiement
                                  ? "Utilisez une nouvelle carte"
                                  : "Enregistrez une nouvelle carte",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 17.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ),
                        getAddCardForm(),
                        widget.forPaiement
                            ? Container(
                                width: double.infinity,
                                child: Row(
                                  children: <Widget>[
                                    Checkbox(
                                        activeColor: Colors.lightGreen,
                                        value: saveCard,
                                        onChanged: (bool) {
                                          setState(() {
                                            saveCard = bool;
                                          });
                                        }),
                                    Text("\t\tEnregistrer cette carte\n",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 17.0,
                                            color: Colors.lightGreen,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                              )
                            : Container(),
                        Container(
                          margin: EdgeInsets.only(top: 15.0),
                          width: double.infinity,
                          child: Text(errorMsg,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  ),
                )),
                isLoading
                    ? Container(
                      color: Colors.white,
                        padding: EdgeInsets.only(
                            left: 20.0, right: 20.0, bottom: 10.0, top: 20.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.only(
                            left: 20.0, right: 20.0, bottom: 10.0, top: 20.0),
                        color: Colors.white,
                        child: PositionedTapDetector(
                            onTap: (position){
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
                              child: Text(
                                  widget.forPaiement ? "PAYER" : "ENREGISTRER",
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: new TextStyle(
                                    color: Colors.white,
                                    decoration: TextDecoration.none,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  )),
                            )),
                      )
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

            isCommandLoading
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
  void onConnectionError() {
    errorMsg = "Échec de connexion. Vérifier votre connexion internet";
    setState(() => isLoading = false);
  }

  @override
  void onRequestError() {
    setState(() {
      isLoading= false;
      errorMsg = "Erreur survénue. Réessayez SVP";
    });
  }

  @override
  void onRequestSuccess(CreditCard card) {

    new DatabaseHelper().addCard(card);
    setState(() {
      errorMsg = "";
      isLoading = false;
    });
    Navigator.pop(context, card);
  }

  @override
  void onCommandError() {
    setState(() {
      isCommandLoading = false;
      errorMsg = "Erreur survénue. Réessayez SVP";
    });
  }

  @override
  void onCommandSuccess(int cardID) {

    if(saveCard && cardID > 0){ // enregistrer la carte si necessaire
      new DatabaseHelper().addCard(CreditCard(cardID, card1 + card2 + card3 + card4));
    }
    new DatabaseHelper().clearPanier(); // vide la panier

    setState(() {
      isCommandLoading = false;
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
                Navigator.of(context).pop(); // rentre a la liste des cartes
                Navigator.of(context).pop(); // rentre au recapitulatif
                Navigator.of(context).pop(); // rentre au panier
              },
            )
          ],
        );
      },
    );
  }
}
