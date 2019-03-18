import 'dart:io';

import 'package:client_app/Utils/AppSharedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';

import 'Accueil/Accueil.dart';
import 'Accueil/Categories.dart';
import 'Accueil/Commandes.dart';
import 'Accueil/LoginIfNot.dart';
import 'Accueil/Panier.dart';
import 'Accueil/Profil.dart';
import 'StringKeys.dart';
import 'Utils/AppBars.dart';

class HomeScreen extends StatefulWidget {
  @override
  createState() => new HomeStateScreen();
}

class HomeStateScreen extends State<HomeScreen> {
  int space_index = 0;
  bool isconnect = false;
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  dispose() {
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
// Ajouter pour proposer au client de se connecter ou de s'inscrire pour eviter de lui demander cela au moment de finaliser l'achat
      case 5:
        return LoginIfNot();

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

  bool _isIPhoneX(MediaQueryData mediaQuery) {
    if (Platform.isIOS) {
      var size = mediaQuery.size;
      if (size.height >= 812.0 || size.width <= 375.0) {
        return true;
      }
    }
    return true;
  }

  bool checkUser() {
    AppSharedPreferences().isAppLoggedIn().then((bool is_logged) {
      setState(() {
        isconnect = is_logged;
      });
    });
    return isconnect;
  }

  @override
  Widget build(BuildContext context) {
    var mediaQueryData = MediaQuery.of(context);
    var homeIndicatorHeight =
        // TODO verify exact values
        mediaQueryData.orientation == Orientation.portrait ? 5.0 : 8.0;

    var outer = mediaQueryData.padding;
    var bottom = !_isIPhoneX(mediaQueryData)
        ? outer.bottom
        : outer.bottom + homeIndicatorHeight;
    Widget buttonSection = Container(
      //padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      padding:
          new EdgeInsets.fromLTRB(outer.left, outer.top, outer.right, bottom),
      child: checkUser() == true
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildButtonColumn(
                    Icons.home,
                    getLocaleText(
                        context: context, strinKey: StringKeys.ACCUEIL_TITLE),
                    isSelectedButton(0),
                    0),
                buildButtonColumn(
                    Icons.search,
                    getLocaleText(
                        context: context, strinKey: StringKeys.SEARCH_TITLE),
                    isSelectedButton(1),
                    1),
                buildButtonColumn(
                    Icons.shopping_cart,
                    getLocaleText(
                        context: context, strinKey: StringKeys.CART_TITLE),
                    isSelectedButton(4),
                    4),
                buildButtonColumn(
                    Icons.list,
                    getLocaleText(
                        context: context, strinKey: StringKeys.COMMANDES_TITLE),
                    isSelectedButton(2),
                    2),
                buildButtonColumn(
                    Icons.person,
                    getLocaleText(
                        context: context, strinKey: StringKeys.PROFIL_TITLE),
                    isSelectedButton(3),
                    3),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildButtonColumn(
                    Icons.home,
                    getLocaleText(
                        context: context, strinKey: StringKeys.ACCUEIL_TITLE),
                    isSelectedButton(0),
                    0),
                buildButtonColumn(
                    Icons.search,
                    getLocaleText(
                        context: context, strinKey: StringKeys.SEARCH_TITLE),
                    isSelectedButton(1),
                    1),
                buildButtonColumn(
                    Icons.shopping_cart,
                    getLocaleText(
                        context: context, strinKey: StringKeys.CART_TITLE),
                    isSelectedButton(4),
                    4),
                buildButtonColumn(
                    Icons.person,
                    getLocaleText(
                        context: context, strinKey: StringKeys.PROFIL_TITLE),
                    isSelectedButton(5),
                    5),
              ],
            ),
    );

    return Material(
      child: Column(
        children: <Widget>[
          HomeAppBar(),
          Expanded(
            child: getAppropriateScreen(),
          ),
          buttonSection
        ],
      ),
    );
  }
}
