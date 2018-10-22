import 'dart:async';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';
import 'package:flutter/material.dart';
import '../Utils/MyBehavior.dart';

class Commandes extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new CommandesState();
}

class CommandesState extends State<Commandes> {


  Widget getDivider(double height, {bool horizontal}) {
    return Container(
      width: horizontal ? double.infinity : height,
      height: horizontal ? height : double.infinity,
      color: Color.fromARGB(15, 0, 0, 0),
    );
  }


  Widget researchBox(String hintText, Color bgdColor, Color textColor, Color borderColor) {
    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0),
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      decoration: new BoxDecoration(
          color: bgdColor,
          border: new Border(
            top: BorderSide(
                color: borderColor, style: BorderStyle.solid, width: 1.0),
            bottom: BorderSide(
                color: borderColor, style: BorderStyle.solid, width: 1.0),
            left: BorderSide(
                color: borderColor, style: BorderStyle.solid, width: 1.0),
            right: BorderSide(
                color: borderColor, style: BorderStyle.solid, width: 1.0),
          )),
      child: Row(children: [
        Icon(
          Icons.search,
          color: textColor,
          size: 25.0,
        ),
        Expanded(
            child: Container(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: TextFormField(
                    autofocus: false,
                    autocorrect: false,
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: hintText,
                        hintStyle: TextStyle(color: textColor)),
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ))))
      ]),
    );
  }

  String _value = new DateTime.now().toString().substring(0, 11);
  int cliked = 0;

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2016),
        lastDate: new DateTime(2019)
    );
    if(picked != null) setState(() => _value = picked.toString().substring(0, 11));
  }

  Widget getDatedBox() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[

        Expanded(
          child: PositionedTapDetector(
            onTap: (position){
              setState(() {
                cliked = 0;
              });

              // Todo : traiter l'action ensuite
            },
            child: Container(
              height: double.infinity,
              margin: EdgeInsets.only(right: 5.0, left: 5.0),
              decoration: BoxDecoration(border: Border.all(color: cliked == 0 ? Colors.lightGreen : Colors.grey, width: 2.0),),
              child: Center(
                child: Text("Semaine"),
              ),

            ),
          ), flex: 3,),

        Expanded(
          child: PositionedTapDetector(
            onTap: (position){
              setState(() {
                cliked = 1;
              });

              // Todo : traiter l'action ensuite
            },
            child: Container(
              height: double.infinity,
              decoration: BoxDecoration(border: Border.all(color: cliked == 1 ? Colors.lightGreen : Colors.grey, width: 2.0)),
              child: Center(
                child: Text("Mois"),
              ),

            ),
          ), flex: 2,),

        Expanded(
          child: PositionedTapDetector(
            onTap: (position){
              setState(() {
                cliked = 2;
              });

              // Todo : traiter l'action ensuite
            },
            child: Container(
              margin: EdgeInsets.only(left: 5.0),
              height: double.infinity,
              decoration: BoxDecoration(border: Border.all(color: cliked == 2 ? Colors.lightGreen : Colors.grey, width: 2.0)),
              child: Center(
                child: Text("Année"),
              ),

            ),
          ), flex: 2,),

        Expanded(
          child: PositionedTapDetector(
            onTap: (position){
              _selectDate();
            },
            child: Container(
              margin: EdgeInsets.only(left: 5.0, right: 5.0),
              height: double.infinity,
              decoration: BoxDecoration(border: Border.all(color: cliked == 3 ? Colors.lightGreen : Colors.grey, width: 2.0)),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.calendar_today, size: 15.0,),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(_value),
                    ),
                    Icon(Icons.arrow_drop_down)
                  ],
                ),
              ),

            ),
          ), flex: 6,),
      ],
    );
  }

  Widget getItem(int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        getDivider(4.0, horizontal: true),
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 10.0),
          child: RichText(
            text: new TextSpan(
              children: [
                new TextSpan(
                    text: "Commande N° ",
                    style: new TextStyle(
                      color: Colors.blue[900],
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    )),
                new TextSpan(
                    text: (index + 300953771).toString(),
                    style: new TextStyle(
                      color: Colors.black54,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ))
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Qté produit: " + 5.toString(),
                textAlign: TextAlign.left,
                style: new TextStyle(
                  color: Colors.black,
                  decoration: TextDecoration.none,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                )),
            Text("Total: " + 2500.toString(),
                textAlign: TextAlign.left,
                style: new TextStyle(
                  color: Colors.blue[900],
                  decoration: TextDecoration.none,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("juin 13, 2018",
                  textAlign: TextAlign.left,
                  style: new TextStyle(
                    color: Colors.black54,
                    decoration: TextDecoration.none,
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                  )),
              Text("11h 52min",
                  textAlign: TextAlign.left,
                  style: new TextStyle(
                    color: Colors.black54,
                    decoration: TextDecoration.none,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        color: Color.fromARGB(25, 0, 0, 0),
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[

              Expanded(
                child: Container(
                  padding : EdgeInsets.only(top: 5.0),
                  child: getDatedBox(),
                ),
                flex: 1,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: researchBox("Chercher ici", Color.fromARGB(15, 0, 0, 0),
                    Colors.grey, Colors.transparent),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: new ListView.builder(
                        padding: EdgeInsets.all(0.0),
                        scrollDirection: Axis.vertical,
                        itemCount: 20 /*litems.length*/,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return getItem(index);
                        }),
                  ),
                ),
                flex: 8,
              )
            ],
          ),
        ));
  }
}
