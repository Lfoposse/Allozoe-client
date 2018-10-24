import '../Rest_dt.dart';
import '../../Models/Produit.dart';

abstract class RestaurantMenusContract {
  void onLoadingSuccess(List<Produit> produits);
  void onLoadingError();
  void onConnectionError();
}

class RestaurantMenusPresenter {
  RestaurantMenusContract _view;
  RestDatasource api = new RestDatasource();
  RestaurantMenusPresenter(this._view);


  loadRestaurantCategorieMenusList(int restaurantID, int categorieID) {
    api.loadRestaurantCategorieMenus(restaurantID, categorieID).then((List<Produit> produits) {
      if (produits != null)
        _view.onLoadingSuccess(produits);
      else
        _view.onLoadingError();
    }).catchError((onError){
      _view.onConnectionError();
    });
  }
}