import 'package:client_app/StringKeys.dart';
import 'package:client_app/Utils/MyBehavior.dart';
import 'package:flutter/material.dart';

class SignUpSegondPageScreen extends StatelessWidget {
  static const double padding_from_screen = 30.0;

  @override
  Widget build(BuildContext context) {
    Container buildEntrieRow(IconData startIcon, IconData endIcon,
        String hintText, TextInputType inputType) {
      Color color = Colors.grey;

      return Container(
        decoration: new BoxDecoration(
          border: new Border.all(color: color),
        ),
        padding: EdgeInsets.only(left: 10.0, right: 10.0),
        margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: Row(
          children: [
            Icon(startIcon, color: color),
            Expanded(
                child: Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: TextFormField(
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
      margin: EdgeInsets.only(top: 30.0),
      padding: const EdgeInsets.only(
          left: padding_from_screen, right: padding_from_screen),
      child: Column(
        children: [
          buildEntrieRow(
              Icons.credit_card,
              Icons.camera_alt,
              getLocaleText(
                  context: context, strinKey: StringKeys.PROFILE_NUM_CARTE),
              TextInputType.number),
          buildEntrieRow(
              Icons.calendar_today, null, "MM/AA", TextInputType.text),
          buildEntrieRow(
              Icons.lock,
              null,
              getLocaleText(
                  context: context, strinKey: StringKeys.PROFILE_CODE),
              TextInputType.number),
        ],
      ),
    );

    Widget buttonSection = Container(
        padding: const EdgeInsets.only(
            left: padding_from_screen,
            right: padding_from_screen,
            top: 30.0,
            bottom: 20.0),
        child: RaisedButton(
          onPressed: () {
            // todo : Enregistrer la carte
          },
          child: SizedBox(
            width: double.infinity,
            child: Text(
                getLocaleText(context: context, strinKey: StringKeys.OK_BTN),
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

    // Material is a conceptual piece of paper on which the UI appears.
    return Material(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: ListView(children: [
                    Image.asset(
                      'images/header.jpg',
                      width: double.infinity,
                      height: 210.0,
                      fit: BoxFit.fill,
                    ),
                    entriesSection,
                    buttonSection,
                  ])),
            ),
            Container(
              height: AppBar().preferredSize.height+50,
              child: AppBar(
                title: Text(getLocaleText(
                    context: context,
                    strinKey: StringKeys.PROFILE_ACCOUNT_INFO)),
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
