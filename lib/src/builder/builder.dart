import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:intl_manager/intl_manager.dart';

import 'package:intl_manager/src/builder/xml2arb.dart';

part './code_file_maker.dart';

class BuildResult {
  List<String> arbFilenNames;
  bool isOk;

  BuildResult(this.arbFilenNames, this.isOk);
}

class IntlBuilder {
  final RegExp stringsXmlNameReg =
      RegExp('^strings(-[a-zA-Z]{2})(-[a-zA-Z]{3})?.xml\$');
  Directory scanDir;
  Directory outDir;
  File outDefineDartFile;
  String genClass;
  File genClassFile;
  Locale devLocale;

  IntlBuilder(
      {String scanDir,
      String outDir,
      String genClass,
      File genClassFile,
      Locale devLocale}) {
    //
    this.scanDir = Directory(scanDir);
    this.outDir = Directory(outDir);
    this.genClass = genClass;
    this.outDefineDartFile = genClassFile;
    this.devLocale = devLocale;
    print(this.scanDir);
    print(this.outDir);
    print(this.devLocale);
    print(outDefineDartFile);
  }

  BuildResult build() {
    List<FileSystemEntity> fseList = scanDir.listSync();
    List<I18nEntity> i18nEnttitys = List();
    bool foundDevLang = false;
    for (FileSystemEntity fe in fseList) {
      if (fe is File) {
        String fileName = path.basename(fe.path);
        Iterable<Match> matchList =
            stringsXmlNameReg.allMatches(fileName).toList();
        int index = 0;
        String languageCode;
        String countryCode;
        for (Match m in matchList) {
          String str = m.group(1);
          str = str.substring(1, str.length);
          if (index == 0) {
            languageCode = str;
          } else if (index == 1) {
            countryCode = str;
            break;
          }
          index++;
        }
        if (languageCode != null) {
          Locale locale = Locale(languageCode, countryCode);
          bool isDevLang = locale.isSameLocale(devLocale);
          if (!foundDevLang) {
            foundDevLang = isDevLang;
          }
          i18nEnttitys.add(I18nEntity(locale, fe.path, isDevLang));
        }
      }
    }
    if (!foundDevLang) {
      print("dev-locale:$devLocale's file was not found");
      exit(0);
    }
    List<String> arbFileNames = [];
    for (I18nEntity en in i18nEnttitys) {
      String fileName = en.makeArbFileName('intl');
      if (arbFileNames != null) {
        arbFileNames.add(fileName);
      }
      _buildI18Entity(en, fileName);
    }
    return BuildResult(arbFileNames, true);
  }

  _buildI18Entity(I18nEntity entity, String fileName) {
    var jsonObj = Xml2Arb.convertFromFile(entity.xmlFilePath, entity.locale.toLocaleString('_'));
    String jsonStr = jsonEncode(jsonObj);
    File outFile =
        File(path.absolute(outDir.path, fileName));
    if (!outFile.existsSync()) {
      outFile.createSync();
    }
    outFile.writeAsStringSync(jsonStr);
    if (entity.isDevLanguage) {
      makeDefinesDartCodeFile(this.outDefineDartFile, this.genClass, jsonObj);
    }
  }
}
