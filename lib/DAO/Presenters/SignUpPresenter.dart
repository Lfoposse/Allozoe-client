import '../Rest_dt.dart';
import '../../Models/Client.dart';

abstract class SignUpContract {
  void onSignUpSuccess(int clientID);
  void onSignUpError();
  void onConnectionError();
}

class SignUpPresenter {
  SignUpContract _view;
  RestDatasource api = new RestDatasource();
  SignUpPresenter(this._view);

  signUp(Client client) {
    api.signup(client).then((int clientID) {
      if (clientID > 0)
        _view.onSignUpSuccess(clientID);
      else
        _view.onSignUpError();
    }).catchError((onError){
      _view.onConnectionError();
    });
  }
}