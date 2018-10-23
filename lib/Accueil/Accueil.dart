import '../Models/Restaurant.dart';
import 'package:flutter/material.dart';
import '../Utils/MyBehavior.dart';
import '../DAO/Presenters/RestaurantsPresenter.dart';
import '../Utils/Loading.dart';
import '../Utils/AppBars.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';
import '../RestaurantMenusScreen.dart';
import '../Database/DatabaseHelper.dart';
import 'package:location/location.dart';

class Accueil extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new AccueilState();
}


class AccueilState extends State<Accueil> implements RestaurantContract{

  int stateIndex;
  List<Restaurant> restaurants;
  RestaurantPresenter _presenter;
  DatabaseHelper db;


  @override
  void initState() {
    db = new DatabaseHelper();
    stateIndex = 0;
    restaurants = null;
    _presenter = new RestaurantPresenter(this);
    _presenter.loadRestaurants();
    super.initState();
  }


  void _onRetryClick(){
    setState(() {
      stateIndex = 0;
      _presenter.loadRestaurants();
    });
  }


  @override
  Widget build(BuildContext context) {

    Container getItem(itemIndex) {
      return Container(
        margin: EdgeInsets.only(top : 5.0 , bottom: 5.0),
        padding: EdgeInsets.all(10.0),
        color: Colors.white,
        height: 320.0,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: PositionedTapDetector(
                onTap: (position){
                  // afficher la description du produit selectionner
                  Navigator.of(context).push(
                      new MaterialPageRoute(builder: (context) => RestaurantMenusScreen(restaurants[itemIndex], null)));

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
                  child: new Text(
                      restaurants[itemIndex].name,
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
                      Expanded(child: new Text(
                          restaurants[itemIndex].name.toString(),
                          textAlign: TextAlign.left,
                          style: new TextStyle(
                            color: Colors.black,
                            fontFamily: 'Roboto',
                            decoration: TextDecoration.none,
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                          ))
                      ),
                      //Icon(Icons.shopping_cart, color: Color.fromARGB(255, 255, 215, 0),size: 14.0, ),
                      Container(
                        padding: EdgeInsets.only(left : 5.0, right: 5.0),
                        decoration: new BoxDecoration(border: new Border.all(color: Colors.lightGreen, style: BorderStyle.solid, width: 0.5)),
                        child: Row(
                          children: <Widget>[
                            new Text("4.5",
                                textAlign: TextAlign.left,
                                style: new TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.normal,
                                )),
                            Icon(Icons.star, color: Color.fromARGB(255, 255, 215, 0),size: 15.0, ),
                            new Text("(243)",
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
//            Expanded(
//              child: Center(
//                child: Container(
//                  padding: EdgeInsets.only(top: 3.0),
//                  child: Row(
//                    mainAxisSize: MainAxisSize.min,
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: <Widget>[
//                      Container(
//                        padding: EdgeInsets.only(left : 10.0, right: 10.0),
//                        decoration: new BoxDecoration(border: new Border.all(color: Colors.lightGreen, style: BorderStyle.solid, width: 0.5)),
//                        child: new Text("5-15 min",
//                            textAlign: TextAlign.left,
//                            style: new TextStyle(
//                              color: Colors.black,
//                              decoration: TextDecoration.none,
//                              fontSize: 11.0,
//                              fontWeight: FontWeight.normal,
//                            )),
//                      ),
//                      Container(
//                        padding: EdgeInsets.only(left : 5.0, right: 5.0),
//                        decoration: new BoxDecoration(border: new Border.all(color: Colors.lightGreen, style: BorderStyle.solid, width: 0.5)),
//                        child: Row(
//                          children: <Widget>[
//                            new Text("4.5",
//                                textAlign: TextAlign.left,
//                                style: new TextStyle(
//                                  color: Colors.black,
//                                  decoration: TextDecoration.none,
//                                  fontSize: 11.0,
//                                  fontWeight: FontWeight.normal,
//                                )),
//                            Icon(Icons.star, color: Color.fromARGB(255, 255, 215, 0),size: 10.0, ),
//                            new Text("(243)",
//                                textAlign: TextAlign.left,
//                                style: new TextStyle(
//                                  color: Colors.black,
//                                  decoration: TextDecoration.none,
//                                  fontSize: 11.0,
//                                  fontWeight: FontWeight.normal,
//                                ))
//                          ],
//                        ),
//                      ),
//                      Container(
//                        padding: EdgeInsets.only(left : 10.0, right: 10.0),
//                        decoration: new BoxDecoration(border: new Border.all(color: Colors.lightGreen, style: BorderStyle.solid, width: 0.5)),
//                        child: new Text("Livraison",
//                            textAlign: TextAlign.left,
//                            style: new TextStyle(
//                              color: Colors.black,
//                              decoration: TextDecoration.none,
//                              fontSize: 11.0,
//                              fontWeight: FontWeight.normal,
//                            )),
//                      )
//
//                    ],
//                  ),
//                ),
//              ),
//              flex: 1,
//            )
          ],
        ),
      );
    }


    switch(stateIndex){

      case 0 : return ShowLoadingView();

      case 1 : return ShowLoadingErrorView(_onRetryClick);

      case 2 : return ShowConnectionErrorView(_onRetryClick);

      default : return Column(
        children: <Widget>[
          researchBox("Recherche", Colors.white70, Colors.black12, Colors.grey),
          Flexible(child: Container(
              color: Colors.black12,
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: new ListView.builder(
                    padding: EdgeInsets.all(0.0),
                    scrollDirection: Axis.vertical,
                    itemCount: restaurants.length ,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return getItem(index);
                    }),
              )))
        ],
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
