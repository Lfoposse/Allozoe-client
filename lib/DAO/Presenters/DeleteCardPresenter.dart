import '../Rest_dt.dart';
import 'package:flutter/material.dart';

abstract class DeleteCardContract {
  void onDeleteSuccess();
  void onDeleteError();
  void onConnectionError();
}

class DeleteCardPresenter {
  DeleteCardContract _view;
  RestDatasource api = new RestDatasource();
  DeleteCardPresenter(this._view);


  deleteCreditCard({@required int clientID, @required int card_id}) {
    api.deleteCreditCard(clientID: clientID, card_id: card_id).then((bool success) {
      if (success)
        _view.onDeleteSuccess();
      else
        _view.onDeleteError();
    }).catchError((onError){
      _view.onConnectionError();
    });
  }
}