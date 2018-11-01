import '../Rest_dt.dart';
import '../../Models/Produit.dart';
import '../../Models/Commande.dart';

abstract class OrderDetailContract {
  void onLoadingSuccess(List<Produit> produits);
  void onLoadingError();
  void onConnectionError();
}

class OrderDetailPresenter {
  OrderDetailContract _view;
  RestDatasource api = new RestDatasource();
  OrderDetailPresenter(this._view);


  loadOrderDetails(Commande commande) {
    api.loadOrderDetails(commande).then((List<Produit> produits) {
      if (produits != null)
        _view.onLoadingSuccess(produits);
      else
        _view.onLoadingError();
    }).catchError((onError){
      _view.onConnectionError();
    });
  }
}