// import 'package:flutter/rendering.dart';
// import 'package:flutter/material.dart';
// import '../helpers/index.dart';

// import 'package:contacts_service/contacts_service.dart';
// import '../../bloc/index.dart';
// import '../../utils/index.dart';
// import '../custom/contact_item.dart';

// void buildSliverContacts(
//     ContactList contactList,
//     ValueChanged<IContact> onSelected,
//     ValueChanged<IContact> onInvite,
//     List<Widget> slivers,
//     BuildContext context) {
//   final header = SliverToBoxAdapter(
//     child: Container(
//       height: 56.0,
//       child: ListTile(
//         title: Text(
//           toTitleCase(contactList.heading),
//           style: Theme.of(context)
//               .textTheme
//               .caption
//               .copyWith(color: Colors.white54, shadows: TEXT_SHADOW),
//         ),
//       ),
//     ),
//   );
//   final list = SliverList(
//     delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
//       if (index >= contactList.contacts.length) return null;
//       final IContact suggestion = contactList.contacts[index];
//       return ContactItemView(
//         contact: suggestion,
//         onTap: () => onSelected(suggestion),
//         onInvite: () => onInvite(suggestion),
//       );
//     }),
//   );
//   slivers.add(header);
//   slivers.add(list);
// }