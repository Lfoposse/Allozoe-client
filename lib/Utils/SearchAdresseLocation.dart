import 'dart:convert';

import 'package:client_app/DAO/Rest_dt.dart';
import 'package:client_app/Models/Google_place.dart';
import 'package:flutter/material.dart';

class SearchAdressePage extends StatefulWidget {
  final double latitude;
  final double longitude;
  SearchAdressePage({Key key, this.latitude, this.longitude}) : super(key: key);
  @override
  SearchAdressePageState createState() => new SearchAdressePageState();
}

class SearchAdressePageState extends State<SearchAdressePage> {
  TextEditingController _searchAdresse;

  RestDatasource api = new RestDatasource();
  var _locations = new List<GooglePlacesItem>();

  @override
  initState() {
    super.initState();
    _searchAdresse = new TextEditingController();
  }

  _findLocation(String input) {
    api
        .findLocation(input, "fr", widget.latitude, widget.longitude)
        .then((response) {
      final String responseString = response.body;
      setState(() {
        GooglePlacesModel placesModel =
            new GooglePlacesModel.fromJson(json.decode(responseString));
        _locations = placesModel.predictions;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 40.0),
        child: Column(
          children: <Widget>[
            Card(
              elevation: 4.0,
              margin: EdgeInsets.only(left: 10.0, right: 10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Container(
                  margin: EdgeInsets.only(
                      top: 2.0, bottom: 2.0, left: 4.0, right: 4.0),
                  child: Column(children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 5.0),
                          child: IconButton(
                            onPressed: () {
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              }
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: new TextField(
                            controller: _searchAdresse,
                            enabled: true,
                            autofocus: true,
                            enableInteractiveSelection: true,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 19.0,
                            ),
                            decoration: new InputDecoration(
                              contentPadding: EdgeInsets.all(12.0),
                              hintText: "Adresse de livraison ",
                              hintStyle: TextStyle(color: Colors.black54),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                            ),
                            onChanged: (text) {
                              if (text.isNotEmpty) {
                                _findLocation(text);
                                return;
                              } else {
                                setState(() {
                                  _searchAdresse.text = "";
                                });
                              }
                            },
                          ),
                        ),
                        _searchAdresse.text.isNotEmpty
                            ? Expanded(
                                flex: 0,
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _searchAdresse.text = "";
                                    });
                                  },
                                  icon: Icon(Icons.clear, color: Colors.black),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ])),
            ),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.all(8.0),
                itemCount: _locations.length,
                itemBuilder: (context, index) {
                  String title = _locations[index].terms[0].value;
                  String subtitle = "";

                  for (int i = 1; i < _locations[index].terms.length; i++) {
                    subtitle = _locations[index].terms[i].value + ", ";
                  }
                  return ListTile(
                    leading: Icon(
                      Icons.location_on,
                      color: Colors.black,
                    ),
                    title: Text(
                      title,
                      style: TextStyle(color: Colors.black),
                    ),
                    subtitle: Text(subtitle),
                    onTap: () {
                      Navigator.of(context).pop(_locations[index]);
                      print("onTap Location item index=${index}");
                      print("Destinatiion Selected " +
                          _locations[index].description);
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
