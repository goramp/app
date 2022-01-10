import 'package:flutter/material.dart';

class SnackbarHelper {
  static void show(
    String message,
    BuildContext context, {
    String? action,
    VoidCallback? onPressed,
  }) {
    final snackBar = SnackBar(
      content: Text(message),
      action: action != null
          ? SnackBarAction(
              label: action,
              onPressed: onPressed!,
            )
          : null,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // static bool checkCanRecord(BuildContext context) {
  //   if (BlocProvider.of<EventPostBloc>(context).state is EventPostWaiting) {
  //     return true;
  //   } else {
  //     String message =
  //         "You are currently uploading a video, please try again later";
  //     final SnackBarContent content = SnackBarContent(
  //       message: message,
  //       backgroundColor: Theme.of(context).colorScheme.surface,
  //       duration: Duration(seconds: 4),
  //       action: SnackBarAction(
  //         textColor: accent,
  //         label: "DISMISS",
  //         onPressed: () {
  //           BlocProvider.of<SnackbarBloc>(context).add(Dismiss());
  //         },
  //       ),
  //     );
  //     BlocProvider.of<SnackbarBloc>(context).add(Show(content));
  //     return false;
  //   }
  // }
}
