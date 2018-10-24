import '../Rest_dt.dart';

abstract class ConfirmAccountContract {
  void onConfirmSuccess();
  void onConfirmError();
  void onConnectionError();
}

class ConfirmAccountPresenter {
  ConfirmAccountContract _view;
  RestDatasource api = new RestDatasource();
  ConfirmAccountPresenter(this._view);

  confirmAccount(int clientID, String code) {
    api.confirmAccount(clientID, code).then((bool confirmed) {
      confirmed ? _view.onConfirmSuccess() : _view.onConfirmError();
    }).catchError((onError){
      _view.onConnectionError();
    });
  }
}