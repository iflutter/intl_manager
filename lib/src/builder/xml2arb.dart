import 'dart:io';
import 'package:xml/xml.dart' as xml;

class Xml2Arb {
  static Map<String, dynamic> convertFromFile(String filePath, String locale) {
    File file = File(filePath);
    String content;
    try {
      content = file.readAsStringSync();
    } catch (e) {
      print(e);
    }
    return convert(content, locale);
  }

  static Map<String, dynamic> convert(String stringsXml, String locale) {
    xml.XmlDocument result = xml.parse(stringsXml);
    var stringsList = result.rootElement.children;
    Map<String, dynamic> arbJson = {};
    arbJson['@@locale'] = locale;
    for (var se in stringsList) {
      String key = getNodeStringKey(se);
      String arbKey = normalizeKeyName(key);
      if (arbKey != null && arbKey.isNotEmpty) {
        arbJson[arbKey] = checkTextConvert(se.text);
        arbJson['@$arbKey'] = {'type': 'text'};
      }
    }
    return arbJson;
  }

  static final _convertCharCode = '\\'.codeUnitAt(0);

  //\b, \t, \n, \a, \r
  static final _convertCharT = '\t'.codeUnitAt(0);
  static final _convertCharB = '\b'.codeUnitAt(0);
  static final _convertCharN = '\n'.codeUnitAt(0);
  static final _convertCharA = '\a'.codeUnitAt(0);
  static final _convertCharR = '\r'.codeUnitAt(0);

  static String checkTextConvert(String str) {
    if (str == null || str.isEmpty) {
      return '';
    }
    int size = str.length;
    var charBuffer = List<int>();
    for (int i = 0; i < size; i++) {
      if (str.codeUnitAt(i) == _convertCharCode) {
        if (i == size - 1) {
          //all done
          break;
        } else {
          //check next char
          var nextCharCode = str.codeUnitAt(i + 1);
          if (nextCharCode == _convertCharCode) {
            //sb.write('\\');
            charBuffer.add(_convertCharCode);
          } else {
            switch (nextCharCode) {
              case 116 :
              case 84 :
                charBuffer.add(_convertCharT);
                break;
              case 98 :
              case 66 :
                charBuffer.add(_convertCharB);
                break;
              case 110 :
              case 78 :
                charBuffer.add(_convertCharN);
                break;
              case 97 :
              case 65 :
                charBuffer.add(_convertCharA);
                break;
              case 114 :
              case 82 :
                charBuffer.add(_convertCharR);
                break;
            }
          }
          i++;
        }
      } else {
        charBuffer.add(str.codeUnitAt(i));
      }
    }
    return String.fromCharCodes(charBuffer);
  }

  static String getNodeStringKey(xml.XmlNode node) {
    if (node.attributes.isNotEmpty) {
      for (xml.XmlAttribute attr in node.attributes) {
        if (attr.name.qualified == "name") {
          return attr.value;
        }
      }
    }
    return null;
  }

  static String normalizeKeyName(String key) {
    if (key == null || key.length == 0) {
      return key;
    }
    List<String> parts = key.split("_");
    if (parts.length == 1) {
      return key;
    }
    StringBuffer sb = StringBuffer();
    for (int i = 0; i < parts.length; i++) {
      String p = parts[i];
      if (p.length > 0) {
        if (i == 0) {
          sb.write(p.substring(0, 1).toLowerCase());
        } else {
          sb.write(p.substring(0, 1).toUpperCase());
        }
        sb.write(p.substring(1, p.length));
      }
    }
    return sb.toString();
  }
}
