import '../Rest_dt.dart';
import '../../Models/Client.dart';

abstract class ConfirmAccountContract {
  void onConfirmSuccess(Client client);
  void onConfirmError();
  void onConnectionError();
}

class ConfirmAccountPresenter {
  ConfirmAccountContract _view;
  RestDatasource api = new RestDatasource();
  ConfirmAccountPresenter(this._view);

  confirmAccount(int clientID, String code, bool isForPassReset) {

    if(isForPassReset) {
      api.confirmAccount(clientID, code).then((bool confirmed) {
        confirmed ? _view.onConfirmSuccess(null) : _view.onConfirmError();
      }).catchError((onError) {
        _view.onConnectionError();
      });
    }
    else {
      api.activateAccount(clientID, code).then((Client client) {
        if (client != null)
          _view.onConfirmSuccess(client);
        else
          _view.onConfirmError();

      }).catchError((onError) {
        _view.onConnectionError();
      });
    }
  }
}