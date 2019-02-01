import 'package:client_app/StringKeys.dart';
import 'package:flutter/material.dart';

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
            Text(
              getLocaleText(context: context, strinKey: StringKeys.LOADING),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            )
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
                  child: Icon(
                    Icons.refresh,
                    size: 50.0,
                    color: Colors.blue,
                  )),
            ),
            Text(
              getLocaleText(
                  context: context,
                  strinKey: StringKeys.ERROR_CONNECTION_FAILED),
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            )
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
                  child: Icon(
                    Icons.refresh,
                    size: 50.0,
                    color: Colors.blue,
                  )),
            ),
            Text(
              getLocaleText(
                  context: context, strinKey: StringKeys.ERROR_OCCURED),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            )
          ],
        ),
      ),
    );
  }
}
