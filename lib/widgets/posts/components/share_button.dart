import 'package:activitypub/activitypub.dart';
import 'package:fedodo_general/logic/vibrate.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ShareButton extends StatefulWidget {
  const ShareButton({
    Key? key,
    required this.activity,
  }) : super(key: key);

  final Activity activity;

  @override
  State<ShareButton> createState() => _ShareButtonState();
}

class _ShareButtonState extends State<ShareButton> {
  Future<bool> isPostSharedFuture = Future(() => false);

  @override
  void initState() {
    super.initState();
    SharesAPI sharesProvider = SharesAPI();

    isPostSharedFuture = sharesProvider.isPostShared(widget.activity.object.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isPostSharedFuture,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        Widget child;
        if (snapshot.hasData) {
          child = IconButton(
              onPressed: announce,
              icon: snapshot.data!
                  ? const Icon(
                      FontAwesomeIcons.retweet,
                      color: Colors.blue,
                    )
                  : const Icon(FontAwesomeIcons.retweet));
        } else if (snapshot.hasError) {
          child = const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          );
        } else {
          child = IconButton(
            onPressed: announce,
            icon: const Icon(
              FontAwesomeIcons.retweet,
            ),
          );
        }
        return child;
      },
    );
  }

  void announce() async {
    VibrateFeedback.feedbackLight();

    setState(() {
      isPostSharedFuture = Future.value(true);
    });

    SharesAPI sharesAPI = SharesAPI();
    sharesAPI.share(widget.activity.object.id);
  }
}
