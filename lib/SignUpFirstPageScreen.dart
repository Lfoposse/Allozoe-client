import 'package:flutter/material.dart';
import 'SignUpSegondPageScreen.dart';
import 'package:client_app/Utils/SelectCountryWidget.dart';
import 'package:client_app/Utils/MyBehavior.dart';

class SignUpFirstPageScreen extends StatelessWidget {

  static const double padding_from_screen = 30.0;

  @override
  Widget build(BuildContext context) {
    Container buildEntrieRow(IconData startIcon, IconData endIcon,
        String hintText, TextInputType inputType, bool hide_content) {
      Color color = Colors.grey;
      return Container(
        decoration: new BoxDecoration(border: new Border.all(color: color)),
        padding: EdgeInsets.only(left: 10.0, right: 10.0),
        margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: Row(
          children: [
            Icon(startIcon, color: color),
            Expanded(
                child: Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: TextFormField(
                        obscureText: hide_content,
                        autofocus: false,
                        autocorrect: false,
                        maxLines: 1,
                        keyboardType: inputType,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: hintText,
                        ),
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        )))),
            Icon(endIcon, color: color),
          ],
        ),
      );
    }

    Widget entriesSection = Container(
      margin: EdgeInsets.only(top: 20.0),
      padding: const EdgeInsets.only(left: padding_from_screen, right: padding_from_screen),
      child: Column(
        children: [
          Row(children: <Widget>[
            new Flexible(
              child: buildEntrieRow(
                  Icons.person, null, "Nom", TextInputType.text, false),
              flex: 1,
            ),
            SizedBox(width: 8.0),
            new Flexible(
              child: buildEntrieRow(
                  Icons.person, null, "Prénom", TextInputType.text, false),
              flex: 1,
            ),
          ]),
          buildEntrieRow(Icons.email, null, "Entrer un email",
              TextInputType.emailAddress, false),
          Row(children: <Widget>[
            new Flexible(
              child: SelectCountry(false, "fr"),
              flex: 5,
            ),
            SizedBox(width: 8.0),
            new Flexible(
              child: buildEntrieRow(
                  Icons.phone, null, "356987412", TextInputType.text, false),
              flex: 6,
            ),
          ]),
          buildEntrieRow(
              Icons.lock, null, "Mot de passe", TextInputType.text, true),
        ],
      ),
    );

    Widget buttonSection = Container(
        padding: const EdgeInsets.only(
            left: padding_from_screen, right: padding_from_screen, top: 10.0, bottom: 15.0),
        child: RaisedButton(
          onPressed: () {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) => SignUpSegondPageScreen()));
          },
          child: SizedBox(
            width: double.infinity,
            child: Text("SUIVANT",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                )),
          ),
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
          textColor: Colors.white,
          color: Colors.lightGreen,
          elevation: 1.0,
        ));

    Widget conditionsSection = Container(
      padding: const EdgeInsets.only(
          left: 10.0, right: 10.0, top: 20.0, bottom: 10.0),
      child: new RichText(
        text: new TextSpan(
          children: [
            new TextSpan(
                text:
                'En cliquant sur « S\"INSCRIRE », je confirme avoir lu et accepté les ',
                style: new TextStyle(
                  color: Colors.black54,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                )),
            new TextSpan(
                text: 'Conditions générales',
                style: new TextStyle(
                  color: Colors.lightGreen,
                  decoration: TextDecoration.underline,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                )),
            new TextSpan(
                text: ' et ',
                style: new TextStyle(
                  color: Colors.black54,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                )),
            new TextSpan(
              text: 'Politique de confidentialité',
              style: new TextStyle(
                color: Colors.lightGreen,
                decoration: TextDecoration.underline,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );

    // Material is a conceptual piece of paper on which the UI appears.
    return Material(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            ScrollConfiguration(
                behavior: MyBehavior(),
                child: ListView(
                  children: [
                    Image.asset(
                      'images/header.jpg',
                      width: double.infinity,
                      height: 210.0,
                      fit: BoxFit.fill,
                    ),
                    entriesSection,
                    conditionsSection,
                    buttonSection,
                  ],
                )
            ),
            Container(
              height: AppBar().preferredSize.height,
              child: AppBar(
                title: Text('Infos de compte'),
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