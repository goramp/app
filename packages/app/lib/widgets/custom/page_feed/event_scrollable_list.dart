// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:provider/provider.dart';
// import '../../../services/index.dart';
// import '../../../bloc/index.dart';
// import '../../../models/index.dart';
// import '../../helpers/index.dart';
// import '../../utils/index.dart';
// import 'event_page_tile.dart';
// import 'base_page_feed.dart';
// import '../feed/index.dart';

// class CallLinkScrollableList extends BaseFeedWidget {
//   final bool? isFavorite;

//   CallLinkScrollableList(
//       {ValueNotifier<int>? page,
//       ValueChanged<int>? onSelected,
//       EdgeInsets padding = kHorizontalListPadding,
//       double itemExtent = TILE_ITEM_WIDTH,
//       Key? key,
//       this.isFavorite}):
//         super(
//             page: page,
//             onSelected: onSelected,
//             padding: padding,
//             itemExtent: itemExtent,
//             key: key);

//   @override
//   _CallLinksState createState() {
//     return _CallLinksState();
//   }
// }

// class _CallLinksState
//     extends BasePageFeedState<CallLinkScrollableList, CallLink> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   BaseFeedBloc<CallLink> getBloc() {
//     return BlocProvider.of<MyCallLinksBloc>(context);
//   }

//   int compare(CallLink a, CallLink b) {
//     return -a.createdAt!.compareTo(b.createdAt!);
//   }

//   Widget buildLoader(FeedUninitialized state) {
//     return FeedLoader();
//   }

//   Widget buildError(FeedError state) {
//     return FeedErrorView(
//       error: "Failed to fetch call links",
//       onRefresh: refresh,
//     );
//   }

//   Widget buildEmpty(FeedLoaded state) {
//     return EmptyPageFeed('no events');
//   }

//   bool hasState(PageControllerPreviewState state) {
//     // return state is CallLinkPreviewState;
//   }

//   bool equal(CallLink a, CallLink b) {
//     return a.id == b .id;
//   }

//   Widget _buildCallLinkItem(
//       User? user, CallLink event, bool isSelected, VoidCallback onTap) {
//     return CallLinkPageTile(
//       key: ObjectKey(event),
//       event: event,
//       width: widget.itemExtent,
//       onTap: onTap,
//       isSelected: isSelected,
//     );
//   }

//   Widget _buildFavCallLinkItem(
//       User? user, CallLink event, bool isSelected, VoidCallback onTap) {
//     return ProxyCallLinkPageTile(
//       key: ObjectKey(event),
//       event: event,
//       user: user,
//       width: widget.itemExtent,
//       onTap: onTap,
//       isSelected: isSelected,
//       onChanged: (CallLink after) =>
//           CallLinkService.updateFavoriteCallLink(user!.id, event, after),
//     );
//   }

//   Widget buildItem(BuildContext context, FeedLoaded state, int index,
//       bool isSelected, double width) {
//     ThemeData theme =
//         ThemeHelper.buildMaterialAppThemeWithContext(context, brightness: Brightness.dark);
//     MyAppModel model = Provider.of<MyAppModel>(context);
//     User? user = model.currentUser;
//     CallLink event = state.items[index];
//     return Theme(
//         data: theme,
//         child: widget.isFavorite!
//             ? _buildFavCallLinkItem(
//                 user, event, isSelected, () => onSelected(state, index))
//             : _buildCallLinkItem(
//                 user, event, isSelected, () => onSelected(state, index)));
//   }
// }
