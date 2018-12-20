
import 'Models/Restaurant.dart';
import 'package:client_app/Utils/AppBars.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'Models/Deliver.dart';
import 'DAO/Presenters/DeliverPositionPresenter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

bool stop;

class TrackingCommandeScreen extends StatefulWidget{

  final String deliveryAdress;
  final Deliver deliver;
  final Restaurant restaurant;

  const TrackingCommandeScreen({@required this.deliveryAdress, @required this.deliver, @required this.restaurant});


  @override
  State<StatefulWidget> createState() => new TrackingCommandeScreenState();
}



class TrackingCommandeScreenState extends State<TrackingCommandeScreen> implements DeliverPositionContract{

  DeliverPositionPresenter _presenter;
  GoogleMapController mapController;
  Marker deliverMarker;

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

  void _setPosition(LatLng position, int distance){

    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0.0,
        target: position,
        tilt: 0.0,
        zoom: 17.0,
      ),
    ));

    if(deliverMarker == null)
      mapController.addMarker(MarkerOptions(position: position, infoWindowText: InfoWindowText("Deliver", distance.toString()))).then((Marker marker){
        deliverMarker = marker;
      });
    else
      mapController.updateMarker(deliverMarker, MarkerOptions(position: position, infoWindowText: InfoWindowText("Deliver", distance.toString() + " m")));
  }


  @override
  Widget build(BuildContext context) {

    return Material(
      child: Scaffold(
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
                      ),
                    )
                )
              ],
            ),
            Container(
              height: AppBar().preferredSize.height,
              child: AppBar(
                iconTheme: IconThemeData(
                  color: Colors.black, //change your color here
                ),
                backgroundColor: Colors.transparent,
                elevation: 0.0,
              ),
            )
          ],
        ),
      ),
    );
  }



  @override
  void onConnectionError() {
    if(stop) return;
    _presenter.getDeliverPosition(widget.deliver.id);
  }

  @override
  void onLoadingError() {
    if(stop) return;
    _presenter.getDeliverPosition(widget.deliver.id);
  }

  @override
  void onLoadingSuccess(Deliver deliver) async{

    if(stop) return;

    try{

      List<Placemark> placemark = await Geolocator().placemarkFromAddress(widget.deliveryAdress);

      double distance = await Geolocator().distanceBetween(placemark[0].position.latitude, placemark[0].position.longitude, deliver.lat, deliver.lng);
      _setPosition(LatLng(deliver.lat, deliver.lng), distance.truncate());

      _presenter.getDeliverPosition(widget.deliver.id);

    }catch(error){
        _presenter.getDeliverPosition(widget.deliver.id);
    }
  }
}

