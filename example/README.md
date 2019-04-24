## add dependencies
```
dependencies:
  ...
  flutter_localizations:
    sdk: flutter
  intl: ^0.15.7
  intl_translation: ^0.17.3

dev_dependencies:
  ...
  intl_manager: ^0.0.2
```
    
## copy android's strings-xx.xml
copy or create android style strings-xx.xml file in flutter project 
flutter project dir:
```
├── res
│   ├── strings
│   │   ├── strings-en.xml
│   │   └── strings-zh.xml
```

## create intl_manager build config file
create config file 'intl_manager.json' in flutter project folder.
```
{
  "scan-dir": "res/strings",
  "out-dir": "lib/i18n/gen",
  "file-name": "app_strings_define.dart",
  "gen-class": "AppStringsDefine",
  "dev-locale": "en"
}
```
## build strings
```
flutter packages pub run intl_manager:build
```
this command will generated arb and dart files.

```
├── lib
│   ├── i18n
│   │   └── gen
│   │       ├── app_strings_define.dart
│   │       ├── intl_en.arb
│   │       ├── intl_zh.arb
│   │       ├── messages_all.dart
│   │       ├── messages_en.dart
│   │       └── messages_zh.dart

```

## define strings API
```
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:example/i18n/gen/app_strings_define.dart';
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
```

## register your define
1.register localizationsDelegates with AppStringsDelegate.
2.provider supportedLocales with AppStrings.createSupportedLocale(false)
```
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        const AppStringsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales:  AppStrings.createSupportedLocale(false),
      onGenerateTitle: (BuildContext context) => AppStrings.of(context).appTitle,
      ...
    );
  }
}
```
## strings usage
```
appBar: AppBar(title: Text(AppStrings.of(context).appTitle))
```

## change locale in running time
1.reload string define:
AppStrings.load(nextLocale).then((_){
                  setState(() {
                    _locale = nextLocale;
                  });
                });
2.reload UI by Localizations.override

```
@override
  Widget build(BuildContext context) {
    var scaffold =  Scaffold(
    ...
      body: Center(
        child: Column(
            RaisedButton(
              onPressed: (){
                //change locale
                Locale nextLocale;
                if(_locale.languageCode=='en'){
                  nextLocale = Locale('zh', '');
                }else{
                  nextLocale = Locale('en', '');
                }
                //
                AppStrings.load(nextLocale).then((_){
                  setState(() {
                    _locale = nextLocale;
                  });
                });
              },
              child: Text(AppStrings.of(context).changeLocale),
            )
          ],
        ),
      ),
    );
    return Localizations.override(context: context, child: scaffold,
      locale: _locale,
    );
  }
```