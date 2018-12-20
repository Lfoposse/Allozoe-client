import 'package:flutter/material.dart';
import 'DAO/Presenters/SignUpPresenter.dart';
import 'package:client_app/Utils/SelectCountryWidget.dart';
import 'package:client_app/Utils/MyBehavior.dart';
import 'ConfirmAccountScreen.dart';
import 'Models/Client.dart';
import 'StringKeys.dart';

class SignUpScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> implements SignUpContract{

  static const double padding_from_screen = 30.0;
  bool _showError = false;
  String _errorMsg ;
  bool _isLoading = false;

  final nameKey = new GlobalKey<FormState>();
  final surnameKey = new GlobalKey<FormState>();
  final emailKey = new GlobalKey<FormState>();
  final phoneKey = new GlobalKey<FormState>();
  final passKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  String _password, _name, _surname, _email, _phone;
  SignUpPresenter _presenter;
  SelectCountry _selectContry;

  SignUpScreenState() {
    _presenter = new SignUpPresenter(this);
    _selectContry = SelectCountry(false, "fr");
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  void _submit() {

    nameKey.currentState.save();
    surnameKey.currentState.save();
    emailKey.currentState.save();
    phoneKey.currentState.save();
    passKey.currentState.save();

    if (_name.length == 0 || _surname.length == 0 || _email.length == 0 || _phone.length == 0 || _password.length == 0) {
      setState(() {
        _errorMsg = getLocaleText(context: context, strinKey: StringKeys.ERROR_FILL_ALL_GAPS);
        _showError = true;
      });
    } else {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      if (!regex.hasMatch(_email)) {
        setState(() {
          _errorMsg = getLocaleText(context: context, strinKey: StringKeys.ERROR_INVALID_EMAIL);
          _showError = true;
        });
      } else {

        Client client = new Client(-1, _name + " " + _surname, _password, _surname, _email, "+" + _selectContry.getSelectedPhoneCode() + _phone, false, _name);

        setState(() {
          _isLoading = true;
          _showError = false;
        });

        _presenter.signUp(client);
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    Widget showError() {
      return _showError
          ? Container(
        margin: EdgeInsets.only(
            left: padding_from_screen, right: padding_from_screen, top: 10.0),
        child: Center(
          child: Text(
            _errorMsg,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.red,
                fontSize: 14.0,
                fontWeight: FontWeight.bold),
          ),
        ),
      )
          : Container();
    }

    Container buildEntrieRow(key, IconData startIcon, IconData endIcon,
        String hintText, TextInputType inputType, bool hide_content) {
      Color color = Colors.grey;
      return Container(
          decoration: new BoxDecoration(border: new Border.all(color: color)),
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
          child: Form(
              key: key,
              child: Row(
                children: [
                  Icon(startIcon, color: color),
                  Expanded(
                      child: Container(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: TextFormField(
                              onSaved: (val){
                                if(key == nameKey){
                                  _name = val;
                                }else if(key == surnameKey){
                                  _surname = val;
                                }else if(key == emailKey){
                                  _email = val;
                                }else if(key == phoneKey){
                                  _phone = val;
                                }else if(key == passKey){
                                  _password = val;
                                }
                              },
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
              )
          )
      );
    }

    Widget entriesSection = Container(
      margin: EdgeInsets.only(top: 15.0),
      padding: const EdgeInsets.only(left: padding_from_screen, right: padding_from_screen),
      child: Column(
        children: [
          Row(children: <Widget>[
            new Flexible(
              child: buildEntrieRow(nameKey,Icons.person, null, getLocaleText(context: context, strinKey: StringKeys.NAME_HINT), TextInputType.text, false),
              flex: 1,
            ),
            SizedBox(width: 8.0),
            new Flexible(
              child: buildEntrieRow(surnameKey, Icons.person, null, getLocaleText(context: context, strinKey: StringKeys.SURNAME_HINT), TextInputType.text, false),
              flex: 1,
            ),
          ]),
          buildEntrieRow(emailKey, Icons.email, null, getLocaleText(context: context, strinKey: StringKeys.SIGNUP_EMAIL_HINT), TextInputType.emailAddress, false),
          Row(children: <Widget>[
            new Flexible(
              child: _selectContry,
              flex: 5,
            ),
            SizedBox(width: 8.0),
            new Flexible(
              child: buildEntrieRow(phoneKey, Icons.phone, null, getLocaleText(context: context, strinKey: StringKeys.PHONE_HINT), TextInputType.number, false),
              flex: 6,
            ),
          ]),
          buildEntrieRow(passKey, Icons.lock, null, getLocaleText(context: context, strinKey: StringKeys.SIGNUP_PASSWORD_HINT), TextInputType.text, true),
        ],
      ),
    );

    Widget buttonSection = Container(
        padding: const EdgeInsets.only(
            left: padding_from_screen, right: padding_from_screen, top: 10.0, bottom: 15.0),
        child: RaisedButton(
          onPressed: _submit,
          child: SizedBox(
            width: double.infinity,
            child: Text(getLocaleText(context: context, strinKey: StringKeys.SIGN_UP),
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
                getLocaleText(context: context, strinKey: StringKeys.CONFIDENTIALITE_BEGIN),
                style: new TextStyle(
                  color: Colors.black54,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                )),
            new TextSpan(
                text: getLocaleText(context: context, strinKey: StringKeys.CONDITIONS_GENERALES),
                style: new TextStyle(
                  color: Colors.lightGreen,
                  decoration: TextDecoration.underline,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                )),
            new TextSpan(
                text: getLocaleText(context: context, strinKey: StringKeys.AND),
                style: new TextStyle(
                  color: Colors.black54,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                )),
            new TextSpan(
              text: getLocaleText(context: context, strinKey: StringKeys.CONFIDENTIALITE),
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
        key: scaffoldKey,
        body: Stack(
          children: <Widget>[
            ScrollConfiguration(
                behavior: MyBehavior(),
                child: ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 5.0),
                      child: Image.asset(
                        'images/icone_launcher.png',
                        height: 210.0,
                        fit: BoxFit.contain,
                      ),
                    ),
                    entriesSection,
                    showError(),
                    conditionsSection,
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
                        : buttonSection,
                  ],
                )
            ),
            Container(
              height: AppBar().preferredSize.height,
              child: AppBar(
                iconTheme: IconThemeData(
                  color: Colors.black, //change your color here
                ),
                title: Text(getLocaleText(context: context, strinKey: StringKeys.SIGNUP_PAGE_TITLE),
                    style: TextStyle(
                        color: Colors.black
                    )),
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
    _showSnackBar(getLocaleText(context: context, strinKey: StringKeys.ERROR_CONNECTION_FAILED));
    setState(() => _isLoading = false);
  }

  @override
  void onSignUpError() {

    setState(() {
      _isLoading = false;
      _errorMsg = getLocaleText(context: context, strinKey: StringKeys.ERROR_ACCOUNT_ALREADY_EXISTS);
      _showError = true;
    });
  }

  @override
  void onSignUpSuccess(int clientID) {

    setState(() => _isLoading = false);
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (context) => ConfirmAccountScreen(clientId: clientID, isForResetPassword: false, clientEmail: _email,)));
  }

}