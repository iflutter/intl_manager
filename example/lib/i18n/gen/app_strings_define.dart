// DO NOT EDIT. This is code generated via package:intl_manager

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class AppStringsDefine {
  static const List<String> _supportedLanguageCode = ['zh','en'];
  static const List<List<String>> _supportedLocaleMap = [['zh',''],['en','']];

  static List<String> getSupportedLanguageCodes(){
    return _supportedLanguageCode;
  }

  static List<Locale> createSupportedLocale(bool appendCountryCode){
    List<Locale> result = [];
    for (List<String> c in _supportedLocaleMap) {
      result.add(Locale(c[0], appendCountryCode ? c[1] : ''));
    }
    return result;
  }

  String get changeLocale => Intl.message('change locale', name: 'changeLocale');
  String get appTitle => Intl.message('intl_manager example', name: 'appTitle');
  String get pushedTitle => Intl.message('You have pushed the button this many times:', name: 'pushedTitle');
  String get increment => Intl.message('Increment', name: 'increment');
}
