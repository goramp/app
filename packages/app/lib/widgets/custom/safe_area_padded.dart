// import 'package:flutter/material.dart';

// class SafeAreaPadded extends StatelessWidget {
//   Widget child;
//   @override
//   Widget build(BuildContext context) {
//     SafeArea(
//           top: false,
//           bottom: true,
//           child: Padding(
//             padding: getExtraPadding(),
//             child: BottomNavigationBar(
//               backgroundColor: Colors.transparent,
//               type: BottomNavigationBarType.fixed,
//               onTap: widget.onSelect,
//               elevation: 0.0,
//               currentIndex: widget.page >= Tabs.length ? 0 : widget.page,
//               unselectedItemColor: theme.textTheme.caption!.color,
//               selectedItemColor: theme.colorScheme.primary,
//               items: Tabs.map(
//                 (TabDesciption tab) => BottomNavigationBarItem(
//                   icon: tab.dummy ? SizedBox.shrink() : tab.icon,
//                   label: tab.dummy || (tab.title == null) ? '' : tab.title,
//                   activeIcon: tab.dummy ? SizedBox.shrink() : tab.activeIcon,
//                 ),
//               ).toList(),
//             ),
//           ),
//         ),
//   }
// }
