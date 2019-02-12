import 'dart:async';

import 'package:client_app/DAO/Presenters/LogoutPresenter.dart';
import 'package:client_app/HomeScreen.dart';
import 'package:client_app/StringKeys.dart';
import 'package:client_app/Utils/MyBehavior.dart';
import 'package:flutter/material.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';

import '../AccountScreen.dart';
import '../DAO/Presenters/ResetPassPresenter.dart';
import '../Database/DatabaseHelper.dart';
import '../Models/Client.dart';
import '../Models/CreditCard.dart';
import '../Paiements/CardListScreen.dart';
import '../SignInScreen.dart';
import '../Utils/AppSharedPreferences.dart';

class Profil extends StatefulWidget {
  @override
  createState() => new ProfilState();
}

Future<Null> _confirmerDeconnexion(BuildContext context) async {
  LogoutPresenter _presenter = new LogoutPresenter();
  return showDialog<Null>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return new AlertDialog(
        title: new Text(getLocaleText(
            context: context, strinKey: StringKeys.PROFILE_DECONNEXION)),
        content: new SingleChildScrollView(
          child: new ListBody(
            children: <Widget>[
              new Text(getLocaleText(
                  context: context,
                  strinKey: StringKeys.PROFILE_ASK_DECONNECTION)),
            ],
          ),
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text(
                getLocaleText(
                    context: context, strinKey: StringKeys.PROFILE_ANNULER),
                style: TextStyle(color: Colors.lightGreen)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          new FlatButton(
            child: new Text(
                getLocaleText(
                    context: context, strinKey: StringKeys.PROFILE_OK),
                style: TextStyle(color: Colors.lightGreen)),
            onPressed: () {
              // Navigator.of(context).pop();
              new DatabaseHelper().clearClient();
              AppSharedPreferences().setAppLoggedIn(
                  false); // on memorise qu'un compte s'est connecter
              Navigator.of(context).pushAndRemoveUntil(
                  new MaterialPageRoute(builder: (context) => HomeScreen()),
                  ModalRoute.withName(Navigator.defaultRouteName));

              DatabaseHelper().loadClient().then((client) {
                _presenter.doLogout(client.id).then((status) {
                  print("statut :" + status.toString());
                });
              });
            },
          ),
        ],
      );
    },
  );
}

Future<Null> _showError(BuildContext context) async {
  return showDialog<Null>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
          title: new Text(getLocaleText(
              context: context, strinKey: StringKeys.PROFILE_DECONNEXION)),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text(getLocaleText(
                    context: context,
                    strinKey: StringKeys.PROFILE_ERROR_OCCURED)),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('ok', style: TextStyle(color: Colors.lightGreen)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ]);
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
        title: Text(getLocaleText(
            context: context, strinKey: StringKeys.PROFILE_UPDATE_PASSWORD)),
        content: ChangePasswordContent(),
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
          new DatabaseHelper().getClientCards().then((List<CreditCard> cards) {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) => CardListScreen(
                      forPaiement: false,
                      paymentMode: 1,
                      cards: cards,
                      langue: getLocaleText(
                          context: context, strinKey: StringKeys.LANGUE),
                    )));
          });

          break;
        }

      default:
        {
          //deconnecter le compte apres confirmation de l'application
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
                        image: AssetImage('images/icone_launcher.png'),
                      ),
                    )),
              ),
            ),
            flex: 5,
          ),
          Container(
              decoration: new BoxDecoration(
            border: new Border(
                top: BorderSide(
                    color: Colors.grey, style: BorderStyle.solid, width: 1.0)),
          )),
          buildOptionsButton(
              getLocaleText(
                  context: context, strinKey: StringKeys.PROFILE_MY_PROFILE),
              0,
              true),
          buildOptionsButton(
              getLocaleText(
                  context: context,
                  strinKey: StringKeys.PROFILE_UPDATE_PASSWORD),
              1,
              true),
          buildOptionsButton(
              getLocaleText(
                  context: context, strinKey: StringKeys.PROFILE_PAYMENT_MODE),
              2,
              true),
          buildOptionsButton(
              getLocaleText(
                  context: context, strinKey: StringKeys.PROFILE_DECONNEXION),
              3,
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

class ChangePasswordContent extends StatefulWidget {
  createState() => new ChangePasswordContentState();
}

class ChangePasswordContentState extends State<ChangePasswordContent>
    implements ResetPassContract {
  bool hideOldPass = false;
  bool hideNewPass = false;
  bool hideNewPassConfirm = false;

  bool _showError = false;
  bool _isLoading = false;
  String _errorMsg;

  final passKey = new GlobalKey<FormState>();
  final confirmKey = new GlobalKey<FormState>();

  String _pass, _confirm;
  ResetPassPresenter _presenter;

  ChangePasswordContentState() {
    _presenter = new ResetPassPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _isLoading = false;
  }

  void _submit() {
    confirmKey.currentState.save();
    passKey.currentState.save();

    if (_pass.length == 0 || _confirm.length == 0) {
      setState(() {
        _errorMsg = getLocaleText(
            context: context,
            strinKey: StringKeys.PROFILE_ERROR_FIELD_REQUIREMENT);
        _showError = true;
      });
    } else if (_pass != _confirm) {
      setState(() {
        _errorMsg = getLocaleText(
            context: context,
            strinKey: StringKeys.PROFILE_ERROR_PASSWORD_DONT_MATCH);
        _showError = true;
      });
    } else {
      setState(() {
        _isLoading = true;
        _showError = false;
      });

      new DatabaseHelper().loadClient().then((Client client) {
        _presenter.resetPassword(client.id, _pass);
      });
    }
  }

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

  Widget getChangePassElement(key, String hintText, int index) {
    return Row(
      children: [
        Expanded(
            child: Form(
                key: key,
                child: Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: TextFormField(
                        onSaved: (val) {
                          if (key == passKey)
                            _pass = val;
                          else
                            _confirm = val;
                        },
                        obscureText: !isElementContentVisible(index),
                        autofocus: false,
                        autocorrect: false,
                        maxLines: 1,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintText: hintText,
                            hintStyle: TextStyle(
                                color: Colors.black12, fontSize: 14.0)),
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ))))),
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
    Widget getButton(String title, int index, Color bgdColor) {
      return Container(
          padding: const EdgeInsets.only(left: 40.0, right: 40.0, bottom: 10.0),
          child: RaisedButton(
            onPressed: () {
              if (index == 1)
                Navigator.of(context).pop();
              else
                _submit();
            },
            child: SizedBox(
              width: double.infinity,
              child: Text(title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            textColor: Colors.white,
            color: bgdColor,
            elevation: 1.0,
          ));
    }

    return ScrollConfiguration(
        behavior: MyBehavior(),
        child: Container(
          height: 300.0,
          child: Column(
            //
            children: <Widget>[
              //getChangePassElement("Mot de passe courant", 0),
              getChangePassElement(
                  passKey,
                  getLocaleText(
                      context: context,
                      strinKey: StringKeys.PROFILE_NEW_PASSWORD),
                  1),
              getChangePassElement(
                  confirmKey,
                  getLocaleText(
                      context: context,
                      strinKey: StringKeys.PROFILE_CONFIRME_PASSWORD),
                  2),

              Container(
                  margin: EdgeInsets.only(bottom: 20.0, top: 20.0),
                  child: Center(
                    child: Text(
                      _showError ? _errorMsg : "",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
              _isLoading
                  ? Container(
                margin: EdgeInsets.symmetric(vertical: 15.0),
                child: Center(
                  child: new CircularProgressIndicator(),
                ),
              )
                  : getButton(
                  getLocaleText(
                      context: context,
                      strinKey: StringKeys.PROFILE_MODIFIER),
                  0,
                  Colors.lightGreen),
              _isLoading
                  ? IgnorePointer(ignoring: true)
                  : getButton(
                  getLocaleText(
                      context: context, strinKey: StringKeys.PROFILE_ANNULER),
                  1,
                  Colors.red)
            ],
          ),
        ));
  }

  @override
  void onConnectionError() {
    setState(() {
      _isLoading = false;
      _errorMsg = getLocaleText(
          context: context, strinKey: StringKeys.PROFILE_CONNECTION_ERROR);
      _showError = true;
    });
  }

  @override
  void onResetError() {
    setState(() {
      _isLoading = false;
      _errorMsg = getLocaleText(
          context: context, strinKey: StringKeys.PROFILE_ERROR_OCCURED);
      _showError = true;
    });
  }

  @override
  void onResetSuccess() {
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(getLocaleText(
              context: context, strinKey: StringKeys.PROFILE_SUCCES)),
          content: new Text(getLocaleText(
              context: context,
              strinKey: StringKeys.PROFILE_PASSWORD_UPDATE_SUCCES)),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

Future<Null> _changerInfosBancaires(BuildContext context) async {
  return showDialog<Null>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.all(5.0),
        title: new Text(getLocaleText(
            context: context, strinKey: StringKeys.PROFILE_ACCOUNT_INFO)),
        content: ChangeInfosBancairesContent(),
        actions: <Widget>[
          new FlatButton(
            child: new Text(
                getLocaleText(
                    context: context, strinKey: StringKeys.PROFILE_ANNULER),
                style: TextStyle(color: Colors.lightGreen)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          new FlatButton(
            child: new Text(
                getLocaleText(
                    context: context,
                    strinKey: StringKeys.PROFILE_ACCOUNT_ENREGISTRER),
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
      ),
    );
  }
}
