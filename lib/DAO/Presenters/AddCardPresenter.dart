import '../Rest_dt.dart';
import 'package:flutter/material.dart';

abstract class AddCardContract {
  void onRequestSuccess();
  void onRequestError();
  void onConnectionError();
}

class AddCardPresenter {
  AddCardContract _view;
  RestDatasource api = new RestDatasource();
  AddCardPresenter(this._view);


  addCreditCard({@required int clientID, @required String token_stripe}) {
    api.addCreditCard(clientID: clientID, token_stripe: token_stripe).then((bool success) {
      if (success)
        _view.onRequestSuccess();
      else
        _view.onRequestError();
    }).catchError((onError){
      _view.onConnectionError();
    });
  }
}