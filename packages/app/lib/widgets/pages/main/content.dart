import 'dart:math';

import 'package:flutter/material.dart';
import '../../../bloc/index.dart';

enum MenuItems { settings, help, feedback, logout }

abstract class BaseTabContent extends StatelessWidget {
  const BaseTabContent();
  List<Widget> buildContentSlivers(BuildContext context);
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        final scrollview = CustomScrollView(
          primary: true,
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                <Widget>[
                  // SizedBox(
                  //   height: 4.0,
                  // ),
                  // _buildTabHeader(),
                  // SizedBox(
                  //   height: 4.0,
                  // ),
                  // _buildTabs(context),
                ],
              ),
            )
          ],
        );

        return SafeArea(
          child: Material(color: Colors.transparent, child: scrollview),
        );
      },
    );
  }
}

class EventContent extends StatelessWidget {
  const EventContent();
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(8.0),
          sliver: SliverFixedExtentList(
            itemExtent: 60.0,
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                    // color: Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0)
                    //     .withOpacity(1.0),
                    );
              },
              childCount: 30,
            ),
          ),
        ),
      ],
    );
  }
}

class UpcomingContent extends BaseTabContent {
  const UpcomingContent();

  List<Widget> buildContentSlivers(BuildContext context) {
    return [];
  }
}

class RecentContent extends BaseTabContent {
  const RecentContent();

  List<Widget> buildContentSlivers(BuildContext context) {
    return [];
  }
}

class MyEvents extends BaseTabContent {
  const MyEvents();

  List<Widget> buildContentSlivers(BuildContext context) {
    return [];
  }
}

class PastTabContent extends BaseTabContent {
  const PastTabContent();

  List<Widget> buildContentSlivers(BuildContext context) {
    return [];
  }
}

class ArchiveTabContent extends BaseTabContent {
  const ArchiveTabContent();

  List<Widget> buildContentSlivers(BuildContext context) {
    return [];
  }
}

class InboxContent extends BaseTabContent {
  const InboxContent();

  List<Widget> buildContentSlivers(BuildContext context) {
    return [];
  }
}

class MeContent extends BaseTabContent {
  const MeContent();

  List<Widget> buildContentSlivers(BuildContext context) {
    return [];
  }
}
