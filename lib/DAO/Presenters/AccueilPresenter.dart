import '../../Models/Produit.dart';
import '../Rest_dt.dart';
import '../../Models/Categorie.dart';

abstract class AccueilContract {
  void onLoadingSuccess(List<Categorie> categories);
  void onLoadingError();
  void onConnectionError();
}

class AccueilPresenter {
  AccueilContract _view;
  RestDatasource api = new RestDatasource();
  AccueilPresenter(this._view);

  loadCategorieList() {
    api.loadCategorieList().then((List<Categorie> categorieList) {
      if (categorieList != null) {
        int count = 0;
        for (int i = 0; i < categorieList.length; i++) {
          api
              .loadCategorieMenus(categorieList[i].id)
              .then((List<Produit> produits) {

            categorieList[i].produits = produits;
            count++;

            if(count == categorieList.length) _view.onLoadingSuccess(categorieList);

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
