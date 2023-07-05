import 'dart:io';
import 'package:fedodo_general/globals/preferences.dart';
import 'package:fedodo_general/widgets/auth/apis/application_registration.dart';
import 'package:flutter/material.dart';
import 'apis/login_manager.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SuSiView extends StatelessWidget {
  SuSiView({
    Key? key,
    required this.title,
    required this.returnToWidget,
  }) : super(key: key);

  final Widget returnToWidget;
  final String title;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final domainController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (kIsWeb && Preferences.prefs!.getString("DomainName") == null) {
      var url = Uri.base;
      Preferences.prefs!
          .setString("DomainName", url.authority.replaceAll("micro.", ""));

      login(context);
    } else {
      login(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: "Righteous",
            fontSize: 25,
            fontWeight: FontWeight.w100,
            color: Colors.white,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: domainController,
              decoration: const InputDecoration(
                hintText: 'Domain',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  Preferences.prefs!
                      .setString("DomainName", domainController.text);

                  login(context);
                }
              },
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }

  Future login(BuildContext context) async {
    String? clientId = Preferences.prefs?.getString("ClientId");
    String? clientSecret = Preferences.prefs?.getString("ClientSecret");

    ApplicationRegistration appRegis = ApplicationRegistration();
    while (clientId == null || clientSecret == null) {
      await appRegis.registerApplication();

      clientId = Preferences.prefs?.getString("ClientId");
      clientSecret = Preferences.prefs?.getString("ClientSecret");
    }

    LoginManager login = LoginManager(!kIsWeb && Platform.isAndroid);
    Preferences.prefs!
        .setString("AccessToken", (await login.login(clientId, clientSecret))!);

    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => returnToWidget,
      ),
    );
  }
}
