import 'package:client_app/Utils/MyBehavior.dart';

import 'Database/DatabaseHelper.dart';
import 'Models/Client.dart';
import 'package:flutter/material.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';
import 'package:flutter/services.dart';
import 'Database/DatabaseHelper.dart';
import 'DAO/Presenters/UpdateAccountInfosPresenter.dart';

class AccountScreen extends StatefulWidget {
  @override
  createState() => new AccountStateScreen();
}

class AccountStateScreen extends State<AccountScreen> implements UpdateAccountInfosContract {

  bool isOnEditingMode = false;
  Client client;
  bool _isLoading = false;

  final nameKey = new GlobalKey<FormState>();
  final lastnameKey = new GlobalKey<FormState>();
  final firstnameKey = new GlobalKey<FormState>();
  final phoneKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  UpdateAccountInfosPresenter _presenter;

  String _name, _firstname, _lastname, _phone;

  AccountStateScreen(){
    _presenter = new UpdateAccountInfosPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  void _submit() {
    nameKey.currentState.save();
    firstnameKey.currentState.save();
    lastnameKey.currentState.save();
    phoneKey.currentState.save();

    if (_name.length == 0 || _firstname.length == 0 || _lastname.length == 0 || _phone.length == 0) {
      _showSnackBar("Renseigner tous les champs");
    } else {


      client.username = _name;
      client.firstname = _firstname;
      client.lastname = _lastname;
      client.phone = _phone;

      setState(() {
        _isLoading = true;
      });

      _presenter.updateAccountDatas(client);
    }
  }

  Widget getAppropriateItem(key, String hintText, bool editable) {
    if (isOnEditingMode && editable) {
      return Form(
          key: key,
          child: TextFormField(
              onSaved: (val) {
                if (key == nameKey)
                  _name = val;
                else if (key == firstnameKey)
                  _firstname = val;
                else if (key == lastnameKey)
                  _lastname = val;
                else if (key == phoneKey) _phone = val;
              },
              obscureText: false,
              autofocus: false,
              autocorrect: false,
              maxLines: 1,
              initialValue: hintText == null ? "" : hintText,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(0.0),
                  border: InputBorder.none,
                  hintText: hintText == null ? "Non définit" : hintText),
              style: TextStyle(
                fontSize: 13.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              )));
    } else {
      return Text(hintText == null ? "Non définit" : hintText,
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
          style: new TextStyle(
            color: Colors.black,
            fontSize: 13.0,
            fontWeight: FontWeight.bold,
          ));
    }
  }

  Widget buildUserItem(
      key, String label, String titleText, bool show_border, bool editable) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      decoration: new BoxDecoration(
          border: !show_border
              ? new Border()
              : new Border(
                  bottom: BorderSide(
                      color: Colors.grey,
                      style: BorderStyle.solid,
                      width: 1.0)),
          color: Colors.white),
      child: Center(
        child: Container(
          width: double
              .infinity, // remove this line in order to center the content of each element
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 15.0),
                child: Text(label,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: new TextStyle(
                      color: Colors.grey,
                      fontSize: 12.0,
                      fontWeight: FontWeight.normal,
                    )),
              ),
              Container(
                  color: isOnEditingMode && editable
                      ? Color.fromARGB(5, 0, 0, 0)
                      : Colors.transparent,
                  margin: EdgeInsets.only(top: 5.0, bottom: 10.0),
                  padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: getAppropriateItem(key, titleText, editable))
            ],
          ),
        ),
      ),
    );
  }

  Widget getActionButton() {
    if (isOnEditingMode) {
      return Container(
          color: Colors.white,
          padding: const EdgeInsets.only(
            top: 30.0,
            bottom: 20.0,
            left: 20.0,
            right: 20.0,
          ),
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : RaisedButton(
                  onPressed: _submit,
                  child: SizedBox(
                    width: double.infinity,
                    child: Text("Enregistrer",
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
    } else {
      return Container();
    }
  }

  Widget getAppropriateRootView(Widget child) {
    return Scaffold(
      key: scaffoldKey,
      //resizeToAvoidBottomPadding: false, // this avoids the overflow error
      body: child,
      floatingActionButton: !isOnEditingMode
          ? Container(
              margin: EdgeInsets.only(bottom: 30.0, right: 10.0),
              child: FloatingActionButton(
                backgroundColor: Colors.lightGreen,
                onPressed: () {
                  setState(() {
                    isOnEditingMode = true;
                  });
                },
                mini: false,
                child: Icon(Icons.edit, size: 30.0),
              ),
            )
          : null,
    );
  }

  Widget getContent() {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              height: 150.0,
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 40.0),
                    child: Image.asset(
                      'images/logo-header.png',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Container(
                    color: Color.fromARGB(0, 0, 255, 0),
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  isOnEditingMode && false
                      ? Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
                            padding: EdgeInsets.all(10.0),
                            decoration: new BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: PositionedTapDetector(
                              onTap: (position) {
                                // TODO: select picture in Gallery or launch camera

                              },
                              child: Icon(Icons.camera_enhance),
                            ),
                          ),
                        )
                      : new Container()
                ],
              ),
            ),
            Expanded(
                child: ScrollConfiguration(behavior: MyBehavior(), child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Text("Informations de compte",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          color: Colors.black
                        ),),
                      ),
                      buildUserItem(
                          null, "Email", client.email, true, false),
                      buildUserItem(
                          nameKey, "username", client.username, true, true),
                      buildUserItem(
                          firstnameKey, "Nom", client.firstname == null ||  client.firstname.length == 0 ? client.username.split(" ")[0] : client.firstname, true, true),
                      buildUserItem(
                          lastnameKey, "Prénom", client.lastname, true, true),
                      buildUserItem(
                          phoneKey, "Numéro", client.phone, true, true),

                      getActionButton()
                    ],
                  ),
                )))
          ],
        ),
        Container(
          height: AppBar().preferredSize.height+50,
          child: AppBar(
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
        ),
      ],
    );
  }

  Widget getPageBody() {
    return FutureBuilder(
      future: DatabaseHelper().loadClient(),
      builder: (BuildContext buildContext, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          client = snapshot.data;
          return getContent();
        } else
          return Container(
              height: double.infinity,
              width: double.infinity,
              child: Center(
                child: CircularProgressIndicator(),
              ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(child: getAppropriateRootView(getPageBody()));
  }

  @override
  void onConnectionError() {
    _showSnackBar("Échec de connexion. Vérifier votre connexion internet");
    setState(() => _isLoading = false);
  }

  @override
  void onRequestError() {
    _showSnackBar("Erreur survénue. Réessayez svp");
    setState(() => _isLoading = false);
  }

  @override
  void onRequestSuccess(Client client) {
    DatabaseHelper().updateClient(client).then((success){

      setState((){ _isLoading = false; isOnEditingMode = false;});
      _showSnackBar("Modification des informations réussie");

    });

  }
}
