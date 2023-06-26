import 'package:fedodo_general/material_app.dart';
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
    return FedodoMaterialApp(
      title: title,
      home: home,
    );
  }
}
