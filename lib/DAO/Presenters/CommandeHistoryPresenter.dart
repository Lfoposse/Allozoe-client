import '../../Models/Commande.dart';
import '../Rest_dt.dart';

abstract class CommandeHistoryContract {
  void onLoadingSuccess(List<Commande> commande);
  void onLoadingError();
  void onConnectionError();
}

class CommandeHistoryPresenter {
  CommandeHistoryContract _view;
  RestDatasource api = new RestDatasource();
  CommandeHistoryPresenter(this._view);


  loadCommandHistory(int clientID) {
    api.loadCommandsHistory(clientID).then((List<Commande> commandes) {
        _view.onLoadingSuccess(commandes);
    }).catchError((onError){
      _view.onConnectionError();
    });
  }
}