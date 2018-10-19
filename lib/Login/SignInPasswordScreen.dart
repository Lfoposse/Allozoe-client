import 'package:client_app/DAO/Presenters/LoginPresenter.dart';
import 'package:client_app/Models/Client.dart';
import 'package:flutter/material.dart';
import 'package:client_app/ConfirmAccountScreen.dart';
import '../HomeScreen.dart';
import '../Utils/MyBehavior.dart';
import '../Utils/AppSharedPreferences.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';

class SignInPasswordScreen extends StatefulWidget {

  SignInPasswordScreen({this.email});
  String email;
  @override
  createState() => new SignInPasswordScreenState();
}

class SignInPasswordScreenState extends State<SignInPasswordScreen> implements LoginContract{

  bool _isLoading = false;
  bool _showError = false;
  String _errorMsg = "Veuillez entrer un mot de passe";
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String _password;

  bool hide_content = true;
  static const double padding_from_screen = 30.0;

  LoginPresenter _presenter;

  SignInPasswordScreenState() {
    _presenter = new LoginPresenter(this);
  }

  void _submit() {

    final form = formKey.currentState;

    if (form.validate()) {
      form.save();

      if(_password.length == 0) {
        setState(() {
          _errorMsg = "Veuillez entrer un mot de passe";
          _showError = true;
        });
      }else {
        setState((){
          _isLoading = true;
          _showError = false;
        });
        _presenter.doLogin(widget.email, _password, false);
      }
    }
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }


  Widget showError(){

    return _showError ? Container(
      margin: EdgeInsets.only(
          left: padding_from_screen, right: padding_from_screen),
      child: Center(
        child: Text(_errorMsg, style: TextStyle(
            color: Colors.red,
            fontSize: 14.0,
            fontWeight: FontWeight.bold
        ),),
      ),
    ) : Container();
  }


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
        child: Form(
          key: formKey,
          child: Row(
            children: [
              Expanded(
                  child: Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: TextFormField(
                          onSaved: (val) => _password = val,
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
              IconButton(
                  onPressed: _update_state,
                  icon: Icon(
                    hide_content ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ))
            ],
          ),
        ),
      );
    }

    Widget buttonSection = Container(
        padding: const EdgeInsets.only(
            left: padding_from_screen, right: padding_from_screen, top: 30.0, bottom: 50.0),
        child: RaisedButton(
          onPressed: _submit,
          child: SizedBox(
            width: double.infinity,
            child: Text("SE CONNECTER",
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
        key: scaffoldKey,
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
                    Container(
                      margin: EdgeInsets.only(
                          top: 30.0, bottom: 20.0, left: padding_from_screen, right: padding_from_screen),
                      child: new Text(
                          'Heureux de vous revoir ! Connectez-vous pour continuer',
                          style: new TextStyle(
                            color: Colors.black54,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    Container(
                      color: Colors.black12,
                      margin: EdgeInsets.only(left: padding_from_screen, right: padding_from_screen),
                      child: buildPassEntry("Saisissez votre mot de passe"),
                    ),
                    showError(),
                    _isLoading
                        ? Container(
                      padding: const EdgeInsets.only(
                          left: padding_from_screen,
                          right: padding_from_screen,
                          top: 30.0, bottom: 50.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                        : buttonSection,

                    Row(children: <Widget>[
                      PositionedTapDetector(
                          onTap: (position) {
                            Navigator.of(context).push(new MaterialPageRoute(
                                builder: (context) => ConfirmAccountScreen()));
                          },
                          child: Container(
                              margin: EdgeInsets.only(
                                  left: padding_from_screen, right: padding_from_screen, bottom: 15.0),
                              child: Text('Mot de passe oublié ?',
                                  style: new TextStyle(
                                    color: Colors.lightGreen,
                                    decoration: TextDecoration.underline,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  )))),
                      Expanded(
                        child: Text(''),
                      )
                    ]),
                  ],
                )),

            Container(
              height: AppBar().preferredSize.height,
              child: AppBar(
                title: Text('Connexion'),
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
  void onLoginError() {
    setState((){
      _isLoading = false;
      _errorMsg = "Mot de passe erroné";
      _showError = true;
    });
  }

  @override
  void onLoginSuccess(Client client) {

    setState(() => _isLoading = false);
    AppSharedPreferences().setAppLoggedIn(true); // on memorise qu'un compte s'est connecter
    Navigator.of(context)
        .pushAndRemoveUntil(new MaterialPageRoute(builder: (context) => HomeScreen()), ModalRoute.withName(Navigator.defaultRouteName));
  }

  @override
  void onConnectionError() {

    _showSnackBar("Échec de connexion. Vérifier votre connexion internet");
    setState(() => _isLoading = false);
  }
}
