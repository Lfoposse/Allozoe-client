import '../../Models/Client.dart';
import '../Rest_dt.dart';

abstract class LogoutContract {
  void onLoginSuccess(Client client);
  void onLoginError();
  void onConnectionError();
}

class LogoutPresenter {
  LogoutContract _view;
  RestDatasource api = new RestDatasource();
  LogoutPresenter();
  Future<bool> doLogout(int livreur) {
    return api.logout(livreur).then((status) {
      return status;
    }).catchError((onError) {
      return false;
    });
  }
}
