import 'package:flutter/material.dart';
import 'package:client_app/Utils/MyBehavior.dart';
import 'SignInScreen.dart';
import 'Utils/AppSharedPreferences.dart';
import 'DAO/Presenters/ResetPassPresenter.dart';
import 'StringKeys.dart';

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
        _errorMsg = getLocaleText(context: context, strinKey: StringKeys.ERROR_FILL_ALL_GAPS);
        _showError = true;
      });
    } else if (_pass != _confirm) {
      setState(() {
        _errorMsg = getLocaleText(context: context, strinKey: StringKeys.ERROR_PASS_AND_CONFIRM_NOT_MATCH);
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
            child: Text(getLocaleText(context: context, strinKey: StringKeys.UPDATE_BTN),
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
                      Container(
                        child: Image.asset(
                          'images/logo-header.png',
                          height: 200.0,
                          fit: BoxFit.contain,
                        ),
                      ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 20.0,
                        bottom: 40.0,
                        left: padding_from_screen,
                        right: padding_from_screen),
                    child: new Text(
                        getLocaleText(context: context, strinKey: StringKeys.RESET_PASS_DESCRIPTION_TEXT),
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
                        passKey, getLocaleText(context: context, strinKey: StringKeys.NEW_PASSWORD_HINT)),
                  ),
                  Container(
                    color: Colors.black12,
                    margin: EdgeInsets.only(
                        left: padding_from_screen, right: padding_from_screen),
                    child:
                        buildPassEntry(confirmKey, getLocaleText(context: context, strinKey: StringKeys.CONFIRM_PASSWORD_HINT)),
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
              height: AppBar().preferredSize.height+50,
              child: AppBar(
                iconTheme: IconThemeData(
                  color: Colors.black, //change your color here
                ),
                title: Text(getLocaleText(context: context, strinKey: StringKeys.RECOVERY_PAGE_TITLE),
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
  void onResetError() {
    setState(() {
      _isLoading = false;
      _errorMsg = getLocaleText(context: context, strinKey: StringKeys.ERROR_OCCURED);
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
          title: new Text(getLocaleText(context: context, strinKey: StringKeys.RESET_SUCCESS_TITLE)),
          content: new Text(
              getLocaleText(context: context, strinKey: StringKeys.RESET_SUCCESS_MESSAGE)),
          actions: <Widget>[
            new FlatButton(
              child: new Text(getLocaleText(context: context, strinKey: StringKeys.OK_BTN)),
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
