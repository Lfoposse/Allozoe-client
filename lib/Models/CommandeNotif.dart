class CommandeNotif {
  int _commande_id;
  int _restaurant_id;
  int _status_id;

  CommandeNotif(this._commande_id, this._restaurant_id, this._status_id);

  int get commande_id => _commande_id;
  int get restaurant_id => _restaurant_id;
  int get status_id => _status_id;

  set commande_id(int value) {
    _commande_id = value;
  }

  set restaurant_id(int value) {
    _restaurant_id = value;
  }

  set status_id(int value) {
    _status_id = value;
  }
}

class CommandeShipp {
  int _commande_id;
  int _restaurant_id;
  int _status_id;

  CommandeShipp(this._commande_id, this._restaurant_id, this._status_id);

  int get commande_id => _commande_id;
  int get restaurant_id => _restaurant_id;
  int get status_id => _status_id;

  set commande_id(int value) {
    _commande_id = value;
  }

  set restaurant_id(int value) {
    _restaurant_id = value;
  }

  set status_id(int value) {
    _status_id = value;
  }
}

class CommandeLivre {
  int _commande_id;
  int _restaurant_id;
  int _status_id;

  CommandeLivre(this._commande_id, this._restaurant_id, this._status_id);

  int get commande_id => _commande_id;
  int get restaurant_id => _restaurant_id;
  int get status_id => _status_id;

  set commande_id(int value) {
    _commande_id = value;
  }

  set restaurant_id(int value) {
    _restaurant_id = value;
  }

  set status_id(int value) {
    _status_id = value;
  }
}
