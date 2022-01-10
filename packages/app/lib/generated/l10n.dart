// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Accept crypto payments`
  String get accept_crypto_payment {
    return Intl.message(
      'Accept crypto payments',
      name: 'accept_crypto_payment',
      desc: '',
      args: [],
    );
  }

  /// `Accept NFT TimePass`
  String get accept_nft_timepass {
    return Intl.message(
      'Accept NFT TimePass',
      name: 'accept_nft_timepass',
      desc: '',
      args: [],
    );
  }

  /// `Accept card payments with Stripe`
  String get accept_payment_stripe {
    return Intl.message(
      'Accept card payments with Stripe',
      name: 'accept_payment_stripe',
      desc: '',
      args: [],
    );
  }

  /// `An account already exist with the same email address.`
  String get account_already_exist {
    return Intl.message(
      'An account already exist with the same email address.',
      name: 'account_already_exist',
      desc: '',
      args: [],
    );
  }

  /// `Account disabled.`
  String get account_disabled {
    return Intl.message(
      'Account disabled.',
      name: 'account_disabled',
      desc: '',
      args: [],
    );
  }

  /// `Account Exist`
  String get account_exists {
    return Intl.message(
      'Account Exist',
      name: 'account_exists',
      desc: '',
      args: [],
    );
  }

  /// `Account ID`
  String get account_id {
    return Intl.message(
      'Account ID',
      name: 'account_id',
      desc: '',
      args: [],
    );
  }

  /// `You must add a payment provider such as Stripe or`
  String get add_a_payment_provider {
    return Intl.message(
      'You must add a payment provider such as Stripe or',
      name: 'add_a_payment_provider',
      desc: '',
      args: [],
    );
  }

  /// `Add Card`
  String get add_card {
    return Intl.message(
      'Add Card',
      name: 'add_card',
      desc: '',
      args: [],
    );
  }

  /// `Add Details`
  String get add_details {
    return Intl.message(
      'Add Details',
      name: 'add_details',
      desc: '',
      args: [],
    );
  }

  /// `Add Funds`
  String get add_funds {
    return Intl.message(
      'Add Funds',
      name: 'add_funds',
      desc: '',
      args: [],
    );
  }

  /// `Add Interval`
  String get add_interval {
    return Intl.message(
      'Add Interval',
      name: 'add_interval',
      desc: '',
      args: [],
    );
  }

  /// `Add notes`
  String get add_notes {
    return Intl.message(
      'Add notes',
      name: 'add_notes',
      desc: '',
      args: [],
    );
  }

  /// `Add Payment Method`
  String get add_payment_method {
    return Intl.message(
      'Add Payment Method',
      name: 'add_payment_method',
      desc: '',
      args: [],
    );
  }

  /// `Add Payment Provider`
  String get add_payment_provider {
    return Intl.message(
      'Add Payment Provider',
      name: 'add_payment_provider',
      desc: '',
      args: [],
    );
  }

  /// `Add Price`
  String get add_price {
    return Intl.message(
      'Add Price',
      name: 'add_price',
      desc: '',
      args: [],
    );
  }

  /// `add this on your phone so we can record and watch videos together`
  String get add_this_on_phone_record_watch {
    return Intl.message(
      'add this on your phone so we can record and watch videos together',
      name: 'add_this_on_phone_record_watch',
      desc: '',
      args: [],
    );
  }

  /// `add this to your phone so we can watch and record videos together`
  String get add_this_to_phone_watch_record {
    return Intl.message(
      'add this to your phone so we can watch and record videos together',
      name: 'add_this_to_phone_watch_record',
      desc: '',
      args: [],
    );
  }

  /// `Add your rescheduling and cancellation policies.`
  String get add_your_rescheduling {
    return Intl.message(
      'Add your rescheduling and cancellation policies.',
      name: 'add_your_rescheduling',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `See all sign in options`
  String get all_signin_options {
    return Intl.message(
      'See all sign in options',
      name: 'all_signin_options',
      desc: '',
      args: [],
    );
  }

  /// `Allow access to camera`
  String get allow_access_camera {
    return Intl.message(
      'Allow access to camera',
      name: 'allow_access_camera',
      desc: '',
      args: [],
    );
  }

  /// `Allow access to microphone`
  String get allow_access_microphone {
    return Intl.message(
      'Allow access to microphone',
      name: 'allow_access_microphone',
      desc: '',
      args: [],
    );
  }

  /// `Almost there!`
  String get almost_there {
    return Intl.message(
      'Almost there!',
      name: 'almost_there',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get amount {
    return Intl.message(
      'Amount',
      name: 'amount',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred. Please try again`
  String get an_error_occurred {
    return Intl.message(
      'An error occurred. Please try again',
      name: 'an_error_occurred',
      desc: '',
      args: [],
    );
  }

  /// `and`
  String get and {
    return Intl.message(
      'and',
      name: 'and',
      desc: '',
      args: [],
    );
  }

  /// `Api Key`
  String get api_key {
    return Intl.message(
      'Api Key',
      name: 'api_key',
      desc: '',
      args: [],
    );
  }

  /// `Apologies, but something went wrong.`
  String get apologies_something_went_wrong {
    return Intl.message(
      'Apologies, but something went wrong.',
      name: 'apologies_something_went_wrong',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this card`
  String get are_you_sure_delete_card {
    return Intl.message(
      'Are you sure you want to delete this card',
      name: 'are_you_sure_delete_card',
      desc: '',
      args: [],
    );
  }

  /// `Availability`
  String get availablity {
    return Intl.message(
      'Availability',
      name: 'availablity',
      desc: '',
      args: [],
    );
  }

  /// `Balance`
  String get balance {
    return Intl.message(
      'Balance',
      name: 'balance',
      desc: '',
      args: [],
    );
  }

  /// `Your Base Commission Rate`
  String get base_commission_rate {
    return Intl.message(
      'Your Base Commission Rate',
      name: 'base_commission_rate',
      desc: '',
      args: [],
    );
  }

  /// `Bio`
  String get bio {
    return Intl.message(
      'Bio',
      name: 'bio',
      desc: '',
      args: [],
    );
  }

  /// `Birthday`
  String get birthday {
    return Intl.message(
      'Birthday',
      name: 'birthday',
      desc: '',
      args: [],
    );
  }

  /// `Book`
  String get book {
    return Intl.message(
      'Book',
      name: 'book',
      desc: '',
      args: [],
    );
  }

  /// `Booking Confirmed`
  String get booking_confirmed {
    return Intl.message(
      'Booking Confirmed',
      name: 'booking_confirmed',
      desc: '',
      args: [],
    );
  }

  /// `Buy`
  String get buy {
    return Intl.message(
      'Buy',
      name: 'buy',
      desc: '',
      args: [],
    );
  }

  /// `Buy Now`
  String get buy_now {
    return Intl.message(
      'Buy Now',
      name: 'buy_now',
      desc: '',
      args: [],
    );
  }

  /// `Call Link`
  String get call_link {
    return Intl.message(
      'Call Link',
      name: 'call_link',
      desc: '',
      args: [],
    );
  }

  /// `Call link cannot accept new bookings`
  String get call_link_accept_new_booking {
    return Intl.message(
      'Call link cannot accept new bookings',
      name: 'call_link_accept_new_booking',
      desc: '',
      args: [],
    );
  }

  /// `Call link can accept bookings`
  String get call_link_can_accept_booking {
    return Intl.message(
      'Call link can accept bookings',
      name: 'call_link_can_accept_booking',
      desc: '',
      args: [],
    );
  }

  /// `Your call link will be LIVE and would start accepting bookings`
  String get call_link_live {
    return Intl.message(
      'Your call link will be LIVE and would start accepting bookings',
      name: 'call_link_live',
      desc: '',
      args: [],
    );
  }

  /// `Your call link will not be visible and won't accept bookings.`
  String get call_link_not_visible {
    return Intl.message(
      'Your call link will not be visible and won\'t accept bookings.',
      name: 'call_link_not_visible',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get camera {
    return Intl.message(
      'Camera',
      name: 'camera',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Cancel CallLink?`
  String get cancel_callback {
    return Intl.message(
      'Cancel CallLink?',
      name: 'cancel_callback',
      desc: '',
      args: [],
    );
  }

  /// `Canceled`
  String get canceled {
    return Intl.message(
      'Canceled',
      name: 'canceled',
      desc: '',
      args: [],
    );
  }

  /// `Canceling`
  String get canceling {
    return Intl.message(
      'Canceling',
      name: 'canceling',
      desc: '',
      args: [],
    );
  }

  /// `CARDS`
  String get cards {
    return Intl.message(
      'CARDS',
      name: 'cards',
      desc: '',
      args: [],
    );
  }

  /// `Check your inbox`
  String get check_your_inbox {
    return Intl.message(
      'Check your inbox',
      name: 'check_your_inbox',
      desc: '',
      args: [],
    );
  }

  /// `Checkout`
  String get checkout {
    return Intl.message(
      'Checkout',
      name: 'checkout',
      desc: '',
      args: [],
    );
  }

  /// `Choose Cover Photo`
  String get choose_cover_photo {
    return Intl.message(
      'Choose Cover Photo',
      name: 'choose_cover_photo',
      desc: '',
      args: [],
    );
  }

  /// `Claims`
  String get claims {
    return Intl.message(
      'Claims',
      name: 'claims',
      desc: '',
      args: [],
    );
  }

  /// `Claim Now`
  String get claim_now {
    return Intl.message(
      'Claim Now',
      name: 'claim_now',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get clear {
    return Intl.message(
      'Clear',
      name: 'clear',
      desc: '',
      args: [],
    );
  }

  /// `2. Click "Add an endpoint" and paste the followig url:`
  String get click_add_on_endpoint {
    return Intl.message(
      '2. Click "Add an endpoint" and paste the followig url:',
      name: 'click_add_on_endpoint',
      desc: '',
      args: [],
    );
  }

  /// `Click the link we sent to {email} to continue`
  String click_link_sent(Object email) {
    return Intl.message(
      'Click the link we sent to $email to continue',
      name: 'click_link_sent',
      desc: '',
      args: [email],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Coinbase Commerce before you can set your price.`
  String get coinbase_commerce_before {
    return Intl.message(
      'Coinbase Commerce before you can set your price.',
      name: 'coinbase_commerce_before',
      desc: '',
      args: [],
    );
  }

  /// `1. In your Coinbase Commerce settings page, scroll to the "Webhook subscriptions" section.`
  String get coinbase_commerce_setting {
    return Intl.message(
      '1. In your Coinbase Commerce settings page, scroll to the "Webhook subscriptions" section.',
      name: 'coinbase_commerce_setting',
      desc: '',
      args: [],
    );
  }

  /// `Collect Payment`
  String get collect_payment {
    return Intl.message(
      'Collect Payment',
      name: 'collect_payment',
      desc: '',
      args: [],
    );
  }

  /// `Collect payments with card, Apple  Pay, Google Pay.`
  String get collect_payment_card_apple_google_pay {
    return Intl.message(
      'Collect payments with card, Apple  Pay, Google Pay.',
      name: 'collect_payment_card_apple_google_pay',
      desc: '',
      args: [],
    );
  }

  /// `Collect payments in KURO, USDC, USDT and SOL`
  String get collect_payment_sol_usd_kuro {
    return Intl.message(
      'Collect payments in KURO, USDC, USDT and SOL',
      name: 'collect_payment_sol_usd_kuro',
      desc: '',
      args: [],
    );
  }

  /// `Complete your profile`
  String get complete_your_profile {
    return Intl.message(
      'Complete your profile',
      name: 'complete_your_profile',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirm_password {
    return Intl.message(
      'Confirm Password',
      name: 'confirm_password',
      desc: '',
      args: [],
    );
  }

  /// `Confirmed`
  String get confirmed {
    return Intl.message(
      'Confirmed',
      name: 'confirmed',
      desc: '',
      args: [],
    );
  }

  /// `Connect`
  String get connect {
    return Intl.message(
      'Connect',
      name: 'connect',
      desc: '',
      args: [],
    );
  }

  /// `Connect bank to earn`
  String get connect_bank_earn {
    return Intl.message(
      'Connect bank to earn',
      name: 'connect_bank_earn',
      desc: '',
      args: [],
    );
  }

  /// `Connect Coinbase Commerce`
  String get connect_coinbase {
    return Intl.message(
      'Connect Coinbase Commerce',
      name: 'connect_coinbase',
      desc: '',
      args: [],
    );
  }

  /// `Connect Solana Wallet`
  String get connect_solana_wallet {
    return Intl.message(
      'Connect Solana Wallet',
      name: 'connect_solana_wallet',
      desc: '',
      args: [],
    );
  }

  /// `Connect wallet to earn`
  String get connect_wallet_earn {
    return Intl.message(
      'Connect wallet to earn',
      name: 'connect_wallet_earn',
      desc: '',
      args: [],
    );
  }

  /// `Connect Wallet`
  String get connect_wallet {
    return Intl.message(
      'Connect Wallet',
      name: 'connect_wallet',
      desc: '',
      args: [],
    );
  }

  /// `Connect Your Stripe Account`
  String get connect_your_stripe_account {
    return Intl.message(
      'Connect Your Stripe Account',
      name: 'connect_your_stripe_account',
      desc: '',
      args: [],
    );
  }

  /// `Connection error!`
  String get connection_error {
    return Intl.message(
      'Connection error!',
      name: 'connection_error',
      desc: '',
      args: [],
    );
  }

  /// `This video potentially contains content that violates our policy. If we have made a mistake, continue to request a manual review when the video is uploaded.`
  String get content_violates_policy {
    return Intl.message(
      'This video potentially contains content that violates our policy. If we have made a mistake, continue to request a manual review when the video is uploaded.',
      name: 'content_violates_policy',
      desc: '',
      args: [],
    );
  }

  /// `Continue with Apple`
  String get continue_apple {
    return Intl.message(
      'Continue with Apple',
      name: 'continue_apple',
      desc: '',
      args: [],
    );
  }

  /// `Continue with Email`
  String get continue_email {
    return Intl.message(
      'Continue with Email',
      name: 'continue_email',
      desc: '',
      args: [],
    );
  }

  /// `Continue with Facebook`
  String get continue_facebook {
    return Intl.message(
      'Continue with Facebook',
      name: 'continue_facebook',
      desc: '',
      args: [],
    );
  }

  /// `Continue with Google`
  String get continue_google {
    return Intl.message(
      'Continue with Google',
      name: 'continue_google',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continue_string {
    return Intl.message(
      'Continue',
      name: 'continue_string',
      desc: '',
      args: [],
    );
  }

  /// `Continue with Twitter`
  String get continue_twitter {
    return Intl.message(
      'Continue with Twitter',
      name: 'continue_twitter',
      desc: '',
      args: [],
    );
  }

  /// `Contribute`
  String get contribute {
    return Intl.message(
      'Contribute',
      name: 'contribute',
      desc: '',
      args: [],
    );
  }

  /// `Copied`
  String get copied {
    return Intl.message(
      'Copied',
      name: 'copied',
      desc: '',
      args: [],
    );
  }

  /// `Copied to clipboard`
  String get copied_to_clipboard {
    return Intl.message(
      'Copied to clipboard',
      name: 'copied_to_clipboard',
      desc: '',
      args: [],
    );
  }

  /// `Copy Link`
  String get copy_link {
    return Intl.message(
      'Copy Link',
      name: 'copy_link',
      desc: '',
      args: [],
    );
  }

  /// `Could not open mail app`
  String get could_not_open_mail_app {
    return Intl.message(
      'Could not open mail app',
      name: 'could_not_open_mail_app',
      desc: '',
      args: [],
    );
  }

  /// `Create`
  String get create {
    return Intl.message(
      'Create',
      name: 'create',
      desc: '',
      args: [],
    );
  }

  /// `Create a call link to start receiving or scheduling 1:1 calls`
  String get create_a_call_lin {
    return Intl.message(
      'Create a call link to start receiving or scheduling 1:1 calls',
      name: 'create_a_call_lin',
      desc: '',
      args: [],
    );
  }

  /// `Create a call link to start receiving`
  String get create_a_calllink_receive {
    return Intl.message(
      'Create a call link to start receiving',
      name: 'create_a_calllink_receive',
      desc: '',
      args: [],
    );
  }

  /// `Create a title`
  String get create_a_title {
    return Intl.message(
      'Create a title',
      name: 'create_a_title',
      desc: '',
      args: [],
    );
  }

  /// `CREATE ACCOUNT`
  String get create_account {
    return Intl.message(
      'CREATE ACCOUNT',
      name: 'create_account',
      desc: '',
      args: [],
    );
  }

  /// `create a new account`
  String get create_new_account {
    return Intl.message(
      'create a new account',
      name: 'create_new_account',
      desc: '',
      args: [],
    );
  }

  /// `Create a title`
  String get create_title {
    return Intl.message(
      'Create a title',
      name: 'create_title',
      desc: '',
      args: [],
    );
  }

  /// `Current Price`
  String get current_price {
    return Intl.message(
      'Current Price',
      name: 'current_price',
      desc: '',
      args: [],
    );
  }

  /// `Data will not be stored`
  String get data_not_stored {
    return Intl.message(
      'Data will not be stored',
      name: 'data_not_stored',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message(
      'Date',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `Days`
  String get days {
    return Intl.message(
      'Days',
      name: 'days',
      desc: '',
      args: [],
    );
  }

  /// `Please try again.`
  String get default_error_title {
    return Intl.message(
      'Please try again.',
      name: 'default_error_title',
      desc: '',
      args: [],
    );
  }

  /// `Something doesn't seem right, we are checking...`
  String get default_error_title2 {
    return Intl.message(
      'Something doesn\'t seem right, we are checking...',
      name: 'default_error_title2',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Delete CallLink?`
  String get delete_calllink {
    return Intl.message(
      'Delete CallLink?',
      name: 'delete_calllink',
      desc: '',
      args: [],
    );
  }

  /// `Deposit`
  String get deposit {
    return Intl.message(
      'Deposit',
      name: 'deposit',
      desc: '',
      args: [],
    );
  }

  /// `Deposit funds from an FTX account, where you can add funds using crypto on multiple blockchains, credit cards, and more.`
  String get deposit_fund_on_ftx_account {
    return Intl.message(
      'Deposit funds from an FTX account, where you can add funds using crypto on multiple blockchains, credit cards, and more.',
      name: 'deposit_fund_on_ftx_account',
      desc: '',
      args: [],
    );
  }

  /// `Destination Address`
  String get destination_address {
    return Intl.message(
      'Destination Address',
      name: 'destination_address',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get details {
    return Intl.message(
      'Details',
      name: 'details',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get dialog_positive_default {
    return Intl.message(
      'OK',
      name: 'dialog_positive_default',
      desc: '',
      args: [],
    );
  }

  /// `Sorry we didn't recogize that email.`
  String get didnt_recognize_email {
    return Intl.message(
      'Sorry we didn\'t recogize that email.',
      name: 'didnt_recognize_email',
      desc: '',
      args: [],
    );
  }

  /// `Discard`
  String get discard {
    return Intl.message(
      'Discard',
      name: 'discard',
      desc: '',
      args: [],
    );
  }

  /// `Discard Call Link?`
  String get discard_call_link {
    return Intl.message(
      'Discard Call Link?',
      name: 'discard_call_link',
      desc: '',
      args: [],
    );
  }

  /// `This will discard your video and all changes.`
  String get discard_video_changes {
    return Intl.message(
      'This will discard your video and all changes.',
      name: 'discard_video_changes',
      desc: '',
      args: [],
    );
  }

  /// `Disconnect`
  String get disconnect {
    return Intl.message(
      'Disconnect',
      name: 'disconnect',
      desc: '',
      args: [],
    );
  }

  /// `Disconnect Coinbase Commerce?`
  String get disconnect_coinbase {
    return Intl.message(
      'Disconnect Coinbase Commerce?',
      name: 'disconnect_coinbase',
      desc: '',
      args: [],
    );
  }

  /// `Disconnect Stripe?`
  String get disconnect_stripe {
    return Intl.message(
      'Disconnect Stripe?',
      name: 'disconnect_stripe',
      desc: '',
      args: [],
    );
  }

  /// `discount`
  String get discount {
    return Intl.message(
      'discount',
      name: 'discount',
      desc: '',
      args: [],
    );
  }

  /// `Dismiss`
  String get dismiss {
    return Intl.message(
      'Dismiss',
      name: 'dismiss',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message(
      'Done',
      name: 'done',
      desc: '',
      args: [],
    );
  }

  /// `Dont't have an account?`
  String get dont_have_an_account {
    return Intl.message(
      'Dont\'t have an account?',
      name: 'dont_have_an_account',
      desc: '',
      args: [],
    );
  }

  /// `Duration`
  String get duration {
    return Intl.message(
      'Duration',
      name: 'duration',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Edit Call Link`
  String get edit_call_link {
    return Intl.message(
      'Edit Call Link',
      name: 'edit_call_link',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profile`
  String get edit_profile {
    return Intl.message(
      'Edit Profile',
      name: 'edit_profile',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Enter the email associated with your account, and we'll send a magic link to your inbox.`
  String get email_associated_with_account {
    return Intl.message(
      'Enter the email associated with your account, and we\'ll send a magic link to your inbox.',
      name: 'email_associated_with_account',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email address to receive a link to reset your password.`
  String get email_link_reset_password {
    return Intl.message(
      'Please enter your email address to receive a link to reset your password.',
      name: 'email_link_reset_password',
      desc: '',
      args: [],
    );
  }

  /// `Email Verified`
  String get email_verified {
    return Intl.message(
      'Email Verified',
      name: 'email_verified',
      desc: '',
      args: [],
    );
  }

  /// `Your end time cannot be before your start time`
  String get end_cant_be_before_start {
    return Intl.message(
      'Your end time cannot be before your start time',
      name: 'end_cant_be_before_start',
      desc: '',
      args: [],
    );
  }

  /// `Ended`
  String get ended {
    return Intl.message(
      'Ended',
      name: 'ended',
      desc: '',
      args: [],
    );
  }

  /// `Ending`
  String get ending {
    return Intl.message(
      'Ending',
      name: 'ending',
      desc: '',
      args: [],
    );
  }

  /// `Ends`
  String get ends {
    return Intl.message(
      'Ends',
      name: 'ends',
      desc: '',
      args: [],
    );
  }

  /// `Enter`
  String get enter {
    return Intl.message(
      'Enter',
      name: 'enter',
      desc: '',
      args: [],
    );
  }

  /// `Enter a price`
  String get enter_a_price {
    return Intl.message(
      'Enter a price',
      name: 'enter_a_price',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email address to create an account.`
  String get enter_email_create_account {
    return Intl.message(
      'Enter your email address to create an account.',
      name: 'enter_email_create_account',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid email address`
  String get enter_valid_email {
    return Intl.message(
      'Enter a valid email address',
      name: 'enter_valid_email',
      desc: '',
      args: [],
    );
  }

  /// `error`
  String get error {
    return Intl.message(
      'error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `estimated`
  String get estimated {
    return Intl.message(
      'estimated',
      name: 'estimated',
      desc: '',
      args: [],
    );
  }

  /// `name@example.com`
  String get example_com {
    return Intl.message(
      'name@example.com',
      name: 'example_com',
      desc: '',
      args: [],
    );
  }

  /// `You have exceeded the maximum of`
  String get exceeded_maximum_amount {
    return Intl.message(
      'You have exceeded the maximum of',
      name: 'exceeded_maximum_amount',
      desc: '',
      args: [],
    );
  }

  /// `You have exceeded the remaining amount of`
  String get exceeded_remaining_amount {
    return Intl.message(
      'You have exceeded the remaining amount of',
      name: 'exceeded_remaining_amount',
      desc: '',
      args: [],
    );
  }

  /// `Expired`
  String get expired {
    return Intl.message(
      'Expired',
      name: 'expired',
      desc: '',
      args: [],
    );
  }

  /// `Expiry`
  String get expiry {
    return Intl.message(
      'Expiry',
      name: 'expiry',
      desc: '',
      args: [],
    );
  }

  /// `External`
  String get external {
    return Intl.message(
      'External',
      name: 'external',
      desc: '',
      args: [],
    );
  }

  /// `Failed to fetch call links`
  String get fail_fetch_call_link {
    return Intl.message(
      'Failed to fetch call links',
      name: 'fail_fetch_call_link',
      desc: '',
      args: [],
    );
  }

  /// `Failed to fetch cards`
  String get fail_fetch_card {
    return Intl.message(
      'Failed to fetch cards',
      name: 'fail_fetch_card',
      desc: '',
      args: [],
    );
  }

  /// `Failed to fetch tokens`
  String get fail_to_fetch_tokens {
    return Intl.message(
      'Failed to fetch tokens',
      name: 'fail_to_fetch_tokens',
      desc: '',
      args: [],
    );
  }

  /// `Failed`
  String get failed {
    return Intl.message(
      'Failed',
      name: 'failed',
      desc: '',
      args: [],
    );
  }

  /// `Failed to fetch transactions`
  String get failed_fetch_transactions {
    return Intl.message(
      'Failed to fetch transactions',
      name: 'failed_fetch_transactions',
      desc: '',
      args: [],
    );
  }

  /// `Failed to fetch wallet details`
  String get failed_fetch_wallet {
    return Intl.message(
      'Failed to fetch wallet details',
      name: 'failed_fetch_wallet',
      desc: '',
      args: [],
    );
  }

  /// `Failed to fetch`
  String get failed_to_fetch {
    return Intl.message(
      'Failed to fetch',
      name: 'failed_to_fetch',
      desc: '',
      args: [],
    );
  }

  /// `failed to fetch event details.`
  String get failed_to_fetch_event_details {
    return Intl.message(
      'failed to fetch event details.',
      name: 'failed_to_fetch_event_details',
      desc: '',
      args: [],
    );
  }

  /// `Failed to fetch payment methods`
  String get failed_to_fetch_payment_method {
    return Intl.message(
      'Failed to fetch payment methods',
      name: 'failed_to_fetch_payment_method',
      desc: '',
      args: [],
    );
  }

  /// `Failed to fetch schedules`
  String get failed_to_fetch_schedules {
    return Intl.message(
      'Failed to fetch schedules',
      name: 'failed_to_fetch_schedules',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load payment method`
  String get failed_to_load_payment_method {
    return Intl.message(
      'Failed to load payment method',
      name: 'failed_to_load_payment_method',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load profile`
  String get failed_to_load_profile {
    return Intl.message(
      'Failed to load profile',
      name: 'failed_to_load_profile',
      desc: '',
      args: [],
    );
  }

  /// `Fee`
  String get fee {
    return Intl.message(
      'Fee',
      name: 'fee',
      desc: '',
      args: [],
    );
  }

  /// `Feedback`
  String get feedback {
    return Intl.message(
      'Feedback',
      name: 'feedback',
      desc: '',
      args: [],
    );
  }

  /// `Fetching card`
  String get fetching_card {
    return Intl.message(
      'Fetching card',
      name: 'fetching_card',
      desc: '',
      args: [],
    );
  }

  /// `Fetching payments`
  String get fetching_payments {
    return Intl.message(
      'Fetching payments',
      name: 'fetching_payments',
      desc: '',
      args: [],
    );
  }

  /// `Fetching tokens`
  String get fetching_token {
    return Intl.message(
      'Fetching tokens',
      name: 'fetching_token',
      desc: '',
      args: [],
    );
  }

  /// `Fetching transactions`
  String get fetching_transactions {
    return Intl.message(
      'Fetching transactions',
      name: 'fetching_transactions',
      desc: '',
      args: [],
    );
  }

  /// `Finish creating your account for the full experience.`
  String get finish_creating_account {
    return Intl.message(
      'Finish creating your account for the full experience.',
      name: 'finish_creating_account',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Passoword?`
  String get forgot_password {
    return Intl.message(
      'Forgot Passoword?',
      name: 'forgot_password',
      desc: '',
      args: [],
    );
  }

  /// `Free`
  String get free {
    return Intl.message(
      'Free',
      name: 'free',
      desc: '',
      args: [],
    );
  }

  /// `Fri`
  String get friday {
    return Intl.message(
      'Fri',
      name: 'friday',
      desc: '',
      args: [],
    );
  }

  /// `Friends Receive`
  String get friend_recieve {
    return Intl.message(
      'Friends Receive',
      name: 'friend_recieve',
      desc: '',
      args: [],
    );
  }

  /// `Set Friends’ Commission Kickback Rate`
  String get friends_commission_kickback_rate {
    return Intl.message(
      'Set Friends’ Commission Kickback Rate',
      name: 'friends_commission_kickback_rate',
      desc: '',
      args: [],
    );
  }

  /// `From`
  String get from {
    return Intl.message(
      'From',
      name: 'from',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get full_name {
    return Intl.message(
      'Full Name',
      name: 'full_name',
      desc: '',
      args: [],
    );
  }

  /// `Generate your link`
  String get generate_your_link {
    return Intl.message(
      'Generate your link',
      name: 'generate_your_link',
      desc: '',
      args: [],
    );
  }

  /// `Generating preview`
  String get generating_preview {
    return Intl.message(
      'Generating preview',
      name: 'generating_preview',
      desc: '',
      args: [],
    );
  }

  /// `Get Credit`
  String get get_credit {
    return Intl.message(
      'Get Credit',
      name: 'get_credit',
      desc: '',
      args: [],
    );
  }

  /// `Get Started`
  String get get_started {
    return Intl.message(
      'Get Started',
      name: 'get_started',
      desc: '',
      args: [],
    );
  }

  /// `Grants access using NFT TimePass as tickets`
  String get grant_access {
    return Intl.message(
      'Grants access using NFT TimePass as tickets',
      name: 'grant_access',
      desc: '',
      args: [],
    );
  }

  /// `Grant camera access to record`
  String get grant_camera_access_record {
    return Intl.message(
      'Grant camera access to record',
      name: 'grant_camera_access_record',
      desc: '',
      args: [],
    );
  }

  /// `Guest`
  String get guest {
    return Intl.message(
      'Guest',
      name: 'guest',
      desc: '',
      args: [],
    );
  }

  /// `Hello World!`
  String get helloWorld {
    return Intl.message(
      'Hello World!',
      name: 'helloWorld',
      desc: '',
      args: [],
    );
  }

  /// `Hey`
  String get hey {
    return Intl.message(
      'Hey',
      name: 'hey',
      desc: '',
      args: [],
    );
  }

  /// `Host`
  String get host {
    return Intl.message(
      'Host',
      name: 'host',
      desc: '',
      args: [],
    );
  }

  /// `Hours`
  String get hours {
    return Intl.message(
      'Hours',
      name: 'hours',
      desc: '',
      args: [],
    );
  }

  /// `I'm available`
  String get i_m_avaliable {
    return Intl.message(
      'I\'m available',
      name: 'i_m_avaliable',
      desc: '',
      args: [],
    );
  }

  /// `Identity Verified`
  String get identity_verified {
    return Intl.message(
      'Identity Verified',
      name: 'identity_verified',
      desc: '',
      args: [],
    );
  }

  /// `In order to accept Bitcoin, Ethereum, DAI, Litecoin, Bitcoin Cash, or USD Coin, you need to link your coinbase commerce account.`
  String get in_order_accept_bitcoin_etherum {
    return Intl.message(
      'In order to accept Bitcoin, Ethereum, DAI, Litecoin, Bitcoin Cash, or USD Coin, you need to link your coinbase commerce account.',
      name: 'in_order_accept_bitcoin_etherum',
      desc: '',
      args: [],
    );
  }

  /// `In order to accept kurobi, USD Coin or Solana, you need to link your solana wallet.`
  String get in_order_accept_kurobi_solona_usd {
    return Intl.message(
      'In order to accept kurobi, USD Coin or Solana, you need to link your solana wallet.',
      name: 'in_order_accept_kurobi_solona_usd',
      desc: '',
      args: [],
    );
  }

  /// `In order to collect card payments, you need to connect your stripe account. If you don't ve a stripe account, you will be redirected to create one.`
  String get in_order_connect_card_payment {
    return Intl.message(
      'In order to collect card payments, you need to connect your stripe account. If you don\'t ve a stripe account, you will be redirected to create one.',
      name: 'in_order_connect_card_payment',
      desc: '',
      args: [],
    );
  }

  /// `Inappropriate Content`
  String get inappropriate_content {
    return Intl.message(
      'Inappropriate Content',
      name: 'inappropriate_content',
      desc: '',
      args: [],
    );
  }

  /// `Insufficient funds`
  String get insufficient_funds {
    return Intl.message(
      'Insufficient funds',
      name: 'insufficient_funds',
      desc: '',
      args: [],
    );
  }

  /// `Intervals are overlapping`
  String get interval_overlapping {
    return Intl.message(
      'Intervals are overlapping',
      name: 'interval_overlapping',
      desc: '',
      args: [],
    );
  }

  /// `Intervals must be atleast`
  String get intervals_must_be {
    return Intl.message(
      'Intervals must be atleast',
      name: 'intervals_must_be',
      desc: '',
      args: [],
    );
  }

  /// `Host 1:1 video calls with your audience and get paid for your time`
  String get intro {
    return Intl.message(
      'Host 1:1 video calls with your audience and get paid for your time',
      name: 'intro',
      desc: '',
      args: [],
    );
  }

  /// `Host 1:1 video calls with your audience`
  String get intro_audience {
    return Intl.message(
      'Host 1:1 video calls with your audience',
      name: 'intro_audience',
      desc: '',
      args: [],
    );
  }

  /// `Host 1:1 video calls with your followers`
  String get intro_followers {
    return Intl.message(
      'Host 1:1 video calls with your followers',
      name: 'intro_followers',
      desc: '',
      args: [],
    );
  }

  /// `and get paid for your time`
  String get intro_paid_for_time {
    return Intl.message(
      'and get paid for your time',
      name: 'intro_paid_for_time',
      desc: '',
      args: [],
    );
  }

  /// `Invalid address`
  String get invalid_address {
    return Intl.message(
      'Invalid address',
      name: 'invalid_address',
      desc: '',
      args: [],
    );
  }

  /// `Invalid amount`
  String get invalid_amount {
    return Intl.message(
      'Invalid amount',
      name: 'invalid_amount',
      desc: '',
      args: [],
    );
  }

  /// `Invalid or expired action code.`
  String get invalid_expired_action_code {
    return Intl.message(
      'Invalid or expired action code.',
      name: 'invalid_expired_action_code',
      desc: '',
      args: [],
    );
  }

  /// `Invalid or expired code. Please verify your email address again.`
  String get invalid_expired_code {
    return Intl.message(
      'Invalid or expired code. Please verify your email address again.',
      name: 'invalid_expired_code',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Price`
  String get invalid_price {
    return Intl.message(
      'Invalid Price',
      name: 'invalid_price',
      desc: '',
      args: [],
    );
  }

  /// `Invite Friends`
  String get invite_friends {
    return Intl.message(
      'Invite Friends',
      name: 'invite_friends',
      desc: '',
      args: [],
    );
  }

  /// `Item Description`
  String get item_description {
    return Intl.message(
      'Item Description',
      name: 'item_description',
      desc: '',
      args: [],
    );
  }

  /// `Item Name`
  String get item_name {
    return Intl.message(
      'Item Name',
      name: 'item_name',
      desc: '',
      args: [],
    );
  }

  /// `JOIN CALL`
  String get join_call {
    return Intl.message(
      'JOIN CALL',
      name: 'join_call',
      desc: '',
      args: [],
    );
  }

  /// `Your KURO has been claimed and should now be in your wallet.`
  String get kuro_claimed_see_wallet {
    return Intl.message(
      'Your KURO has been claimed and should now be in your wallet.',
      name: 'kuro_claimed_see_wallet',
      desc: '',
      args: [],
    );
  }

  /// `Your KURO will be automatically distributed after the sale ends.`
  String get kuro_will_distributed_sales_end {
    return Intl.message(
      'Your KURO will be automatically distributed after the sale ends.',
      name: 'kuro_will_distributed_sales_end',
      desc: '',
      args: [],
    );
  }

  /// `Learn More`
  String get learn_more {
    return Intl.message(
      'Learn More',
      name: 'learn_more',
      desc: '',
      args: [],
    );
  }

  /// `Log In`
  String get log_in {
    return Intl.message(
      'Log In',
      name: 'log_in',
      desc: '',
      args: [],
    );
  }

  /// `Log in as a different user`
  String get log_in_different_user {
    return Intl.message(
      'Log in as a different user',
      name: 'log_in_different_user',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get log_out {
    return Intl.message(
      'Logout',
      name: 'log_out',
      desc: '',
      args: [],
    );
  }

  /// `Logout of`
  String get log_out_of {
    return Intl.message(
      'Logout of',
      name: 'log_out_of',
      desc: '',
      args: [],
    );
  }

  /// `Oops! Your username/email address or password is incorrect `
  String get login_unauthorized {
    return Intl.message(
      'Oops! Your username/email address or password is incorrect ',
      name: 'login_unauthorized',
      desc: '',
      args: [],
    );
  }

  /// `Login to view your liked call links`
  String get login_view_liked_calls {
    return Intl.message(
      'Login to view your liked call links',
      name: 'login_view_liked_calls',
      desc: '',
      args: [],
    );
  }

  /// `Max`
  String get max {
    return Intl.message(
      'Max',
      name: 'max',
      desc: '',
      args: [],
    );
  }

  /// `maximum`
  String get maximum {
    return Intl.message(
      'maximum',
      name: 'maximum',
      desc: '',
      args: [],
    );
  }

  /// `You have reached the maximum number of cards. Please remove or update an existing card`
  String get maximum_number_card {
    return Intl.message(
      'You have reached the maximum number of cards. Please remove or update an existing card',
      name: 'maximum_number_card',
      desc: '',
      args: [],
    );
  }

  /// `Me`
  String get me {
    return Intl.message(
      'Me',
      name: 'me',
      desc: '',
      args: [],
    );
  }

  /// `minimum:`
  String get minimum {
    return Intl.message(
      'minimum:',
      name: 'minimum',
      desc: '',
      args: [],
    );
  }

  /// `Minimum contribution of`
  String get minimum_contribution_of {
    return Intl.message(
      'Minimum contribution of',
      name: 'minimum_contribution_of',
      desc: '',
      args: [],
    );
  }

  /// `mins`
  String get mins {
    return Intl.message(
      'mins',
      name: 'mins',
      desc: '',
      args: [],
    );
  }

  /// `Minutes`
  String get minutes {
    return Intl.message(
      'Minutes',
      name: 'minutes',
      desc: '',
      args: [],
    );
  }

  /// `Mon`
  String get monday {
    return Intl.message(
      'Mon',
      name: 'monday',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `New Call Link`
  String get new_call_link {
    return Intl.message(
      'New Call Link',
      name: 'new_call_link',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get new_password {
    return Intl.message(
      'New Password',
      name: 'new_password',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `No likes here`
  String get no_likes_here {
    return Intl.message(
      'No likes here',
      name: 'no_likes_here',
      desc: '',
      args: [],
    );
  }

  /// `No Payment`
  String get no_payment {
    return Intl.message(
      'No Payment',
      name: 'no_payment',
      desc: '',
      args: [],
    );
  }

  /// `No Result Found`
  String get no_result_found {
    return Intl.message(
      'No Result Found',
      name: 'no_result_found',
      desc: '',
      args: [],
    );
  }

  /// `NO TITLE`
  String get no_title {
    return Intl.message(
      'NO TITLE',
      name: 'no_title',
      desc: '',
      args: [],
    );
  }

  /// `No Tokens`
  String get no_tokens {
    return Intl.message(
      'No Tokens',
      name: 'no_tokens',
      desc: '',
      args: [],
    );
  }

  /// `No Transactions`
  String get no_transactions {
    return Intl.message(
      'No Transactions',
      name: 'no_transactions',
      desc: '',
      args: [],
    );
  }

  /// `no buy events`
  String get no_upcoming_event {
    return Intl.message(
      'no buy events',
      name: 'no_upcoming_event',
      desc: '',
      args: [],
    );
  }

  /// `You have not liked any call links by`
  String get not_like_any_call_link {
    return Intl.message(
      'You have not liked any call links by',
      name: 'not_like_any_call_link',
      desc: '',
      args: [],
    );
  }

  /// `Notes`
  String get notes {
    return Intl.message(
      'Notes',
      name: 'notes',
      desc: '',
      args: [],
    );
  }

  /// `Nothing here`
  String get nothing_here {
    return Intl.message(
      'Nothing here',
      name: 'nothing_here',
      desc: '',
      args: [],
    );
  }

  /// `Ok`
  String get ok {
    return Intl.message(
      'Ok',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Open Mail AppOpen Mail App`
  String get open_mail_app {
    return Intl.message(
      'Open Mail AppOpen Mail App',
      name: 'open_mail_app',
      desc: '',
      args: [],
    );
  }

  /// `or`
  String get or {
    return Intl.message(
      'or',
      name: 'or',
      desc: '',
      args: [],
    );
  }

  /// `or drag and drop a file`
  String get or_drag_drop_file {
    return Intl.message(
      'or drag and drop a file',
      name: 'or_drag_drop_file',
      desc: '',
      args: [],
    );
  }

  /// `Order Canceled`
  String get order_canceled {
    return Intl.message(
      'Order Canceled',
      name: 'order_canceled',
      desc: '',
      args: [],
    );
  }

  /// `PASSES`
  String get passes {
    return Intl.message(
      'PASSES',
      name: 'passes',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Password is required`
  String get password_required {
    return Intl.message(
      'Password is required',
      name: 'password_required',
      desc: '',
      args: [],
    );
  }

  /// `Sell`
  String get sell {
    return Intl.message(
      'Sell',
      name: 'sell',
      desc: '',
      args: [],
    );
  }

  /// `Pay`
  String get pay {
    return Intl.message(
      'Pay',
      name: 'pay',
      desc: '',
      args: [],
    );
  }

  /// `Pay with crypto`
  String get pay_with_crypto {
    return Intl.message(
      'Pay with crypto',
      name: 'pay_with_crypto',
      desc: '',
      args: [],
    );
  }

  /// `Payment terms`
  String get payment_terms {
    return Intl.message(
      'Payment terms',
      name: 'payment_terms',
      desc: '',
      args: [],
    );
  }

  /// `PAYMENTS`
  String get payments {
    return Intl.message(
      'PAYMENTS',
      name: 'payments',
      desc: '',
      args: [],
    );
  }

  /// `Payout`
  String get payout {
    return Intl.message(
      'Payout',
      name: 'payout',
      desc: '',
      args: [],
    );
  }

  /// `Payout Now`
  String get payout_now {
    return Intl.message(
      'Payout Now',
      name: 'payout_now',
      desc: '',
      args: [],
    );
  }

  /// `Pending Balance`
  String get pending_balance {
    return Intl.message(
      'Pending Balance',
      name: 'pending_balance',
      desc: '',
      args: [],
    );
  }

  /// `Photo Library`
  String get photo_librar {
    return Intl.message(
      'Photo Library',
      name: 'photo_librar',
      desc: '',
      args: [],
    );
  }

  /// `Photos`
  String get photos {
    return Intl.message(
      'Photos',
      name: 'photos',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a new password.`
  String get please_enter_new_password {
    return Intl.message(
      'Please enter a new password.',
      name: 'please_enter_new_password',
      desc: '',
      args: [],
    );
  }

  /// `powered by`
  String get powered_by {
    return Intl.message(
      'powered by',
      name: 'powered_by',
      desc: '',
      args: [],
    );
  }

  /// `Preparing`
  String get preparing {
    return Intl.message(
      'Preparing',
      name: 'preparing',
      desc: '',
      args: [],
    );
  }

  /// `Preview`
  String get preview {
    return Intl.message(
      'Preview',
      name: 'preview',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get price {
    return Intl.message(
      'Price',
      name: 'price',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacy_policy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacy_policy',
      desc: '',
      args: [],
    );
  }

  /// `processing`
  String get processing {
    return Intl.message(
      'processing',
      name: 'processing',
      desc: '',
      args: [],
    );
  }

  /// `Processing Video`
  String get processing_video {
    return Intl.message(
      'Processing Video',
      name: 'processing_video',
      desc: '',
      args: [],
    );
  }

  /// `Product`
  String get product {
    return Intl.message(
      'Product',
      name: 'product',
      desc: '',
      args: [],
    );
  }

  /// `Profile not found`
  String get profile_not_found {
    return Intl.message(
      'Profile not found',
      name: 'profile_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Please provide your email for confirmation.`
  String get provide_email_for_confirmation {
    return Intl.message(
      'Please provide your email for confirmation.',
      name: 'provide_email_for_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Publish`
  String get publish {
    return Intl.message(
      'Publish',
      name: 'publish',
      desc: '',
      args: [],
    );
  }

  /// `Publish Call Link`
  String get publish_call_link {
    return Intl.message(
      'Publish Call Link',
      name: 'publish_call_link',
      desc: '',
      args: [],
    );
  }

  /// `Published`
  String get published {
    return Intl.message(
      'Published',
      name: 'published',
      desc: '',
      args: [],
    );
  }

  /// `QR Code`
  String get qr_code {
    return Intl.message(
      'QR Code',
      name: 'qr_code',
      desc: '',
      args: [],
    );
  }

  /// `Ramp allows you to buy crypto with Apple Pay, Google Pay, Credit Card and bank transfer in 170+ countries.`
  String get ramp_allows_you_to_buy_cryto {
    return Intl.message(
      'Ramp allows you to buy crypto with Apple Pay, Google Pay, Credit Card and bank transfer in 170+ countries.',
      name: 'ramp_allows_you_to_buy_cryto',
      desc: '',
      args: [],
    );
  }

  /// `Re-Schedule`
  String get re_schedule {
    return Intl.message(
      'Re-Schedule',
      name: 're_schedule',
      desc: '',
      args: [],
    );
  }

  /// `Receive`
  String get receive {
    return Intl.message(
      'Receive',
      name: 'receive',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Record a video`
  String get record_video {
    return Intl.message(
      'Record a video',
      name: 'record_video',
      desc: '',
      args: [],
    );
  }

  /// `Recorded`
  String get recorded {
    return Intl.message(
      'Recorded',
      name: 'recorded',
      desc: '',
      args: [],
    );
  }

  /// `RECORDING`
  String get recording {
    return Intl.message(
      'RECORDING',
      name: 'recording',
      desc: '',
      args: [],
    );
  }

  /// `Let's see if refreshing the page will fix it`
  String get refreshing_the_page {
    return Intl.message(
      'Let\'s see if refreshing the page will fix it',
      name: 'refreshing_the_page',
      desc: '',
      args: [],
    );
  }

  /// `Reminder`
  String get reminder {
    return Intl.message(
      'Reminder',
      name: 'reminder',
      desc: '',
      args: [],
    );
  }

  /// `Remove`
  String get remove {
    return Intl.message(
      'Remove',
      name: 'remove',
      desc: '',
      args: [],
    );
  }

  /// `Remove Card`
  String get remove_card {
    return Intl.message(
      'Remove Card',
      name: 'remove_card',
      desc: '',
      args: [],
    );
  }

  /// `Removed`
  String get removed {
    return Intl.message(
      'Removed',
      name: 'removed',
      desc: '',
      args: [],
    );
  }

  /// `Report`
  String get report {
    return Intl.message(
      'Report',
      name: 'report',
      desc: '',
      args: [],
    );
  }

  /// `required`
  String get required {
    return Intl.message(
      'required',
      name: 'required',
      desc: '',
      args: [],
    );
  }

  /// `Your reservation has been released.`
  String get reservation_been_released {
    return Intl.message(
      'Your reservation has been released.',
      name: 'reservation_been_released',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get reset {
    return Intl.message(
      'Reset',
      name: 'reset',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get reset_password {
    return Intl.message(
      'Reset Password',
      name: 'reset_password',
      desc: '',
      args: [],
    );
  }

  /// `Reset Your Password`
  String get reset_your_password {
    return Intl.message(
      'Reset Your Password',
      name: 'reset_your_password',
      desc: '',
      args: [],
    );
  }

  /// `Please re-start your booking.`
  String get restart_booking {
    return Intl.message(
      'Please re-start your booking.',
      name: 'restart_booking',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message(
      'Retry',
      name: 'retry',
      desc: '',
      args: [],
    );
  }

  /// `Sat`
  String get saturday {
    return Intl.message(
      'Sat',
      name: 'saturday',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Scan`
  String get scan {
    return Intl.message(
      'Scan',
      name: 'scan',
      desc: '',
      args: [],
    );
  }

  /// `Scan to call`
  String get scan_to_call {
    return Intl.message(
      'Scan to call',
      name: 'scan_to_call',
      desc: '',
      args: [],
    );
  }

  /// `schedules`
  String get schedules {
    return Intl.message(
      'schedules',
      name: 'schedules',
      desc: '',
      args: [],
    );
  }

  /// `schedule(s) that have not been canceled.`
  String get schedules_not_been_cancelled {
    return Intl.message(
      'schedule(s) that have not been canceled.',
      name: 'schedules_not_been_cancelled',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Search failed, please try again.`
  String get search_failed {
    return Intl.message(
      'Search failed, please try again.',
      name: 'search_failed',
      desc: '',
      args: [],
    );
  }

  /// `Secs`
  String get secs {
    return Intl.message(
      'Secs',
      name: 'secs',
      desc: '',
      args: [],
    );
  }

  /// `See all payout options`
  String get see_all_payout {
    return Intl.message(
      'See all payout options',
      name: 'see_all_payout',
      desc: '',
      args: [],
    );
  }

  /// `Select`
  String get select {
    return Intl.message(
      'Select',
      name: 'select',
      desc: '',
      args: [],
    );
  }

  /// `Select a Date`
  String get select_a_date {
    return Intl.message(
      'Select a Date',
      name: 'select_a_date',
      desc: '',
      args: [],
    );
  }

  /// `Select a Time`
  String get select_a_time {
    return Intl.message(
      'Select a Time',
      name: 'select_a_time',
      desc: '',
      args: [],
    );
  }

  /// `Select a week day`
  String get select_a_week_day {
    return Intl.message(
      'Select a week day',
      name: 'select_a_week_day',
      desc: '',
      args: [],
    );
  }

  /// `Select All`
  String get select_all {
    return Intl.message(
      'Select All',
      name: 'select_all',
      desc: '',
      args: [],
    );
  }

  /// `Select Country`
  String get select_country {
    return Intl.message(
      'Select Country',
      name: 'select_country',
      desc: '',
      args: [],
    );
  }

  /// `Select Cover`
  String get select_cover {
    return Intl.message(
      'Select Cover',
      name: 'select_cover',
      desc: '',
      args: [],
    );
  }

  /// `Select a Date and Time`
  String get select_date_time {
    return Intl.message(
      'Select a Date and Time',
      name: 'select_date_time',
      desc: '',
      args: [],
    );
  }

  /// `Select Duration`
  String get select_duration {
    return Intl.message(
      'Select Duration',
      name: 'select_duration',
      desc: '',
      args: [],
    );
  }

  /// `Select Items`
  String get select_items {
    return Intl.message(
      'Select Items',
      name: 'select_items',
      desc: '',
      args: [],
    );
  }

  /// `Select Time Interval`
  String get select_time_interval {
    return Intl.message(
      'Select Time Interval',
      name: 'select_time_interval',
      desc: '',
      args: [],
    );
  }

  /// `Select Timezone`
  String get select_timezone {
    return Intl.message(
      'Select Timezone',
      name: 'select_timezone',
      desc: '',
      args: [],
    );
  }

  /// `Select video to upload`
  String get select_video_to_upload {
    return Intl.message(
      'Select video to upload',
      name: 'select_video_to_upload',
      desc: '',
      args: [],
    );
  }

  /// `Selected`
  String get selected {
    return Intl.message(
      'Selected',
      name: 'selected',
      desc: '',
      args: [],
    );
  }

  /// `Sell All`
  String get sell_all {
    return Intl.message(
      'Sell All',
      name: 'sell_all',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message(
      'Send',
      name: 'send',
      desc: '',
      args: [],
    );
  }

  /// `3. Make sure to select "Send me all events", to receive all payment updates.`
  String get send_me_all_events {
    return Intl.message(
      '3. Make sure to select "Send me all events", to receive all payment updates.',
      name: 'send_me_all_events',
      desc: '',
      args: [],
    );
  }

  /// `Send only`
  String get send_only {
    return Intl.message(
      'Send only',
      name: 'send_only',
      desc: '',
      args: [],
    );
  }

  /// `We have sent a link to reset your password to`
  String get sent_link_reset_password {
    return Intl.message(
      'We have sent a link to reset your password to',
      name: 'sent_link_reset_password',
      desc: '',
      args: [],
    );
  }

  /// `Service Fee`
  String get service_fee {
    return Intl.message(
      'Service Fee',
      name: 'service_fee',
      desc: '',
      args: [],
    );
  }

  /// `Service Unavailable`
  String get service_unavailable {
    return Intl.message(
      'Service Unavailable',
      name: 'service_unavailable',
      desc: '',
      args: [],
    );
  }

  /// `This service is currently not available in your region`
  String get service_unavailable_region {
    return Intl.message(
      'This service is currently not available in your region',
      name: 'service_unavailable_region',
      desc: '',
      args: [],
    );
  }

  /// `Set Default`
  String get set_default {
    return Intl.message(
      'Set Default',
      name: 'set_default',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message(
      'Share',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `Share To`
  String get share_to {
    return Intl.message(
      'Share To',
      name: 'share_to',
      desc: '',
      args: [],
    );
  }

  /// `Share To Facebook`
  String get share_to_facebook {
    return Intl.message(
      'Share To Facebook',
      name: 'share_to_facebook',
      desc: '',
      args: [],
    );
  }

  /// `Share To Line`
  String get share_to_line {
    return Intl.message(
      'Share To Line',
      name: 'share_to_line',
      desc: '',
      args: [],
    );
  }

  /// `Share To LinkedIn`
  String get share_to_linkedln {
    return Intl.message(
      'Share To LinkedIn',
      name: 'share_to_linkedln',
      desc: '',
      args: [],
    );
  }

  /// `Share To Twitter`
  String get share_to_twitter {
    return Intl.message(
      'Share To Twitter',
      name: 'share_to_twitter',
      desc: '',
      args: [],
    );
  }

  /// `Share To WhatsApp`
  String get share_to_whatsapp {
    return Intl.message(
      'Share To WhatsApp',
      name: 'share_to_whatsapp',
      desc: '',
      args: [],
    );
  }

  /// `Show less`
  String get show_less {
    return Intl.message(
      'Show less',
      name: 'show_less',
      desc: '',
      args: [],
    );
  }

  /// `Show more`
  String get show_more {
    return Intl.message(
      'Show more',
      name: 'show_more',
      desc: '',
      args: [],
    );
  }

  /// `4. Click "show shared secret" and paste into the box above.`
  String get show_shared_secret {
    return Intl.message(
      '4. Click "show shared secret" and paste into the box above.',
      name: 'show_shared_secret',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get sign_in {
    return Intl.message(
      'Sign in',
      name: 'sign_in',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with email`
  String get sign_in_email {
    return Intl.message(
      'Sign in with email',
      name: 'sign_in_email',
      desc: '',
      args: [],
    );
  }

  /// `Sign up with email`
  String get sign_up_email {
    return Intl.message(
      'Sign up with email',
      name: 'sign_up_email',
      desc: '',
      args: [],
    );
  }

  /// `Sign up now`
  String get sign_up_now {
    return Intl.message(
      'Sign up now',
      name: 'sign_up_now',
      desc: '',
      args: [],
    );
  }

  /// `By signing in, you agree to the `
  String get signin_agreement {
    return Intl.message(
      'By signing in, you agree to the ',
      name: 'signin_agreement',
      desc: '',
      args: [],
    );
  }

  /// `Sign in as a different user`
  String get signin_different_user {
    return Intl.message(
      'Sign in as a different user',
      name: 'signin_different_user',
      desc: '',
      args: [],
    );
  }

  /// `Your sign in link has expired.`
  String get signin_link_expired {
    return Intl.message(
      'Your sign in link has expired.',
      name: 'signin_link_expired',
      desc: '',
      args: [],
    );
  }

  /// `Your sign in link is not valid.`
  String get signin_link_not_valid {
    return Intl.message(
      'Your sign in link is not valid.',
      name: 'signin_link_not_valid',
      desc: '',
      args: [],
    );
  }

  /// `By signing up, you agree to the `
  String get signup_agreement {
    return Intl.message(
      'By signing up, you agree to the ',
      name: 'signup_agreement',
      desc: '',
      args: [],
    );
  }

  /// `One Moment!`
  String get signup_dialog_error_default_title {
    return Intl.message(
      'One Moment!',
      name: 'signup_dialog_error_default_title',
      desc: '',
      args: [],
    );
  }

  /// `Oh no!`
  String get signup_dialog_error_default_title2 {
    return Intl.message(
      'Oh no!',
      name: 'signup_dialog_error_default_title2',
      desc: '',
      args: [],
    );
  }

  /// `Your email is not valid :)`
  String get signup_invalid_email_default_error {
    return Intl.message(
      'Your email is not valid :)',
      name: 'signup_invalid_email_default_error',
      desc: '',
      args: [],
    );
  }

  /// `Add your name to let your friends know who they're talking to :)`
  String get signup_no_name_default_error {
    return Intl.message(
      'Add your name to let your friends know who they\'re talking to :)',
      name: 'signup_no_name_default_error',
      desc: '',
      args: [],
    );
  }

  /// `Your email has already been registered :)`
  String get signup_unique_email_default_error {
    return Intl.message(
      'Your email has already been registered :)',
      name: 'signup_unique_email_default_error',
      desc: '',
      args: [],
    );
  }

  /// `Slippage`
  String get slippage {
    return Intl.message(
      'Slippage',
      name: 'slippage',
      desc: '',
      args: [],
    );
  }

  /// `Your Solana Wallet is Linked`
  String get solona_wallet_linked {
    return Intl.message(
      'Your Solana Wallet is Linked',
      name: 'solona_wallet_linked',
      desc: '',
      args: [],
    );
  }

  /// `Oops! Something went wrong.`
  String get something_went_wrong {
    return Intl.message(
      'Oops! Something went wrong.',
      name: 'something_went_wrong',
      desc: '',
      args: [],
    );
  }

  /// `Sorry, this callLink cannot be deleted because you have`
  String get sorry_calllink_cannot_deleted {
    return Intl.message(
      'Sorry, this callLink cannot be deleted because you have',
      name: 'sorry_calllink_cannot_deleted',
      desc: '',
      args: [],
    );
  }

  /// `Sorry, this callLink has ended or expired`
  String get sorry_calllink_ended {
    return Intl.message(
      'Sorry, this callLink has ended or expired',
      name: 'sorry_calllink_ended',
      desc: '',
      args: [],
    );
  }

  /// `Sorry! The target maximum contribution of`
  String get sorry_target_contribution {
    return Intl.message(
      'Sorry! The target maximum contribution of',
      name: 'sorry_target_contribution',
      desc: '',
      args: [],
    );
  }

  /// `Starting`
  String get starting {
    return Intl.message(
      'Starting',
      name: 'starting',
      desc: '',
      args: [],
    );
  }

  /// `Starts`
  String get starts {
    return Intl.message(
      'Starts',
      name: 'starts',
      desc: '',
      args: [],
    );
  }

  /// `We use Stripe to make sure you get paid on time and to keep your personal bank and details secure.`
  String get stripe_make_sure_get_paid {
    return Intl.message(
      'We use Stripe to make sure you get paid on time and to keep your personal bank and details secure.',
      name: 'stripe_make_sure_get_paid',
      desc: '',
      args: [],
    );
  }

  /// `Sun`
  String get sunday {
    return Intl.message(
      'Sun',
      name: 'sunday',
      desc: '',
      args: [],
    );
  }

  /// `Supports Bitcoin, Ethereum, DAI, Litecoin, Bitcoin Cash, or USD Coin`
  String get supports_bitcoin_etherum {
    return Intl.message(
      'Supports Bitcoin, Ethereum, DAI, Litecoin, Bitcoin Cash, or USD Coin',
      name: 'supports_bitcoin_etherum',
      desc: '',
      args: [],
    );
  }

  /// `Supports card payments, Apple  Pay, Google Pay.`
  String get supports_card_payments {
    return Intl.message(
      'Supports card payments, Apple  Pay, Google Pay.',
      name: 'supports_card_payments',
      desc: '',
      args: [],
    );
  }

  /// `You need to add this event to your weekly availability so people can select a convenient time to book or subscribe to your event.`
  String get suscbribe_to_your_event {
    return Intl.message(
      'You need to add this event to your weekly availability so people can select a convenient time to book or subscribe to your event.',
      name: 'suscbribe_to_your_event',
      desc: '',
      args: [],
    );
  }

  /// `Swap`
  String get swap {
    return Intl.message(
      'Swap',
      name: 'swap',
      desc: '',
      args: [],
    );
  }

  /// `The amount (in units of percent) a swap can be off from the estimate`
  String get swap_off_from_estimate {
    return Intl.message(
      'The amount (in units of percent) a swap can be off from the estimate',
      name: 'swap_off_from_estimate',
      desc: '',
      args: [],
    );
  }

  /// `Swipe down to create event`
  String get swipe_down_create_event {
    return Intl.message(
      'Swipe down to create event',
      name: 'swipe_down_create_event',
      desc: '',
      args: [],
    );
  }

  /// `Terms of Service`
  String get terms_of_service {
    return Intl.message(
      'Terms of Service',
      name: 'terms_of_service',
      desc: '',
      args: [],
    );
  }

  /// `Thank You`
  String get thank_you {
    return Intl.message(
      'Thank You',
      name: 'thank_you',
      desc: '',
      args: [],
    );
  }

  /// `Thank You For Participating!!!`
  String get thank_you_participating {
    return Intl.message(
      'Thank You For Participating!!!',
      name: 'thank_you_participating',
      desc: '',
      args: [],
    );
  }

  /// `Thu`
  String get thursday {
    return Intl.message(
      'Thu',
      name: 'thursday',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get time {
    return Intl.message(
      'Time',
      name: 'time',
      desc: '',
      args: [],
    );
  }

  /// `Time Left`
  String get time_left {
    return Intl.message(
      'Time Left',
      name: 'time_left',
      desc: '',
      args: [],
    );
  }

  /// `Time Limit Reached`
  String get time_limit_reached {
    return Intl.message(
      'Time Limit Reached',
      name: 'time_limit_reached',
      desc: '',
      args: [],
    );
  }

  /// `time passes will appear here`
  String get time_passes_appear_here {
    return Intl.message(
      'time passes will appear here',
      name: 'time_passes_appear_here',
      desc: '',
      args: [],
    );
  }

  /// `Time ZoneTime Zone`
  String get time_zone {
    return Intl.message(
      'Time ZoneTime Zone',
      name: 'time_zone',
      desc: '',
      args: [],
    );
  }

  /// `TimePass is coming soon`
  String get timepass_coming_soon {
    return Intl.message(
      'TimePass is coming soon',
      name: 'timepass_coming_soon',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get title {
    return Intl.message(
      'Title',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `To`
  String get to {
    return Intl.message(
      'To',
      name: 'to',
      desc: '',
      args: [],
    );
  }

  /// `to complete your account set-up.`
  String get to_complete_setup {
    return Intl.message(
      'to complete your account set-up.',
      name: 'to_complete_setup',
      desc: '',
      args: [],
    );
  }

  /// `to contribute`
  String get to_contribute {
    return Intl.message(
      'to contribute',
      name: 'to_contribute',
      desc: '',
      args: [],
    );
  }

  /// `to sign in.`
  String get to_sigin_in {
    return Intl.message(
      'to sign in.',
      name: 'to_sigin_in',
      desc: '',
      args: [],
    );
  }

  /// `to this address. Sending any other digital asset will result in permanent loss`
  String get to_this_addres_any_digital_asset_loss {
    return Intl.message(
      'to this address. Sending any other digital asset will result in permanent loss',
      name: 'to_this_addres_any_digital_asset_loss',
      desc: '',
      args: [],
    );
  }

  /// `TOKENS`
  String get tokens {
    return Intl.message(
      'TOKENS',
      name: 'tokens',
      desc: '',
      args: [],
    );
  }

  /// `Tolerance`
  String get tolerance {
    return Intl.message(
      'Tolerance',
      name: 'tolerance',
      desc: '',
      args: [],
    );
  }

  /// `Top Up`
  String get top_up {
    return Intl.message(
      'Top Up',
      name: 'top_up',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get total {
    return Intl.message(
      'Total',
      name: 'total',
      desc: '',
      args: [],
    );
  }

  /// `Trade`
  String get trade {
    return Intl.message(
      'Trade',
      name: 'trade',
      desc: '',
      args: [],
    );
  }

  /// `Transaction confirmed`
  String get transaction_confirmed {
    return Intl.message(
      'Transaction confirmed',
      name: 'transaction_confirmed',
      desc: '',
      args: [],
    );
  }

  /// `Transaction Id`
  String get transaction_id {
    return Intl.message(
      'Transaction Id',
      name: 'transaction_id',
      desc: '',
      args: [],
    );
  }

  /// `Transaction Signature`
  String get transaction_signature {
    return Intl.message(
      'Transaction Signature',
      name: 'transaction_signature',
      desc: '',
      args: [],
    );
  }

  /// `Transaction Successful`
  String get transaction_successful {
    return Intl.message(
      'Transaction Successful',
      name: 'transaction_successful',
      desc: '',
      args: [],
    );
  }

  /// `Transaction Type`
  String get transaction_type {
    return Intl.message(
      'Transaction Type',
      name: 'transaction_type',
      desc: '',
      args: [],
    );
  }

  /// `Transak supports debit card and bank transfers (depending on location) in 60+ countries.`
  String get transak_supports_debit_card_bank_transfer {
    return Intl.message(
      'Transak supports debit card and bank transfers (depending on location) in 60+ countries.',
      name: 'transak_supports_debit_card_bank_transfer',
      desc: '',
      args: [],
    );
  }

  /// `Try Again`
  String get try_again {
    return Intl.message(
      'Try Again',
      name: 'try_again',
      desc: '',
      args: [],
    );
  }

  /// `Tues`
  String get tuesday {
    return Intl.message(
      'Tues',
      name: 'tuesday',
      desc: '',
      args: [],
    );
  }

  /// `Unavailable`
  String get unavailable {
    return Intl.message(
      'Unavailable',
      name: 'unavailable',
      desc: '',
      args: [],
    );
  }

  /// `Unfortunately, we cannot process your order as the reservation was canceled or expired. Rest assured, you won't be charged.`
  String get unfortunately_cant_process_order {
    return Intl.message(
      'Unfortunately, we cannot process your order as the reservation was canceled or expired. Rest assured, you won\'t be charged.',
      name: 'unfortunately_cant_process_order',
      desc: '',
      args: [],
    );
  }

  /// `An unknown error has occurred. Please try again...`
  String get unknown_error {
    return Intl.message(
      'An unknown error has occurred. Please try again...',
      name: 'unknown_error',
      desc: '',
      args: [],
    );
  }

  /// `Unknown Screen`
  String get unknown_screen {
    return Intl.message(
      'Unknown Screen',
      name: 'unknown_screen',
      desc: '',
      args: [],
    );
  }

  /// `Unpublish`
  String get unpublish {
    return Intl.message(
      'Unpublish',
      name: 'unpublish',
      desc: '',
      args: [],
    );
  }

  /// `Unpublish Call Link`
  String get unpublish_call_link {
    return Intl.message(
      'Unpublish Call Link',
      name: 'unpublish_call_link',
      desc: '',
      args: [],
    );
  }

  /// `Unverified`
  String get unverified {
    return Intl.message(
      'Unverified',
      name: 'unverified',
      desc: '',
      args: [],
    );
  }

  /// `Up Next`
  String get up_next {
    return Intl.message(
      'Up Next',
      name: 'up_next',
      desc: '',
      args: [],
    );
  }

  /// `up to`
  String get up_to {
    return Intl.message(
      'up to',
      name: 'up_to',
      desc: '',
      args: [],
    );
  }

  /// `Up to 60 secs`
  String get up_to_60_secs {
    return Intl.message(
      'Up to 60 secs',
      name: 'up_to_60_secs',
      desc: '',
      args: [],
    );
  }

  /// `Updated`
  String get updated {
    return Intl.message(
      'Updated',
      name: 'updated',
      desc: '',
      args: [],
    );
  }

  /// `Upload a short video that explains`
  String get upload_video_explains {
    return Intl.message(
      'Upload a short video that explains',
      name: 'upload_video_explains',
      desc: '',
      args: [],
    );
  }

  /// `Uploading`
  String get uploading {
    return Intl.message(
      'Uploading',
      name: 'uploading',
      desc: '',
      args: [],
    );
  }

  /// `User not found.`
  String get user_not_found {
    return Intl.message(
      'User not found.',
      name: 'user_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get username {
    return Intl.message(
      'Username',
      name: 'username',
      desc: '',
      args: [],
    );
  }

  /// `Username or Email`
  String get username_or_email {
    return Intl.message(
      'Username or Email',
      name: 'username_or_email',
      desc: '',
      args: [],
    );
  }

  /// `Using webhooks allows Coinbase Commerce to notify Gotok when a payment has been confirmed in real time.`
  String get using_webhook_allows_coinbase {
    return Intl.message(
      'Using webhooks allows Coinbase Commerce to notify Gotok when a payment has been confirmed in real time.',
      name: 'using_webhook_allows_coinbase',
      desc: '',
      args: [],
    );
  }

  /// `Verified`
  String get verified {
    return Intl.message(
      'Verified',
      name: 'verified',
      desc: '',
      args: [],
    );
  }

  /// `You must verify your identity in order for us to make our platform safe, trustworthy and to comply with KYC requirements.`
  String get verify_identity_plaform_safe {
    return Intl.message(
      'You must verify your identity in order for us to make our platform safe, trustworthy and to comply with KYC requirements.',
      name: 'verify_identity_plaform_safe',
      desc: '',
      args: [],
    );
  }

  /// `Verify Profile`
  String get verify_profile {
    return Intl.message(
      'Verify Profile',
      name: 'verify_profile',
      desc: '',
      args: [],
    );
  }

  /// `Verify Your Identity`
  String get verify_your_identity {
    return Intl.message(
      'Verify Your Identity',
      name: 'verify_your_identity',
      desc: '',
      args: [],
    );
  }

  /// `Oops! Video too short.`
  String get video_too_short {
    return Intl.message(
      'Oops! Video too short.',
      name: 'video_too_short',
      desc: '',
      args: [],
    );
  }

  /// `View All Transactions`
  String get view_all_transactions {
    return Intl.message(
      'View All Transactions',
      name: 'view_all_transactions',
      desc: '',
      args: [],
    );
  }

  /// `View on`
  String get view_on {
    return Intl.message(
      'View on',
      name: 'view_on',
      desc: '',
      args: [],
    );
  }

  /// `Call link will be visible and can accept bookings.`
  String get visible_accept_bookings {
    return Intl.message(
      'Call link will be visible and can accept bookings.',
      name: 'visible_accept_bookings',
      desc: '',
      args: [],
    );
  }

  /// `Wallet`
  String get wallet {
    return Intl.message(
      'Wallet',
      name: 'wallet',
      desc: '',
      args: [],
    );
  }

  /// `Your wallet is powered by Torus decentralized non-custodial PKI infrastructure.`
  String get wallet_powered_by_torus {
    return Intl.message(
      'Your wallet is powered by Torus decentralized non-custodial PKI infrastructure.',
      name: 'wallet_powered_by_torus',
      desc: '',
      args: [],
    );
  }

  /// `We are processing your order`
  String get we_are_processing_order {
    return Intl.message(
      'We are processing your order',
      name: 'we_are_processing_order',
      desc: '',
      args: [],
    );
  }

  /// `Webhook Shared Secret`
  String get webbook_shared_secret {
    return Intl.message(
      'Webhook Shared Secret',
      name: 'webbook_shared_secret',
      desc: '',
      args: [],
    );
  }

  /// `Wed`
  String get wednesday {
    return Intl.message(
      'Wed',
      name: 'wednesday',
      desc: '',
      args: [],
    );
  }

  /// `with FTX Pay`
  String get with_ftx_pay {
    return Intl.message(
      'with FTX Pay',
      name: 'with_ftx_pay',
      desc: '',
      args: [],
    );
  }

  /// `with RAMP`
  String get with_ramp {
    return Intl.message(
      'with RAMP',
      name: 'with_ramp',
      desc: '',
      args: [],
    );
  }

  /// `with Transak`
  String get with_transak {
    return Intl.message(
      'with Transak',
      name: 'with_transak',
      desc: '',
      args: [],
    );
  }

  /// `Would you like to sign in with a different email?`
  String get would_sign_in_different_email {
    return Intl.message(
      'Would you like to sign in with a different email?',
      name: 'would_sign_in_different_email',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `You are scheduled with`
  String get you_are_scheduled_with {
    return Intl.message(
      'You are scheduled with',
      name: 'you_are_scheduled_with',
      desc: '',
      args: [],
    );
  }

  /// `You can manage your API keys within the Coinbase Commerce Settings page. available here`
  String get you_can_manage_api_key_coinbase {
    return Intl.message(
      'You can manage your API keys within the Coinbase Commerce Settings page. available here',
      name: 'you_can_manage_api_key_coinbase',
      desc: '',
      args: [],
    );
  }

  /// `You have no events`
  String get you_have_no_event {
    return Intl.message(
      'You have no events',
      name: 'you_have_no_event',
      desc: '',
      args: [],
    );
  }

  /// `You receive`
  String get you_receive {
    return Intl.message(
      'You receive',
      name: 'you_receive',
      desc: '',
      args: [],
    );
  }

  /// `Your`
  String get your {
    return Intl.message(
      'Your',
      name: 'your',
      desc: '',
      args: [],
    );
  }

  /// `your call link`
  String get your_call_link {
    return Intl.message(
      'your call link',
      name: 'your_call_link',
      desc: '',
      args: [],
    );
  }

  /// `Your coinbase account is connected`
  String get your_coinbase_account {
    return Intl.message(
      'Your coinbase account is connected',
      name: 'your_coinbase_account',
      desc: '',
      args: [],
    );
  }

  /// `Your contribution has been accepted and we are now processing it.`
  String get your_contribution_accepted_proccessing {
    return Intl.message(
      'Your contribution has been accepted and we are now processing it.',
      name: 'your_contribution_accepted_proccessing',
      desc: '',
      args: [],
    );
  }

  /// `Your Email`
  String get your_email {
    return Intl.message(
      'Your Email',
      name: 'your_email',
      desc: '',
      args: [],
    );
  }

  /// `Your stripe account is connected`
  String get your_stripe_account_is_connected {
    return Intl.message(
      'Your stripe account is connected',
      name: 'your_stripe_account_is_connected',
      desc: '',
      args: [],
    );
  }

  /// `Insufficient balance for network fees {fees}. Please fund your {token} account`
  String insufficient_wallet_balance(Object fees, Object token) {
    return Intl.message(
      'Insufficient balance for network fees $fees. Please fund your $token account',
      name: 'insufficient_wallet_balance',
      desc: '',
      args: [fees, token],
    );
  }

  /// `You do not have enough {token} to pay for transaction fees. Please deposit more and try again`
  String insufficient_sol_for_fees(Object token) {
    return Intl.message(
      'You do not have enough $token to pay for transaction fees. Please deposit more and try again',
      name: 'insufficient_sol_for_fees',
      desc: '',
      args: [token],
    );
  }

  /// `Deposit {token}`
  String deposit_token(Object token) {
    return Intl.message(
      'Deposit $token',
      name: 'deposit_token',
      desc: '',
      args: [token],
    );
  }

  /// `{token} is used to pay for transactions`
  String sol_pays_transaction_fee(Object token) {
    return Intl.message(
      '$token is used to pay for transactions',
      name: 'sol_pays_transaction_fee',
      desc: '',
      args: [token],
    );
  }

  /// `Connect Your Wallet`
  String get connect_your_wallet {
    return Intl.message(
      'Connect Your Wallet',
      name: 'connect_your_wallet',
      desc: '',
      args: [],
    );
  }

  /// `Your tokens will appear here to make payment`
  String get your_tokens_will_appear_to_make_payment {
    return Intl.message(
      'Your tokens will appear here to make payment',
      name: 'your_tokens_will_appear_to_make_payment',
      desc: '',
      args: [],
    );
  }

  /// `Change`
  String get change {
    return Intl.message(
      'Change',
      name: 'change',
      desc: '',
      args: [],
    );
  }

  /// `Connecting`
  String get connecting {
    return Intl.message(
      'Connecting',
      name: 'connecting',
      desc: '',
      args: [],
    );
  }

  /// `Monetize your time`
  String get monetize_your_time {
    return Intl.message(
      'Monetize your time',
      name: 'monetize_your_time',
      desc: '',
      args: [],
    );
  }

  /// `Collect payments in crypto or cash when your guest book a call and reduce no shows.`
  String get payout_onboarding_description {
    return Intl.message(
      'Collect payments in crypto or cash when your guest book a call and reduce no shows.',
      name: 'payout_onboarding_description',
      desc: '',
      args: [],
    );
  }

  /// `Country`
  String get country {
    return Intl.message(
      'Country',
      name: 'country',
      desc: '',
      args: [],
    );
  }

  /// `AM/PM`
  String get ampm {
    return Intl.message(
      'AM/PM',
      name: 'ampm',
      desc: '',
      args: [],
    );
  }

  /// `Copy Address`
  String get copy_address {
    return Intl.message(
      'Copy Address',
      name: 'copy_address',
      desc: '',
      args: [],
    );
  }

  /// `Caution: Your SOL balance is low `
  String get low_sol_balance {
    return Intl.message(
      'Caution: Your SOL balance is low ',
      name: 'low_sol_balance',
      desc: '',
      args: [],
    );
  }

  /// `SOL is needed for Solana network fees. A minimum balance of 0.05 SOL is recommended to avoid failed transactions.`
  String get low_sol_balance_info {
    return Intl.message(
      'SOL is needed for Solana network fees. A minimum balance of 0.05 SOL is recommended to avoid failed transactions.',
      name: 'low_sol_balance_info',
      desc: '',
      args: [],
    );
  }

  /// `Pay with crypto wallet`
  String get pay_with_crypto_wallet {
    return Intl.message(
      'Pay with crypto wallet',
      name: 'pay_with_crypto_wallet',
      desc: '',
      args: [],
    );
  }

  /// `Cancel Payment`
  String get cancel_payment {
    return Intl.message(
      'Cancel Payment',
      name: 'cancel_payment',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to cancel the payment?`
  String get are_you_sure_cancel_payment {
    return Intl.message(
      'Are you sure you want to cancel the payment?',
      name: 'are_you_sure_cancel_payment',
      desc: '',
      args: [],
    );
  }

  /// `We have sent a verification link to your inbox`
  String get sent_verification_link {
    return Intl.message(
      'We have sent a verification link to your inbox',
      name: 'sent_verification_link',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email address`
  String get enter_email_address {
    return Intl.message(
      'Enter your email address',
      name: 'enter_email_address',
      desc: '',
      args: [],
    );
  }

  /// `Failed to re-send confimation link, please try again.`
  String get failed_to_send_confirmation_link {
    return Intl.message(
      'Failed to re-send confimation link, please try again.',
      name: 'failed_to_send_confirmation_link',
      desc: '',
      args: [],
    );
  }

  /// `An account with this email already exists`
  String get account_with_email_exists {
    return Intl.message(
      'An account with this email already exists',
      name: 'account_with_email_exists',
      desc: '',
      args: [],
    );
  }

  /// `We couldn't find an account with that email`
  String get account_does_not_exist {
    return Intl.message(
      'We couldn\'t find an account with that email',
      name: 'account_does_not_exist',
      desc: '',
      args: [],
    );
  }

  /// `Make sure to use less than 255 characters`
  String get character_less_than_255 {
    return Intl.message(
      'Make sure to use less than 255 characters',
      name: 'character_less_than_255',
      desc: '',
      args: [],
    );
  }

  /// `You don't meet the age requirement.`
  String get age_too_low {
    return Intl.message(
      'You don\'t meet the age requirement.',
      name: 'age_too_low',
      desc: '',
      args: [],
    );
  }

  /// `Can't validate address`
  String get cant_validate_address {
    return Intl.message(
      'Can\'t validate address',
      name: 'cant_validate_address',
      desc: '',
      args: [],
    );
  }

  /// `Destination address mint does not match`
  String get dst_ady_mint_dont_match {
    return Intl.message(
      'Destination address mint does not match',
      name: 'dst_ady_mint_dont_match',
      desc: '',
      args: [],
    );
  }

  /// `Make sure to enter at least 8 characters`
  String get min_password_chars {
    return Intl.message(
      'Make sure to enter at least 8 characters',
      name: 'min_password_chars',
      desc: '',
      args: [],
    );
  }

  /// `Make sure to enter at least 3 characters`
  String get min_username_chars {
    return Intl.message(
      'Make sure to enter at least 3 characters',
      name: 'min_username_chars',
      desc: '',
      args: [],
    );
  }

  /// `Make sure to use less than 30 characters`
  String get username_lt_max_chars {
    return Intl.message(
      'Make sure to use less than 30 characters',
      name: 'username_lt_max_chars',
      desc: '',
      args: [],
    );
  }

  /// `Oops! Usernames can only include letters, numbers and 1 "-","_",or".", but no special characters`
  String get username_must_include_latin_chars {
    return Intl.message(
      'Oops! Usernames can only include letters, numbers and 1 "-","_",or".", but no special characters',
      name: 'username_must_include_latin_chars',
      desc: '',
      args: [],
    );
  }

  /// `Uh oh! Usernames must end in a letter or number`
  String get username_must_end_in_letter_or_num {
    return Intl.message(
      'Uh oh! Usernames must end in a letter or number',
      name: 'username_must_end_in_letter_or_num',
      desc: '',
      args: [],
    );
  }

  /// `An account with this username already exists`
  String get usernmae_already_exists {
    return Intl.message(
      'An account with this username already exists',
      name: 'usernmae_already_exists',
      desc: '',
      args: [],
    );
  }

  /// `Sign up with email`
  String get sign_up_with_email {
    return Intl.message(
      'Sign up with email',
      name: 'sign_up_with_email',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get first_name {
    return Intl.message(
      'First Name',
      name: 'first_name',
      desc: '',
      args: [],
    );
  }

  /// `Last Name`
  String get last_name {
    return Intl.message(
      'Last Name',
      name: 'last_name',
      desc: '',
      args: [],
    );
  }

  /// `Username is required`
  String get username_required {
    return Intl.message(
      'Username is required',
      name: 'username_required',
      desc: '',
      args: [],
    );
  }

  /// `Login with email`
  String get login_with_email {
    return Intl.message(
      'Login with email',
      name: 'login_with_email',
      desc: '',
      args: [],
    );
  }

  /// `Phone number already exists`
  String get phone_number_exists {
    return Intl.message(
      'Phone number already exists',
      name: 'phone_number_exists',
      desc: '',
      args: [],
    );
  }

  /// `Email already exists`
  String get email_already_exists {
    return Intl.message(
      'Email already exists',
      name: 'email_already_exists',
      desc: '',
      args: [],
    );
  }

  /// `Username already exists`
  String get username_already_exists {
    return Intl.message(
      'Username already exists',
      name: 'username_already_exists',
      desc: '',
      args: [],
    );
  }

  /// `First name required`
  String get first_name_required {
    return Intl.message(
      'First name required',
      name: 'first_name_required',
      desc: '',
      args: [],
    );
  }

  /// `Last name required`
  String get last_name_required {
    return Intl.message(
      'Last name required',
      name: 'last_name_required',
      desc: '',
      args: [],
    );
  }

  /// `Email is not valid`
  String get email_invalid {
    return Intl.message(
      'Email is not valid',
      name: 'email_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Email required`
  String get email_required {
    return Intl.message(
      'Email required',
      name: 'email_required',
      desc: '',
      args: [],
    );
  }

  /// `Invalid username or password`
  String get wrong_password {
    return Intl.message(
      'Invalid username or password',
      name: 'wrong_password',
      desc: '',
      args: [],
    );
  }

  /// `At least 8 characters and should include letters, numbers, and special characters`
  String get password_invalid {
    return Intl.message(
      'At least 8 characters and should include letters, numbers, and special characters',
      name: 'password_invalid',
      desc: '',
      args: [],
    );
  }

  /// `First name or last name is not valid`
  String get name_invalid {
    return Intl.message(
      'First name or last name is not valid',
      name: 'name_invalid',
      desc: '',
      args: [],
    );
  }

  /// `I confirm that I am 18 years of age or older and agree with`
  String get confirm_age_terms {
    return Intl.message(
      'I confirm that I am 18 years of age or older and agree with',
      name: 'confirm_age_terms',
      desc: '',
      args: [],
    );
  }

  /// `Log in to Kurobi`
  String get login_to_kurobi {
    return Intl.message(
      'Log in to Kurobi',
      name: 'login_to_kurobi',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up for Kurobi`
  String get signup_for_kurobi {
    return Intl.message(
      'Sign Up for Kurobi',
      name: 'signup_for_kurobi',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get sign_up {
    return Intl.message(
      'Sign up',
      name: 'sign_up',
      desc: '',
      args: [],
    );
  }

  /// `Please confirm your age and agree with Kurobi Terms of Service`
  String get accept_terms_error_confirmation {
    return Intl.message(
      'Please confirm your age and agree with Kurobi Terms of Service',
      name: 'accept_terms_error_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Verification code expired`
  String get verification_code_expired {
    return Intl.message(
      'Verification code expired',
      name: 'verification_code_expired',
      desc: '',
      args: [],
    );
  }

  /// `Invalid verification code`
  String get invalid_verification_code {
    return Intl.message(
      'Invalid verification code',
      name: 'invalid_verification_code',
      desc: '',
      args: [],
    );
  }

  /// `Please check your connection`
  String get please_check_your_connection {
    return Intl.message(
      'Please check your connection',
      name: 'please_check_your_connection',
      desc: '',
      args: [],
    );
  }

  /// `Password is too weak`
  String get weak_password {
    return Intl.message(
      'Password is too weak',
      name: 'weak_password',
      desc: '',
      args: [],
    );
  }

  /// `An account already exists with a different credentials.`
  String get an_account_already_exists {
    return Intl.message(
      'An account already exists with a different credentials.',
      name: 'an_account_already_exists',
      desc: '',
      args: [],
    );
  }

  /// `Password reset request sent successfully`
  String get password_reset_request {
    return Intl.message(
      'Password reset request sent successfully',
      name: 'password_reset_request',
      desc: '',
      args: [],
    );
  }

  /// `You have reached the maximum number of cards. Please remove or update an existing card`
  String get max_cards_reached {
    return Intl.message(
      'You have reached the maximum number of cards. Please remove or update an existing card',
      name: 'max_cards_reached',
      desc: '',
      args: [],
    );
  }

  /// `No Cards`
  String get no_cards {
    return Intl.message(
      'No Cards',
      name: 'no_cards',
      desc: '',
      args: [],
    );
  }

  /// `Fetching cards...`
  String get fetching_cards {
    return Intl.message(
      'Fetching cards...',
      name: 'fetching_cards',
      desc: '',
      args: [],
    );
  }

  /// `Failed to fetch cards...`
  String get failed_to_fetch_cards {
    return Intl.message(
      'Failed to fetch cards...',
      name: 'failed_to_fetch_cards',
      desc: '',
      args: [],
    );
  }

  /// `Call Links`
  String get call_links {
    return Intl.message(
      'Call Links',
      name: 'call_links',
      desc: '',
      args: [],
    );
  }

  /// `Likes`
  String get likes {
    return Intl.message(
      'Likes',
      name: 'likes',
      desc: '',
      args: [],
    );
  }

  /// `Failed to fetch transaction`
  String get failed_to_fetch_transaction {
    return Intl.message(
      'Failed to fetch transaction',
      name: 'failed_to_fetch_transaction',
      desc: '',
      args: [],
    );
  }

  /// `Failed to fetch card`
  String get failed_to_fetch_card {
    return Intl.message(
      'Failed to fetch card',
      name: 'failed_to_fetch_card',
      desc: '',
      args: [],
    );
  }

  /// `Failed to fetch profile`
  String get failed_to_fetch_profile {
    return Intl.message(
      'Failed to fetch profile',
      name: 'failed_to_fetch_profile',
      desc: '',
      args: [],
    );
  }

  /// `pending`
  String get pending {
    return Intl.message(
      'pending',
      name: 'pending',
      desc: '',
      args: [],
    );
  }

  /// `Savings`
  String get savings {
    return Intl.message(
      'Savings',
      name: 'savings',
      desc: '',
      args: [],
    );
  }

  /// `One-on-One`
  String get one_on_one {
    return Intl.message(
      'One-on-One',
      name: 'one_on_one',
      desc: '',
      args: [],
    );
  }

  /// `Group`
  String get group {
    return Intl.message(
      'Group',
      name: 'group',
      desc: '',
      args: [],
    );
  }

  /// `Let one guest book a time with you.`
  String get one_on_one_sub_title {
    return Intl.message(
      'Let one guest book a time with you.',
      name: 'one_on_one_sub_title',
      desc: '',
      args: [],
    );
  }

  /// `Stream to multiple guests at a particular time`
  String get group_sub_title {
    return Intl.message(
      'Stream to multiple guests at a particular time',
      name: 'group_sub_title',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password is required`
  String get confirm_password_is_required {
    return Intl.message(
      'Confirm password is required',
      name: 'confirm_password_is_required',
      desc: '',
      args: [],
    );
  }

  /// `Closed`
  String get closed {
    return Intl.message(
      'Closed',
      name: 'closed',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email or password provided`
  String get invalid_email_or_password {
    return Intl.message(
      'Invalid email or password provided',
      name: 'invalid_email_or_password',
      desc: '',
      args: [],
    );
  }

  /// `Code required`
  String get code_required {
    return Intl.message(
      'Code required',
      name: 'code_required',
      desc: '',
      args: [],
    );
  }

  /// `Code must be a 6 digit number`
  String get code_is_number {
    return Intl.message(
      'Code must be a 6 digit number',
      name: 'code_is_number',
      desc: '',
      args: [],
    );
  }

  /// `Code expired`
  String get code_expired {
    return Intl.message(
      'Code expired',
      name: 'code_expired',
      desc: '',
      args: [],
    );
  }

  /// `Code not found`
  String get code_not_found {
    return Intl.message(
      'Code not found',
      name: 'code_not_found',
      desc: '',
      args: [],
    );
  }

  /// `RE-SEND IN {time}`
  String resend_in(Object time) {
    return Intl.message(
      'RE-SEND IN $time',
      name: 'resend_in',
      desc: '',
      args: [time],
    );
  }

  /// `Verification code sent`
  String get verification_code_sent {
    return Intl.message(
      'Verification code sent',
      name: 'verification_code_sent',
      desc: '',
      args: [],
    );
  }

  /// `Email can't change`
  String get email_immutable {
    return Intl.message(
      'Email can\'t change',
      name: 'email_immutable',
      desc: '',
      args: [],
    );
  }

  /// `Verify Email`
  String get verify_email {
    return Intl.message(
      'Verify Email',
      name: 'verify_email',
      desc: '',
      args: [],
    );
  }

  /// `Your email is not yet verified. Please verify your email to continue`
  String get verify_email_body {
    return Intl.message(
      'Your email is not yet verified. Please verify your email to continue',
      name: 'verify_email_body',
      desc: '',
      args: [],
    );
  }

  /// `Verify`
  String get verify {
    return Intl.message(
      'Verify',
      name: 'verify',
      desc: '',
      args: [],
    );
  }

  /// `Verify your email`
  String get verify_your_email {
    return Intl.message(
      'Verify your email',
      name: 'verify_your_email',
      desc: '',
      args: [],
    );
  }

  /// `Token expired, please log in`
  String get auth_token_expired {
    return Intl.message(
      'Token expired, please log in',
      name: 'auth_token_expired',
      desc: '',
      args: [],
    );
  }

  /// `Please log in again to continue`
  String get please_log_in {
    return Intl.message(
      'Please log in again to continue',
      name: 'please_log_in',
      desc: '',
      args: [],
    );
  }

  /// `Please log in again to continue`
  String get please_log_in_again_to_continue {
    return Intl.message(
      'Please log in again to continue',
      name: 'please_log_in_again_to_continue',
      desc: '',
      args: [],
    );
  }

  /// `Kurobi Terms of Service`
  String get kurobi_terms {
    return Intl.message(
      'Kurobi Terms of Service',
      name: 'kurobi_terms',
      desc: '',
      args: [],
    );
  }

  /// `Password reset successful! Please log in with your new password`
  String get password_reset_successful {
    return Intl.message(
      'Password reset successful! Please log in with your new password',
      name: 'password_reset_successful',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'en', countryCode: 'GB'),
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'),
      Locale.fromSubtags(languageCode: 'ja'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
