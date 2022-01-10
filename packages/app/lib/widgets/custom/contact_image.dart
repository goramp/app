// import 'package:flutter/rendering.dart';
// import 'package:flutter/material.dart';
// import 'dart:typed_data';
// import '../utils/index.dart';
// import '../../utils/index.dart';
// import '../helpers/index.dart';

// class ContactImage extends StatefulWidget {
//   final IContact contact;
//   ContactImage({Key key, @required this.contact})
//       : assert(contact != null),
//         super(key: key);

//   @override
//   _ContactImageState createState() => _ContactImageState();
// }

// class _ContactImageState extends State<ContactImage> {
//   Uint8List _avatar;

//   @override
//   initState() {
//     super.initState();
//     _avatar = widget.contact.avatar;
// //    if (_avatar == null && !_hasRequestedAvatar) {
// //      fetchContactImage();
// //    }
//   }

//   fetchContactImage() async {
//     final Uint8List avatar =
//         await ContactsService.getAvatarForContact(widget.contact.id);
//     if (mounted) {
//       setState(() {
//         _avatar = avatar;
//       });
//     }
//   }

//   bool _shouldShowIcon() {
//     final name = widget.contact.name ?? "";
//     return name.isEmpty || name.startsWith("+") || isNumeric(name.substring(0, 1));
//   }

//   @override
//   Widget build(BuildContext context) {
// //    if (_avatar != null && _avatar.length > 0) {
// //      return CircleAvatar(backgroundImage: MemoryImage(_avatar));
// //    }
//     // const Icon(Icons.person_outline, color: Colors.white)
//     final name = widget.contact.name ?? "";
//     final ThemeData theme = Theme.of(context);
//     final bool hasAvatar = _avatar != null && _avatar.length > 0;
//     return crossFade(
//         CircleAvatar(
//           foregroundColor: Colors.white,
//           backgroundColor: Colors.white24,
//           child: _shouldShowIcon()
//               ? Icon(
//                   Icons.person_outline,
//                   color: Colors.white,
//                   size: 18.0,
//                 )
//               : Text(
//                   name.substring(0, 1).toUpperCase(),
//                   style: theme.textTheme.subhead.copyWith(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                       shadows: TEXT_SHADOW),
//                 ),
//         ),
//         CircleAvatar(
//             backgroundColor: Colors.white24,
//             backgroundImage: hasAvatar ? MemoryImage(_avatar) : null),
//         hasAvatar);
//   }
// }
