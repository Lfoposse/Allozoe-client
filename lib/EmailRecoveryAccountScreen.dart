import 'package:flutter/material.dart';
import 'Utils/MyBehavior.dart';
import 'DAO/Presenters/EmailRecoveryAccountPresenter.dart';
import 'ConfirmAccountScreen.dart';
import 'StringKeys.dart';

class EmailRecoveryAccountScreen extends StatefulWidget {
  @override
  createState() => new EmailRecoveryAccountScreenState();
}

class EmailRecoveryAccountScreenState extends State<EmailRecoveryAccountScreen>
    implements EmailRecoveryAccountContract{

  bool _isLoading = false;
  bool _showError = false;
  String _errorMsg = "";
  static const double padding_from_screen = 30.0;

  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String _email;

  EmailRecoveryAccountPresenter _presenter;

  EmailRecoveryAccountScreenState() {
    _presenter = new EmailRecoveryAccountPresenter(this);
  }

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();

      if(_email.length == 0) {
        setState(() {
          _errorMsg = getLocaleText(context: context, strinKey: StringKeys.ERROR_ENTER_EMAIL);
          _showError = true;
        });
      }else {
        Pattern pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regex = new RegExp(pattern);
        if (!regex.hasMatch(_email)) {
          setState(() {
            _errorMsg = getLocaleText(context: context, strinKey: StringKeys.ERROR_INVALID_EMAIL);
            _showError = true;
          });
        }else {
          setState((){
            _isLoading = true;
            _showError = false;
          });
          _presenter.checkAccount(_email);
        }
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
          left: padding_from_screen, right: padding_from_screen, top: 10.0),
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


    Container buildEntrieRow(IconData startIcon, IconData endIcon,
        String hintText, TextInputType inputType, bool hide_content) {
      Color color = Colors.grey;
      return Container(
        decoration: new BoxDecoration(border: new Border.all(color: color)),
        padding: EdgeInsets.only(left: 10.0, right: 10.0),
        child: new Form(
            key: formKey,
            child: Row(
              children: [
                Icon(startIcon, color: color),
                Expanded(
                    child: Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: TextFormField(
                            onSaved: (val) => _email = val,
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
            )),
      );
    }

    Widget buttonSection = Container(
        padding: const EdgeInsets.only(
            left: padding_from_screen + 20.0,
            right: padding_from_screen + 20.0,
            top: 40.0,
            bottom: 15.0),
        child: RaisedButton(
          onPressed: _submit,
          child: SizedBox(
            width: double.infinity,
            child: Text(getLocaleText(context: context, strinKey: StringKeys.NEXT_BTN),
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
                          top: 20.0,
                          bottom: 30.0,
                          left: padding_from_screen,
                          right: padding_from_screen),
                      child:
                      new Text(getLocaleText(context: context, strinKey: StringKeys.RECOVERY_DESCRIPTION_TEXT),
                          style: new TextStyle(
                            color: Colors.black54,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: padding_from_screen, right: padding_from_screen),
                      decoration: new BoxDecoration(
                          border: new Border.all(color: Colors.grey)),
                      child: buildEntrieRow(Icons.email, null, getLocaleText(context: context, strinKey: StringKeys.SIGNUP_EMAIL_HINT),
                          TextInputType.emailAddress, false),
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
                        : buttonSection,
                  ],
                )),
            Container(
              height: AppBar().preferredSize.height,
              child: AppBar(
                title: Text(getLocaleText(context: context, strinKey: StringKeys.RECOVERY_PAGE_TITLE)),
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
  void onLoadingError() {
    setState(() {
      _isLoading = false;
      _errorMsg = getLocaleText(context: context, strinKey: StringKeys.ERROR_UNKOWN_EMAIL);
      _showError = true;

    });
  }

  @override
  void onLoadingSuccess(int clientID) async {

    setState(() => _isLoading = false);
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (context) => ConfirmAccountScreen(clientId: clientID, isForResetPassword: true, clientEmail: _email,)));
  }

  @override
  void onConnectionError() {

    _showSnackBar(getLocaleText(context: context, strinKey: StringKeys.ERROR_CONNECTION_FAILED));
    setState(() => _isLoading = false);
  }
}
