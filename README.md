## intl_manager
A library tool that help you manager i18n strings in flutter,include convert from android "strings-xx.xml".
Before to use,you need to kown what is LocalizationsDelegate and what is intl_translation.

Flutter use arb file to manager i18n strings. some times you need to refactor an old android project use flutter.

intl_manager can help you converte android strings-xx.xml to flutter's arb file,and auto generate Dart class
include all the strings define.You just need to extend the Dart class and registe with LocalizationsDelegate.

Flutter's internationalization reference:
https://github.com/flutter/website/tree/master/examples/internationalization/intl_example/lib

### Install

```
dev_dependencies:
  intl_manager: version
```  

### Use build args

--scan-dir      the path where to scan android style strings-xx.xml files

--out-dir       ARB and dart file output path

--gen-class     the dart class name of auto generated

--file-name     the dart file name of auto generated.default is:"strings_define.dart"
                (defaults to "strings_define.dart")

--dev-locale    use which locale content to generate default dart class

build: flutter packages pub run intl_manager:build --scan-dir=xx --out-dir=yy --gen-class=zz

### Use json config 'intl_manager.json'

```json
{
  "scan-dir": "assets/i18n",
  "out-dir": "lib/i18n/gen",
  "gen-class": "AppStringsDefine",
  "dev-locale": "zh"
}
```
build: flutter packages pub run intl_manager:build