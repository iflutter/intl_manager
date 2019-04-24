part of './builder.dart';

String _makeClassCodeString(String className,String supportedLocaleCode, String getterCode) {
  return '''
// DO NOT EDIT. This is code generated via package:intl_manager

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class $className {
$supportedLocaleCode
$getterCode}
''';
}

String _makeGetterCode(String message, String key) {
  message = _filterMessage(message);
  key = _filterKey(key);
  return '''
  String get $key => Intl.message('$message', name: '$key');\n''';
}

String _makeSupportedLocaleCode(List<I18nEntity> supportedLocale) {
  String _supportedLanguageCode='';
  int size = supportedLocale.length;
  for(int i=0;i<size;i++){
    var l = supportedLocale[i].locale;
    _supportedLanguageCode+="'${l.languageCode}',";
  }
  if(_supportedLanguageCode.endsWith(',')){
    _supportedLanguageCode=_supportedLanguageCode.substring(0,_supportedLanguageCode.length-1);
  }
  //
  String _supportedLocaleMap='';
  for(int i=0;i<size;i++){
    var l = supportedLocale[i].locale;
    _supportedLocaleMap+="['${l.languageCode}','${l.countryCode??''}'],";
  }
  if(_supportedLocaleMap.endsWith(',')){
    _supportedLocaleMap=_supportedLocaleMap.substring(0,_supportedLocaleMap.length-1);
  }
  return '''
  static const List<String> _supportedLanguageCode = [${_supportedLanguageCode??''}];
  static const List<List<String>> _supportedLocaleMap = [${_supportedLocaleMap??''}];

  static List<String> getSupportedLanguageCodes(){
    return _supportedLanguageCode;
  }

  static List<Locale> createSupportedLocale(bool appendCountryCode){
    List<Locale> result = [];
    for (List<String> c in _supportedLocaleMap) {
      result.add(Locale(c[0], appendCountryCode ? c[1] : ''));
    }
    return result;
  }\n''';
}

String _filterMessage(String msg){
  msg = msg.replaceAll('\n', '\\n');
  msg = msg.replaceAll('\r', '\\r');
  msg = msg.replaceAll('\t', '\\r');
  msg = msg.replaceAll("'", "\\'");
  return msg;
}

String _filterKey(String key){
  if(key==null){
    return '';
  }
  return key.trim();
}

bool makeDefinesDartCodeFile(
    File outFile, String className, Map<String, dynamic> arbJson,List<I18nEntity> supportedLocale) {
  List<String> getters = new List();
  arbJson.forEach((key, value) {
    if (key.startsWith('@')) {
      return;
    }
    getters.add(_makeGetterCode(value, key));
  });
  if (!outFile.existsSync()) {
    outFile.createSync();
  }
  String supportedLocaleCode = _makeSupportedLocaleCode(supportedLocale);
  String contentStr = _makeClassCodeString(className,supportedLocaleCode, getters.join());
  outFile.writeAsStringSync(contentStr);
  return true;
}
