import '../Rest_dt.dart';
import '../../Models/Client.dart';

abstract class LoginContract {
  void onLoginSuccess(Client client);
  void onLoginError();
  void onConnectionError();
}

class LoginPresenter {
  LoginContract _view;
  RestDatasource api = new RestDatasource();
  LoginPresenter(this._view);

  doLogin(String username, String password, bool checkAccountExists) {
    api.login(username, password, checkAccountExists).then((Client client) {
      if (client != null)
      _view.onLoginSuccess(client);
      else
        _view.onLoginError();
    }).catchError((onError){
      _view.onConnectionError();
    });
  }
}