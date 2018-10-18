import 'package:flutter/material.dart';
import '../Utils/MyBehavior.dart';

class Categories extends StatelessWidget {

  Container getItem() {
    return Container(
      padding: EdgeInsets.only(right: 4.0, bottom: 4.0),
      color: Colors.white,
      width: 200.0,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                Image.asset(
                  'images/plat.png',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),

                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 5.0, right: 5.0),
                    child: Text("salade",
                    style: TextStyle(
                      color: Colors.lightGreen,
                      decoration: TextDecoration.none,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    )),
                  ),
                )
              ],
            ),
            flex: 7,
          ),
        ],
      ),
    );
  }

  Container getSection(int index) {
    String getTitle() {
      switch (index) {
        case 1:
          return "D'autres catégories";

        default:
          return "Meilleures catégories";
      }
    }

    return Container(
      padding: EdgeInsets.only(top: 10.0, left: 5.0),
      color: Colors.white,
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
                fontSize: 15.0,
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

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Expanded(
              child: getSection(0),
              flex: 1,
            ),
            Expanded(
              child: getSection(1),
              flex: 1,
            )
          ],
        ));
  }
}
