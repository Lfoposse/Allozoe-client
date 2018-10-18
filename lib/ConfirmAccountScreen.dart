import 'package:flutter/material.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';
import 'ResetPasswordScreen.dart';
import 'package:client_app/Utils/MyBehavior.dart';

class ConfirmAccountScreen extends StatefulWidget {
  @override

  createState() => new ConfirmAccountState();
}

class ConfirmAccountState extends State<ConfirmAccountScreen> {
  @override
  Widget build(BuildContext context) {

    String user_phone = "+3373388383";
    const double padding_from_screen = 30.0;

    Container buildCase() {
      Color color = Colors.grey;

      return Container(
          decoration: new BoxDecoration(
            border: new Border.all(color: color),
          ),
          margin: EdgeInsets.only(left: 10.0, right: 10.0),
          padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
          child: TextFormField(
              autofocus: false,
              autocorrect: false,
              textAlign: TextAlign.center,
              maxLines: 1,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              )));
    }

    Widget codeSection = Container(
      padding: EdgeInsets.only(left: padding_from_screen - 10.0, right: padding_from_screen - 10.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: buildCase(),
            ),
            Expanded(
              child: buildCase(),
            ),
            Expanded(
              child: buildCase(),
            ),
            Expanded(
              child: buildCase(),
            )
          ]),
    );

    return Material(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            ScrollConfiguration(
                behavior: MyBehavior(),
                child: ListView(
                  physics: new ClampingScrollPhysics(),
                  children: [
                    Image.asset(
                      'images/header.jpg',
                      width: double.infinity,
                      height: 210.0,
                      fit: BoxFit.fill,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: 50.0, bottom: 30.0, left: padding_from_screen, right: padding_from_screen),
                      child: new RichText(
                        text: new TextSpan(
                          children: [
                            new TextSpan(
                                text:
                                'Saississez le code à 4 chiffres reçu au numéro ',
                                style: new TextStyle(
                                  color: Colors.black54,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                )),
                            new TextSpan(
                                text: user_phone,
                                style: new TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ))
                          ],
                        ),
                      ),
                    ),
                    codeSection,
                    Row(children: <Widget>[
                      PositionedTapDetector(
                          onTap: (position) {
                            Navigator.of(context).push(new MaterialPageRoute(
                                builder: (context) => ResetPasswordScreen()));
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                left: padding_from_screen, right: padding_from_screen, top: 60.0, bottom: 20.0),
                            child: Text('J\'ai un problème',
                                style: new TextStyle(
                                  color: Colors.lightGreen,
                                  decoration: TextDecoration.underline,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                )),
                          )),
                      Expanded(
                        child: Text(''),
                      )
                    ])
                  ],
                )),
            Container(
              height: AppBar().preferredSize.height,
              child: AppBar(
                title: Text('Code de confirmation'),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}
