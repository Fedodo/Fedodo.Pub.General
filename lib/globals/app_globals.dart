import 'package:fedodo_general/globals/general.dart';
import 'package:fedodo_general/globals/preferences.dart';
import 'package:fedodo_general/fedodo_main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppGlobals {
  static void createApp(String title, Widget home) {
    General.appName = title;

    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.getInstance().then(
      // Put this into the general package
      (value) {
        Preferences.prefs = value;

        runApp(
          FedodoMain(
            title: title,
            home: home,
          ),
        );
      },
    );
  }
}
