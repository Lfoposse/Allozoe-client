import 'package:client_app/DAO/Presenters/SendCommandePresenter.dart';

import '../Models/CreditCard.dart';
import 'package:client_app/Utils/AppBars.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';
import '../Paiements/AddCardScreen.dart';
import 'package:flutter/material.dart';


class CardListScreen extends StatefulWidget{

  final bool forPaiement;
  final double montantPaiement;
  final List<CreditCard> cards;

  CardListScreen({@required this.forPaiement, this.montantPaiement, this.cards});

  createState() =>  new CardListScreenState();
}


class CardListScreenState extends State<CardListScreen> implements SendCommandeContract {

  int indexSelected = 0;

  void _submit() {

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
                      child: Column(
                        children: <Widget>[
                          widget.forPaiement ? Container(
                            margin: EdgeInsets.symmetric(vertical: 25.0),
                            child: Text("Montant à payer : " + "165€",
                                style: TextStyle(
                                    fontSize: 17.0,
                                    color: Colors.lightGreen,
                                    fontWeight: FontWeight.bold)),
                          ) : Container(),
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
                                    new MaterialPageRoute(builder: (context) => AddCardScreen(forPaiement: widget.forPaiement,))).then((dynamic res){
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
                      ),
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
                            color: Colors.lightGreen),
                        child: Text("PAYER",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: new TextStyle(
                              color: Colors.white,
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
            )
          ],
        ),
      ),
    );
  }

  @override
  void onCommandError() {
    // TODO: implement onCommandError
  }

  @override
  void onCommandSuccess() {
    // TODO: implement onCommandSuccess
  }

  @override
  void onConnectionError() {
    // TODO: implement onConnectionError
  }

}