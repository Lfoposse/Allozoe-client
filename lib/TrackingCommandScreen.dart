import 'package:client_app/PanierScreen.dart';
import 'package:client_app/StringKeys.dart';
import 'package:client_app/Utils/AppBars.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'DAO/Presenters/DeliverPositionPresenter.dart';
import 'Models/Deliver.dart';
import 'Models/Restaurant.dart';

bool stop;

class TrackingCommandeScreen extends StatefulWidget {
  final String deliveryAdress;
  final Deliver deliver;
  final Restaurant restaurant;

  const TrackingCommandeScreen(
      {@required this.deliveryAdress,
      @required this.deliver,
      @required this.restaurant});

  @override
  State<StatefulWidget> createState() => new TrackingCommandeScreenState();
}

class TrackingCommandeScreenState extends State<TrackingCommandeScreen>
    implements DeliverPositionContract {
  DeliverPositionPresenter _presenter;
  GoogleMapController mapController;
  Marker deliverMarker;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    stop = false;
    deliverMarker = null;
    _presenter = new DeliverPositionPresenter(this);
  }

  @override
  void dispose() {
    stop = true;
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
      _presenter.getDeliverPosition(widget.deliver.id);
    });
  }

  void _setPosition(LatLng position, int distance) {
    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0.0,
        target: position,
        tilt: 0.0,
        zoom: 11.0,
      ),
    ));

    if (deliverMarker == null)
      mapController
          .addMarker(MarkerOptions(
              position: position,
              infoWindowText: InfoWindowText(
                  getLocaleText(context: context, strinKey: StringKeys.DELIVER),
                  distance.toString())))
          .then((Marker marker) {
        deliverMarker = marker;
      });
    else
      mapController.updateMarker(
          deliverMarker,
          MarkerOptions(
              position: position,
              infoWindowText: InfoWindowText(
                  getLocaleText(context: context, strinKey: StringKeys.DELIVER),
                  distance.toString() + " m")));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                HomeAppBar(),
                Expanded(
                    child: Container(
                  color: Colors.white,
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    options: GoogleMapOptions(
                        mapType: MapType.normal,
                        trackCameraPosition: true,
                        zoomGesturesEnabled: true,
                        myLocationEnabled: true),
                  ),
                ))
              ],
            ),
            Container(
              height: AppBar().preferredSize.height + 50,
              child: AppBar(
                iconTheme: IconThemeData(
                  color: Colors.black, //change your color here
                ),
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                actions: <Widget>[
                  new IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () => panier(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget panier() {
    _scaffoldKey.currentState.showBottomSheet<Null>((BuildContext context) {
      return new Container(height: 500.0, child: PanierScreen());
    });
  }

  @override
  void onConnectionError() {
    if (stop) return;
    _presenter.getDeliverPosition(widget.deliver.id);
  }

  @override
  void onLoadingError() {
    if (stop) return;
    _presenter.getDeliverPosition(widget.deliver.id);
  }

  @override
  void onLoadingSuccess(Deliver deliver) async {
    if (stop) return;

    try {
      List<Placemark> placemark =
          await Geolocator().placemarkFromAddress(widget.deliveryAdress);

      double distance = await Geolocator().distanceBetween(
          placemark[0].position.latitude,
          placemark[0].position.longitude,
          deliver.lat,
          deliver.lng);
      _setPosition(LatLng(deliver.lat, deliver.lng), distance.truncate());

      _presenter.getDeliverPosition(widget.deliver.id);
    } catch (error) {
      _presenter.getDeliverPosition(widget.deliver.id);
    }
  }
}
