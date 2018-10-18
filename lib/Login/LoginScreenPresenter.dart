import '../DAO/Rest_dt.dart';
import '../Models/Client.dart';

abstract class LoginScreenContract {
  void onLoginSuccess(Client client);
  void onLoginError(String errorTxt);
  void onConnectionError();
}

class LoginScreenPresenter {
  LoginScreenContract _view;
  RestDatasource api = new RestDatasource();
  LoginScreenPresenter(this._view);

  doLogin(String username, String password, bool checkAccountExists) {
    api.login(username, password, checkAccountExists, _view).then((Client client) {
      if (client != null)
      _view.onLoginSuccess(client);
      else
        _view.onLoginError("");
    }).catchError((onError){
      _view.onConnectionError();
    });
  }
}