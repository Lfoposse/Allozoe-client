import 'dart:async';

import 'package:flutter/services.dart';


class StripeView {
  static const MethodChannel _channel = const MethodChannel('stripe_payment');

  /// opens the stripe dialog to add a new card
  /// if the source has been successfully added the card token will be returned
  static Future<String> getNumber() async {
    final String number = await _channel.invokeMethod('getNumber');
    return number;
  }

  static Future<String> getExpMonth() async {
    final String month = await _channel.invokeMethod('getExpMonth');
    return month;
  }

  static Future<String> getExpYear() async {
    final String year = await _channel.invokeMethod('getExpYear');
    return year;
  }

  static Future<String> getCode() async {
    final String code = await _channel.invokeMethod('getCode');
    return code;
  }

  static Future<String> getCard() async {
    final String token = await _channel.invokeMethod('addSource');

    return token;
  }

  static bool _publishableKeySet = false;

  /// set the publishable key that stripe should use
  /// call this once and before you use [addSource]
  static void setPublishableKey(String apiKey) {
    _channel.invokeMethod('setPublishableKey', apiKey);
    _publishableKeySet = true;
  }
}

class CardPayment {
  String _number;
  String _date;
  String _code;

  CardPayment(this._number, this._date, this._code);

  String get code => _code;

  set code(String value) {
    _code = value;
  }

  String get date => _date;

  set date(String value) {
    _date = value;
  }

  String get number => _number;

  set number(String value) {
    _number = value;
  }
}

