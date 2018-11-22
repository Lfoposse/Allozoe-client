import 'dart:async';

import 'package:flutter/services.dart';

import 'Models/Restaurant.dart';
import 'package:client_app/Utils/AppBars.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'Models/Deliver.dart';
import 'DAO/Presenters/DeliverPositionPresenter.dart';


class TrackingCommandeScreen extends StatefulWidget{

  final String deliveryAdress;
  final Deliver deliver;
  final Restaurant restaurant;

  const TrackingCommandeScreen({@required this.deliveryAdress, @required this.deliver, @required this.restaurant});


  @override
  State<StatefulWidget> createState() => new TrackingCommandeScreenState();
}



class TrackingCommandeScreenState extends State<TrackingCommandeScreen> implements DeliverPositionContract{

  double percent;
  int temps, distance;
  DeliverPositionPresenter _presenter;
  bool firstCheck; // determine si la recherche initiale a deja ete effectue avec succes ou pas
  int stateIndex;
  bool stop;

  @override
  void initState() {
    super.initState();

    firstCheck = true;
    stop = false;
    stateIndex = 0;
    percent = 0.0;
    temps = 0;
    distance = 0;
    _presenter = new DeliverPositionPresenter(this);
    _presenter.getDeliverPosition(widget.deliver.id);

    SystemChannels.lifecycle.setMessageHandler((msg){
      if(msg == AppLifecycleState.suspending) setState(() {
        stop = true;
      });
    });
  }

  Widget getInfos(String title, String value) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 10.0),
      padding: EdgeInsets.only(
          left: 15.0,
          right: 15.0
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(title,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold)),
          Container(
            margin: EdgeInsets.only(top: 10.0),
            child: Text(value,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }


  Widget getAppropriateView(){
    switch(stateIndex){

      case 3 : {
        return Text(
            ((percent)*100).ceil().toString() + "% \n Effectuée",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 26.0,
              fontWeight: FontWeight.bold,
              color: Colors.black
          ),
        );
      }

      case 0 : {
        return Container(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(),
                ),
                Text("Calcul en cours",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0
                  ),)
              ],
            ),
          ),
        );
      }

      default: {
        return Container(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: RaisedButton(
                      onPressed: (){
                        setState(() {
                          stateIndex = 0;
                          _presenter.getDeliverPosition(widget.deliver.id);
                        });
                      },
                      color: Colors.transparent,
                      elevation: 0.0,
                      child: Icon(Icons.refresh, size: 50.0, color: Colors.blue,)
                  ),
                ),
                Text("Réessayer svp!",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0
                  ),)
              ],
            ),
          ),
        );
      }
    }

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
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(15.0),
                            child: Text(
                              "Statistiques sur le traitement et le délai de livraison de votre commande",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 22.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(child: Container(
                            child: Center(
                              child: CircularPercentIndicator(
                                radius: 200.0,
                                fillColor: Colors.white,
                                lineWidth: 20.0,
                                percent: percent,
                                center: getAppropriateView(),
                                progressColor: Colors.green,
                                backgroundColor: Colors.black38,
                              ),
                            ),
                          ), flex: 3,),
                          Expanded(child: Container(
                            child: Center(
                              child: getInfos("Livraison dans environ : ", stateIndex != 3 ? "Estimation en cours" : temps.toString() + " min"),
                            ),
                          ), flex: 1,),
                          Expanded(child: Container(
                            child: Center(
                              child: getInfos("Proximité du livreur : ", stateIndex != 3 ? "Estimation en cours" :( distance == 0 ? "Au lieu de livraison" : "Environ " + distance.toString() + " m")),
                            ),
                          ), flex: 1,),
                          Expanded(child: Container(), flex: 1,)
                        ],
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

    if(firstCheck){
      setState(() {
        stateIndex = 2;
      });
    }else
      _presenter.getDeliverPosition(widget.deliver.id);
  }

  @override
  void onLoadingError() {
    if(stop) return;

    if(firstCheck){
      setState(() {
        stateIndex = 1;
      });
    }else
      _presenter.getDeliverPosition(widget.deliver.id);
  }

  @override
  void onLoadingSuccess(Deliver deliver) async{

    if(stop) return;

    try{
      List<Placemark> placemark = await Geolocator().placemarkFromAddress(widget.deliveryAdress);

      double originalDistance = await Geolocator().distanceBetween(placemark[0].position.latitude, placemark[0].position.longitude, widget.restaurant.latitude, widget.restaurant.longitude);
      double distanceInMeters = await Geolocator().distanceBetween(placemark[0].position.latitude, placemark[0].position.longitude, deliver.lat, deliver.lng);

//      // santa lucia
//      double deliv_lat = 4.092629;
//      double deliv_lng = 9.746420;
//
//      // bureau
//      double res_lat = 4.0922813;
//      double res_lng = 9.748298;
//
//      double originalDistance = await Geolocator().distanceBetween(deliv_lat, deliv_lng, res_lat, res_lng);
//      double distanceInMeters = await Geolocator().distanceBetween(deliv_lat, deliv_lng, deliver.lat, deliver.lng);

      setState(() {
        distance = distanceInMeters.truncate();
        temps = (distanceInMeters / 60).truncate();

        percent =  distanceInMeters > originalDistance ? 0 : 1 - (distanceInMeters / originalDistance);
      });

      print("dis = " + distanceInMeters.toString());
      print("tot = " + originalDistance.toString());
      print("percent = " + percent.toString());

      if(firstCheck) setState(() { // si c'est le resultat de la recherche initiale
        stateIndex = 3;
        firstCheck = false; // on signale que l'etape de recherche initiale a ete traversee
      });
      _presenter.getDeliverPosition(widget.deliver.id);

    }catch(error){
      if(firstCheck){
        setState(() {
          stateIndex = 1;
        });
      }else
        _presenter.getDeliverPosition(widget.deliver.id);
    }



  }
}

