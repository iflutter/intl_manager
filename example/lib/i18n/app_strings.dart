import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'gen/app_strings_define.dart';
import 'gen/messages_all.dart';

///this delegate need register in you main.dart file[main]
class AppStringsDelegate extends LocalizationsDelegate<AppStrings> {
  const AppStringsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppStrings.getSupportedLanguageCodes().contains(locale.languageCode);
  }

  @override
  Future<AppStrings> load(Locale locale) {
    return AppStrings.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppStrings> old) {
    return false;
  }
}

///project api for i18n strings, extends from 'intl_manager' generated strings define
class AppStrings extends AppStringsDefine{
  static Future<AppStrings> load(Locale locale) {
    final String name = locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return AppStrings();
    });
  }

  static AppStrings of(BuildContext context) {
    return Localizations.of<AppStrings>(context, AppStrings);
  }

  //wrap AppStringsDefine method
  static List<String> getSupportedLanguageCodes(){
    return AppStringsDefine.getSupportedLanguageCodes();
  }

  //wrap AppStringsDefine method
  static List<Locale> createSupportedLocale(bool appendCountryCode){
    return AppStringsDefine.createSupportedLocale(appendCountryCode);
  }
}
