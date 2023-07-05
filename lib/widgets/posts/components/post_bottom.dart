import 'package:activitypub/Models/activity.dart';
import 'package:fedodo_general/logic/vibrate.dart';
import 'package:fedodo_general/widgets/posts/components/share_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'like_button.dart';

class PostBottom extends StatelessWidget {
  const PostBottom({
    Key? key,
    required this.activity,
    required this.appTitle,
    required this.createPostView,
  }) : super(key: key);

  final Activity activity;
  final String appTitle;
  final Widget createPostView;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () => {chatOnPressed(context)},
            icon: const Icon(FontAwesomeIcons.comments),
          ),
          ShareButton(
            activity: activity,
          ),
          LikeButton(
            activity: activity,
          ),
          IconButton(
            onPressed: share,
            icon: const Icon(FontAwesomeIcons.shareNodes),
          ),
        ],
      ),
    );
  }

  void chatOnPressed(BuildContext context) {
    VibrateFeedback.feedbackLight();

    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, animation2) => createPostView,
        transitionsBuilder: (context, animation, animation2, widget) =>
            SlideTransition(
                position: Tween(
                  begin: const Offset(1.0, 0.0),
                  end: const Offset(0.0, 0.0),
                ).animate(animation),
                child: widget),
      ),
    );
  }

  void share() async {
    VibrateFeedback.feedbackLight();

    Share.share("Checkout this post on Fedodo. ${activity.object.id} \n\n");
  }
}
