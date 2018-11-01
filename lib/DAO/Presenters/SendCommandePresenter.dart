import '../Rest_dt.dart';
import '../../Models/Produit.dart';

abstract class SendCommandeContract {
  void onCommandSuccess();
  void onCommandError();
  void onConnectionError();
}

class SendCommandePresenter {
  SendCommandeContract _view;
  RestDatasource api = new RestDatasource();
  SendCommandePresenter(this._view);

  commander(List<Produit> panier, String address, String phone) {
    api.commander(panier, address, phone).then((bool confirmed) {
      confirmed ? _view.onCommandSuccess() : _view.onCommandError();
    }).catchError((onError){
      _view.onConnectionError();
    });
  }
}