import 'dart:async';
import 'package:flutter/material.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';
import '../Utils/AppSharedPreferences.dart';
import '../SignInScreen.dart';
import '../AccountScreen.dart';

class Profil extends StatefulWidget {
  @override
  createState() => new ProfilState();
}

Future<Null> _confirmerDeconnexion(BuildContext context) async {
  return showDialog<Null>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return new AlertDialog(
        title: new Text('Déconnexion'),
        content: new SingleChildScrollView(
          child: new ListBody(
            children: <Widget>[
              new Text('Voulez vous vraiment vous déconnecter ?'),
            ],
          ),
        ),
        actions: <Widget>[
          new FlatButton(
            child:
                new Text('ANNULER', style: TextStyle(color: Colors.lightGreen)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          new FlatButton(
            child: new Text('OK', style: TextStyle(color: Colors.lightGreen)),
            onPressed: () {
              Navigator.of(context).pop();
              AppSharedPreferences().setAppLoggedIn(
                  false); // on memorise qu'un compte s'est connecter
              Navigator.of(context).pushAndRemoveUntil(
                  new MaterialPageRoute(
                      builder: (context) => SignInScreen()),
                  ModalRoute.withName(Navigator.defaultRouteName));
            },
          ),
        ],
      );
    },
  );
}

Future<Null> _changerMotDePasse(BuildContext context) async {
  return showDialog<Null>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.all(5.0),
        title: new Text('Changer le mot de passe'),
        content: ChangePasswordContent(),
        actions: <Widget>[
          new FlatButton(
            child:
                new Text('ANNULER', style: TextStyle(color: Colors.lightGreen)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          new FlatButton(
            child: new Text('OK', style: TextStyle(color: Colors.lightGreen)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<Null> _changerInfosBancaires(BuildContext context) async {
  return showDialog<Null>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.all(5.0),
        title: new Text('Infos de paiement'),
        content: ChangeInfosBancairesContent(),
        actions: <Widget>[
          new FlatButton(
            child:
                new Text('ANNULER', style: TextStyle(color: Colors.lightGreen)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          new FlatButton(
            child: new Text('ENREGISTRER',
                style: TextStyle(color: Colors.lightGreen)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class ProfilState extends State<Profil> {
  int index = -1;

  Color setButtonsTint(int button_index) {
    Color selectedColor = Colors.lightGreen;
    Color color = Colors.white;

    return index == button_index ? selectedColor : color;
  }

  void handleButtonClick() {
    // effectue une action suivant le bouton qui a ete cliquer

    switch (index) {
      case 0:
        {
          // lancer la page de profil
          Navigator.of(context).push(
              new MaterialPageRoute(builder: (context) => AccountScreen()));
          break;
        }

      case 1:
        {
          // lancer la page de changement de mot de passe
          _changerMotDePasse(context);
          break;
        }

      case 2:
        {
          // lancer la page de modification des infos bancaires
          _changerInfosBancaires(context);
          break;
        }

      default:
        {
          // deconnecter le compte apres confirmation de l'application
          _confirmerDeconnexion(context);
        }
    }
  }

  Expanded buildOptionsButton(
      String label, int button_index, bool show_border) {
    return Expanded(
      child: PositionedTapDetector(
          onTap: (position) {
            setState(() {
              index = button_index;
              handleButtonClick(); // effectuer l'action associer au bouton
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            decoration: new BoxDecoration(
                border: !show_border
                    ? new Border()
                    : new Border(
                        bottom: BorderSide(
                            color: Colors.grey,
                            style: BorderStyle.solid,
                            width: 1.0)),
                color: setButtonsTint(button_index)),
            child: Center(
              child: Container(
                width: double
                    .infinity, // remove this line in order to center the title of each option button
                child: Text(label,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: new TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration.none,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    )),
              ),
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
                    width: 200.0,
                    height: 200.0,
                    decoration: new BoxDecoration(
                      border: new Border.all(
                          color: Colors.lightGreen,
                          style: BorderStyle.solid,
                          width: 4.0),
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('images/plat.png'),
                      ),
                    )),
              ),
            ),
            flex: 5,
          ),
          buildOptionsButton("Mon profil", 0, true),
          buildOptionsButton("Changer le mot de passe", 1, true),
          buildOptionsButton("Changer les infos de paiement", 2, true),
          buildOptionsButton("Déconnecter", 3, true),
          Expanded(child: Container(color: Colors.white,),)
        ],
      ),
    );
  }
}

class ChangePasswordContent extends StatefulWidget {
  createState() => new ChangePasswordContentState();
}

class ChangePasswordContentState extends State<ChangePasswordContent> {
  bool hideOldPass = false;
  bool hideNewPass = false;
  bool hideNewPassConfirm = false;

  bool isElementContentVisible(int index) {
    switch (index) {
      case 0:
        return hideOldPass;

      case 1:
        return hideNewPass;

      case 2:
        return hideNewPassConfirm;

      default:
        return false;
    }
  }

  Widget getChangePassElement(String hintText, int index) {
    return Row(
      children: [
        Expanded(
            child: Container(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: TextFormField(
                    obscureText: !isElementContentVisible(index),
                    autofocus: false,
                    autocorrect: false,
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: hintText,
                        hintStyle:
                            TextStyle(color: Colors.black12, fontSize: 14.0)),
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    )))),
        IconButton(
            onPressed: () {
              setState(() {
                switch (index) {
                  case 0:
                    {
                      hideOldPass = !hideOldPass;
                      break;
                    }

                  case 1:
                    {
                      hideNewPass = !hideNewPass;
                      break;
                    }

                  case 2:
                    {
                      hideNewPassConfirm = !hideNewPassConfirm;
                      break;
                    }
                }
              });
            },
            icon: Icon(
              isElementContentVisible(index)
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: Colors.grey,
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        getChangePassElement("Mot de passe courant", 0),
        getChangePassElement("Nouveau mot de passe", 1),
        getChangePassElement("Confirmer le mot de passe", 2)
      ],
    );
  }
}

class ChangeInfosBancairesContent extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            buildEntrieRow(Icons.credit_card, Icons.camera_alt,
                "Numéro de la carte", TextInputType.number),
            buildEntrieRow(
                Icons.calendar_today, null, "MM/AA", TextInputType.text),
            buildEntrieRow(
                Icons.lock, null, "Code de sécurite", TextInputType.number),
          ],
        ),
      ),
    );
  }
}
