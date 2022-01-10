import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:goramp/widgets/index.dart';
import 'package:provider/provider.dart';
import '../../../models/index.dart';

class CallFeedListItem extends StatelessWidget {
  final GroupedCallItem item;
  final VoidCallback? onTapped;
  final Call? selectedCall;
  final double? parentWidth;
  final bool isCompact;
  final bool isLast;

  CallFeedListItem(this.item,
      {Key? key,
      this.selectedCall,
      this.onTapped,
      this.parentWidth,
      this.isCompact = false,
      this.isLast = false})
      : super(key: key);

  Widget build(
    BuildContext context,
  ) {
    if (item is GroupedCallSectionHeaderItem) {
      final myItem = item as GroupedCallSectionHeaderItem;
      return GroupedCallSectionHeaderItemView(
        item as GroupedCallSectionHeaderItem,
        // onSeeAll: () {
        //   final state = context.read<MainScaffoldState>();
        //   if (myItem.key == kSectionKeyUpcoming) {
        //     state.recentFilter.value = 1;
        //   }
        // },
      );
    }
    if (item is GroupedCallHeaderItem) {
      return GroupedCallHeaderItemView(item as GroupedCallHeaderItem);
    }
    if (item is GroupedCallListItem) {
      final myItem = item as GroupedCallListItem;
      return GroupedCallListItemView(
        item as GroupedCallListItem,
        selected: myItem.schedule.id == selectedCall?.id,
        parentWidth: parentWidth,
        isCompact: isCompact,
        //isLast: isLast,
        onTap: () {
          context.read<MainScaffoldState>().trySetSelectedCall(myItem.schedule);
        },
      );
    }
    // if (item is GroupedScheduleDividerItem) {
    //   return Divider(
    //     height: context.dividerHairLineWidth,
    //     thickness: context.dividerHairLineWidth,
    //   );
    // }
    return const SizedBox.shrink();
  }
}
