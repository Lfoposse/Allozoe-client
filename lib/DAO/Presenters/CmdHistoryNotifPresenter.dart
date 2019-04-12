import '../../Models/Commande.dart';
import '../Rest_dt.dart';

class CommandeHistoryNotifPresenter {
  RestDatasource api = new RestDatasource();

  ///commandes validees
  Future<List<Commande>> loadCmdsValide(int clientID) {
    return api.loadCommandsValide(clientID).then((List<Commande> commandes) {
      if (commandes != null)
        return commandes;
      else
        return null;
    }).catchError((onError) {
      print("Erreur historique cmd");
    });
  }

  /// commandes en cours de livraison
  Future<List<Commande>> loadCmdsLivraison(int clientID) {
    return api.loadCommandsEL(clientID).then((List<Commande> commandes) {
      if (commandes != null)
        return commandes;
      else
        return null;
    }).catchError((onError) {
      print("Erreur historique cmd");
    });
  }

  ///  commandes livrees
  Future<List<Commande>> loadCmdsLivre(int clientID) {
    return api.loadCommandsLV(clientID).then((List<Commande> commandes) {
      if (commandes != null)
        return commandes;
      else
        return null;
    }).catchError((onError) {
      print("Erreur historique cmd");
    });
  }

  Future<Commande> loadCmdDetail(int cmdID) {
    return api.loadCmdDetail(cmdID).then((Commande commande) {
      if (commande != null) {
        print('cmd detail :' + commande.toString());
        return commande;
      } else
        return null;
    }).catchError((onError) {
      print("Erreur detail cmd");
    });
  }
}
