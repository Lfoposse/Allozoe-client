import '../Rest_dt.dart';
import '../../Models/Deliver.dart';

abstract class DeliverPositionContract {
  void onLoadingSuccess(Deliver deliver);
  void onLoadingError();
  void onConnectionError();
}

class DeliverPositionPresenter {
  DeliverPositionContract _view;
  RestDatasource api = new RestDatasource();
  DeliverPositionPresenter(this._view);

  getDeliverPosition(int deliverID) {
    api.loadDeliverPosition(deliverID).then((Deliver deliver) {

      if (deliver != null)
        _view.onLoadingSuccess(deliver);
      else
        _view.onLoadingError();

    }).catchError((onError){
      _view.onConnectionError();
    });
  }
}