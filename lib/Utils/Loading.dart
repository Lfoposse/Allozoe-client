import 'package:flutter/material.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';

class ShowLoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
            ),
            Text("Loading datas",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0
            ),)
          ],
        ),
      ),
    );
  }
}

class ShowConnectionErrorView extends StatelessWidget {

  final void Function() onRetryClick;
  ShowConnectionErrorView(this.onRetryClick);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[

            Container(
              padding: EdgeInsets.all(20.0),
              child: RaisedButton(
                  onPressed: onRetryClick,
                  color: Colors.transparent,
                  elevation: 0.0,
                  child: Icon(Icons.refresh, size: 50.0, color: Colors.blue,)
              ),
            ),
            Text("It seems that your device has no internet connection.\nPlease check it and retry",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0
              ),)
          ],
        ),
      ),
    );
  }
}




class ShowLoadingErrorView extends StatelessWidget {

  final void Function() onRetryClick;
  ShowLoadingErrorView(this.onRetryClick);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0),
              child: RaisedButton(
                  onPressed: onRetryClick,
                  color: Colors.transparent,
                  elevation: 0.0,
                  child: Icon(Icons.refresh, size: 50.0, color: Colors.blue,)
              ),
            ),
            Text("An error occured. Please retry",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0
              ),)
          ],
        ),
      ),
    );
  }
}
