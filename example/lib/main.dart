import 'package:flutter/material.dart';
import 'i18n/app_strings.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Locale defLocale = Locale('en','');
    return MaterialApp(
      localizationsDelegates: [
        const AppStringsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      locale: defLocale,
      supportedLocales:  AppStrings.createSupportedLocale(false),
      onGenerateTitle: (BuildContext context) => AppStrings.of(context).appTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(defLocale),
    );
  }
}

class MyHomePage extends StatefulWidget {
  Locale locale;
  MyHomePage(this.locale,{Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState(locale);
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  Locale _locale;

  _MyHomePageState(this._locale);

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    var scaffold =  Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.of(context).appTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              AppStrings.of(context).pushedTitle,
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
            RaisedButton(
              onPressed: (){
                //change locale
                Locale nextLocale;
                if(_locale.languageCode=='en'){
                  nextLocale = Locale('zh', '');
                }else{
                  nextLocale = Locale('en', '');
                }
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
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: AppStrings.of(context).increment,
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
    return Localizations.override(context: context, child: scaffold,
      locale: _locale,
    );
  }
}
