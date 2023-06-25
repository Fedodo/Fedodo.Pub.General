import '../Globals/preferences.dart';

extension StringExtensions on String{
  String asFedodoProxyString() {
    return "https://${Preferences.prefs!.getString("DomainName")}/proxy?url=${Uri.encodeQueryComponent(this)}";
  }
}