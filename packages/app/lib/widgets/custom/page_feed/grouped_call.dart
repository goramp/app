import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goramp/widgets/index.dart';
import "package:intl/intl.dart";
import 'package:provider/provider.dart';
import 'package:goramp/generated/l10n.dart';
import '../../../models/index.dart';
import '../../../bloc/index.dart';
import '../../extensions/index.dart';
import 'call_tile.dart';

class GroupedCallListItemView extends StatelessWidget {
  final GroupedCallListItem groupedCall;
  final VoidCallback? onTap;
  final bool selected;
  final double? parentWidth;
  final bool isCompact;
  final bool isLast;

  const GroupedCallListItemView(this.groupedCall,
      {this.onTap,
      this.selected = false,
      this.parentWidth,
      required this.isCompact,
      this.isLast = false});

  bool get headerMode => groupedCall.schedule == null;
  @override
  Widget build(BuildContext context) {
    MyAppModel model = Provider.of<MyAppModel>(context);
    User? user = model.currentUser;
    final isDesktop = isDisplayDesktop(context);
    return Material(
      //elevation: 0,
      color: selected
          ? Theme.of(context).selectedRowColor
          : Theme.of(context).canvasColor,
      child: InkWell(
        onTap: onTap,
        child: isDesktop
            ? CallListRow(
                parentWidth: parentWidth,
                schedule: groupedCall.schedule,
                isLast: isLast,
                user: user)
            : SimpleCallListTile(
                isLast: isLast,
                parentWidth: parentWidth,
                schedule: groupedCall.schedule,
                user: user),
      ),
    );
  }
}

const _kSectionHeaderHeight = 30.0;

class GroupCallSectionHeader extends StatelessWidget {
  final String? title;
  final Widget? rightItem;
  final bool active;
  final double verticalHeight;
  final bool borderTop;
  final bool borderBottom;

  const GroupCallSectionHeader(
      {Key? key,
      this.title,
      this.rightItem,
      this.verticalHeight = _kSectionHeaderHeight,
      this.borderBottom = false,
      this.borderTop = false,
      this.active = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle =
        theme.textTheme.caption!.copyWith(fontWeight: FontWeight.bold);
    bool isDark = theme.brightness == Brightness.dark;
    return Container(
      height: verticalHeight,
      color: isDark ? theme.colorScheme.background : Colors.grey[100],
      child: Column(
        children: [
          // if (borderTop)
          //   Divider(
          //     height: context.dividerHairLineWidth,
          //     thickness: context.dividerHairLineWidth,
          //   ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  width: 12.0,
                ),
                Expanded(
                  child: Text(
                    title!.toUpperCase(),
                    style: textStyle.copyWith(fontSize: 12),
                  ),
                ),
                rightItem ?? Container(),
                const SizedBox(
                  width: 12.0,
                ),
              ],
            ),
          ),
          // if (borderBottom)
          //   Divider(
          //     height: context.dividerHairLineWidth,
          //     thickness: context.dividerHairLineWidth,
          //   ),
        ],
      ),
    );
  }
}

class GroupedCallHeaderItemView extends StatelessWidget {
  final GroupedCallHeaderItem headerItem;
  const GroupedCallHeaderItemView(this.headerItem);
  @override
  Widget build(BuildContext context) {
    return GroupCallSectionHeader(
      title: '${DateFormat('MMM d, yyyy').format(headerItem.dateTime!)}',
      active: headerItem.active,
      borderBottom: headerItem.borderBottom,
      borderTop: headerItem.borderTop,
    );
  }
}

class GroupedCallSectionHeaderItemView extends StatelessWidget {
  final GroupedCallSectionHeaderItem headerItem;
  final VoidCallback? onSeeAll;
  const GroupedCallSectionHeaderItemView(this.headerItem, {this.onSeeAll});
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      children: [
        Divider(
          height: context.dividerHairLineWidth,
          thickness: context.dividerHairLineWidth,
        ),
        Expanded(
          child: Container(
            padding:
                EdgeInsets.only(left: 12.0, top: 0.0, bottom: 0.0, right: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  headerItem.description!,
                  style: theme.textTheme.headline5!.copyWith(
                    fontSize: 18.0,
                  ),
                ),
                if (headerItem.showSeeAll != null && headerItem.showSeeAll)
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Text(
                        S.of(context).sell_all,
                        style: theme.textTheme.button!
                            .copyWith(color: theme.colorScheme.primary),
                      ),
                    ),
                    onPressed: onSeeAll,
                  )
              ],
            ),
          ),
        )
      ],
    );
  }
}
