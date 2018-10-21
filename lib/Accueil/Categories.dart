import 'package:flutter/material.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';
import '../Utils/Loading.dart';
import '../Models/Categorie.dart';
import '../DAO/Presenters/CategoriesPresenter.dart';
import '../Utils/AppBars.dart';
import '../CategorieMenusScreen.dart';


class Categories extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new CategoriesState();
}

class CategoriesState extends State<Categories> implements CategoriesContract{

  int stateIndex;
  List<Categorie> categories;
  CategoriesPresenter _presenter;


  @override
  void initState() {
    stateIndex = 0;
    categories = null;
    _presenter = new CategoriesPresenter(this);
    _presenter.loadCategorieList();
  }

  PositionedTapDetector getItem(int index) {
    return PositionedTapDetector(
      onTap: (position){
        // afficher la liste des menus de cette categorie
        Navigator.of(context).push(
            new MaterialPageRoute(builder: (context) => CategorieMenusScreen(categories[index])));
      },
      child: Container(
        padding: EdgeInsets.only(right: 8.0, bottom: 8.0),
        color: Colors.white,
        width: 200.0,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Stack(
                children: <Widget>[
                  Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          color: Colors.white,
                          image: new DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(categories[index].photo),
                          )
                      )
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 5.0, right: 5.0),
                      child: Text(categories[index].name,
                          style: TextStyle(
                            color: Colors.lightGreen,
                            decoration: TextDecoration.none,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  )
                ],
              ),
              flex: 7,
            ),
          ],
        ),
      ),
    );
  }

  Container getSection() {

    return Container(
      padding: EdgeInsets.only(top: 10.0, left: 5.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 10.0),
            child: new Text(
              "Nos différentes catégories",
              textAlign: TextAlign.left,
              style: new TextStyle(
                color: Colors.black,
                decoration: TextDecoration.none,
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: GridView.builder(
                padding: EdgeInsets.all(0.0),
                itemCount: categories.length,
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (BuildContext context, int index) {
                  return getItem(index);
                }),
          )
        ],
      ),
    );
  }

  void _onRetryClick(){
    setState(() {
      stateIndex = 0;
      _presenter.loadCategorieList();
    });
  }

  @override
  Widget build(BuildContext context) {



    switch(stateIndex){

      case 0 : return ShowLoadingView();

      case 1 : return ShowLoadingErrorView(_onRetryClick);

      case 2 : return ShowConnectionErrorView(_onRetryClick);

      default : return Column(
        children: <Widget>[
          researchBox("Recherche par catégorie", Colors.lightGreen, Colors.white70, Colors.lightGreen),
          Flexible(
            child: Container(
                color: Colors.white,
                child:  getSection()
            ),
          )
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
  void onLoadingSuccess(List<Categorie> categories) {
    setState(() {
      this.categories = categories;
      stateIndex = 3;
    });
  }
}
