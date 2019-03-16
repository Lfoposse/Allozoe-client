import '../../Models/Restaurant.dart';
import '../Rest_dt.dart';

abstract class CategorieRestaurantsContract {
  void onLoadingSuccess(List<Restaurant> restaurants);
  void onLoadingError();
  void onConnectionError();
}

class CategorieRestaurantsPresenter {
  CategorieRestaurantsContract _view;
  RestDatasource api = new RestDatasource();
  CategorieRestaurantsPresenter(this._view);

  loadCategorieRestaurantsList(
      int categorieID, double latitude, double longitude) {
    api
        .loadCategorieRestaurants(categorieID, latitude, longitude)
        .then((List<Restaurant> restaurants) {
      if (restaurants != null)
        _view.onLoadingSuccess(restaurants);
      else
        _view.onLoadingError();
    }).catchError((onError) {
      _view.onConnectionError();
    });
  }
}
