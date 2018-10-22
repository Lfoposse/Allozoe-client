import '../Rest_dt.dart';
import '../../Models/Client.dart';

abstract class SignUpContract {
  void onSignUpSuccess();
  void onSignUpError();
  void onConnectionError();
}

class SignUpPresenter {
  SignUpContract _view;
  RestDatasource api = new RestDatasource();
  SignUpPresenter(this._view);

  signUp(Client client) {
    api.login("", "", false).then((Client client) {
      if (client != null)
        _view.onSignUpSuccess();
      else
        _view.onSignUpError();
    }).catchError((onError){
      _view.onConnectionError();
    });
  }
}