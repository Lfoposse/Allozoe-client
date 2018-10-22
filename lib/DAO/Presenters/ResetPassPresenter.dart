import '../Rest_dt.dart';
import '../../Models/Client.dart';

abstract class ResetPassContract {
  void onResetSuccess();
  void onResetError();
  void onConnectionError();
}

class ResetPassPresenter {
  ResetPassContract _view;
  RestDatasource api = new RestDatasource();
  ResetPassPresenter(this._view);

  resetPassword(String password) {
    api.login("", "", false).then((Client client) {
      if (client != null)
        _view.onResetSuccess();
      else
        _view.onResetError();
    }).catchError((onError){
      _view.onConnectionError();
    });
  }
}