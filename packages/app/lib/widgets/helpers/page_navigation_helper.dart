import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/models/index.dart';
import 'package:goramp/models/token.dart';
import 'package:goramp/widgets/index.dart';
import 'package:goramp/widgets/pages/wallets/crypto/index.dart';
import 'package:goramp/widgets/pages/wallets/transactions/detail.dart';
import 'package:goramp/widgets/router/routes/index.dart';
import 'package:provider/provider.dart';
import 'package:universal_platform/universal_platform.dart';

class PagenavigationHelper {
  static void newCallLink(BuildContext context) {
    if (UniversalPlatform.isWeb) {
      final router = GoRouter.of(context);
      router.goNamed('savings',
          params: {'stream': 'new'},
          queryParams: {'returnTo': router.location});
    } else {
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
            builder: (BuildContext context) {
              return const SizedBox.shrink();
            },
            fullscreenDialog: true),
      );
    }
  }

  static void settings(BuildContext context) {
    // final appModel = context.read<MyAppModel>();
    // final me = appModel.profile?.username ?? 'me';
    if (UniversalPlatform.isWeb) {
      context.goNamed('settings');
    } else {
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
            builder: (BuildContext context) {
              return const SettingsPage();
            },
            fullscreenDialog: true),
      );
    }
  }

  static void editProfile(
    BuildContext context,
  ) {
    if (UniversalPlatform.isWeb) {
      context.goNamed('editProfile');
    } else {
      final appModel = context.read<MyAppModel>();
      final me = appModel.profile?.username ?? 'me';
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
            builder: (BuildContext context) {
              return EditProfile(
                username: me,
              );
            },
            fullscreenDialog: true),
      );
    }
  }

  static void browseUserCallLinks(
      BuildContext context, String callLinkId, UserProfile profile,
      {CallLink? callLink,
      BaseFeedBloc<CallLink>? bloc,
      String tab = 'call_links'}) {
    final path = CallLinkDetailsPath(
      callLinkId,
      callLink: callLink,
      shouldClose: false,
      feedBloc: bloc,
    );
    if (UniversalPlatform.isWeb) {
      final queryParams = <String, String>{
        'start': callLinkId,
        //'from': GoRouter.of(context).location,
      };
      //queryParams['close'] = 'false';
      // if (tab == 'likes') {
      //   queryParams['likes'] = 'true';
      // }
      final params = {
        'user': profile.username!,
        'tab': tab,
      };
      context.goNamed('browse',
          queryParams: queryParams, params: params, extra: path);
    }
  }

  static void savings(BuildContext context, String stream) {
    context.goNamed(
      'savings',
      params: {
        'stream': stream,
      },
    );
  }

  static void paymentTransactionDetail(
      BuildContext context, String transactionId,
      {PaymentTransaction? transaction}) {
    if (UniversalPlatform.isWeb) {
      context.goNamed('walletToken',
          params: {
            'wallet': 'payments',
            'token': transactionId,
          },
          extra: transaction);
    } else {
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return PaymentTransactionDetail(
              transactionId,
              transaction: transaction,
            );
          },
        ),
      );
    }
  }

  static void tokenDetail(BuildContext context, String token,
      {TokenAccount? tokenAccount}) {
    if (UniversalPlatform.isWeb) {
      context.goNamed('walletToken',
          params: {
            'wallet': 'tokens',
            'token': token,
          },
          extra: tokenAccount);
    } else {
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return WalletPages(
                token: token, page: token, tokenAccount: tokenAccount);
          },
        ),
      );
    }
  }

  static void tokenDetailPage(BuildContext context, String token, String page,
      {TokenAccount? tokenAccount, String? swapFrom, String? swapTo}) {
    if (UniversalPlatform.isWeb) {
      final queryParams = <String, String>{};
      if (swapFrom != null) {
        queryParams['from'] = swapFrom;
      }
      if (swapTo != null) {
        queryParams['to'] = swapTo;
      }
      context.goNamed(
        'walletTokenPage',
        params: {
          'wallet': 'tokens',
          'token': token,
          'page': page,
        },
        queryParams: queryParams,
        extra: tokenAccount,
      );
    } else {
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return WalletPages(
              token: token,
              page: page,
              tokenAccount: tokenAccount,
              swapFrom: swapFrom,
              swapTo: swapTo,
            );
          },
        ),
      );
    }
  }

  static void walletClaims(BuildContext context) {
    context.goNamed(
      'walletClaims',
      params: {
        'wallet': 'tokens',
      },
    );
  }

}
