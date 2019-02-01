import 'package:client_app/StringKeys.dart';
import 'package:flutter/material.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';

import '../CategorieRestaurantsScreen.dart';
import '../DAO/Presenters/CategoriesPresenter.dart';
import '../Models/Categorie.dart';
import '../Utils/Loading.dart';

class Categories extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new CategoriesState();
}

class CategoriesState extends State<Categories> implements CategoriesContract {
  int stateIndex;
  List<Categorie> categories;
  CategoriesPresenter _presenter;

  bool isSearching; // determine si une recherche est en cours ou pas
  List<Categorie> searchResult;
  final controller = new TextEditingController();

  @override
  void initState() {
    stateIndex = 0;
    _presenter = new CategoriesPresenter(this);
    _presenter.loadCategorieList();

    isSearching = false;
    controller.addListener(() {
      String currentText = controller.text;
      if (currentText.length > 0) {
        setState(() {
          searchResult = new List<Categorie>();
          for (Categorie categorie in categories) {
            // pour chaque commande
            if (categorie.name
                .toLowerCase()
                .contains(currentText.toLowerCase())) {
              // si ca commence par le texte taper
              searchResult.add(categorie); // l'ajouter au resultat de recherche
            }
          }
          isSearching = true;
        });
      } else {
        setState(() {
          isSearching = false;
        });
      }
    });
    super.initState();
  }

  Widget getItem(int index) {
    return PositionedTapDetector(
      onTap: (position) {
        // afficher la liste des menus de cette categorie
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (context) => CategorieRestaurantssScreen(
                isSearching ? searchResult[index] : categories[index])));
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
                          image: NetworkImage(isSearching
                              ? searchResult[index].photo
                              : categories[index].photo),
                        )),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          color: Color.fromARGB(100, 0, 0, 0)),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 5.0, right: 5.0),
                      child: Text(
                          isSearching
                              ? searchResult[index].name
                              : categories[index].name,
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.none,
                            fontSize: 16.0,
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
              getLocaleText(
                  context: context,
                  strinKey: StringKeys.CATEGORY_DIFF_CATEGORY),
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
                itemCount:
                    isSearching ? searchResult.length : categories.length,
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

  void _onRetryClick() {
    setState(() {
      stateIndex = 0;
      _presenter.loadCategorieList();
    });
  }

  Widget researchBox(
      String hintText, Color bgdColor, Color textColor, Color borderColor) {
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      decoration: new BoxDecoration(
          color: bgdColor,
          border: new Border(
            top: BorderSide(
                color: borderColor, style: BorderStyle.solid, width: 1.0),
            bottom: BorderSide(
                color: borderColor, style: BorderStyle.solid, width: 1.0),
            left: BorderSide(
                color: borderColor, style: BorderStyle.solid, width: 1.5),
            right: BorderSide(
                color: borderColor, style: BorderStyle.solid, width: 1.5),
          )),
      child: Row(children: [
        Icon(
          Icons.search,
          color: textColor,
          size: 30.0,
        ),
        Expanded(
            child: Container(
                child: TextFormField(
                    autofocus: false,
                    autocorrect: false,
                    maxLines: 1,
                    controller: controller,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: hintText,
                        hintStyle: TextStyle(color: textColor)),
                    style: TextStyle(
                      fontSize: 16.0,
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ))))
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (stateIndex) {
      case 0:
        return ShowLoadingView();

      case 1:
        return ShowLoadingErrorView(_onRetryClick);

      case 2:
        return ShowConnectionErrorView(_onRetryClick);

      default:
        return Column(
          children: <Widget>[
            researchBox(
                getLocaleText(
                    context: context, strinKey: StringKeys.CATEGORY_SEARCH),
                Colors.lightGreen,
                Colors.white70,
                Colors.lightGreen),
            Flexible(
              child: Container(color: Colors.white, child: getSection()),
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
