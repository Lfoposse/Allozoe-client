
class CreditCard{

  int _id;
  String _card_number;


  CreditCard(this._id, this._card_number);

  CreditCard.empty(){
    this._id = -1;
    this._card_number = null;
  }

  CreditCard.map(dynamic obj) {

    this._id = obj["card_id"];
    this._card_number = obj["card_number"];
  }


  CreditCard copy(){

    CreditCard card = new CreditCard.empty();
    card.id = _id;
    card.card_number = _card_number;

    return card;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["card_id"] = _id;
    map["card_number"] = _card_number;
    return map;
  }


  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get card_number => _card_number;

  set card_number(String value) {
    _card_number = value;
  }


}