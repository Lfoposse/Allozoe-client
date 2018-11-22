import '../Rest_dt.dart';
import '../../Models/Produit.dart';

abstract class SendCommandeContract {
  void onCommandSuccess(int card_id);
  void onCommandError();
  void onConnectionError();
}

class SendCommandePresenter {
  SendCommandeContract _view;
  RestDatasource api = new RestDatasource();
  SendCommandePresenter(this._view);

  commander(List<Produit> panier, String address, String phone, dynamic creditcard, dynamic ticket, int payment_mode) {
    api.commander(panier, address, phone, creditcard, ticket, payment_mode).then((int card_id) {
      card_id >= 0 ? _view.onCommandSuccess(card_id) : _view.onCommandError();
    }).catchError((onError){
      _view.onConnectionError();
    });
  }
}