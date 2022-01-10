import 'package:flutter/material.dart';
import 'package:goramp/generated/l10n.dart';
import 'package:goramp/models/index.dart';
import 'package:goramp/services/index.dart';
import 'package:goramp/widgets/custom/fetch_error.dart';
import 'package:goramp/widgets/index.dart';

typedef ProfileWidgetBuilder = Widget Function(
    BuildContext, UserProfile profile);

class ProfileBuilder extends StatefulWidget {
  final String username;
  final ProfileWidgetBuilder widgetBuilder;
  final UserProfile? profile;
  ProfileBuilder(this.username, this.widgetBuilder, {this.profile});

  @override
  State<ProfileBuilder> createState() => _ProfileBuilderState();
}

class _ProfileBuilderState extends State<ProfileBuilder> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserProfile?>(
      initialData: widget.profile,
      stream: UserService.getProfileStreamByUsername(widget.username),
      builder: (context, snapshot) {
        Widget body;
        if (snapshot.hasData) {
          body = KeyedSubtree(
            child: widget.widgetBuilder(context, snapshot.data!),
            key: ValueKey(widget.username),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            body = Scaffold(
              body: FetchError(
                S.of(context).failed_to_fetch_profile,
                onRetry: () {
                  setState(() {});
                },
              ),
            );
          } else {
            body = Scaffold(
              body: FetchError(
                S.of(context).profile_not_found,
                onRetry: () {
                  setState(() {});
                },
              ),
            );
          }
        } else {
          body = Scaffold(
            body: const FeedLoader(),
          );
        }
        return body;
      },
    );
  }
}
