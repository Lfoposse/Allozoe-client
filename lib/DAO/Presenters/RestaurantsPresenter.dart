import '../Rest_dt.dart';
import '../../Models/Restaurant.dart';

abstract class RestaurantContract {
  void onLoadingSuccess(List<Restaurant> restaurants);
  void onLoadingError();
  void onConnectionError();
}

class RestaurantPresenter {
  RestaurantContract _view;
  RestDatasource api = new RestDatasource();
  RestaurantPresenter(this._view);

  loadRestaurants() {
    api.loadRestaurants().then((List<Restaurant> restaurants) {
      if (restaurants != null)
        _view.onLoadingSuccess(restaurants);
      else
        _view.onLoadingError();
    }).catchError((onError){
      _view.onConnectionError();
    });
  }
}