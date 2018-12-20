import '../../Models/Produit.dart';
import '../Rest_dt.dart';
import '../../Models/Categorie.dart';

abstract class RestaurantCategorizedMenusContract {
  void onLoadingSuccess(List<Categorie> categories);
  void onLoadingError();
  void onConnectionError();
}

class RestaurantCategorizedMenusPresenter {
  RestaurantCategorizedMenusContract _view;
  RestDatasource api = new RestDatasource();
  RestaurantCategorizedMenusPresenter(this._view);

  loadCategorieList(int restaurantID) {
    api.loadCategorieList().then((List<Categorie> categorieList) {
      if (categorieList != null) {
        List<Categorie> finalList = new List();
        int count = 0;

        for (int i = 0; i < categorieList.length; i++) {
          api
              .loadRestaurantCategorieMenus(restaurantID, categorieList[i].id)
              .then((List<Produit> produits) {

            if(produits != null && produits.length > 0) {
              categorieList[i].produits = produits;
              finalList.add(categorieList[i]);
            }
            count++;

            if(count == categorieList.length) _view.onLoadingSuccess(finalList);

          }).catchError((onError) {
            _view.onConnectionError();
          });
        }



      } else
        _view.onLoadingError();
    }).catchError((onError) {
      _view.onConnectionError();
    });
  }
}
