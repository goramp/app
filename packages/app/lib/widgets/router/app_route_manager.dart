import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/models/index.dart';
import 'package:goramp/models/token.dart';
import 'package:goramp/widgets/index.dart';
import 'package:goramp/widgets/pages/complete_profile/index.dart';
import 'package:goramp/widgets/pages/firebase_email_sigin_callback/index.dart';
import 'package:goramp/widgets/pages/me/profile.dart';
import 'package:goramp/widgets/pages/reset_password_callback/index.dart';
import 'package:goramp/widgets/pages/wallets/crypto/claims.dart';
import 'package:goramp/widgets/pages/wallets/crypto/index.dart';
import 'package:goramp/widgets/pages/wallets/transactions/detail.dart';
import 'package:goramp/widgets/utils/index.dart';
import 'package:universal_platform/universal_platform.dart';

class WrapPageWithBackButton extends StatelessWidget {
  WrapPageWithBackButton(this.child, {Key? key}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!UniversalPlatform.isAndroid) {
      return child;
    }
    return WillPopScope(
      child: child,
      onWillPop: () async {
        final router = GoRouter.of(context);
        if (router.location == '/') {
          return true;
        }
        context.go('/');
        return false;
      },
    );
  }
}

class AppRouter {
  late GoRouter router;
  final MyAppModel appModel;
  final LocalKey _rootKey = UniqueKey();
  final LocalKey _authKey = UniqueKey();

  AppRouter(this.appModel) {
    router = _initialize();
  }

  bool get isLoggedIn => appModel.currentUser != null;
  bool get isLoggedOut => appModel.currentUser == null;

  void onCloseHandler() {
    // if (isLoggedIn) {
    //   setNewRoutePath(MainRoutePath());
    // } else {
    //   setNewRoutePath(LoginRoutePath());
    // }
  }

  bool get _pendingRegister =>
      isLoggedIn &&
      (appModel.currentUser!.isPendingSignup ||
          (appModel.profile != null && !appModel.profile!.hasUsername));

  String? _handleRedirect(GoRouterState state) {
    final goingToLogin = state.subloc == '/login';
    final goingToHome = state.subloc == '/';
    final goingToRegister = state.subloc == '/register';
    final inSecurePaths = [
      '/login',
      '/callback/email',
      '/signup',
      '/change_password',
      '/reset',
      '/'
    ];

    final goingToInsecureRoutes =
        inSecurePaths.any((path) => state.subloc == path);
    // the user is not logged in and not headed to /login, they need to login
    if (!isLoggedIn && !goingToInsecureRoutes) {
      if (goingToHome) return '/login';
      return '/login?returnTo=${state.subloc}';
    }
    //final shouldRedirectToRegister = _pendingRegister;

    // if (shouldRedirectToRegister && !goingToRegister) {
    //   if (goingToLogin) return '/register';
    //   return '/register?returnTo=${state.subloc}';
    // }

    // if (!shouldRedirectToRegister && goingToRegister) {
    //   return '/';
    // }

    // the user is logged in and headed to /login, no need to login again
    if (isLoggedIn && goingToLogin) return '/';

    // no need to redirect at all
    return null;
  }

  Page<dynamic> _userTabs(
    BuildContext context,
    GoRouterState state,
  ) {
    final user = state.params['user']!;
    final tab = state.params['tab'];
    var index = 0;
    if (tab != null) {
      index = MY_TABS.indexOf(tab);
      if (index == -1) {
        index = 0;
      }
    }
    return isLoggedIn
        ? MaterialPage<void>(
            key: _rootKey,
            child: MainScaffold(
              'me',
              profileIndex: index,
            ),
          )
        : MaterialPage(
            child: ProfilePage(
              user,
            ),
            key: state.pageKey,
          );
  }

  GoRouter _initialize() {
    return GoRouter(
      //refreshListenable: appModel,
      multiMatchStrategy: GoRouterMultiMatchStrategy.matchFirst,
      routes: [
        GoRoute(
          path: '/',
          name: 'Home',
          redirect: (_) => '/home/buy',
        ),
        GoRoute(
          path: '/login',
          name: 'login',
          pageBuilder: (context, state) {
            final returnTo = state.queryParams['returnTo'];
            return MaterialPage<void>(
              key: _authKey,
              child: Welcome(
                isDialog: true,
                returnTo: returnTo,
              ),
            );
          },
        ),
        GoRoute(
          path: '/signup',
          name: 'signup',
          pageBuilder: (context, state) => MaterialPage<void>(
            key: _authKey,
            child: Welcome(
              loginMode: false,
            ),
          ),
        ),
        GoRoute(
          path: '/register',
          name: 'register',
          pageBuilder: (context, state) => MaterialPage<void>(
            key: _authKey,
            child: CompleteProfile(
              returnTo: state.params['returnTo'],
            ),
          ),
        ),
        GoRoute(
          path: '/reset',
          name: 'reset',
          pageBuilder: (context, state) => MaterialPage<void>(
            key: _authKey,
            child: Welcome(
              loginMode: false,
              initialStep: 3,
            ),
          ),
        ),
        GoRoute(
            path: '/change_password',
            name: 'change_password',
            pageBuilder: (context, state) {
              final code = state.queryParams['code'] ?? "";
              return MaterialPage<void>(
                key: state.pageKey,
                child: ResetPasswordCallback(code: code),
              );
            }),
        GoRoute(
          path: '/home',
          redirect: (_) => '/home/buy',
        ),
        GoRoute(
          path: '/home/:stream',
          name: 'streams',
          pageBuilder: (context, state) {
            final stream = state.params['stream'];
            // if (stream == 'new') {
            //   final returnTo = state.queryParams['returnTo'];
            //   return MaterialPage<void>(
            //     key: state.pageKey,
            //     child: NewCallLink(
            //       onClose: () {
            //         if (returnTo != null) {
            //           router.go(returnTo);
            //           return;
            //         }
            //         router.go('/');
            //       },
            //     ),
            //   );
            // }
            var index = 0;
            switch (stream) {
              case 'buy':
                index = 0;
                break;
              case 'sell':
                index = 1;
                break;
              case 'pending':
                index = 2;
                break;
            }
            return MaterialPage<void>(
              key: _rootKey,
              child: MainScaffold(
                'home',
                eventIndex: index,
              ),
            );
          },
        ),
        GoRoute(
          path: '/wallet',
          name: 'wallet',
          redirect: (_) => '/wallet/${MY_WALLETS[0]}',
        ),
        GoRoute(
            path: '/wallet/:wallet',
            pageBuilder: (context, state) {
              final wallet = state.params['wallet']!;
              final walletTabIndex = MY_WALLETS.indexOf(wallet);
              return MaterialPage<void>(
                key: _rootKey,
                child: WrapPageWithBackButton(MainScaffold(
                  'wallet',
                  walletIndex: walletTabIndex,
                )),
              );
            },
            routes: [
              GoRoute(
                path: 'claims',
                name: 'walletClaims',
                pageBuilder: (context, state) {
                  return MaterialPage<void>(
                    key: state.pageKey,
                    child: Claims(),
                  );
                },
              ),
              GoRoute(
                path: ':token',
                name: 'walletToken',
                routes: [
                  GoRoute(
                    path: ':page',
                    name: 'walletTokenPage',
                    pageBuilder: (context, state) {
                      final token = state.params['token']!;
                      final page = state.params['page']!;
                      final swapFrom = state.queryParams['from'];
                      final swapTo = state.queryParams['to'];
                      final tokenAccount = state.extra;
                      return MaterialPage<void>(
                        key: state.pageKey,
                        child: WalletPages(
                          token: token,
                          page: page,
                          tokenAccount: tokenAccount as TokenAccount?,
                          swapFrom: swapFrom,
                          swapTo: swapTo,
                        ),
                      );
                    },
                  ),
                ],
                pageBuilder: (context, state) {
                  final wallet = state.params['wallet']!;
                  if (wallet == 'payments') {
                    final transactionId = state.params['token']!;
                    final paymentTransaction = state.extra;
                    return MaterialPage<void>(
                      key: state.pageKey,
                      child: PaymentTransactionDetail(
                        transactionId,
                        transaction: paymentTransaction as PaymentTransaction?,
                      ),
                    );
                  }
                  final token = state.params['token']!;
                  final tokenAccount = state.extra;
                  return MaterialPage<void>(
                    key: state.pageKey,
                    child: WalletPages(
                      token: token,
                      page: token,
                      tokenAccount: tokenAccount as TokenAccount?,
                    ),
                  );
                },
              ),
            ]),
        GoRoute(
          path: '/callback/email',
          name: 'email_calllback',
          redirect: (state) {
            final mode = state.queryParams['mode'] ?? "";
            final code = state.queryParams['oobCode'] ?? "";
            if (mode == "resetPassword") {
              return '/change_password?code=$code';
            }
            return null;
          },
          pageBuilder: (context, state) {
            //final mode = state.queryParams['mode'] ?? "";
            final code = state.queryParams['oobCode'] ?? "";
            final continueUrl = state.queryParams['continueUrl'];
            final lang = state.queryParams['lang'];
            return MaterialPage<void>(
                key: state.pageKey,
                child: FBEmailSignInCallback(
                  url: continueUrl,
                  lang: lang,
                  code: code,
                ));
          },
        ),
        GoRoute(
            path: '/settings',
            name: 'settings',
            pageBuilder: (context, state) {
              return MaterialPage<void>(
                key: _rootKey,
                child: const SettingsPage(),
              );
            },
            routes: [
              GoRoute(
                path: 'edit',
                name: 'editProfile',
                pageBuilder: (context, state) {
                  final me = appModel.profile?.username ?? 'me';
                  return MaterialPage<void>(
                    key: state.pageKey,
                    child: EditProfile(
                      username: me,
                    ),
                  );
                },
              ),
            ]),
        GoRoute(
          path: '/:user',
          name: 'user',
          routes: [
            GoRoute(
              path: 'settings',
              name: 'my_settings',
              pageBuilder: (context, state) {
                return MaterialPage<void>(
                  key: state.pageKey,
                  child: const SettingsPage(),
                );
              },
            ),
          ],
          pageBuilder: _userTabs,
        ),
      ],
      redirect: _handleRedirect,
      errorPageBuilder: (context, state) {
        print('location: ${state.location}');
        // final uri = Uri.tryParse(state.location);
        // print('state.location: ${state.location}');
        // if (uri != null && uri.pathSegments.length == 1) {
        //   final username = uri.pathSegments.first;
        //   return MaterialPage(
        //     child: ProfilePage(
        //       username,
        //     ),
        //     key: state.pageKey,
        //   );
        // }
        return MaterialPage<void>(
          key: state.pageKey,
          child: UnknownScreen(
            onClose: onCloseHandler,
          ),
        );
      },
    );
  }
}
