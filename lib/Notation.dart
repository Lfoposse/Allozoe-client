import 'package:client_app/StringKeys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';

import 'DAO/Presenters/NotePresenter.dart';
import 'Models/Commande.dart';

Future<Null> showRatingDialog(BuildContext context, Commande commande) async {
  return showDialog<Null>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.all(5.0),
        content: RateDelivery(commande),
      );
    },
  );
}

class RateDelivery extends StatefulWidget {
  @override
  final Commande commande;

  const RateDelivery(this.commande);
  RateDeliveryState createState() => new RateDeliveryState();
}

class RateDeliveryState extends State<RateDelivery> implements NoteContract {
  double deliverRating, restauRating;
  int starCount;
  bool isDeliverAlreadyRated;
  NotePresenter _presenter;
  int stateIndex;
  bool isSearching;

  final pourboireKey = new GlobalKey<FormState>();
  String _pourboire;

  @override
  void initState() {
    super.initState();

    deliverRating = restauRating = 3.5;
    starCount = 5;
    isDeliverAlreadyRated = false;
    _pourboire = 1.toString();
    _presenter = new NotePresenter(this);
    stateIndex = 0;
    isSearching = false;
  }

  void _showDialog(String title) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(getLocaleText(
              context: context, strinKey: StringKeys.AVERTISSEMENT)),
          content: new Text(title),
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

  void _submit() {
    if (!isDeliverAlreadyRated) {
      //pourboireKey.currentState.save();

      try {
        int.parse(_pourboire);
      } catch (error) {
        _showDialog(getLocaleText(
            context: context, strinKey: StringKeys.CARD_AMOUNT_INVALIDE));
        return;
      }

      setState(() {
        isDeliverAlreadyRated = true;
      });
    } else {
      setState(() {
        isSearching = true;
      });
      _presenter.noterService(widget.commande.id, restauRating, deliverRating,
          int.parse(_pourboire));
    }
  }

  Widget getPourboireContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
              getLocaleText(
                  context: context, strinKey: StringKeys.COMMANDE_POURBOIRE),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),
        ),
        Container(
            padding: EdgeInsets.only(top: 5.0),
            margin: EdgeInsets.symmetric(horizontal: 50.0),
            child: Form(
                key: pourboireKey,
                child: TextFormField(
                    onSaved: (val) {
                      _pourboire = val;
                    },
                    initialValue: _pourboire,
                    textAlign: TextAlign.center,
                    autofocus: false,
                    autocorrect: false,
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        contentPadding: new EdgeInsets.all(0.0),
                        //border: InputBorder.none,
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
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 10.0),
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: <Widget>[
                PositionedTapDetector(
                  onTap: (position) {
                    if (isDeliverAlreadyRated) {
                      setState(() {
                        isDeliverAlreadyRated = false;
                      });
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Icon(
                    Icons.backspace,
                    size: 20.0,
                    color: Colors.black,
                  ),
                ),
                Expanded(
                  child: Text(
                    isDeliverAlreadyRated
                        ? getLocaleText(
                            context: context,
                            strinKey: StringKeys.COMMANDE_NOTE_LIVREUR)
                        : getLocaleText(
                            context: context,
                            strinKey: StringKeys.COMMANDE_NOTE_RESTAURANT),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 5.0, top: 25.0),
            child: Text(
              "Note : " +
                  (isDeliverAlreadyRated ? restauRating : deliverRating)
                      .toString(),
              style: new TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
            ),
          ),
          new Padding(
            padding: new EdgeInsets.only(
              bottom: 20.0,
            ),
            child: new StarRating(
              size: 25.0,
              rating: isDeliverAlreadyRated ? restauRating : deliverRating,
              color: Colors.orange,
              borderColor: Colors.grey,
              starCount: starCount,
              onRatingChanged: (rating) => setState(
                    () {
                      if (isDeliverAlreadyRated) {
                        this.restauRating = rating;
                      } else {
                        this.deliverRating = rating;
                      }
                    },
                  ),
            ),
          ),
          //!isDeliverAlreadyRated ? getPourboireContent() :
          Container(),
          isSearching
              ? Container(
                  margin: EdgeInsets.symmetric(vertical: 15.0),
                  child: Center(
                    child: new CircularProgressIndicator(),
                  ),
                )
              : PositionedTapDetector(
                  onTap: (position) {
                    _submit();
                  },
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    margin: EdgeInsets.only(bottom: 10.0, top: 20.0),
                    decoration: BoxDecoration(
                        color: Colors.lightGreen,
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: Text(
                      isDeliverAlreadyRated
                          ? getLocaleText(
                              context: context,
                              strinKey: StringKeys.COMMANDE_NOTE_ENVOYER)
                          : getLocaleText(
                              context: context,
                              strinKey: StringKeys.COMMANDE_NOTE_SUIVANT),
                      style: new TextStyle(fontSize: 15.0, color: Colors.white),
                    ),
                  ),
                )
        ],
      ),
    );
  }

  @override
  void onConnectionError() {
    setState(() {
      isSearching = false;
    });
    _showDialog(getLocaleText(
        context: context, strinKey: StringKeys.ERROR_CONNECTION_FAILED));
  }

  @override
  void onRequestError() {
    setState(() {
      isSearching = false;
    });
    _showDialog(
        getLocaleText(context: context, strinKey: StringKeys.ERROR_OCCURED));
  }

  @override
  void onRequestSuccess() {
    widget.commande.dejaNoter = true;
    setState(() {
      isSearching = false;
    });
    Navigator.of(context).pop();
    _showDialog(
        getLocaleText(context: context, strinKey: StringKeys.COMMANDE_NOTE_OK));
  }
}
