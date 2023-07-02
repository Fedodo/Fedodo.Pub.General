import 'package:activitypub/activitypub.dart';
import 'package:fedodo_general/widgets/profile/enums/profile_button_state.dart';
import 'package:flutter/material.dart';

class ProfileNameRow extends StatefulWidget {
  const ProfileNameRow({
    Key? key,
    required this.preferredUsername,
    required this.userId,
    required this.name,
    required this.profileButtonInitialState,
  }) : super(key: key);

  final String preferredUsername;
  final String userId;
  final String? name;
  final Future<ProfileButtonState> profileButtonInitialState;

  @override
  State<ProfileNameRow> createState() => _ProfileNameRowState();
}

class _ProfileNameRowState extends State<ProfileNameRow> {
  late Future<ProfileButtonState> profileButtonState;

  @override
  Widget build(BuildContext context) {

    profileButtonState = widget.profileButtonInitialState;

    String fullUserName =
        "@${widget.preferredUsername}@${Uri.parse(widget.userId).authority}";

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.name ?? "",
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                fullUserName,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
          Column(
            children: [
              FutureBuilder<ProfileButtonState>(
                future: profileButtonState,
                builder: (BuildContext context,
                    AsyncSnapshot<ProfileButtonState> snapshot) {
                  Widget child;
                  if (snapshot.hasData) {
                    switch (snapshot.data!) {
                      case ProfileButtonState.ownProfile:
                        {
                          child = ElevatedButton(
                            onPressed: () {},
                            child: const Text("Edit Profile"),
                          );
                        }
                        break;
                      case ProfileButtonState.subscribed:
                        {
                          child = ElevatedButton(
                            onPressed: () {},
                            child: const Text("Unfollow"),
                          );
                        }
                        break;
                      case ProfileButtonState.notSubscribed:
                        child = ElevatedButton(
                          onPressed: () async {
                            ActivityAPI activityApi = ActivityAPI();
                            activityApi.follow(Uri.parse(widget.userId));

                            setState(() {
                              profileButtonState = Future.sync(
                                  () => ProfileButtonState.subscribed);
                            });
                          },
                          child: const Text("Follow"),
                        );
                        break;
                    }
                  } else if (snapshot.hasError) {
                    child = const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    );
                  } else {
                    child = ElevatedButton(
                      onPressed: () {},
                      child: const Text("Loading"),
                    );
                  }
                  return child;
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
