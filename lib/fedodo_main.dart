import 'package:fedodo_general/Globals/app_globals.dart';
import 'package:flutter/material.dart';

class FedodoMain extends StatelessWidget {
  const FedodoMain({
    Key? key,
    required this.title,
    required this.home,
  }) : super(key: key);

  final String title;
  final Widget home;

  @override
  Widget build(BuildContext context) {
    return AppGlobals.getMaterialApp(
      title,
      home,
    );
  }
}
