## Getting Started

### Use build args

--scan-dir      the path where to scan android style strings-xx.xml files

--out-dir       ARB and dart file output path

--gen-class     the dart class name of auto generated

--file-name     the dart file name of auto generated.default is:"strings_define.dart"
                (defaults to "strings_define.dart")

--dev-locale    use which locale content to generate default dart class

build: flutter packages pub run intl_manager:build --scan-dir=xx --out-dir=yy --gen-class=zz

### Use json config 'intl_manager.json'
`
{
  "scan-dir": "assets/i18n",
  "out-dir": "lib/i18n/gen",
  "gen-class": "AppStringsDefine",
  "dev-locale": "zh"
}
`
build: flutter packages pub run intl_manager:build
