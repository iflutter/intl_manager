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
  RegExp('^strings(-[a-zA-Z]{1,10})(-[a-zA-Z]{1,10})?.xml\$');
  Directory scanDir;
  Directory outDir;
  File outDefineDartFile;
  String genClass;
  File genClassFile;
  Locale devLocale;
  final List<I18nEntity> i18nEnttitys = List();

  IntlBuilder({String scanDir,
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
    if (!this.outDir.existsSync()) {
      this.outDir.createSync();
    }
    print(this.scanDir);
    print(this.outDir);
    print(this.devLocale);
    print(outDefineDartFile);
  }

  BuildResult build() {
    List<FileSystemEntity> fseList = scanDir.listSync();
    bool foundDevLang = false;
    for (FileSystemEntity fe in fseList) {
      if (fe is File) {
        String fileName = path.basename(fe.path);
        Match matched = stringsXmlNameReg.firstMatch(fileName);
        String languageCode;
        String countryCode;
        if (matched != null && matched.groupCount > 0) {
          languageCode = matched.group(1);
          languageCode = languageCode?.replaceAll('-', '');
          if (matched.groupCount > 1) {
            countryCode = matched.group(2);
            countryCode = countryCode?.replaceAll('-', '');
          }
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
    var jsonObj = Xml2Arb.convertFromFile(
        entity.xmlFilePath, entity.locale.toLocaleString('_'));
    String jsonStr = jsonEncode(jsonObj);
    File outFile = File(path.absolute(outDir.path, fileName));
    if (!outFile.existsSync()) {
      outFile.createSync();
    }
    outFile.writeAsStringSync(jsonStr);
    if (entity.isDevLanguage) {
      makeDefinesDartCodeFile(
          this.outDefineDartFile, this.genClass, jsonObj, i18nEnttitys);
    }
  }
}
