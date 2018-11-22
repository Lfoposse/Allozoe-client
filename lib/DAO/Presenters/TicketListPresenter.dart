import '../Rest_dt.dart';
import '../../Models/Ticket.dart';

abstract class TicketListContract {
  void onLoadingSuccess(List<Ticket> tickets);
  void onConnectionError();
}

class TicketListPresenter {
  TicketListContract _view;
  RestDatasource api = new RestDatasource();
  TicketListPresenter(this._view);


  loadClientTickets(int clientID) {
    api.loadClientTicket(clientID).then((List<Ticket> tickets) {
      _view.onLoadingSuccess(tickets);
    }).catchError((onError){
      _view.onConnectionError();
    });
  }
}