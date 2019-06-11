class GooglePlacesItemTerm {
  int offset;
  String value;

  GooglePlacesItemTerm({this.offset, this.value});

  factory GooglePlacesItemTerm.fromJson(Map<String, dynamic> json) {
    return GooglePlacesItemTerm(
      offset: json['offset'],
      value: json['value'],
    );
  }
}

class GooglePlacesItem {
  String description;
  String id;
  String place_id;
  String reference;
  List<GooglePlacesItemTerm> terms;

  GooglePlacesItem(
      {this.description, this.id, this.place_id, this.reference, this.terms});

  factory GooglePlacesItem.fromJson(Map<String, dynamic> json) {
    return GooglePlacesItem(
      description: json["description"],
      id: json["id"],
      place_id: json["place_id"],
      reference: json["reference"],
      terms: (json['terms'] as List)
          ?.map((e) => e == null
              ? null
              : GooglePlacesItemTerm.fromJson(e as Map<String, dynamic>))
          ?.toList(),
    );
  }
}

class GooglePlacesModel {
  String status;
  List<GooglePlacesItem> predictions;

  GooglePlacesModel({this.status, this.predictions});

  factory GooglePlacesModel.fromJson(Map<String, dynamic> json) {
    return GooglePlacesModel(
      status: json["status"],
      predictions: (json['predictions'] as List)
          ?.map((e) => e == null
              ? null
              : GooglePlacesItem.fromJson(e as Map<String, dynamic>))
          ?.toList(),
    );
  }
}

class LocationModel {
  double lat;
  double lng;

  LocationModel({this.lat, this.lng});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      lat: json["lat"],
      lng: json["lng"],
    );
  }
}
