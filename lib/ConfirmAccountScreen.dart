import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';
import 'ResetPasswordScreen.dart';
import 'package:client_app/Utils/MyBehavior.dart';
import 'DAO/Presenters/ConfirmPresenter.dart';
import 'HomeScreen.dart';
import 'Utils/AppSharedPreferences.dart';

class ConfirmAccountScreen extends StatefulWidget {
  @override

  final int clientId;
  final String clientEmail;
  final bool isForResetPassword;
  ConfirmAccountScreen({@required this.clientId, @required this.isForResetPassword, @required this.clientEmail});

  createState() => new ConfirmAccountState();
}

class ConfirmAccountState extends State<ConfirmAccountScreen> implements ConfirmContract{

  bool _showError = false;
  bool _isLoading = false;
  String _errorMsg ;

  final unKey = new GlobalKey<FormState>();
  final deuxKey = new GlobalKey<FormState>();
  final troisKey = new GlobalKey<FormState>();
  final quatreKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  String _un, _deux, _trois, _quatre;
  ConfirmPresenter _presenter;

  ConfirmAccountState() {
    _presenter = new ConfirmPresenter(this);
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  void _submit() {

    unKey.currentState.save();
    deuxKey.currentState.save();
    troisKey.currentState.save();
    quatreKey.currentState.save();

    if (_un.length == 0 || _deux.length == 0 || _trois.length == 0 || _quatre.length == 0) {
      setState(() {
        _errorMsg = "Compléter le code";
        _showError = true;
      });
    } else {
      String code = _un + _deux + _trois + _quatre;
      setState(() {
        _isLoading = true;
        _showError = false;
      });

      _presenter.verifyCode(code);
    }
  }


  Widget showError() {
    return _showError
        ? Container(
      margin: EdgeInsets.only(top: 10.0),
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




  @override
  Widget build(BuildContext context) {

    const double padding_from_screen = 30.0;

    Container buildCase(key) {
      Color color = Colors.grey;

      return Container(
          decoration: new BoxDecoration(
            border: new Border.all(color: color),
          ),
          margin: EdgeInsets.only(left: 10.0, right: 10.0),
          padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
          child: Form(
            key: key,
              child: TextFormField(
                onSaved: (val){
                  if(key == unKey){
                    _un = val;
                  }else if(key == deuxKey){
                    _deux = val;
                  }else if(key == troisKey){
                    _trois = val;
                  }else if(key == quatreKey){
                    _quatre = val;
                  }
                },
                  autofocus: false,
                  autocorrect: false,
                  textAlign: TextAlign.center,
                  inputFormatters:[
                    LengthLimitingTextInputFormatter(1),
                  ],
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ))
          ));
    }

    Widget codeSection = Container(
      padding: EdgeInsets.only(left: padding_from_screen - 10.0, right: padding_from_screen - 10.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: buildCase(unKey),
            ),
            Expanded(
              child: buildCase(deuxKey),
            ),
            Expanded(
              child: buildCase(troisKey),
            ),
            Expanded(
              child: buildCase(quatreKey),
            )
          ]),
    );

    Widget buttonSection = Container(
      margin: EdgeInsets.only(top: 20.0),
        padding: EdgeInsets.only(
            left: padding_from_screen, right: padding_from_screen, top: 25.0, bottom: 20.0),
        child: Center(
          child: RaisedButton(
            onPressed: (){ //_submit()
              if(widget.isForResetPassword) {

                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) => ResetPasswordScreen(clientId: widget.clientId,)));

              }else{

                AppSharedPreferences().setAppLoggedIn(true); // on memorise qu'un compte s'est connecter
                Navigator.of(context).pushAndRemoveUntil(
                    new MaterialPageRoute(builder: (context) => HomeScreen()), ModalRoute.withName(Navigator.defaultRouteName));
              }
            },
            child: SizedBox(

              child: Text("VALIDER",
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
          ),
        ));



    return Material(
      child: Scaffold(
        key: scaffoldKey,
        body: Stack(
          children: <Widget>[
            ScrollConfiguration(
                behavior: MyBehavior(),
                child: ListView(
                  physics: new ClampingScrollPhysics(),
                  children: [
                    Image.asset(
                      'images/header.jpg',
                      width: double.infinity,
                      height: 210.0,
                      fit: BoxFit.fill,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: 50.0, bottom: 30.0, left: padding_from_screen, right: padding_from_screen),
                      child: new RichText(
                        text: new TextSpan(
                          children: [
                            new TextSpan(
                                text:
                                'Saississez le code envoyé à l\'adresse ',
                                style: new TextStyle(
                                  color: Colors.black54,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                )),
                            new TextSpan(
                                text: widget.clientEmail,
                                style: new TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ))
                          ],
                        ),
                      ),
                    ),
                    codeSection,
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
                title: Text('Code de confirmation'),
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
  void onConfirmError() {
    setState(() {
      _isLoading = false;
      _errorMsg = "Code incorrect";
      _showError = true;
    });
  }

  @override
  void onConfirmSuccess() {

    setState(() => _isLoading = false);
    if(widget.isForResetPassword) {

      Navigator.of(context).push(new MaterialPageRoute(
          builder: (context) => ResetPasswordScreen(clientId: widget.clientId,)));

    }else{

      AppSharedPreferences().setAppLoggedIn(true); // on memorise qu'un compte s'est connecter
      Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(builder: (context) => HomeScreen()), ModalRoute.withName(Navigator.defaultRouteName));
    }
  }

  @override
  void onConnectionError() {
    _showSnackBar("Échec de connexion. Vérifier votre connexion internet");
    setState(() => _isLoading = false);
  }
}
