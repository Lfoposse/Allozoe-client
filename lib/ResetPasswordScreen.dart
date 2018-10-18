import 'package:flutter/material.dart';
import 'package:client_app/Utils/MyBehavior.dart';
import 'HomeScreen.dart';
import 'Utils/AppSharedPreferences.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  createState() => new ResetPasswordScreenState();
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> {

  static const double padding_from_screen = 30.0;
  bool hide_content = true;

  @override
  Widget build(BuildContext context) {
    void _update_state() {
      setState(() {
        hide_content = !hide_content;
      });
    }

    Container buildPassEntry(String hintText) {
      Color color = Colors.black12;
      return Container(
        decoration: new BoxDecoration(border: new Border.all(color: color)),
        padding: EdgeInsets.only(left: 10.0, right: 10.0),
        child: Row(
          children: [
            Expanded(
                child: Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: TextFormField(
                        obscureText: hide_content,
                        autofocus: false,
                        autocorrect: false,
                        maxLines: 1,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: hintText,
                            hintStyle: TextStyle(
                                color: Colors.black12, fontSize: 14.0)),
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        )))),
//            IconButton(
//                onPressed: _update_state,
//                icon: Icon(
//                  hide_content ? Icons.visibility : Icons.visibility_off,
//                  color: Colors.grey,
//                ))
          ],
        ),
      );
    }

    Widget buttonSection = Container(
        padding: const EdgeInsets.only(
            left: padding_from_screen, right: padding_from_screen, top: 40.0, bottom: 20.0),
        child: RaisedButton(
          onPressed: () {

            AppSharedPreferences().setAppLoggedIn(true); // on memorise qu'un compte s'est connecter
            Navigator.of(context)
                .pushAndRemoveUntil(new MaterialPageRoute(builder: (context) => HomeScreen()), ModalRoute.withName(Navigator.defaultRouteName));
          },
          child: SizedBox(
            width: double.infinity,
            child: Text("MODIFIER",
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

    return Material(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            ScrollConfiguration(
                behavior: new MyBehavior(),
                child: ListView(physics: new ClampingScrollPhysics(), children: [
                  Image.asset(
                    'images/header.jpg',
                    width: double.infinity,
                    height: 210.0,
                    fit: BoxFit.fill,
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 50.0, bottom: 20.0, left: padding_from_screen, right: padding_from_screen),
                    child: new Text(
                        'Définissez un nouveau mot de passe pour votre compte',
                        style: new TextStyle(
                          color: Colors.black54,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  Container(
                    color: Colors.black12,
                    margin:
                    EdgeInsets.only(left: padding_from_screen, right: padding_from_screen, bottom: 20.0),
                    child: buildPassEntry("Saisissez le nouveau mot de passe"),
                  ),
                  Container(
                    color: Colors.black12,
                    margin: EdgeInsets.only(left: padding_from_screen, right: padding_from_screen),
                    child: buildPassEntry("Confirmer le mot de passe"),
                  ),
                  buttonSection
                ])),
            Container(
              height: AppBar().preferredSize.height,
              child: AppBar(
                title: Text('Récupération'),
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
