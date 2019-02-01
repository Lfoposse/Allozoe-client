import 'dart:async';

import 'package:client_app/StringKeys.dart';
import 'package:flutter/material.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';

import '../DAO/Presenters/CommandeHistoryPresenter.dart';
import '../Database/DatabaseHelper.dart';
import '../DetailsCommande.dart';
import '../Models/Client.dart';
import '../Models/Commande.dart';
import '../Notation.dart';
import '../Utils/CommandStatusHelper.dart';
import '../Utils/Loading.dart';
import '../Utils/MyBehavior.dart';
import '../Utils/PriceFormatter.dart';

class Commandes extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new CommandesState();
}

class CommandesState extends State<Commandes>
    implements CommandeHistoryContract {
  CommandeHistoryPresenter _presenter;
  List<Commande> commandes;
  int stateIndex;
  Client client;
  List<Commande>
      searchResultCommandes; // les commandes du resultat de la recherche
  bool isSearching; // determine si une recherche est en cours ou pas
  final controller = new TextEditingController();

  @override
  void initState() {
    stateIndex = 0;
    commandes = null;
    _presenter = new CommandeHistoryPresenter(this);

    isSearching = false;
    controller.addListener(() {
      String currentText = controller.text;
      if (currentText.length > 0) {
        setState(() {
          searchResultCommandes = new List<Commande>();
          for (Commande commande in commandes) {
            // pour chaque commande
            if (commande.reference
                .toLowerCase()
                .contains(currentText.toLowerCase())) {
              // si ca commence par le texte taper
              searchResultCommandes
                  .add(commande); // l'ajouter au resultat de recherche
            }
          }
          isSearching = true;
        });
      } else {
        setState(() {
          isSearching = false;
        });
      }
    });

    DatabaseHelper().loadClient().then((Client client) {
      this.client = client;
      debugPrint("Client = " + client.toString());
      _presenter.loadCommandHistory(client.id);
    });
    super.initState();
  }

  void _onRetryClick() {
    setState(() {
      stateIndex = 0;
      _presenter.loadCommandHistory(client.id);
    });
  }

  Widget getDivider(double height, {bool horizontal}) {
    return Container(
      width: horizontal ? double.infinity : height,
      height: horizontal ? height : double.infinity,
      color: Color.fromARGB(15, 0, 0, 0),
    );
  }

  Widget researchBox(
      String hintText, Color bgdColor, Color textColor, Color borderColor) {
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
                    controller: controller,
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

  String _value = new DateTime.now().toString().substring(0, 11);
  int cliked = 2;

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2016),
        lastDate: new DateTime(2019));
    if (picked != null)
      setState(() => _value = picked.toString().substring(0, 11));
  }

  Widget getDatedBox() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: PositionedTapDetector(
            onTap: (position) {
              setState(() {
                cliked = 0;
              });

              // Todo : traiter l'action ensuite
            },
            child: Container(
              height: double.infinity,
              margin: EdgeInsets.only(right: 5.0, left: 5.0),
              decoration: BoxDecoration(
                border: Border.all(
                    color: cliked == 0 ? Colors.lightGreen : Colors.grey,
                    width: 2.0),
              ),
              child: Center(
                child: Text("Semaine",
                    style: TextStyle(
                        color: cliked == 0 ? Colors.lightGreen : Colors.black)),
              ),
            ),
          ),
          flex: 2,
        ),
        Expanded(
          child: PositionedTapDetector(
            onTap: (position) {
              setState(() {
                cliked = 1;
              });

              // Todo : traiter l'action ensuite
            },
            child: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: cliked == 1 ? Colors.lightGreen : Colors.grey,
                      width: 2.0)),
              child: Center(
                child: Text("Mois",
                    style: TextStyle(
                        color: cliked == 1 ? Colors.lightGreen : Colors.black)),
              ),
            ),
          ),
          flex: 1,
        ),
        Expanded(
          child: PositionedTapDetector(
            onTap: (position) {
              setState(() {
                cliked = 2;
              });
              _selectDate();
            },
            child: Container(
              margin: EdgeInsets.only(left: 5.0, right: 5.0),
              height: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: cliked == 2 ? Colors.lightGreen : Colors.grey,
                      width: 2.0)),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.calendar_today,
                        size: 15.0,
                        color: cliked == 2 ? Colors.lightGreen : Colors.black),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(_value,
                          style: TextStyle(
                              color: cliked == 2
                                  ? Colors.lightGreen
                                  : Colors.black)),
                    ),
                    Icon(Icons.arrow_drop_down,
                        color: cliked == 2 ? Colors.lightGreen : Colors.black)
                  ],
                ),
              ),
            ),
          ),
          flex: 3,
        ),
      ],
    );
  }

  Widget getItem(int index) {
    return PositionedTapDetector(
        onTap: (position) {
          Navigator.of(context)
              .push(new MaterialPageRoute(
                  builder: (context) => DetailsCommande(
                        commande: isSearching
                            ? searchResultCommandes[index]
                            : commandes[index],
                      )))
              .then((value) {
            setState(() {});
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            getDivider(4.0, horizontal: true),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: RichText(
                    text: new TextSpan(
                      children: [
                        new TextSpan(
                            text: getLocaleText(
                                context: context,
                                strinKey: StringKeys.COMMANDE_REF),
                            style: new TextStyle(
                              color: Colors.blue[900],
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            )),
                        new TextSpan(
                            text: isSearching
                                ? searchResultCommandes[index].reference
                                : this.commandes[index].reference,
                            style: new TextStyle(
                              color: Colors.black54,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ))
                      ],
                    ),
                  )),
                  isDelivredAndNotRated(isSearching
                          ? searchResultCommandes[index]
                          : this.commandes[index])
                      ? PositionedTapDetector(
                          onTap: (position) {
                            // Afficher la vue de notation du service de livraison recue
                            showRatingDialog(
                                    context,
                                    isSearching
                                        ? searchResultCommandes[index]
                                        : this.commandes[index])
                                .then((Null) {
                              setState(() {
                                print("commandes set State");
                              });
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 5.0),
                            padding: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              color: Colors.lightGreen,
                            ),
                            child: Text(
                              getLocaleText(
                                  context: context,
                                  strinKey: StringKeys.COMMANDE_NOTE),
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        )
                      : Container()
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                    getStatusCommandValue(
                        this.commandes[index].status, context),
                    textAlign: TextAlign.left,
                    style: new TextStyle(
                      color: getStatusCommandValueColor(isSearching
                          ? searchResultCommandes[index].status
                          : this.commandes[index].status),
                      decoration: TextDecoration.none,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    )),
                Text(
                    getLocaleText(
                            context: context,
                            strinKey: StringKeys.COMMANDE_TOTAL) +
                        PriceFormatter.formatPrice(
                            price: isSearching
                                ? searchResultCommandes[index].prix
                                : this.commandes[index].prix),
                    textAlign: TextAlign.left,
                    style: new TextStyle(
                      color: Colors.blue[900],
                      decoration: TextDecoration.none,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                      isSearching
                          ? searchResultCommandes[index].date
                          : this.commandes[index].date,
                      textAlign: TextAlign.left,
                      style: new TextStyle(
                        color: Colors.black54,
                        decoration: TextDecoration.none,
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                      )),
                  Text(
                      isSearching
                          ? searchResultCommandes[index].heure
                          : this.commandes[index].heure,
                      textAlign: TextAlign.left,
                      style: new TextStyle(
                        color: Colors.black54,
                        decoration: TextDecoration.none,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    switch (stateIndex) {
      case 0:
        return ShowLoadingView();

      case 1:
        return ShowLoadingErrorView(_onRetryClick);

      case 2:
        return ShowConnectionErrorView(_onRetryClick);

      default:
        return new Container(
            padding: EdgeInsets.symmetric(
                vertical:
                    commandes != null && commandes.length > 0 ? 5.0 : 0.0),
            color: Color.fromARGB(25, 0, 0, 0),
            child: Container(
              color: Colors.white,
              child: commandes != null && commandes.length > 0
                  ? Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 15.0),
                          child: researchBox(
                              getLocaleText(
                                  context: context,
                                  strinKey: StringKeys.COMMANDE_RECHERCHER),
                              Color.fromARGB(15, 0, 0, 0),
                              Colors.grey,
                              Colors.transparent),
                        ),
                        Expanded(
                          child: isSearching
                              ? (searchResultCommandes != null &&
                                      searchResultCommandes.length > 0)
                                  ? Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: ScrollConfiguration(
                                        behavior: MyBehavior(),
                                        child: ListView.builder(
                                            padding: EdgeInsets.all(0.0),
                                            scrollDirection: Axis.vertical,
                                            itemCount: this
                                                .searchResultCommandes
                                                .length,
                                            itemBuilder:
                                                (BuildContext ctxt, int index) {
                                              return getItem(index);
                                            }),
                                      ))
                                  : Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Text(
                                        getLocaleText(
                                            context: context,
                                            strinKey:
                                                StringKeys.COMMANDE_NOT_FOUND),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                            color: Colors.black),
                                      ))
                              : Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  child: ScrollConfiguration(
                                    behavior: MyBehavior(),
                                    child: ListView.builder(
                                        padding: EdgeInsets.all(0.0),
                                        scrollDirection: Axis.vertical,
                                        itemCount: this.commandes.length,
                                        itemBuilder:
                                            (BuildContext ctxt, int index) {
                                          return getItem(index);
                                        }),
                                  )),
                          flex: 8,
                        )
                      ],
                    )
                  : Container(
                      color: Colors.white,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(bottom: 10.0),
                              child: Icon(
                                Icons.subtitles,
                                size: 60.0,
                                color: Colors.lightGreen,
                              ),
                            ),
                            Text(
                              getLocaleText(
                                  context: context,
                                  strinKey: StringKeys.COMMANDE_VIDE),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.black),
                            )
                          ],
                        ),
                      ),
                    ),
            ));
    }
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
  void onLoadingSuccess(List<Commande> commandes) {
    setState(() {
      stateIndex = 3;
      if (commandes != null && commandes.length > 0)
        this.commandes = commandes.reversed.toList();
    });
  }
}
