import 'package:flutter/material.dart';
import '../Utils/MyBehavior.dart';

class Accueil extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    Container getItem() {
      return Container(
        margin: EdgeInsets.only(right: 15.0),
        padding: EdgeInsets.all(8.0),
        color: Colors.white,
        width: 230.0,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                margin: EdgeInsets.only(bottom: 4.0),
                child: Image.asset(
                  'images/plat.png',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              flex: 7,
            ),
            Expanded(
              child: Center(
                child: Container(
                  width: double.infinity,
                  child: new Text(
                      "Sandwich au poulet croustillant hhdhh dhdhhdhdhddddd",
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
              flex: 1,
            ),
            Expanded(
              child: Center(
                child: Container(
                  width: double.infinity,
                  child: Row(
                    children: <Widget>[
                      Expanded(child: new Text("5,000",
                          textAlign: TextAlign.left,
                          style: new TextStyle(
                            color: Colors.black,
                            fontFamily: 'Roboto',
                            decoration: TextDecoration.none,
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                          ))
                      ),
                      Icon(Icons.shopping_cart, color: Color.fromARGB(255, 255, 215, 0),size: 14.0, ),
                    ],
                  ),
                ),
              ),
              flex: 1,
            ),
            Expanded(
              child: Center(
                child: Container(
                  padding: EdgeInsets.only(top: 3.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left : 10.0, right: 10.0),
                        decoration: new BoxDecoration(border: new Border.all(color: Colors.lightGreen, style: BorderStyle.solid, width: 0.5)),
                        child: new Text("5-15 min",
                            textAlign: TextAlign.left,
                            style: new TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.none,
                              fontSize: 11.0,
                              fontWeight: FontWeight.normal,
                            )),
                      ),
                      Container(
                        padding: EdgeInsets.only(left : 5.0, right: 5.0),
                        decoration: new BoxDecoration(border: new Border.all(color: Colors.lightGreen, style: BorderStyle.solid, width: 0.5)),
                        child: Row(
                          children: <Widget>[
                            new Text("4.5",
                                textAlign: TextAlign.left,
                                style: new TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.normal,
                                )),
                            Icon(Icons.star, color: Color.fromARGB(255, 255, 215, 0),size: 10.0, ),
                            new Text("(243)",
                                textAlign: TextAlign.left,
                                style: new TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.normal,
                                ))
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left : 10.0, right: 10.0),
                        decoration: new BoxDecoration(border: new Border.all(color: Colors.lightGreen, style: BorderStyle.solid, width: 0.5)),
                        child: new Text("Livraison",
                            textAlign: TextAlign.left,
                            style: new TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.none,
                              fontSize: 11.0,
                              fontWeight: FontWeight.normal,
                            )),
                      )

                    ],
                  ),
                ),
              ),
              flex: 1,
            )
          ],
        ),
      );
    }

    Container getSection(int index) {
      String getTitle() {
        switch (index) {
          case 1:
            return "Restaurant pres de chez vous";
          case 2:
            return "Les meilleurs deals";
          default:
            return "Tendances de la semaine";
        }
      }

      return Container(
        height: 300.0,
        padding: EdgeInsets.only(top: 15.0, left: 15.0, bottom: 15.0),
        color: Color.fromARGB(200, 255, 255, 255),
        margin: EdgeInsets.only(bottom: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 10.0),
              child: new Text(
                getTitle(),
                textAlign: TextAlign.left,
                style: new TextStyle(
                  color: Colors.black,
                  decoration: TextDecoration.none,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: new ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 8 /*litems.length*/,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return getItem();
                    }),
              ),
            )
          ],
        ),
      );
    }

    return Container(
        color: Colors.black12,
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: new ListView.builder(
              padding: EdgeInsets.all(0.0),
              scrollDirection: Axis.vertical,
              itemCount: 3 /*litems.length*/,
              itemBuilder: (BuildContext ctxt, int index) {
                return getSection(index);
              }),
        ));
  }
}
