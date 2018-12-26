class Note {

  int _count;
  double _rating;


  Note.empty(){
    this._count = 0;
    this._rating = 0.0;
  }

  Note(this._rating, this._count);


  Note.map(dynamic obj) {

    this._rating = obj == null ? obj : double.parse(double.parse(obj["stars"].toString()).toStringAsFixed(1));
    this._count = obj == null ? obj : obj["avis"];
  }


  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["rating"] = _rating;
    map["count"] = _count;
    return map;
  }

  double get rating => _rating;

  set rating(double value) {
    _rating = value;
  }

  int get count => _count;

  set count(int value) {
    _count = value;
  }


}