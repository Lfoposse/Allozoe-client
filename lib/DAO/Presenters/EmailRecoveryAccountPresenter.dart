import '../Rest_dt.dart';
import '../../Models/Client.dart';

abstract class EmailRecoveryAccountContract {
  void onLoadingSuccess(int clientID);
  void onLoadingError();
  void onConnectionError();
}

class EmailRecoveryAccountPresenter {
  EmailRecoveryAccountContract _view;
  RestDatasource api = new RestDatasource();
  EmailRecoveryAccountPresenter(this._view);

  checkAccount(String email) {
    api.emailRecoveryAccount(email).then((int clientID) {
      if (clientID > 0)
        _view.onLoadingSuccess(clientID);
      else
        _view.onLoadingError();
    }).catchError((onError){
      _view.onConnectionError();
    });
  }
}