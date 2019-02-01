import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

// workaround for iPhone X which draws navigation in the bottom of the screen.
// Wait until https://github.com/flutter/flutter/issues/12099 is fixed
class IPhoneXPadding {
  final BuildContext context;

  IPhoneXPadding({
    @required this.context,
  }){
    _isIPhoneX(MediaQuery.of(context));
  }
   bool _isIphone;


  bool get isIphone => _isIphone;

  set isIphone(bool value) {
    _isIphone = value;
  }

   _isIPhoneX(MediaQueryData mediaQuery) {
    if (Platform.isIOS) {
      var size = mediaQuery.size;
      if (size.height >= 812.0 || size.width >= 375.0) {
        print('iphone x');
         this._isIphone=true;
      }
    }
    this._isIphone=false;
  }
}