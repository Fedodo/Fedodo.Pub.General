import 'package:activitypub/APIs/followers_api.dart';
import 'package:activitypub/APIs/followings_api.dart';
import 'package:activitypub/APIs/outbox_api.dart';
import 'package:activitypub/Models/actor.dart';
import 'package:activitypub/Models/ordered_paged_collection.dart';
import 'package:fedodo_general/globals/general.dart';
import 'package:flutter/material.dart';
import 'components/profile_description.dart';
import 'components/profile_name_row.dart';
import 'components/profile_picture_detail.dart';
import 'enums/profile_button_state.dart';

class ProfileHead extends StatefulWidget {
  const ProfileHead({
    super.key,
    required this.actor,
  });

  final Actor actor;

  @override
  State<ProfileHead> createState() => _ProfileHeadState();
}

class _ProfileHeadState extends State<ProfileHead> {
  int? postCount;
  int? followingCount;
  int? followersCount;

  @override
  Widget build(BuildContext context) {
    if (followersCount == null && widget.actor.followers != null) {
      setFollowers(widget.actor.followers!);
    }
    if (followingCount == null && widget.actor.following != null) {
      setFollowings(widget.actor.following!);
    }
    if (postCount == null) {
      setPosts(widget.actor.outbox!);
    }

    return Column(
      children: [
        ProfilePictureDetail(
          followersCount: followersCount ?? 0,
          followingCount: followingCount ?? 0,
          iconUrl: widget.actor.icon?.url,
          postsCount: postCount ?? 0,
        ),
        ProfileNameRow(
          profileButtonInitialState: getProfileButtonState(widget.actor),
          preferredUsername: widget.actor.preferredUsername!,
          userId: widget.actor.id!,
          name: widget.actor.name,
        ),
        ProfileDescription(
          htmlData: widget.actor.summary ?? "",
        ),
      ],
    );
  }

  Future<ProfileButtonState> getProfileButtonState(Actor actor) async {
    if (actor.id == null) General.logger.w("ActorId was null!");

    if (actor.id == General.fullActorId) {
      return ProfileButtonState.ownProfile;
    } else {
      FollowingsAPI followingsAPI = FollowingsAPI();
      var isFollowed =
          await followingsAPI.isFollowed(actor.id!, General.fullActorId);
      if (isFollowed) {
        return ProfileButtonState.subscribed;
      } else {
        return ProfileButtonState.notSubscribed;
      }
    }
  }

  void setFollowers(String followersString) async {
    FollowersAPI followersApi = FollowersAPI();
    OrderedPagedCollection followersCollection =
        await followersApi.getFollowers(followersString);

    setState(() {
      followersCount = followersCollection.totalItems;
    });
  }

  void setFollowings(String followingsString) async {
    FollowingsAPI followersProvider = FollowingsAPI();
    OrderedPagedCollection followingCollection =
        await followersProvider.getFollowings(followingsString);

    setState(() {
      followingCount = followingCollection.totalItems;
    });
  }

  void setPosts(String outboxUrl) async {
    OutboxAPI outboxProvider = OutboxAPI();

    OrderedPagedCollection orderedPagedCollection =
        await outboxProvider.getFirstPage(outboxUrl);

    setState(() {
      postCount = orderedPagedCollection.totalItems;
    });
  }
}
