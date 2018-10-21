import '../Rest_dt.dart';
import '../../Models/Produit.dart';

abstract class CategorieMenusContract {
  void onLoadingSuccess(List<Produit> produits);
  void onLoadingError();
  void onConnectionError();
}

class CategorieMenusPresenter {
  CategorieMenusContract _view;
  RestDatasource api = new RestDatasource();
  CategorieMenusPresenter(this._view);


  loadCategorieList(int categorieID) {
    api.loadCategorieMenus(categorieID).then((List<Produit> produits) {
      if (produits != null)
        _view.onLoadingSuccess(produits);
      else
        _view.onLoadingError();
    }).catchError((onError){
      _view.onConnectionError();
    });
  }
}