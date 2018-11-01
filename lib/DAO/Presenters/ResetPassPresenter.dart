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

  resetPassword(int clientID, String password) {
    api.resetPass(clientID, password).then((bool resetSuccess) {
      resetSuccess ?
        _view.onResetSuccess() :
        _view.onResetError();
    }).catchError((onError){
      _view.onConnectionError();
    });
  }
}