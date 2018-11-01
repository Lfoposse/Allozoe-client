import 'package:flutter/material.dart';
import 'package:client_app/Utils/MyBehavior.dart';
import 'SignInScreen.dart';
import 'Utils/AppSharedPreferences.dart';
import 'DAO/Presenters/ResetPassPresenter.dart';

class ResetPasswordScreen extends StatefulWidget {

  final int clientId;
  ResetPasswordScreen({@required this.clientId});

  @override
  createState() => new ResetPasswordScreenState();
}

class ResetPasswordScreenState extends State<ResetPasswordScreen>
    implements ResetPassContract {
  static const double padding_from_screen = 30.0;

  bool _showError = false;
  bool _isLoading = false;
  String _errorMsg;

  final passKey = new GlobalKey<FormState>();
  final confirmKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  String _pass, _confirm;
  ResetPassPresenter _presenter;

  ResetPasswordScreenState() {
    _presenter = new ResetPassPresenter(this);
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  void _submit() {
    confirmKey.currentState.save();
    passKey.currentState.save();

    if (_pass.length == 0 || _confirm.length == 0) {
      setState(() {
        _errorMsg = "Renseigner tous les champs";
        _showError = true;
      });
    } else if (_pass != _confirm) {
      setState(() {
        _errorMsg = "Mot de passe et confirmation différents";
        _showError = true;
      });
    } else {
      setState(() {
        _isLoading = true;
        _showError = false;
      });

      _presenter.resetPassword(widget.clientId, _pass);
    }
  }

  @override
  Widget build(BuildContext context) {
    Container buildPassEntry(key, String hintText) {
      Color color = Colors.black12;
      return Container(
        decoration: new BoxDecoration(border: new Border.all(color: color)),
        padding: EdgeInsets.only(left: 10.0, right: 10.0),
        child: Form(
            key: key,
            child: Row(
              children: [
                Icon(Icons.lock, color: Colors.grey),
                Expanded(
                    child: Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: TextFormField(
                            onSaved: (val) {
                              if (key == passKey) {
                                _pass = val;
                              } else if (key == confirmKey) {
                                _confirm = val;
                              }
                            },
                            obscureText: true,
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
              ],
            )),
      );
    }

    Widget buttonSection = Container(
        padding: const EdgeInsets.only(
            left: padding_from_screen + 20.0,
            right: padding_from_screen + 20.0,
            top: 40.0,
            bottom: 20.0),
        child: RaisedButton(
          onPressed: _submit,
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

    Widget showError() {
      return _showError
          ? Container(
              margin: EdgeInsets.only(
                  left: padding_from_screen,
                  right: padding_from_screen,
                  top: 15.0),
              child: Center(
                child: Text(
                  _errorMsg,
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          : Container();
    }

    return Material(
      child: Scaffold(
        key: scaffoldKey,
        body: Stack(
          children: <Widget>[
            ScrollConfiguration(
                behavior: new MyBehavior(),
                child:
                    ListView(physics: new ClampingScrollPhysics(), children: [
                  Image.asset(
                    'images/header.jpg',
                    width: double.infinity,
                    height: 210.0,
                    fit: BoxFit.fill,
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 20.0,
                        bottom: 40.0,
                        left: padding_from_screen,
                        right: padding_from_screen),
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
                    margin: EdgeInsets.only(
                        left: padding_from_screen,
                        right: padding_from_screen,
                        bottom: 10.0),
                    child: buildPassEntry(
                        passKey, "Saisissez le nouveau mot de passe"),
                  ),
                  Container(
                    color: Colors.black12,
                    margin: EdgeInsets.only(
                        left: padding_from_screen, right: padding_from_screen),
                    child:
                        buildPassEntry(confirmKey, "Confirmer le mot de passe"),
                  ),
                  showError(),
                  _isLoading
                      ? Container(
                          padding: const EdgeInsets.only(
                              left: padding_from_screen,
                              right: padding_from_screen,
                              top: 30.0,
                              bottom: 15.0),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : buttonSection
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

  @override
  void onConnectionError() {
    _showSnackBar("Échec de connexion. Vérifier votre connexion internet");
    setState(() => _isLoading = false);
  }

  @override
  void onResetError() {
    setState(() {
      _isLoading = false;
      _errorMsg = "Erreur survénue. Réessayez SVP!";
      _showError = true;
    });
  }

  @override
  void onResetSuccess() {

    setState(() {_isLoading = false;});

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Succès"),
          content: new Text(
              "Le mot de passe de votre compte a ete réinitialiser avec succès.\nConnectez vous avec vos nouveaux identifiants"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                AppSharedPreferences().setAppLoggedIn(true); // on memorise qu'un compte s'est connecter
                Navigator.of(context).pushAndRemoveUntil(
                    new MaterialPageRoute(builder: (context) => SignInScreen()), ModalRoute.withName(Navigator.defaultRouteName));
              },
            ),

          ],
        );
      },
    );

  }
}
