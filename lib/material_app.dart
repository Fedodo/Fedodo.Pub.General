import 'package:fedodo_general/globals/auth.dart';
import 'package:fedodo_general/globals/preferences.dart';
import 'package:fedodo_general/widgets/auth/susi_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FedodoMaterialApp extends StatelessWidget {
  const FedodoMaterialApp({
    super.key,
    required this.title,
    required this.home,
  });

  final String title;
  final Widget home;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      onGenerateRoute: (settings) {
        if (settings.name?.contains("code") ?? false) {
          AuthGlobals.appLoginCodeRoute = settings.name;
        }

        return null;
      },
      theme: ThemeData(
        fontFamily: "Roboto",
        fontFamilyFallback: const ["NotoColorEmoji"],
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: const Color.fromARGB(255, 1, 76, 72),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          // elevation: 5000, // Does not seem to do anything. Oh I see... There is a bug on GitHub
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color.fromARGB(255, 1, 76, 72),
          enableFeedback: true,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedIconTheme: IconThemeData(
            size: 30,
            color: Colors.white,
          ),
          unselectedIconTheme: IconThemeData(
            size: 30,
            color: Colors.white54,
          ),
        ),
        appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(),
            centerTitle: true,
            color: Color.fromARGB(255, 1, 76, 72),
            elevation: 0.5,
            scrolledUnderElevation: 0.5,
            shadowColor: Colors.black,
            titleTextStyle: TextStyle(
              fontFamily: "Righteous",
              fontSize: 25,
              fontWeight: FontWeight.w100,
            )),
      ),
      home: Preferences.prefs!.getString("DomainName") == null ||
              Preferences.prefs!.getString("AccessToken") == null
          ? SuSiView(
              title: title,
              returnToWidget: home,
            )
          : home,
    );
  }
}
