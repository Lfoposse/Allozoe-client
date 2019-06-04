import 'dart:async';

import '../../Models/Categorie.dart';
import '../../Models/Produit.dart';
import '../Rest_dt.dart';

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
        //categorieList.add(new Categorie(-1, "Favoris", null, null, null));
        List<Categorie> finalList = new List();
        int count = 0;
        for (int i = 0; i < categorieList.length; i++) {
          count++;
          api
              .loadRestaurantCategorieMenus(restaurantID, categorieList[i].id)
              .then((List<Produit> produits) {
            if (produits != null && produits.length > 0) {
              categorieList[i].produits = produits;
              finalList.add(categorieList[i]);
            }
            if (count == categorieList.length)
              Timer(new Duration(seconds: 2), () {
                _view.onLoadingSuccess(finalList);
              });
          });
        }
      } else
        _view.onLoadingError();
    }).catchError((onError) {
      _view.onConnectionError();
    });
  }
}
