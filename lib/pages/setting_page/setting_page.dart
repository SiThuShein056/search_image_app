// ignore_for_file: prefer_const_constructors

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:search_image_app/pages/downloaded_image_page/downloaded_image_page.dart';
import 'package:search_image_app/pages/language_page/language_page.dart';
import 'package:search_image_app/provider/theme_provider.dart';

class SettinghPage extends StatefulWidget {
  const SettinghPage({Key? key}) : super(key: key);

  @override
  _SettinghPageState createState() => _SettinghPageState();
}

class _SettinghPageState extends State<SettinghPage> {
  @override
  Widget build(BuildContext context) {
    ThemeProvider tp = Provider.of(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(tr("setting")),
        centerTitle: true,
      ),
      body: ListView(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          ListTile(
              leading: Icon(Icons.brightness_2),
              title: Text(tr("night_mode")),
              trailing: Consumer(
                builder: (context, ThemeProvider tp, child) {
                  return Switch(
                      value: tp.tm == ThemeMode.dark,
                      onChanged: (isOn) {
                        if (isOn) {
                          tp.changeToDark();
                        } else {
                          tp.changeToLight();
                        }
                      });
                },
              )),
          ListTile(
            leading: Icon(Icons.photo),
            title: Text(tr("downloaded_images")),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return DownloadedImagePage();
              }));
            },
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text(tr("language")),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return LanguagePage();
              })).then((value) {
                setState(() {});
              });
            },
          ),
        ],
      ),
    );
  }
}
