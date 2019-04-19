part of './builder.dart';

String _makeClassCodeString(String className, String getterCode) {
  return '''
// DO NOT EDIT. This is code generated via package:intl_manager

import 'package:intl/intl.dart';

class $className {
$getterCode}
''';
}

String _makeGetterCode(String message, String key) {
  return '''
  String get $key => Intl.message('$message', name: '$key');\n''';
}

bool makeDefinesDartCodeFile(
    File outFile, String className, Map<String, dynamic> arbJson) {
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
  String contentStr = _makeClassCodeString(className, getters.join());
  outFile.writeAsStringSync(contentStr);
  return true;
}
