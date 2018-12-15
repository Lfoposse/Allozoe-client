import '../Rest_dt.dart';

abstract class NoteContract {
  void onRequestSuccess();
  void onRequestError();
  void onConnectionError();
}

class NotePresenter {
  NoteContract _view;
  RestDatasource api = new RestDatasource();
  NotePresenter(this._view);

  noterService(int cmdID, double restauNote, double deliNote, int pourboire) {
    api.noterService(cmdID, restauNote, deliNote, pourboire).then((bool success) {
      success ?
      _view.onRequestSuccess() :
      _view.onRequestError();
    }).catchError((onError){
      _view.onConnectionError();
    });
  }
}