// import 'package:flutter/rendering.dart';
// import 'package:flutter/material.dart';
// import '../helpers/index.dart';

// import 'package:contacts_service/contacts_service.dart';
// import 'contact_search.dart' as ContactSearch;
// import '../../bloc/index.dart';
// import 'basic_suggestion_list.dart';

// class BasicSearchDelegate extends ContactSearch.SearchDelegate<String> {
//   @override bool isPicker() {
//     return false;
//   }
//   @override
//   Widget buildSuggestions(BuildContext context, List<ContactList> suggestions) {
//     return BasicSuggestionList(
//       suggestions: suggestions,
//       onSelected: (IContact contact) {
//         focusNode.unfocus();
//       },
//       onInvite: (IContact contact) {
//         focusNode.unfocus();
//         LinkHelper.sendPrivateInvite(context, contact.phoneNumber,
//             name: contact.name);
//       },
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context, ContactSearchState state) {
//     return _buildSuccess(
//         context, state is ContactSearchPopulated ? state.result.sections : []);
//   }

//   Widget _buildSuccess(BuildContext context, List<ContactList> items) {
//     final List<Widget> sliverWidgets = [];
//     items
//         .map((item) => buildSliverContacts(item, (IContact contact) {
//       focusNode.unfocus();
//     }, (IContact contact) {
//       focusNode.unfocus();
//       LinkHelper.sendPrivateInvite(context, contact.phoneNumber,
//           name: contact.name);
//     }, sliverWidgets, context))
//         .toList();
//     return CustomScrollView(
//         key: PageStorageKey('_ResultList'), slivers: sliverWidgets);
//   }

//   Widget buildEmptyResult(BuildContext context, ContactSearchState state) {
//     return Container();
//   }

//   Widget buildLoading(BuildContext context, ContactSearchState state) {
//     return Container(
//         constraints: BoxConstraints(maxHeight: 2.0),
//         child: LinearProgressIndicator());
//   }

//   Widget buildError(BuildContext context, ContactSearchState state) {
//     return IgnorePointer(
//       child: Container(
//         alignment: FractionalOffset.center,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             Icon(Icons.error_outline, color: Colors.red[300], size: 80.0),
//             Container(
//               padding: EdgeInsets.only(top: 16.0),
//               child: Text(
//                 "Something went wrong",
//                 style: TextStyle(
//                   color: Colors.white54,
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   ThemeData appBarTheme(BuildContext context) {
//     assert(context != null);
//     final ThemeData theme = ThemeData.dark();
//     assert(theme != null);
//     return theme.copyWith(
//         primaryColor: Colors.transparent,
//         primaryIconTheme:
//         theme.primaryIconTheme.copyWith(color: Colors.white70),
//         primaryTextTheme: theme.textTheme,
//         hintColor: Colors.white54);
//   }
// }