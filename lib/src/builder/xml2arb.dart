import 'dart:io';
import 'package:xml/xml.dart' as xml;
import 'package:string_unescape/string_unescape.dart';

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
        arbJson[arbKey] = unescape(se.text);
        arbJson['@$arbKey'] = {'type': 'text'};
      }
    }
    return arbJson;
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
