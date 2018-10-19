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
  HomeAppBar({this.title});

  final Widget title;

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
          padding: EdgeInsets.only(left: 8.0, right: 8.0),
          decoration: BoxDecoration(color: Colors.white),
          // Row is a horizontal, linear layout.
          child: Center(
            child: Row(
              // <Widget> is the type of items in the list.
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.menu, color: Colors.black),
                  tooltip: 'Navigation menu',
                  onPressed: null, // null disables the button
                ),
                // Expanded expands its child to fill the available space.
                Expanded(
                  child: widget.title,
                ),
                IconButton(
                  icon: Icon(Icons.arrow_drop_down, color: Colors.lightGreen,),
                  tooltip: 'Search',
                  onPressed: null,
                ),
              ],
            ),
          )),
    );
  }
}

Widget researchBox(String hintText, Color bgdColor, Color textColor, Color borderColor) {
  return Container(
    padding: EdgeInsets.only(left: 20.0, right: 20.0),
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
                    fontSize: 12.0,
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ))))
    ]),
  );
}
