import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goramp/app_config.dart';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/bloc/wallet/wallet_provider/inapp_wallet.dart';
import 'package:goramp/utils/index.dart';
import 'package:goramp/widgets/index.dart';
import 'package:goramp/widgets/utils/index.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart' as launcher;
import 'package:goramp/generated/l10n.dart';

class TorusLogo extends StatelessWidget {
  final double width;
  const TorusLogo({Key? key, this.width = 64}) : super(key: key);

  build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return PlatformSvg.asset(
      isDark ? Constants.TORUS_LOGO_WHITE_SVG : Constants.TORUS_LOGO_BLUE_SVG,
      width: width,
    );
  }
}

class WalletSecurityFooter extends StatelessWidget {
  const WalletSecurityFooter();
  @override
  Widget build(BuildContext context) {
    return  const SizedBox.shrink();
    // final theme = Theme.of(context);
    // final baseTextStyle =
    //     theme.textTheme.caption; //!.copyWith(fontWeight: FontWeight.bold);
    // final buttonStyle =
    //     baseTextStyle?.copyWith(color: theme.colorScheme.primary);
    // final AppConfig config = Provider.of(context, listen: false);
    // return BlocBuilder<WalletCubit, WalletsState>(builder: (context, state) {
    //   return state.wallet != null && state.wallet is InAppWalletProvider
    //       ? Container(
    //           padding: EdgeInsets.all(Insets.ls),
    //           margin: EdgeInsets.all(Insets.ls),
    //           decoration: BoxDecoration(
    //             borderRadius: kInputBorderRadius,
    //             border: Border.all(
    //               color: Theme.of(context).dividerColor,
    //               width: 0.5, // One physical pixel.
    //               style: BorderStyle.solid,
    //             ),
    //           ),
    //           child: Row(
    //             children: [
    //               Icon(
    //                 Icons.lock_outline,
    //                 color: Theme.of(context).textTheme.caption!.color,
    //                 size: 18,
    //               ),
    //               HSpace(Insets.m),
    //               Expanded(
    //                 child: Text.rich(
    //                   TextSpan(
    //                     text: "${S.of(context).wallet_powered_by_torus} ",
    //                     style: theme.textTheme.caption,
    //                     children: [
    //                       WidgetSpan(
    //                         child: launcher.Link(
    //                           uri: Uri.parse(config.torusUrl!),
    //                           target: launcher.LinkTarget.blank,
    //                           builder: (contex, follow) => Text(
    //                             S.of(context).learn_more,
    //                             style: buttonStyle,
    //                           ).clickable(follow),
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //               launcher.Link(
    //                 uri: Uri.parse('https://tor.us'),
    //                 target: launcher.LinkTarget.blank,
    //                 builder: (contex, follow) =>
    //                     const TorusLogo().clickable(follow),
    //               )
    //             ],
    //           ),
    //         )
    //       : const SizedBox.shrink();
    // });
  }
}
