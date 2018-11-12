import 'Models/Categorie.dart';
import 'package:flutter/material.dart';
import 'Utils/MyBehavior.dart';
import 'DAO/Presenters/RestaurantsCategorizedMenusPresenter.dart';
import 'Utils/Loading.dart';
import 'Utils/AppBars.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';
import 'ProductDetailScreen.dart';
import 'Models/Restaurant.dart';
import 'Database/DatabaseHelper.dart';
import 'Models/Produit.dart';

class RestaurantCategorizedMenus extends StatefulWidget {

  final Restaurant restaurant;
  RestaurantCategorizedMenus(this.restaurant);

  @override
  State<StatefulWidget> createState() => new RestaurantCategorizedMenusState();
}


class RestaurantCategorizedMenusState extends State<RestaurantCategorizedMenus> implements RestaurantCategorizedMenusContract{

  int stateIndex;
  List<Categorie> categories;
  RestaurantCategorizedMenusPresenter _presenter;
  DatabaseHelper db;


  @override
  void initState() {
    stateIndex = 0;
    db = new DatabaseHelper();
    categories = null;
    _presenter = new RestaurantCategorizedMenusPresenter(this);
    _presenter.loadCategorieList(widget.restaurant.id);
    super.initState();
  }


  void _onRetryClick(){
    setState(() {
      stateIndex = 0;
      _presenter.loadCategorieList(widget.restaurant.id);
    });
  }


  @override
  Widget build(BuildContext context) {

    Container getItem(int sectionIndex, itemIndex) {
      return Container(
        margin: EdgeInsets.only(right: 10.0),
        padding: EdgeInsets.all(8.0),
        //color:  db.isInCart(categories[sectionIndex].produits[itemIndex]) ? Colors.black12 : Colors.white,
        width: 230.0,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: PositionedTapDetector(
                onTap: (position){
                  // afficher la description du produit selectionner
                  Navigator.of(context).push(
                      new MaterialPageRoute(builder: (context) => ProductDetailScreen(categories[sectionIndex].produits[itemIndex])));

                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 4.0),
                  child: Image.network(
                    categories[sectionIndex].produits[itemIndex].photo,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              flex: 7,
            ),
            Expanded(
              child: Center(
                child: Container(
                  width: double.infinity,
                  child: new Text(
                      categories[sectionIndex].produits[itemIndex].name,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: new TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.none,
                        fontSize: 14.0,
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
                          categories[sectionIndex].produits[itemIndex].prix.toString()+ "€",
                          textAlign: TextAlign.left,
                          style: new TextStyle(
                            color: Colors.black,
                            fontFamily: 'Roboto',
                            decoration: TextDecoration.none,
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                          ))
                      ),
                      FutureBuilder(
                        future: db.getProduit(categories[sectionIndex].produits[itemIndex].id),
                        builder: (BuildContext context, AsyncSnapshot snapshot ){

                          if(snapshot.hasData){
                            Produit prod = snapshot.data;
                            return prod.id > 0 ? Icon(Icons.shopping_cart, color: Color.fromARGB(255, 255, 215, 0),size: 20.0):Container();
                          }else return Container();
                        }
                      )
                    ],
                  ),
                ),
              ),
              flex: 1,
            ),
            Expanded(
              child: Center(
                child: Container(
                  padding: EdgeInsets.only(top: 3.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left : 10.0, right: 10.0),
                        decoration: new BoxDecoration(border: new Border.all(color: Colors.lightGreen, style: BorderStyle.solid, width: 0.5)),
                        child: new Text("5-15 min",
                            textAlign: TextAlign.left,
                            style: new TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.none,
                              fontSize: 11.0,
                              fontWeight: FontWeight.normal,
                            )),
                      ),
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
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.normal,
                                )),
                            Icon(Icons.star, color: Color.fromARGB(255, 255, 215, 0),size: 10.0, ),
                            new Text("(243)",
                                textAlign: TextAlign.left,
                                style: new TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.normal,
                                ))
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left : 10.0, right: 10.0),
                        decoration: new BoxDecoration(border: new Border.all(color: Colors.lightGreen, style: BorderStyle.solid, width: 0.5)),
                        child: new Text("Livraison",
                            textAlign: TextAlign.left,
                            style: new TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.none,
                              fontSize: 11.0,
                              fontWeight: FontWeight.normal,
                            )),
                      )

                    ],
                  ),
                ),
              ),
              flex: 1,
            )
          ],
        ),
      );
    }

    Container getSection(int sectionIndex) {

      return Container(
        height: 300.0,
        padding: EdgeInsets.only(top: 5.0, left: 10.0, bottom: 5.0),
        color: Color.fromARGB(200, 255, 255, 255),
        margin: EdgeInsets.only(bottom: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 5.0),
              child: new Text(
                categories[sectionIndex].name,
                textAlign: TextAlign.left,
                style: new TextStyle(
                  color: Colors.black,
                  decoration: TextDecoration.none,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: new ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories[sectionIndex].produits == null ? 0 : categories[sectionIndex].produits.length,
                    itemBuilder: (BuildContext ctxt, int itemIndex) {
                      return getItem(sectionIndex, itemIndex);
                    }),
              ),
            )
          ],
        ),
      );
    }

    Widget getAppropriateScene(){

      switch(stateIndex){

        case 0 : return ShowLoadingView();

        case 1 : return ShowLoadingErrorView(_onRetryClick);

        case 2 : return ShowConnectionErrorView(_onRetryClick);

        default :
          return Column(
            children: <Widget>[
              researchBox("Recherche", Colors.white70, Colors.black54, Colors.transparent),
              Flexible(child: Container(
                  color: Colors.black12,
                  child: ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: new ListView.builder(
                        padding: EdgeInsets.all(0.0),
                        scrollDirection: Axis.vertical,
                        itemCount: categories.length ,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return getSection(index);
                        }),
                  )))
            ],
          );
      }

    }

    return Material(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              HomeAppBar(),
              Expanded(
                child: getAppropriateScene(),
              ),
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
    );

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
  void onLoadingSuccess(List<Categorie> categoriesList) {
    setState(() {
      this.categories = categoriesList;
      stateIndex = 3;
    });
  }

}
