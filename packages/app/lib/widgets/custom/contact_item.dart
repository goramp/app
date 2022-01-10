// import 'package:flutter/rendering.dart';
// import 'package:flutter/material.dart';
// import 'package:recase/recase.dart';
// import '../styles/index.dart';
// import 'package:contacts_service/contacts_service.dart';
// import '../helpers/index.dart';
// import '../../utils/index.dart';
// import 'dot.dart';
// import 'contact_image.dart';

// class ContactItemView extends StatelessWidget {
//   const ContactItemView({this.contact, this.onTap, this.onInvite})
//       : assert(contact != null);

//   final IContact contact;
//   final VoidCallback onTap;
//   final VoidCallback onInvite;
//   @override
//   Widget build(BuildContext context) {
//     final ThemeData theme = Theme.of(context);
//     if (contact.name == null || contact.name.isEmpty) {
//       return ListTile(
//         leading: ContactImage(contact: contact),
//         title: Text(
//           ReCase(contact.phoneNumber).titleCase,
//           overflow: TextOverflow.ellipsis,
//           maxLines: 1,
//           style: theme.textTheme.subhead.copyWith(
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//               shadows: TEXT_SHADOW),
//         ),
//         trailing: buildInviteButton(context, onInvite),
//         onTap: onTap,
//       );
//     }
//     Widget subtitle = Text(
//       contact.phoneNumber,
//       style: theme.textTheme.body1.copyWith(color: Colors.white54),
//       overflow: TextOverflow.ellipsis,
//       maxLines: 1,
//     );
//     if (contact.phoneType != null && contact.phoneType.isNotEmpty) {
//       subtitle = Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: <Widget>[
//           Text(
//             contact.phoneType.toLowerCase(),
//             style: theme.textTheme.body1.copyWith(color: Colors.white54),
//             overflow: TextOverflow.ellipsis,
//             maxLines: 1,
//           ),
//           Dot(),
//           Expanded(
//             child: Text(
//               contact.phoneNumber,
//               style: theme.textTheme.body1.copyWith(color: Colors.white54),
//               overflow: TextOverflow.ellipsis,
//               maxLines: 1,
//             ),
//           ),
//         ],
//       );
//     }
//     return ListTile(
//       leading: ContactImage(contact: contact),
//       title: Text(
//         toTitleCase(contact.name),
//         overflow: TextOverflow.ellipsis,
//         maxLines: 1,
//         style: theme.textTheme.subhead.copyWith(
//             fontWeight: FontWeight.bold, color: Colors.white, shadows: TEXT_SHADOW),
//       ),
//       subtitle: subtitle,
//       onTap: onTap,
//       trailing: buildInviteButton(context, onInvite),
//     );
//   }

//   Widget buildInviteButton(BuildContext context, VoidCallback onPress) {
//     final ThemeData theme = Theme.of(context);
// //    return OutlineButton(
// //      padding: EdgeInsets.all(0.0),
// //      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
// //      borderSide: BorderSide(color: Colors.white70),
// //      highlightedBorderColor: Colors.transparent,
// //      child: Text(
// //        'INVITE',
// //        semanticsLabel: 'INVITE',
// //        style: theme.textTheme.button
// //            .copyWith(color: Colors.white70, fontSize: 12.0),
// //      ),
// ////      color: Colors.white70,
// //      highlightColor: Colors.black26,
// //      splashColor: Colors.black26,
// //      onPressed: onPress,
// //    );

//     return SizedBox(
//       height: 32.0,
//       child: OutlineButton.icon(
//         icon: Icon(
//           Icons.add,
//           color: Colors.white,
//         ),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
//         borderSide: BorderSide(color: Colors.white, width: 2.0),
//         highlightedBorderColor: Colors.white70,
//         label: Text(
//           'INVITE',
//           semanticsLabel: 'INVITE',
//           style: theme.textTheme.button
//               .copyWith(color: Colors.white, fontSize: 12.0),
//         ),
// //      color: Colors.white70,
//         highlightColor: primary,
//         onPressed: () {},
//       ),
//     );
//   }
// }