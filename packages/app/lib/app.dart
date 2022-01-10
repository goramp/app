import 'dart:async';
import 'package:browser_adapter/browser_adapter.dart';
import 'package:country_code_picker/country_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:goramp/bloc/fiat_rate_cubit.dart';
import 'package:goramp/bloc/payment_transactions.dart';
import 'package:goramp/bloc/wallet/claims_cubit.dart';
import 'package:goramp/bloc/wallet/wallet_provider/inapp_wallet.dart';
import 'package:goramp/widgets/data/gotok_options.dart';
import 'package:goramp/widgets/router/app_route_manager.dart';
import 'package:provider/provider.dart';
import 'package:solana/solana.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:wiredash/wiredash.dart';
import './bloc/index.dart';
import 'app_config.dart';
import 'widgets/index.dart';
import 'package:goramp/generated/l10n.dart';

class AuthLoader extends StatelessWidget {
  final Widget child;
  const AuthLoader(this.child);

  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<AuthenticationBloc>(context),
      builder: (BuildContext context, AuthenticationState state) {
        return child;
      },
    );
  }
}

class App extends StatefulWidget {
  final AppConfig config;
  final GotokOptions options;
  final AuthenticationBloc authenticationBloc;
  final MyAppModel appModel;
  //final LazyBox<Record> recordBox;
  // final Realm realm;
  App(
      {Key? key,
      required this.config,
      required this.options,
      required this.authenticationBloc,
      required this.appModel})
      : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  late AppRouter _appRouter;
  late ConnectionBloc _connectionBloc;
  late PreviewBloc _previewBloc;
  late StreamSubscription _linkStream;
  late SnackbarBloc _snackbarBloc;
  late MyCallLinksBloc _myEventBloc;
  late CallFeedBloc _scheduleFeedBloc;
  late UserPaymentProviderCubit _userPaymentProviderCubit;
  late PaymentProviderCubit _paymentProviderCubit;
  late MyCustomerCubit _customerCubit;
  //RTCCallClient _callClient;
  late LinkBloc _linkBloc;
  RouteObserver<ModalRoute> _routeObserver = RouteObserver<ModalRoute>();
  // CallKitBloc _callKitBloc;
  late NotificationsBloc _notificationBloc;
  late InAppWalletProvider _appWalletProvider;
  late SearchBloc _searchBloc;
  late WalletCubit _walletCubit;
  late RPCClient _solanaClient;
  late CryptoPriceCubit _cryptoPriceCubit;
  late FiatRatesCubit _fiatRateCubit;
  late PaymentTransactionsCubit _transactionsCubit;
  late ClaimsCubit _claimsCubit;
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    //_callClient = FirebaseCallClient();
    _createBloc();
    _initStripe();
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      removeDocument('loading-indicator');
    });
  }

  void _initStripe() {
    if (!UniversalPlatform.isWeb) {
      // StripePayment.setOptions(StripeOptions(
      //     publishableKey: widget.config.stripePublishKey,
      //     merchantId: widget.config.applePayMerchantId,
      //     androidPayMode: widget.config.isDev ? 'test' : null));
    }
  }

  void _createBloc() {
    _solanaClient = RPCClient(widget.config.solanaRPCUrl!);
    _appRouter = AppRouter(widget.appModel);
    _cryptoPriceCubit = CryptoPriceCubit(widget.authenticationBloc);
    _fiatRateCubit = FiatRatesCubit(widget.authenticationBloc);
    _transactionsCubit = PaymentTransactionsCubit(widget.authenticationBloc);
    _connectionBloc = ConnectionBloc(widget.config);
    _previewBloc = PreviewBloc();
    _snackbarBloc = SnackbarBloc();
    _myEventBloc = MyCallLinksBloc(
        authBloc: widget.authenticationBloc, useUsername: false);
    _userPaymentProviderCubit =
        UserPaymentProviderCubit(widget.authenticationBloc);
    _paymentProviderCubit =
        PaymentProviderCubit(widget.config, widget.authenticationBloc);
    _customerCubit = MyCustomerCubit(widget.authenticationBloc);
    _scheduleFeedBloc =
        CallFeedBloc(widget.authenticationBloc, config: widget.config);
    _linkBloc = LinkBloc();
    _notificationBloc = NotificationsBloc(
      widget.authenticationBloc,
    );
    _searchBloc = SearchBloc(
      config: widget.config,
    );
    _claimsCubit = ClaimsCubit(widget.authenticationBloc);
    _appWalletProvider =
        InAppWalletProvider(widget.config, widget.authenticationBloc);
    _walletCubit = WalletCubit(
        widget.appModel, widget.authenticationBloc, _appWalletProvider);
  }

  void _disposeBloc() {
    _connectionBloc.dispose();
    _previewBloc.close();
    _snackbarBloc.close();
    _myEventBloc.close();
    _scheduleFeedBloc.close();
    _notificationBloc.dispose();
    // _callKitBloc.dispose();
    widget.authenticationBloc.close();
    _searchBloc.close();
    _paymentProviderCubit.close();
    _userPaymentProviderCubit.close();
    _customerCubit.close();
    _walletCubit.close();
    _cryptoPriceCubit.close();
    _fiatRateCubit.close();
    _transactionsCubit.close();
    _claimsCubit.close();
    _appWalletProvider.dispose();
  }

  void dispose() {
    _disposeBloc();
    WidgetsBinding.instance!.removeObserver(this);
    _linkStream.cancel();
    widget.appModel.dispose();
    super.dispose();
  }

  Widget _buildMaterialApp() {
    final theme = ThemeHelper.buildMaterialAppTheme(
        context, widget.config.isKuro ? kLightColorScheme : lightColorScheme,
        brightness: Brightness.light);
    final darkTheme = ThemeHelper.buildMaterialAppTheme(
      context,
      widget.config.isKuro ? kDarkColorScheme : darkColorScheme,
      brightness: Brightness.dark,
    );
    Widget body = MaterialApp.router(
        title: widget.config.appName!,
        shortcuts: <ShortcutActivator, Intent>{
          ...WidgetsApp.defaultShortcuts,
          const SingleActivator(LogicalKeyboardKey.select):
              const ActivateIntent(),
        },
        localizationsDelegates: [
          S.delegate,
          CountryLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        debugShowCheckedModeBanner: false,
        theme: theme,
        darkTheme: darkTheme,
        routerDelegate: _appRouter.router.routerDelegate, // _routerDelegate,
        routeInformationParser:
            _appRouter.router.routeInformationParser //routeInformationParser,
        );
    if (!widget.config.isDev) {
      body = Wiredash(
        projectId: widget.config.wireDashProjectId!,
        secret: widget.config.wireDashSecret!,
        navigatorKey: _navigatorKey,
        child: widget.config.isBeta
            ? Banner(
                message: 'BETA',
                child: body,
                location: BannerLocation.bottomStart,
              )
            : body,
      );
    }
    return body;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MyAppModel>.value(value: widget.appModel),
        Provider<GotokOptions>.value(
          value: widget.options,
        ),
        Provider<AppConfig>.value(
          value: widget.config,
        ),
        Provider<ConnectionBloc>.value(
          value: _connectionBloc,
        ),
        Provider<RouteObserver<ModalRoute>>.value(
          value: _routeObserver,
        ),
        Provider<NotificationsBloc>.value(
          value: _notificationBloc,
        ),
        // Provider<CallKitBloc>.value(
        //   value: _callKitBloc,
        // ),
        Provider<LinkBloc>.value(
          value: _linkBloc,
        ),
        Provider<RPCClient>.value(
          value: _solanaClient,
        ),
        Provider<InAppWalletProvider>.value(
          value: _appWalletProvider,
        ),
      ],
      child: MultiBlocProvider(
        child: _buildMaterialApp(),
        providers: [
          BlocProvider<SearchBloc>.value(value: _searchBloc),
          BlocProvider<CallFeedBloc>.value(value: _scheduleFeedBloc),
          BlocProvider<MyCallLinksBloc>.value(value: _myEventBloc),
          BlocProvider<PreviewBloc>.value(value: _previewBloc),
          BlocProvider<AuthenticationBloc>.value(
              value: widget.authenticationBloc),
          BlocProvider<UserPaymentProviderCubit>.value(
              value: _userPaymentProviderCubit),
          BlocProvider<MyCustomerCubit>.value(value: _customerCubit),
          BlocProvider<PaymentProviderCubit>.value(
              value: _paymentProviderCubit),
          BlocProvider<WalletCubit>.value(value: _walletCubit),
          BlocProvider<CryptoPriceCubit>.value(value: _cryptoPriceCubit),
          BlocProvider<FiatRatesCubit>.value(value: _fiatRateCubit),
          BlocProvider<PaymentTransactionsCubit>.value(
              value: _transactionsCubit),
          BlocProvider<ClaimsCubit>.value(value: _claimsCubit),
        ],
      ),
    );
  }
}
