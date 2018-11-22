import '../Models/Ticket.dart';

import '../DAO/Presenters/SendCommandePresenter.dart';
import '../Database/DatabaseHelper.dart';
import '../Models/Produit.dart';

import '../Models/CreditCard.dart';
import 'package:client_app/Utils/AppBars.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';
import '../Paiements/AddCardScreen.dart';
import 'package:flutter/material.dart';
import '../Utils/PriceFormatter.dart';
import '../DAO/Presenters/TicketListPresenter.dart';
import '../Models/Client.dart';
import '../Utils/PriceFormatter.dart';


class CardListScreen extends StatefulWidget{

  final bool forPaiement;
  final double montantPaiement;
  final List<CreditCard> cards;
  final List<Produit> produits;
  final String address, phone;

  CardListScreen({@required this.forPaiement, this.montantPaiement, this.cards, this.produits, this.address, this.phone});

  createState() =>  new CardListScreenState();
}


class CardListScreenState extends State<CardListScreen> implements SendCommandeContract, TicketListContract {

  int indexSelected, selectedTicket;
  bool isLoading, ticketLoading;
  int paiementModeIndex; // 1 = carte bancaire et 2 = ticket restaurant
  String paiementModeName;
  SendCommandePresenter _presenter;
  TicketListPresenter _ticketPresenter;
  List<DropdownMenuItem<String>> _dropDownMenuItems;

  List<Ticket> tickets;

  @override
  void initState() {
    super.initState();
    tickets = null;
    paiementModeIndex = 1;
    _dropDownMenuItems = getDropDownMenuItems();
    paiementModeName = _dropDownMenuItems[0].value;
    indexSelected = selectedTicket = 0;
    isLoading = false;
    ticketLoading = false;
    _presenter = new SendCommandePresenter(this);
    _ticketPresenter = new TicketListPresenter(this);
  }


  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    List _paymentModes = ["Carte Bancaire", "Ticket Restaurant"];
    for (String paymentMode in _paymentModes) {
      items.add(new DropdownMenuItem(
          value: paymentMode,
          child: new Text(paymentMode)
      ));
    }
    return items;
  }

  void changedDropDownItem(String paymentMode) {
    setState(() {
      paiementModeIndex = paymentMode == "Carte Bancaire" ? 1 : 2;
      paiementModeName = paymentMode;
      if(paymentMode != "Carte Bancaire") {
        indexSelected = 0;
        ticketLoading = true;
        new DatabaseHelper().loadClient().then((Client client) {
          _ticketPresenter.loadClientTickets(client.id);
        });
      }else{
        selectedTicket = 0;
      }
    });
  }


  void _submit() {

    if(paiementModeIndex == 2 && (tickets == null || tickets.length == 0)) return;

    setState(() {
      isLoading = true;
    });

    // TODO : formatter l'envoi des commandes selon les restaurants si necessaires ici
    _presenter.commander(widget.produits, widget.address, widget.phone,
        {
          "id": paiementModeIndex == 1 ? widget.cards[indexSelected].id : -1
        },
      {
        "id" : paiementModeIndex == 1 ? -1 : tickets[selectedTicket].id
      },
      paiementModeIndex
    );
  }

  Widget getCardItem(int index){

    return Container(
      height: 60.0,
      margin: EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.0),
      ),
      padding: EdgeInsets.only(left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
      child: Row(
        children: <Widget>[
          Icon(Icons.credit_card, size: 30.0,),
          Expanded(child: Container(
            margin: EdgeInsets.symmetric(horizontal: 15.0),
            child: Text("Numero de la carte \n" + widget.cards[index].card_number,
              style: TextStyle(
                fontSize: 16.0
              ),
            ),
          )),
          widget.forPaiement ? PositionedTapDetector(
            onTap: (position){
              setState(() {
                indexSelected = index;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: indexSelected == index ? Colors.lightGreen : Colors.transparent,
                  border: Border.all(color: Colors.grey, width: 1.0)
              ),
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
          ) : Container()
        ],
      ),
    );
  }


  Widget getCardPaiementContent(){

    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 20.0),
          child: Text(widget.cards == null || widget.cards.length == 0 ? "Aucune carte de paiement enregistrée" : (widget.forPaiement ? "Sélectionnez la carte" : "Vos cartes de paiement"),
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 17.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),
        ),
        widget.cards != null && widget.cards.length > 0 ? Flexible(
          child: SingleChildScrollView(
            child: ListView.builder(
                padding: EdgeInsets.all(0.0),
                itemCount: widget.cards.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index){
                  return getCardItem(index);
                }
            ),
          ),
        ) : Container(),
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 15.0, bottom: 20.0),
          child: PositionedTapDetector(
            onTap: (position){
              Navigator.of(context).push(
                  new MaterialPageRoute(builder: (context) => AddCardScreen(
                    forPaiement: widget.forPaiement,
                    montantPaiement: widget.montantPaiement,
                    produits: widget.produits,
                    address: widget.address,
                    phone: widget.phone,
                  ))
              ).then((dynamic res){
                if(res != null) widget.cards.insert(0, res as CreditCard);
                setState(() {});
              });
            },
            child: Text("+ Ajouter une nouvelle carte",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 17.0,
                    color: Colors.lightGreen,
                    fontWeight: FontWeight.bold)) ,
          ),
        ),

      ],
    );
  }


  Widget getTicketItem(int index){

    return Container(
      height: 60.0,
      margin: EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey, width: 1.0)
        ),
      ),
      padding: EdgeInsets.only(left: 20.0, right: 10.0, top: 10.0),
      child: Row(
        children: <Widget>[
          Icon(Icons.restaurant, size: 30.0,),
          Expanded(child: Container(
            margin: EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 5.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(tickets[index].restaurant.name,
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.bold
                            )
                        ),
                      ),
                      Text(PriceFormatter.formatPrice(price: tickets[index].amount),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.lightGreen,
                              fontWeight: FontWeight.bold
                          )
                      )
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: Text(tickets[index].code,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 16.0
                      )),
                )
              ],
            ),
          )),
          widget.forPaiement ? PositionedTapDetector(
            onTap: (position){
              setState(() {
                selectedTicket = index;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selectedTicket == index ? Colors.lightGreen : Colors.transparent,
                  border: Border.all(color: Colors.grey, width: 1.0)
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: selectedTicket == index
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
          ) : Container()
        ],
      ),
    );
  }


  Widget getTicketPaiementContent(){

    return
      ticketLoading ? Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CircularProgressIndicator(),
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: Text("chargement de vos tickets restaurant",
                  textAlign: TextAlign.center,
                  style: TextStyle(

                  ),
                ),
              )
            ],
          ),
        ),
      ) :
    (tickets == null || tickets.length == 0 ? Container(
      child: Center(
        child: Text(
        "Vous ne disposez d'aucun ticket restaurant\n" +
            (widget.forPaiement ? "Selectionner un autre moyen de paiement pour finaliser votre commande" : ""),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold
        ))
      ),
    ) :
    Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 20.0),
          child: Text(widget.forPaiement ? "Sélectionnez le ticket a utiliser" : "Liste de vos tickets restaurants",
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 17.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),
        ),
        Container(
          padding: EdgeInsets.only(top: 15.0, bottom: 20.0),
          child: SingleChildScrollView(
            child: ListView.builder(
                padding: EdgeInsets.all(0.0),
                itemCount: tickets.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index){
                  return getTicketItem(index);
                }
            ),
          )
        ),

      ],
    )
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
                widget.forPaiement ? Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 25.0),
                  width: double.infinity,
                  child: Text("Montant à payer : " + PriceFormatter.formatPrice(price: widget.montantPaiement),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 17.0,
                          color: Colors.lightGreen,
                          fontWeight: FontWeight.bold)),
                ) : Container(),
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Center(
                    child: DropdownButton(
                      value: paiementModeName,
                      items: _dropDownMenuItems,
                      onChanged: changedDropDownItem,
                    ),
                  ),
                ),
                Expanded(
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                      child: paiementModeIndex == 1 ? getCardPaiementContent() : getTicketPaiementContent(),
                    )
                ),
                widget.forPaiement ? Container(
                  padding: EdgeInsets.only(left : 20.0, right: 20.0, bottom: 10.0, top: 20.0),
                  color: Colors.white,
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
                            color: paiementModeIndex == 2 && (tickets == null || tickets.length == 0) ? Colors.grey : Colors.lightGreen),
                        child: Text("PAYER",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: new TextStyle(
                              color: paiementModeIndex == 2 && (tickets == null || tickets.length == 0) ? Colors.blueGrey : Colors.white,
                              decoration: TextDecoration.none,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            )),
                      )),
                ): Container()
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
  void onCommandSuccess(int cardID) {

    new DatabaseHelper().clearPanier(); // vide la panier

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
  }

  @override
  void onConnectionError() {
    setState(() {
      isLoading = ticketLoading = false;
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
  void onLoadingSuccess(List<Ticket> tickets) {

    this.tickets = tickets;
    setState(() {
      ticketLoading = false;
    });
  }

}