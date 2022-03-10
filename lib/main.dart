// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:search_image_app/pages/home_page/home_page.dart';
import 'package:search_image_app/provider/theme_provider.dart';

/////// In this app , night mode can't store with shp ,later i will solve this error
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en', 'US'), Locale('my', 'MM')],
        path:
            'langs/translations', // <-- change the path of the translation files
        fallbackLocale: Locale('en', 'US'),
        child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeProvider>(
      create: (context) => ThemeProvider(),
      child:
          Consumer<ThemeProvider>(builder: (context, ThemeProvider tp, child) {
        ThemeProvider themeprovider =
            Provider.of<ThemeProvider>(context, listen: false);
        themeprovider.checkThemeData;
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          home: HomePage(),
          themeMode: tp.tm,
          theme: ThemeData(
            appBarTheme: AppBarTheme(color: Colors.green),
            primarySwatch: Colors.green,
            primaryColor: Colors.green,
            brightness: Brightness.light,
            textTheme: TextTheme(
              headline6: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          darkTheme: ThemeData(
            appBarTheme: AppBarTheme(color: Colors.blueAccent),
            primarySwatch: Colors.blue,
            primaryIconTheme: IconThemeData(color: Colors.red),
            primaryColor: Colors.blueAccent,
            brightness: Brightness.dark,
            textTheme: TextTheme(
              headline6: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        );
      }),
    );
  }
}
