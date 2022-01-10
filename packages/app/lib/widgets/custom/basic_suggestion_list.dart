// import 'package:flutter/rendering.dart';
// import 'package:flutter/material.dart';
// import 'package:contacts_service/contacts_service.dart';
// import '../../bloc/index.dart';
// import '../helpers/index.dart';

// class BasicSuggestionList extends StatelessWidget {
//   const BasicSuggestionList({this.suggestions, this.onSelected, this.onInvite});

//   final List<ContactList> suggestions;
//   final ValueChanged<IContact> onSelected;
//   final ValueChanged<IContact> onInvite;

//   @override
//   Widget build(BuildContext context) {
//     final List<Widget> sliverWidgets = [];
//     suggestions
//         .map((item) => buildSliverContacts(
//         item, onSelected, onInvite, sliverWidgets, context))
//         .toList();
//     return CustomScrollView(
//         key: PageStorageKey('_SuggestionList'), slivers: sliverWidgets);
//   }
// }