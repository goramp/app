// import 'package:flutter/material.dart';
// import '../../fixtures/index.dart';
// import '../../models/index.dart';
// import '../../bloc/index.dart';
// import 'user_video_tile.dart';

// const int _NUM_TILES = 10;
// const double _ITEM_WIDTH = 160;

// class NoOverScrollBehavior extends ScrollBehavior {
//   @override
//   Widget buildViewportChrome(
//       BuildContext context, Widget child, AxisDirection axisDirection) {
//     return child;
//   }
// }

// class UserVideoTiles extends StatefulWidget {
//   UserVideoTiles({Key key}) : super(key: key);

//   @override
//   _UserVideoTilesState createState() {
//     return _UserVideoTilesState();
//   }
// }

// class UserItem {
//   final User user;
//   bool isSelected;
//   UserItem({this.user, this.isSelected});
// }

// class _UserVideoTilesState extends State<UserVideoTiles>
//     with SingleTickerProviderStateMixin {
//   List<CallLink> _events = [];
//   int selected;
//   ScrollController _scrollController;

//   initState() {
//     super.initState();
//     _scrollController = new ScrollController();
//     fetchUsers();
//   }

//   fetchUsers() async {
//     List<CallLink> events = await EventFixtures.getUsers();
//     if (mounted) {
//       setState(() {
//         _events =
//             events; // users.map((user) => UserItem(user: user, isSelected: false)).toList();
//       });
//     }
//   }

//   Widget _buildVideoScroller() {
//     return Container(
//       child: ScrollConfiguration(
//         behavior: NoOverScrollBehavior(),
//         child: ListView.builder(
//           scrollDirection: Axis.horizontal,
//           shrinkWrap: true,
//           controller: _scrollController,
//           padding: const EdgeInsets.only(
//               left: 16.0, top: 8.0, bottom: 8.0, right: 0.0),
//           itemCount: _events.length,
//           itemBuilder: (BuildContext context, int index) {
//             CallLink event = _events[index];
//             return UserVideoTile(
//               key: ObjectKey(event),
//               event: event,
//               width: _ITEM_WIDTH,
//               onTap: () {
//                 setState(() {
//                   PreviewBloc preview = PreviewProvider.of(context);
//                   if (index == selected) {
//                     selected = null;
//                     preview.updatePreview.add(PreviewBlocState.user);
//                   } else {
//                     selected = index;
//                     _scrollController.animateTo(selected * _ITEM_WIDTH,
//                         duration: kThemeAnimationDuration,
//                         curve: Curves.fastOutSlowIn);
//                     preview.updatePreview.add(PreviewBlocState.room);
//                   }
//                 });
//               },
//               isSelected: selected != null && selected == index,
//             );
//           },
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _buildVideoScroller();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }
// }
