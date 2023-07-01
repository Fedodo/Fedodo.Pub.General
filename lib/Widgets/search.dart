import 'package:activitypub/APIs/ActivityPubRelated/webfinger_api.dart';
import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  Search({
    Key? key,
    required this.appTitle,
    required this.getProfile,
  }) : super(key: key);

  final searchTextEditingController = TextEditingController();
  final String appTitle;
  final Function(String profileId) getProfile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: searchTextEditingController,
                  decoration: const InputDecoration(
                    hintText: 'Search',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
              ),
              IconButton(
                onPressed: () async {
                  String input = searchTextEditingController.text;

                  if (input.contains("@")) {
                    WebfingerApi webfingerApi = WebfingerApi();
                    String profileId = await webfingerApi.getUser(input);

                    // ignore: use_build_context_synchronously
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 300),
                        reverseTransitionDuration:
                            const Duration(milliseconds: 300),
                        pageBuilder: (context, animation, animation2) =>
                            getProfile(profileId),
                        transitionsBuilder:
                            (context, animation, animation2, widget) =>
                                SlideTransition(
                                    position: Tween(
                                      begin: const Offset(1.0, 0.0),
                                      end: const Offset(0.0, 0.0),
                                    ).animate(animation),
                                    child: widget),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.search),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
