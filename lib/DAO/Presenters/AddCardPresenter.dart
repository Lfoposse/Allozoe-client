import '../Rest_dt.dart';
import 'package:flutter/material.dart';
import '../../Models/CreditCard.dart';

abstract class AddCardContract {
  void onRequestSuccess(CreditCard card);
  void onRequestError();
  void onConnectionError();
}

class AddCardPresenter {
  AddCardContract _view;
  RestDatasource api = new RestDatasource();
  AddCardPresenter(this._view);


  addCreditCard({@required int clientID, @required String ownerName, @required String cardNumber, @required String month, @required String year, @required String security}) {
    api.addCreditCard(clientID: clientID, ownerName: ownerName, cardNumber: cardNumber, month: month, year: year, security: security).then((int cardID) {
      if (cardID != -1)
        _view.onRequestSuccess(CreditCard(cardID, cardNumber));
      else
        _view.onRequestError();
    }).catchError((onError){
      _view.onConnectionError();
    });
  }
}