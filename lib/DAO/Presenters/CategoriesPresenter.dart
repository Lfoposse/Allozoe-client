
import '../Rest_dt.dart';
import '../../Models/Categorie.dart';

abstract class CategoriesContract {
  void onLoadingSuccess(List<Categorie> categories);
  void onLoadingError();
  void onConnectionError();
}

class CategoriesPresenter {
  CategoriesContract _view;
  RestDatasource api = new RestDatasource();
  CategoriesPresenter(this._view);


  loadCategorieList() {
    api.loadCategorieList().then((List<Categorie> categories) {
      if (categories != null)
      _view.onLoadingSuccess(categories);
      else
        _view.onLoadingError();
    }).catchError((onError){
      _view.onConnectionError();
    });
  }
}