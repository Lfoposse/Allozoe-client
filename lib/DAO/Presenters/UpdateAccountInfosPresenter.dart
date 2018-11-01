import '../Rest_dt.dart';
import '../../Models/Client.dart';

abstract class UpdateAccountInfosContract {
  void onRequestSuccess(Client client);
  void onRequestError();
  void onConnectionError();
}

class UpdateAccountInfosPresenter {
  UpdateAccountInfosContract _view;
  RestDatasource api = new RestDatasource();
  UpdateAccountInfosPresenter(this._view);

  updateAccountDatas(Client client) {
    api.updateClient(client).then((bool success) {
      success ?
      _view.onRequestSuccess(client) :
      _view.onRequestError();
    }).catchError((onError){
      _view.onConnectionError();
    });
  }
}