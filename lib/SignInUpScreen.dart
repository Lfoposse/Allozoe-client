import 'package:flutter/material.dart';
import 'SignUpFirstPageScreen.dart';
import 'package:client_app/Login/SignInPhoneScreen.dart';


class SignInUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Material is a conceptual piece of paper on which the UI appears.
    return Material(
      // Column is a vertical, linear layout.
      color: Colors.white,

      child: Column(
        children: <Widget>[
          Expanded(
            child: Image.asset(
              'images/plat.png',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => SignInPhoneScreen()));
                },
                child: SizedBox(
                  //width: double.infinity,
                  child: Text(
                    "SE CONNECTER",
                    textAlign: TextAlign.center,
                  ),
                ),
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                textColor: Colors.white,
                color: Colors.lightGreen,
                elevation: 1.0,
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => SignUpFirstPageScreen()));
                },
                child: SizedBox(
//                  width: double.infinity,
                  child: Text(
                    "S'INSCRIRE",
                    textAlign: TextAlign.center,
                  ),
                ),
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                textColor: Colors.lightGreen,
                color: Colors.white,
                elevation: 0.0,
              )
            ],
          )
        ],
      ),
    );
  }
}
