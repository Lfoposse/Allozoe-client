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

  commander(List<Produit> panier, String address, String phone, dynamic creditcard, dynamic ticket, int payment_mode, bool newCard) {
    api.commander(panier, address, phone, creditcard, ticket, payment_mode, newCard).then((bool success) {
      success ? _view.onCommandSuccess() : _view.onCommandError();
    }).catchError((onError){
      _view.onConnectionError();
    });
  }
}