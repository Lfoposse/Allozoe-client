import '../Models/Restaurant.dart';
import 'package:flutter/material.dart';
import '../Utils/MyBehavior.dart';
import '../DAO/Presenters/RestaurantsPresenter.dart';
import '../Utils/Loading.dart';
import '../Utils/AppBars.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';
import '../RestaurantCategorizedMenus.dart';
import '../Database/DatabaseHelper.dart';
import 'package:flutter_google_places_autocomplete/flutter_google_places_autocomplete.dart';
import 'package:geolocator/geolocator.dart';
import '../StringKeys.dart';

const kGoogleApiKey = "AIzaSyBNm8cnYw5inbqzgw8LjXyt3rMhFhEVTjY";


// to get places detail (lat/lng)
GoogleMapsPlaces _places = new GoogleMapsPlaces(apiKey: kGoogleApiKey);/*kGoogleApiKey*/
final homeScaffoldKey = new GlobalKey<ScaffoldState>();
double latitude, longitude;


_showMessage(String message) {
  homeScaffoldKey.currentState
      .showSnackBar(new SnackBar(content: new Text(message)));
}


class Accueil extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new AccueilState();
}


class AccueilState extends State<Accueil> implements RestaurantContract {
  int stateIndex;
  List<Restaurant> restaurants;
  RestaurantPresenter _presenter;
  DatabaseHelper db;
  String adressName;
  bool deviceLocationMode;
  var geolocator;

  @override
  void initState() {
    super.initState();
    deviceLocationMode = true;
    geolocator = Geolocator()
      ..forceAndroidLocationManager = false;
    db = new DatabaseHelper();
    restaurants = null;
    latitude = 48.9031145;
    longitude = 2.2638343;

    var locationOptions =
    LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 100);
    geolocator.getPositionStream(locationOptions).listen((Position position) {
      if(position != null){ //  si la position n'est pas nulle
        debugPrint("updated position : lat = " + position.latitude.toString() + " long = " + position.longitude.toString());

      }
    });

    _presenter = new RestaurantPresenter(this);
    loadRestaurantNearBy();
  }


  loadRestaurantNearBy() async {

    setState(() {
      stateIndex = 0;
      adressName = "Restaurants a proximite";
      deviceLocationMode = true;
    });


    GeolocationStatus geolocationStatus = await geolocator.checkGeolocationPermissionStatus();

    if (geolocationStatus == GeolocationStatus.granted) {
      Position position = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      if (position != null) {
        debugPrint("actual position : lat = " +
            position.latitude.toString() +
            " long = " +
            position.longitude.toString()
        );
        latitude = position.latitude;
        longitude = position.longitude;
        _presenter.loadRestaurants(latitude, longitude);

      } else {
        Position pos = await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
        if (pos == null) {

          debugPrint(" actual position not found");
          _presenter.loadRestaurants(latitude, longitude);

        } else {

          debugPrint("last known position : lat = " + pos.latitude.toString() + " long = " + pos.longitude.toString());
          latitude = pos.latitude;
          longitude = pos.longitude;
          _presenter.loadRestaurants(latitude, longitude);
        }
      }

    }else{

      debugPrint("Permission de geolocation refusee");
      _presenter.loadRestaurants(latitude, longitude);
    }
  }



  void _onRetryClick() {

    setState(() {
      stateIndex = 0;
      _presenter.loadRestaurants(latitude, longitude);
    });
  }



  @override
  Widget build(BuildContext context) {

    Container getItem(itemIndex) {
      return Container(
        margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
        padding: EdgeInsets.all(10.0),
        color: Colors.white,
        height: 320.0,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: PositionedTapDetector(
                onTap: (position) {
                  // afficher la description du produit selectionner
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) =>
                          RestaurantCategorizedMenus(restaurants[itemIndex])));
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 4.0),
                  child: Image.network(
                    restaurants[itemIndex].photo,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              flex: 8,
            ),
            Expanded(
              child: Center(
                child: Container(
                  width: double.infinity,
                  child: new Text(restaurants[itemIndex].name,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: new TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.none,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),
              flex: 1,
            ),
            Expanded(
              child: Center(
                child: Container(
                  width: double.infinity,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child:
                              new Text(restaurants[itemIndex].name.toString(),
                                  textAlign: TextAlign.left,
                                  style: new TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Roboto',
                                    decoration: TextDecoration.none,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.normal,
                                  ))),
                      Container(
                        padding: EdgeInsets.only(left: 5.0, right: 5.0),
                        decoration: new BoxDecoration(
                            border: new Border.all(
                                color: Colors.lightGreen,
                                style: BorderStyle.solid,
                                width: 0.5)),
                        child: Row(
                          children: <Widget>[
                            new Text(restaurants[itemIndex].note != null ? (restaurants[itemIndex].note.rating == 0.0 ? "2.5" : restaurants[itemIndex].note.rating.toString()) : "2.5",
                                textAlign: TextAlign.left,
                                style: new TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.normal,
                                )),
                            Icon(
                              Icons.star,
                              color: Color.fromARGB(255, 255, 215, 0),
                              size: 15.0,
                            ),
                            new Text("(" + (restaurants[itemIndex].note != null ? (restaurants[itemIndex].note.count == 0 ? "10" : restaurants[itemIndex].note.count.toString()) : "10") + ")",
                                textAlign: TextAlign.left,
                                style: new TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.normal,
                                ))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              flex: 1,
            ),
          ],
        ),
      );
    }

    switch (stateIndex) {
      case 0:
        return ShowLoadingView();

      case 2:
        return ShowConnectionErrorView(_onRetryClick);

      default:
        return Scaffold(
          key: homeScaffoldKey,
          body: Column(
            children: <Widget>[
              Flexible(
                child: Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.grey)),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                          child: Stack(
                        children: <Widget>[
                          researchBox(adressName, Colors.white70,
                              Colors.black54, Colors.transparent),
                          PositionedTapDetector(
                            onTap: (position) async {
                              Prediction p = await showGooglePlacesAutocomplete(
                                  context: context,
                                  apiKey: kGoogleApiKey,
                                  onError: (res) {
                                    _showMessage(res.errorMessage);
                                  },
                                  mode: Mode.overlay,
                                  language: "fr",
                                  components: [
                                    new Component(Component.country, "fr")
                                  ]);
                              if (p != null) {
                                // get detail (lat/lng)
                                setState(() {
                                  stateIndex = 0;
                                  deviceLocationMode = false;
                                  adressName = p.description;
                                });
                                PlacesDetailsResponse detail = await _places
                                    .getDetailsByPlaceId(p.placeId);
                                latitude = detail.result.geometry.location.lat;
                                longitude = detail.result.geometry.location.lng;

                                debugPrint(p.description +
                                    " position : lat = " +
                                    latitude.toString() +
                                    " long = " +
                                    longitude.toString());

                                _presenter.loadRestaurants(latitude, longitude);
                              }
                            },
                            child: Container(
                              color: Colors.transparent,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          )
                        ],
                      )),
                      deviceLocationMode
                          ? Container()
                          : PositionedTapDetector(
                              onTap: (position) {
                                loadRestaurantNearBy();
                              },
                              child: Container(
                                  margin: EdgeInsets.only(right: 5.0),
                                  color: Colors.white,
                                  child: Icon(Icons.location_on,
                                      size: 25.0, color: Colors.lightGreen)),
                            )
                    ],
                  ),
                ),
                flex: 2,
              ),
              Flexible(
                child: stateIndex == 1
                    ? Container(
                        child: Center(
                          child: Text(
                            getLocaleText(context: context, strinKey: StringKeys.RESTAURANTS_NEARBY_NOT_FOUND),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    : Container(
                        color: Colors.black12,
                        child: ScrollConfiguration(
                          behavior: MyBehavior(),
                          child: new ListView.builder(
                              padding: EdgeInsets.all(0.0),
                              scrollDirection: Axis.vertical,
                              itemCount: restaurants.length,
                              itemBuilder: (BuildContext ctxt, int index) {
                                return getItem(index);
                              }),
                        )),
                flex: 19,
              )
            ],
          ),
        );
    }
  }


  @override
  void onConnectionError() {
    setState(() {
      stateIndex = 2;
    });
  }


  @override
  void onLoadingError() {
    setState(() {
      stateIndex = 1;
    });
  }


  @override
  void onLoadingSuccess(List<Restaurant> restaurants) {
    setState(() {
      this.restaurants = restaurants;
      stateIndex = 3;
    });
  }
}
