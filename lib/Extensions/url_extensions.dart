import '../Globals/preferences.dart';

extension UriExtensions on Uri{
  Uri asFedodoProxyUri() {
    return Uri.parse("https://${Preferences.prefs!.getString("DomainName")}/proxy?url=${Uri.encodeQueryComponent(toString())}");
  }
}