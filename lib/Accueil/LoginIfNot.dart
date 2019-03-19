import 'package:client_app/SignInScreen.dart';
import 'package:client_app/StringKeys.dart';
import 'package:flutter/material.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';

class LoginIfNot extends StatefulWidget {
  @override
  createState() => new LoginIfNotState();
}

class LoginIfNotState extends State<LoginIfNot> {
  int index = -1;

  Color setButtonsTint(int button_index) {
    Color selectedColor = Colors.lightGreen;
    Color color = Colors.white;

    return index == button_index ? selectedColor : color;
  }

  Expanded buildOptionsButton(
      String label, String click, int button_index, bool show_border) {
    return Expanded(
      child: PositionedTapDetector(
          onTap: (position) {
            Navigator.of(context).push(
                new MaterialPageRoute(builder: (context) => SignInScreen()));
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            color: Colors.white,
            child: Center(
              child: Container(
                  width: double
                      .infinity, // remove this line in order to center the title of each option button
                  child: Column(
                    children: <Widget>[
                      Text(label,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: new TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.none,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          )),
                      Text(click,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: new TextStyle(
                            color: Colors.lightGreen,
                            decoration: TextDecoration.none,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  )),
            ),
          )),
      flex: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              color: Colors.white,
              child: Center(
                child: Container(
                    width: 160.0,
                    height: 160.0,
                    decoration: new BoxDecoration(
                      border: new Border.all(
                          color: Colors.lightGreen,
                          style: BorderStyle.solid,
                          width: 4.0),
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('images/icone_launcher.png'),
                      ),
                    )),
              ),
            ),
            flex: 3,
          ),
          buildOptionsButton(
              getLocaleText(
                  context: context, strinKey: StringKeys.LOGIN_REGISTER),
              getLocaleText(context: context, strinKey: StringKeys.CLICK_HERE),
              0,
              true),
          Expanded(
            child: Container(
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
