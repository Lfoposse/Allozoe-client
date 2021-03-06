import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';

class MyNavigationAppBar extends StatelessWidget {
  MyNavigationAppBar(this.title);

  // Fields in a Widget subclass are always marked "final".

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 56.0, // in logical pixels
        margin: EdgeInsets.only(top: 30.0),
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(color: Colors.transparent),
        child: AppBar(
          title: Text(title),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ));
  }
}

class HomeAppBar extends StatefulWidget {
  HomeAppBar();

  @override
  createState() => new HomeAppBarState();
}

class HomeAppBarState extends State<HomeAppBar> {
  // Fields in a Widget subclass are always marked "final".

  double _statusBarHeight = 0.0;

  Future<void> initPlatformState() async {
    double statusBarHeight;
    statusBarHeight = await FlutterStatusbarManager.getHeight;
    setState(() {
      _statusBarHeight = statusBarHeight;
    });
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Container(
          height: 56.0, // in logical pixels
          margin: EdgeInsets.only(
              top: _statusBarHeight == 0 ? 40.0 : _statusBarHeight),
          padding:
              EdgeInsets.only(left: 8.0, right: 8.0, top: 3.0, bottom: 3.0),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Center(
            child: Image.asset(
              'images/logo-header.png',
              fit: BoxFit.fill,
            ),
          )),
    );
  }
}

Widget researchBox(
    String hintText, Color bgdColor, Color textColor, Color borderColor) {
  return Container(
    padding: EdgeInsets.only(left: 10.0, right: 10.0),
    decoration: new BoxDecoration(
        color: bgdColor,
        border: new Border(
          top: BorderSide(
              color: borderColor, style: BorderStyle.solid, width: 1.0),
          bottom: BorderSide(
              color: borderColor, style: BorderStyle.solid, width: 1.0),
          left: BorderSide(
              color: borderColor, style: BorderStyle.solid, width: 1.5),
          right: BorderSide(
              color: borderColor, style: BorderStyle.solid, width: 1.5),
        )),
    child: Row(children: [
      Icon(Icons.search, color: textColor),
      Expanded(
          child: Container(
              padding: EdgeInsets.only(left: 5.0, right: 5.0),
              child: TextFormField(
                  autofocus: false,
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: hintText,
                      hintStyle: TextStyle(color: textColor)),
                  style: TextStyle(
                    fontSize: 12.0,
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ))))
    ]),
  );
}

Widget researchBoxLeft(
    String hintText, Color bgdColor, Color textColor, Color borderColor) {
  return Container(
    alignment: Alignment.topRight,
    padding: EdgeInsets.only(left: 10.0, right: 10.0),
    decoration: new BoxDecoration(
        color: Colors.red,
        border: new Border(
          top: BorderSide(
              color: borderColor, style: BorderStyle.solid, width: 1.0),
          bottom: BorderSide(
              color: borderColor, style: BorderStyle.solid, width: 1.0),
          left: BorderSide(
              color: borderColor, style: BorderStyle.solid, width: 1.5),
          right: BorderSide(
              color: borderColor, style: BorderStyle.solid, width: 1.5),
        )),
    child: Row(children: [
      Icon(Icons.search, color: textColor),
      Expanded(
          child: Container(
              padding: EdgeInsets.only(left: 5.0, right: 5.0),
              child: TextFormField(
                  autofocus: false,
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: hintText,
                      hintStyle: TextStyle(color: textColor)),
                  style: TextStyle(
                    fontSize: 12.0,
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ))))
    ]),
  );
}
