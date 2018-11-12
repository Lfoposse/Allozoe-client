import '../Rest_dt.dart';
import '../../Models/Produit.dart';

abstract class ProductDetailContract {
  void onLoadingSuccess(Produit produit);
  void onLoadingError();
  void onConnectionError();
}

class ProductDetailPresenter {
  ProductDetailContract _view;
  RestDatasource api = new RestDatasource();
  ProductDetailPresenter(this._view);


  loadProductDetails(int productID) {
    api.loadProductDetails(productID).then((Produit produit) {
      if (produit != null)
        _view.onLoadingSuccess(produit);
      else
        _view.onLoadingError();
    }).catchError((onError){
      _view.onConnectionError();
    });
  }
}