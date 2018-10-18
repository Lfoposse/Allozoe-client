import 'package:flutter/material.dart';
import 'Utils/AppBars.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';
import 'Accueil/Accueil.dart';
import 'Accueil/Commandes.dart';
import 'Accueil/Profil.dart';
import 'Accueil/Categories.dart';
import 'Accueil/Panier.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  @override
  createState() => new HomeStateScreen();

}

class HomeStateScreen extends State<HomeScreen> {
  int space_index = 0;

  @override
  void initState(){
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  dispose(){
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  Widget getAppropriateScreen() {
    switch (space_index) {
      case 1: // zone de recherche par categorie
        return Categories();

      case 2: // zone de consultation des commandes effectuees et de leur status
        return Commandes();

      case 3: // zone de modification du profil
        return Profil();

      case 4: // Zone de consultation du panier
        return Panier();

      default: // zone d'accueil
        return Accueil();
    }
  }

  bool isSelectedButton(int index) {
    return space_index == index;
  }

  PositionedTapDetector buildButtonColumn(
      IconData icon, String label, bool selected_button, int button_index) {
    Color selected_color = Colors.lightGreen;
    Color color = Colors.black;

    return PositionedTapDetector(
        onTap: (position) {
          setState(() {
            space_index = button_index;
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: selected_button ? selected_color : color),
            Container(
              margin: const EdgeInsets.only(top: 4.0, bottom: 4.0),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400,
                  color: selected_button ? selected_color : color,
                ),
              ),
            ),
          ],
        ));
  }


  Widget researchBox(String hintText, Color bgdColor, Color textColor, Color borderColor) {
    return Container(
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
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
        Icon(Icons.search, color: textColor),
        Expanded(
            child: Container(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: TextFormField(
                    autofocus: false,
                    autocorrect: false,
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: hintText,
                        hintStyle: TextStyle(color: textColor)),
                    style: TextStyle(
                      fontSize: 12.0,
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ))))
      ]),
    );
  }

  Widget getResearchBoxIfNeeded() {
    switch (space_index) {
      case 1:
        return researchBox("Recherche par catégorie", Colors.lightGreen, Colors.white70, Colors.lightGreen); // categories
      case 2:
        return new Container();
      case 3:
        return new Container();
      case 4:
        return new Container();
      default:
        return researchBox("Recherche", Colors.white70, Colors.black12, Colors.grey); // accueil
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget buttonSection = Container(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildButtonColumn(Icons.home, 'Accueil', isSelectedButton(0), 0),
          buildButtonColumn(Icons.search, 'Recherche', isSelectedButton(1), 1),
          buildButtonColumn(Icons.shopping_cart, 'Panier', isSelectedButton(4), 4),
          buildButtonColumn(Icons.list, 'Commandes', isSelectedButton(2), 2),
          buildButtonColumn(Icons.person, 'Profil', isSelectedButton(3), 3),
        ],
      ),
    );

    return Material(
      child: Column(
        children: <Widget>[
          HomeAppBar(
            title: Text(""),
          ),
          getResearchBoxIfNeeded(),
          Expanded(
            child: getAppropriateScreen(),
          ),
          buttonSection
        ],
      ),
    );
  }
}
