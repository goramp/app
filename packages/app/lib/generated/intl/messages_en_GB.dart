// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en_GB locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en_GB';

  static String m0(email) => "Click the link we sent to ${email} to continue";

  static String m1(token) => "Deposit ${token}";

  static String m2(token) =>
      "You do not have enough ${token} to pay for transaction fees. Please deposit more and try again";

  static String m3(fees, token) =>
      "Insufficient balance for network fees ${fees}. Please fund your ${token} account";

  static String m4(time) => "RE-SEND IN ${time}";

  static String m5(token) => "${token} is used to pay for transactions";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "accept_crypto_payment":
            MessageLookupByLibrary.simpleMessage("Accept crypto payments"),
        "accept_nft_timepass":
            MessageLookupByLibrary.simpleMessage("Accept NFT TimePass"),
        "accept_payment_stripe": MessageLookupByLibrary.simpleMessage(
            "Accept card payments with Stripe"),
        "accept_terms_error_confirmation": MessageLookupByLibrary.simpleMessage(
            "Please confirm your age and agree with Kurobi Terms of Service"),
        "account_already_exist": MessageLookupByLibrary.simpleMessage(
            "An account already exist with the same email address."),
        "account_disabled":
            MessageLookupByLibrary.simpleMessage("Account disabled."),
        "account_does_not_exist": MessageLookupByLibrary.simpleMessage(
            "We couldn\'t find an account with that email"),
        "account_exists": MessageLookupByLibrary.simpleMessage("Account Exist"),
        "account_id": MessageLookupByLibrary.simpleMessage("Account ID"),
        "account_with_email_exists": MessageLookupByLibrary.simpleMessage(
            "An account with this email already exists"),
        "add_a_payment_provider": MessageLookupByLibrary.simpleMessage(
            "You must add a payment provider such as Stripe or"),
        "add_card": MessageLookupByLibrary.simpleMessage("Add Card"),
        "add_details": MessageLookupByLibrary.simpleMessage("Add Details"),
        "add_funds": MessageLookupByLibrary.simpleMessage("Add Funds"),
        "add_interval": MessageLookupByLibrary.simpleMessage("Add Interval"),
        "add_notes": MessageLookupByLibrary.simpleMessage("Add notes"),
        "add_payment_method":
            MessageLookupByLibrary.simpleMessage("Add Payment Method"),
        "add_payment_provider":
            MessageLookupByLibrary.simpleMessage("Add Payment Provider"),
        "add_price": MessageLookupByLibrary.simpleMessage("Add Price"),
        "add_this_on_phone_record_watch": MessageLookupByLibrary.simpleMessage(
            "add this on your phone so we can record and watch videos together"),
        "add_this_to_phone_watch_record": MessageLookupByLibrary.simpleMessage(
            "add this to your phone so we can watch and record videos together"),
        "add_your_rescheduling": MessageLookupByLibrary.simpleMessage(
            "Add your rescheduling and cancellation policies."),
        "address": MessageLookupByLibrary.simpleMessage("Address"),
        "age_too_low": MessageLookupByLibrary.simpleMessage(
            "You don\'t meet the age requirement."),
        "all_signin_options":
            MessageLookupByLibrary.simpleMessage("See all sign in options"),
        "allow_access_camera":
            MessageLookupByLibrary.simpleMessage("Allow access to camera"),
        "allow_access_microphone":
            MessageLookupByLibrary.simpleMessage("Allow access to microphone"),
        "almost_there": MessageLookupByLibrary.simpleMessage("Almost there!"),
        "amount": MessageLookupByLibrary.simpleMessage("Amount"),
        "ampm": MessageLookupByLibrary.simpleMessage("AM/PM"),
        "an_account_already_exists": MessageLookupByLibrary.simpleMessage(
            "An account already exists with a different credentials."),
        "an_error_occurred": MessageLookupByLibrary.simpleMessage(
            "An error occurred. Please try again"),
        "and": MessageLookupByLibrary.simpleMessage("and"),
        "api_key": MessageLookupByLibrary.simpleMessage("Api Key"),
        "apologies_something_went_wrong": MessageLookupByLibrary.simpleMessage(
            "Apologies, but something went wrong."),
        "are_you_sure_cancel_payment": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to cancel the payment?"),
        "are_you_sure_delete_card": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to delete this card"),
        "auth_token_expired": MessageLookupByLibrary.simpleMessage(
            "Token expired, please log in"),
        "availablity": MessageLookupByLibrary.simpleMessage("Availability"),
        "balance": MessageLookupByLibrary.simpleMessage("Balance"),
        "base_commission_rate":
            MessageLookupByLibrary.simpleMessage("Your Base Commission Rate"),
        "bio": MessageLookupByLibrary.simpleMessage("Bio"),
        "birthday": MessageLookupByLibrary.simpleMessage("Birthday"),
        "book": MessageLookupByLibrary.simpleMessage("Book"),
        "booking_confirmed":
            MessageLookupByLibrary.simpleMessage("Booking Confirmed"),
        "buy": MessageLookupByLibrary.simpleMessage("Buy"),
        "buy_now": MessageLookupByLibrary.simpleMessage("Buy Now"),
        "call_link": MessageLookupByLibrary.simpleMessage("Call Link"),
        "call_link_accept_new_booking": MessageLookupByLibrary.simpleMessage(
            "Call link cannot accept new bookings"),
        "call_link_can_accept_booking": MessageLookupByLibrary.simpleMessage(
            "Call link can accept bookings"),
        "call_link_live": MessageLookupByLibrary.simpleMessage(
            "Your call link will be LIVE and would start accepting bookings"),
        "call_link_not_visible": MessageLookupByLibrary.simpleMessage(
            "Your call link will not be visible and won\'t accept bookings."),
        "call_links": MessageLookupByLibrary.simpleMessage("Call Links"),
        "camera": MessageLookupByLibrary.simpleMessage("Camera"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "cancel_callback":
            MessageLookupByLibrary.simpleMessage("Cancel CallLink?"),
        "cancel_payment":
            MessageLookupByLibrary.simpleMessage("Cancel Payment"),
        "canceled": MessageLookupByLibrary.simpleMessage("Canceled"),
        "canceling": MessageLookupByLibrary.simpleMessage("Canceling"),
        "cant_validate_address":
            MessageLookupByLibrary.simpleMessage("Can\'t validate address"),
        "cards": MessageLookupByLibrary.simpleMessage("CARDS"),
        "change": MessageLookupByLibrary.simpleMessage("Change"),
        "character_less_than_255": MessageLookupByLibrary.simpleMessage(
            "Make sure to use less than 255 characters"),
        "check_your_inbox":
            MessageLookupByLibrary.simpleMessage("Check your inbox"),
        "checkout": MessageLookupByLibrary.simpleMessage("Checkout"),
        "choose_cover_photo":
            MessageLookupByLibrary.simpleMessage("Choose Cover Photo"),
        "claim_now": MessageLookupByLibrary.simpleMessage("Claim Now"),
        "claims": MessageLookupByLibrary.simpleMessage("Claims"),
        "clear": MessageLookupByLibrary.simpleMessage("Clear"),
        "click_add_on_endpoint": MessageLookupByLibrary.simpleMessage(
            "2. Click \"Add an endpoint\" and paste the followig url:"),
        "click_link_sent": m0,
        "close": MessageLookupByLibrary.simpleMessage("Close"),
        "closed": MessageLookupByLibrary.simpleMessage("Closed"),
        "code_expired": MessageLookupByLibrary.simpleMessage("Code expired"),
        "code_is_number": MessageLookupByLibrary.simpleMessage(
            "Code must be a 6 digit number"),
        "code_not_found":
            MessageLookupByLibrary.simpleMessage("Code not found"),
        "code_required": MessageLookupByLibrary.simpleMessage("Code required"),
        "coinbase_commerce_before": MessageLookupByLibrary.simpleMessage(
            "Coinbase Commerce before you can set your price."),
        "coinbase_commerce_setting": MessageLookupByLibrary.simpleMessage(
            "1. In your Coinbase Commerce settings page, scroll to the \"Webhook subscriptions\" section."),
        "collect_payment":
            MessageLookupByLibrary.simpleMessage("Collect Payment"),
        "collect_payment_card_apple_google_pay":
            MessageLookupByLibrary.simpleMessage(
                "Collect payments with card, Apple  Pay, Google Pay."),
        "collect_payment_sol_usd_kuro": MessageLookupByLibrary.simpleMessage(
            "Collect payments in KURO, USDC, USDT and SOL"),
        "complete_your_profile":
            MessageLookupByLibrary.simpleMessage("Complete your profile"),
        "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
        "confirm_age_terms": MessageLookupByLibrary.simpleMessage(
            "I confirm that I am 18 years of age or older and agree with"),
        "confirm_password":
            MessageLookupByLibrary.simpleMessage("Confirm Password"),
        "confirm_password_is_required": MessageLookupByLibrary.simpleMessage(
            "Confirm password is required"),
        "confirmed": MessageLookupByLibrary.simpleMessage("Confirmed"),
        "connect": MessageLookupByLibrary.simpleMessage("Connect"),
        "connect_bank_earn":
            MessageLookupByLibrary.simpleMessage("Connect bank to earn"),
        "connect_coinbase":
            MessageLookupByLibrary.simpleMessage("Connect Coinbase Commerce"),
        "connect_solana_wallet":
            MessageLookupByLibrary.simpleMessage("Connect Solana Wallet"),
        "connect_wallet":
            MessageLookupByLibrary.simpleMessage("Connect Wallet"),
        "connect_wallet_earn":
            MessageLookupByLibrary.simpleMessage("Connect wallet to earn"),
        "connect_your_stripe_account":
            MessageLookupByLibrary.simpleMessage("Connect Your Stripe Account"),
        "connect_your_wallet":
            MessageLookupByLibrary.simpleMessage("Connect Your Wallet"),
        "connecting": MessageLookupByLibrary.simpleMessage("Connecting"),
        "connection_error":
            MessageLookupByLibrary.simpleMessage("Connection error!"),
        "content_violates_policy": MessageLookupByLibrary.simpleMessage(
            "This video potentially contains content that violates our policy. If we have made a mistake, continue to request a manual review when the video is uploaded."),
        "continue_apple":
            MessageLookupByLibrary.simpleMessage("Continue with Apple"),
        "continue_email":
            MessageLookupByLibrary.simpleMessage("Continue with Email"),
        "continue_facebook":
            MessageLookupByLibrary.simpleMessage("Continue with Facebook"),
        "continue_google":
            MessageLookupByLibrary.simpleMessage("Continue with Google"),
        "continue_string": MessageLookupByLibrary.simpleMessage("Continue"),
        "continue_twitter":
            MessageLookupByLibrary.simpleMessage("Continue with Twitter"),
        "contribute": MessageLookupByLibrary.simpleMessage("Contribute"),
        "copied": MessageLookupByLibrary.simpleMessage("Copied"),
        "copied_to_clipboard":
            MessageLookupByLibrary.simpleMessage("Copied to clipboard"),
        "copy_address": MessageLookupByLibrary.simpleMessage("Copy Address"),
        "copy_link": MessageLookupByLibrary.simpleMessage("Copy Link"),
        "could_not_open_mail_app":
            MessageLookupByLibrary.simpleMessage("Could not open mail app"),
        "country": MessageLookupByLibrary.simpleMessage("Country"),
        "create": MessageLookupByLibrary.simpleMessage("Create"),
        "create_a_call_lin": MessageLookupByLibrary.simpleMessage(
            "Create a call link to start receiving or scheduling 1:1 calls"),
        "create_a_calllink_receive": MessageLookupByLibrary.simpleMessage(
            "Create a call link to start receiving"),
        "create_a_title":
            MessageLookupByLibrary.simpleMessage("Create a title"),
        "create_account":
            MessageLookupByLibrary.simpleMessage("CREATE ACCOUNT"),
        "create_new_account":
            MessageLookupByLibrary.simpleMessage("create a new account"),
        "create_title": MessageLookupByLibrary.simpleMessage("Create a title"),
        "current_price": MessageLookupByLibrary.simpleMessage("Current Price"),
        "data_not_stored":
            MessageLookupByLibrary.simpleMessage("Data will not be stored"),
        "date": MessageLookupByLibrary.simpleMessage("Date"),
        "days": MessageLookupByLibrary.simpleMessage("Days"),
        "default_error_title":
            MessageLookupByLibrary.simpleMessage("Please try again."),
        "default_error_title2": MessageLookupByLibrary.simpleMessage(
            "Something doesn\'t seem right, we are checking..."),
        "delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "delete_calllink":
            MessageLookupByLibrary.simpleMessage("Delete CallLink?"),
        "deposit": MessageLookupByLibrary.simpleMessage("Deposit"),
        "deposit_fund_on_ftx_account": MessageLookupByLibrary.simpleMessage(
            "Deposit funds from an FTX account, where you can add funds using crypto on multiple blockchains, credit cards, and more."),
        "deposit_token": m1,
        "destination_address":
            MessageLookupByLibrary.simpleMessage("Destination Address"),
        "details": MessageLookupByLibrary.simpleMessage("Details"),
        "dialog_positive_default": MessageLookupByLibrary.simpleMessage("OK"),
        "didnt_recognize_email": MessageLookupByLibrary.simpleMessage(
            "Sorry we didn\'t recogize that email."),
        "discard": MessageLookupByLibrary.simpleMessage("Discard"),
        "discard_call_link":
            MessageLookupByLibrary.simpleMessage("Discard Call Link?"),
        "discard_video_changes": MessageLookupByLibrary.simpleMessage(
            "This will discard your video and all changes."),
        "disconnect": MessageLookupByLibrary.simpleMessage("Disconnect"),
        "disconnect_coinbase": MessageLookupByLibrary.simpleMessage(
            "Disconnect Coinbase Commerce?"),
        "disconnect_stripe":
            MessageLookupByLibrary.simpleMessage("Disconnect Stripe?"),
        "discount": MessageLookupByLibrary.simpleMessage("discount"),
        "dismiss": MessageLookupByLibrary.simpleMessage("Dismiss"),
        "done": MessageLookupByLibrary.simpleMessage("Done"),
        "dont_have_an_account":
            MessageLookupByLibrary.simpleMessage("Dont\'t have an account?"),
        "dst_ady_mint_dont_match": MessageLookupByLibrary.simpleMessage(
            "Destination address mint does not match"),
        "duration": MessageLookupByLibrary.simpleMessage("Duration"),
        "edit": MessageLookupByLibrary.simpleMessage("Edit"),
        "edit_call_link":
            MessageLookupByLibrary.simpleMessage("Edit Call Link"),
        "edit_profile": MessageLookupByLibrary.simpleMessage("Edit Profile"),
        "email": MessageLookupByLibrary.simpleMessage("Email"),
        "email_already_exists":
            MessageLookupByLibrary.simpleMessage("Email already exists"),
        "email_associated_with_account": MessageLookupByLibrary.simpleMessage(
            "Enter the email associated with your account, and we\'ll send a magic link to your inbox."),
        "email_immutable":
            MessageLookupByLibrary.simpleMessage("Email can\'t change"),
        "email_invalid":
            MessageLookupByLibrary.simpleMessage("Email is not valid"),
        "email_link_reset_password": MessageLookupByLibrary.simpleMessage(
            "Please enter your email address to receive a link to reset your password."),
        "email_required":
            MessageLookupByLibrary.simpleMessage("Email required"),
        "email_verified":
            MessageLookupByLibrary.simpleMessage("Email Verified"),
        "end_cant_be_before_start": MessageLookupByLibrary.simpleMessage(
            "Your end time cannot be before your start time"),
        "ended": MessageLookupByLibrary.simpleMessage("Ended"),
        "ending": MessageLookupByLibrary.simpleMessage("Ending"),
        "ends": MessageLookupByLibrary.simpleMessage("Ends"),
        "enter": MessageLookupByLibrary.simpleMessage("Enter"),
        "enter_a_price": MessageLookupByLibrary.simpleMessage("Enter a price"),
        "enter_email_address":
            MessageLookupByLibrary.simpleMessage("Enter your email address"),
        "enter_email_create_account": MessageLookupByLibrary.simpleMessage(
            "Enter your email address to create an account."),
        "enter_valid_email":
            MessageLookupByLibrary.simpleMessage("Enter a valid email address"),
        "error": MessageLookupByLibrary.simpleMessage("error"),
        "estimated": MessageLookupByLibrary.simpleMessage("estimated"),
        "example_com": MessageLookupByLibrary.simpleMessage("name@example.com"),
        "exceeded_maximum_amount": MessageLookupByLibrary.simpleMessage(
            "You have exceeded the maximum of"),
        "exceeded_remaining_amount": MessageLookupByLibrary.simpleMessage(
            "You have exceeded the remaining amount of"),
        "expired": MessageLookupByLibrary.simpleMessage("Expired"),
        "expiry": MessageLookupByLibrary.simpleMessage("Expiry"),
        "external": MessageLookupByLibrary.simpleMessage("External"),
        "fail_fetch_call_link":
            MessageLookupByLibrary.simpleMessage("Failed to fetch call links"),
        "fail_fetch_card":
            MessageLookupByLibrary.simpleMessage("Failed to fetch cards"),
        "fail_to_fetch_tokens":
            MessageLookupByLibrary.simpleMessage("Failed to fetch tokens"),
        "failed": MessageLookupByLibrary.simpleMessage("Failed"),
        "failed_fetch_transactions": MessageLookupByLibrary.simpleMessage(
            "Failed to fetch transactions"),
        "failed_fetch_wallet": MessageLookupByLibrary.simpleMessage(
            "Failed to fetch wallet details"),
        "failed_to_fetch":
            MessageLookupByLibrary.simpleMessage("Failed to fetch"),
        "failed_to_fetch_card":
            MessageLookupByLibrary.simpleMessage("Failed to fetch card"),
        "failed_to_fetch_cards":
            MessageLookupByLibrary.simpleMessage("Failed to fetch cards..."),
        "failed_to_fetch_event_details": MessageLookupByLibrary.simpleMessage(
            "failed to fetch event details."),
        "failed_to_fetch_payment_method": MessageLookupByLibrary.simpleMessage(
            "Failed to fetch payment methods"),
        "failed_to_fetch_profile":
            MessageLookupByLibrary.simpleMessage("Failed to fetch profile"),
        "failed_to_fetch_schedules":
            MessageLookupByLibrary.simpleMessage("Failed to fetch schedules"),
        "failed_to_fetch_transaction":
            MessageLookupByLibrary.simpleMessage("Failed to fetch transaction"),
        "failed_to_load_payment_method": MessageLookupByLibrary.simpleMessage(
            "Failed to load payment method"),
        "failed_to_load_profile":
            MessageLookupByLibrary.simpleMessage("Failed to load profile"),
        "failed_to_send_confirmation_link":
            MessageLookupByLibrary.simpleMessage(
                "Failed to re-send confimation link, please try again."),
        "fee": MessageLookupByLibrary.simpleMessage("Fee"),
        "feedback": MessageLookupByLibrary.simpleMessage("Feedback"),
        "fetching_card": MessageLookupByLibrary.simpleMessage("Fetching card"),
        "fetching_cards":
            MessageLookupByLibrary.simpleMessage("Fetching cards..."),
        "fetching_payments":
            MessageLookupByLibrary.simpleMessage("Fetching payments"),
        "fetching_token":
            MessageLookupByLibrary.simpleMessage("Fetching tokens"),
        "fetching_transactions":
            MessageLookupByLibrary.simpleMessage("Fetching transactions"),
        "finish_creating_account": MessageLookupByLibrary.simpleMessage(
            "Finish creating your account for the full experience."),
        "first_name": MessageLookupByLibrary.simpleMessage("First Name"),
        "first_name_required":
            MessageLookupByLibrary.simpleMessage("First name required"),
        "forgot_password":
            MessageLookupByLibrary.simpleMessage("Forgot Passoword?"),
        "free": MessageLookupByLibrary.simpleMessage("Free"),
        "friday": MessageLookupByLibrary.simpleMessage("Fri"),
        "friend_recieve":
            MessageLookupByLibrary.simpleMessage("Friends Receive"),
        "friends_commission_kickback_rate":
            MessageLookupByLibrary.simpleMessage(
                "Set Friends’ Commission Kickback Rate"),
        "from": MessageLookupByLibrary.simpleMessage("From"),
        "full_name": MessageLookupByLibrary.simpleMessage("Full Name"),
        "generate_your_link":
            MessageLookupByLibrary.simpleMessage("Generate your link"),
        "generating_preview":
            MessageLookupByLibrary.simpleMessage("Generating preview"),
        "get_credit": MessageLookupByLibrary.simpleMessage("Get Credit"),
        "get_started": MessageLookupByLibrary.simpleMessage("Get Started"),
        "grant_access": MessageLookupByLibrary.simpleMessage(
            "Grants access using NFT TimePass as tickets"),
        "grant_camera_access_record": MessageLookupByLibrary.simpleMessage(
            "Grant camera access to record"),
        "group": MessageLookupByLibrary.simpleMessage("Group"),
        "group_sub_title": MessageLookupByLibrary.simpleMessage(
            "Stream to multiple guests at a particular time"),
        "guest": MessageLookupByLibrary.simpleMessage("Guest"),
        "helloWorld": MessageLookupByLibrary.simpleMessage("Hello World!"),
        "hey": MessageLookupByLibrary.simpleMessage("Hey"),
        "home": MessageLookupByLibrary.simpleMessage("Home"),
        "host": MessageLookupByLibrary.simpleMessage("Host"),
        "hours": MessageLookupByLibrary.simpleMessage("Hours"),
        "i_m_avaliable": MessageLookupByLibrary.simpleMessage("I\'m available"),
        "identity_verified":
            MessageLookupByLibrary.simpleMessage("Identity Verified"),
        "in_order_accept_bitcoin_etherum": MessageLookupByLibrary.simpleMessage(
            "In order to accept Bitcoin, Ethereum, DAI, Litecoin, Bitcoin Cash, or USD Coin, you need to link your coinbase commerce account."),
        "in_order_accept_kurobi_solona_usd": MessageLookupByLibrary.simpleMessage(
            "In order to accept kurobi, USD Coin or Solana, you need to link your solana wallet."),
        "in_order_connect_card_payment": MessageLookupByLibrary.simpleMessage(
            "In order to collect card payments, you need to connect your stripe account. If you don\'t ve a stripe account, you will be redirected to create one."),
        "inappropriate_content":
            MessageLookupByLibrary.simpleMessage("Inappropriate Content"),
        "insufficient_funds":
            MessageLookupByLibrary.simpleMessage("Insufficient funds"),
        "insufficient_sol_for_fees": m2,
        "insufficient_wallet_balance": m3,
        "interval_overlapping":
            MessageLookupByLibrary.simpleMessage("Intervals are overlapping"),
        "intervals_must_be":
            MessageLookupByLibrary.simpleMessage("Intervals must be atleast"),
        "intro": MessageLookupByLibrary.simpleMessage(
            "Host 1:1 video calls with your audience and get paid for your time"),
        "intro_audience": MessageLookupByLibrary.simpleMessage(
            "Host 1:1 video calls with your audience"),
        "intro_followers": MessageLookupByLibrary.simpleMessage(
            "Host 1:1 video calls with your followers"),
        "intro_paid_for_time":
            MessageLookupByLibrary.simpleMessage("and get paid for your time"),
        "invalid_address":
            MessageLookupByLibrary.simpleMessage("Invalid address"),
        "invalid_amount":
            MessageLookupByLibrary.simpleMessage("Invalid amount"),
        "invalid_email_or_password": MessageLookupByLibrary.simpleMessage(
            "Invalid email or password provided"),
        "invalid_expired_action_code": MessageLookupByLibrary.simpleMessage(
            "Invalid or expired action code."),
        "invalid_expired_code": MessageLookupByLibrary.simpleMessage(
            "Invalid or expired code. Please verify your email address again."),
        "invalid_price": MessageLookupByLibrary.simpleMessage("Invalid Price"),
        "invalid_verification_code":
            MessageLookupByLibrary.simpleMessage("Invalid verification code"),
        "invite_friends":
            MessageLookupByLibrary.simpleMessage("Invite Friends"),
        "item_description":
            MessageLookupByLibrary.simpleMessage("Item Description"),
        "item_name": MessageLookupByLibrary.simpleMessage("Item Name"),
        "join_call": MessageLookupByLibrary.simpleMessage("JOIN CALL"),
        "kuro_claimed_see_wallet": MessageLookupByLibrary.simpleMessage(
            "Your KURO has been claimed and should now be in your wallet."),
        "kuro_will_distributed_sales_end": MessageLookupByLibrary.simpleMessage(
            "Your KURO will be automatically distributed after the sale ends."),
        "kurobi_terms":
            MessageLookupByLibrary.simpleMessage("Kurobi Terms of Service"),
        "last_name": MessageLookupByLibrary.simpleMessage("Last Name"),
        "last_name_required":
            MessageLookupByLibrary.simpleMessage("Last name required"),
        "learn_more": MessageLookupByLibrary.simpleMessage("Learn More"),
        "likes": MessageLookupByLibrary.simpleMessage("Likes"),
        "log_in": MessageLookupByLibrary.simpleMessage("Log In"),
        "log_in_different_user":
            MessageLookupByLibrary.simpleMessage("Log in as a different user"),
        "log_out": MessageLookupByLibrary.simpleMessage("Logout"),
        "log_out_of": MessageLookupByLibrary.simpleMessage("Logout of"),
        "login_to_kurobi":
            MessageLookupByLibrary.simpleMessage("Log in to Kurobi"),
        "login_unauthorized": MessageLookupByLibrary.simpleMessage(
            "Oops! Your username/email address or password is incorrect "),
        "login_view_liked_calls": MessageLookupByLibrary.simpleMessage(
            "Login to view your liked call links"),
        "login_with_email":
            MessageLookupByLibrary.simpleMessage("Login with email"),
        "low_sol_balance": MessageLookupByLibrary.simpleMessage(
            "Caution: Your SOL balance is low "),
        "low_sol_balance_info": MessageLookupByLibrary.simpleMessage(
            "SOL is needed for Solana network fees. A minimum balance of 0.05 SOL is recommended to avoid failed transactions."),
        "max": MessageLookupByLibrary.simpleMessage("Max"),
        "max_cards_reached": MessageLookupByLibrary.simpleMessage(
            "You have reached the maximum number of cards. Please remove or update an existing card"),
        "maximum": MessageLookupByLibrary.simpleMessage("maximum"),
        "maximum_number_card": MessageLookupByLibrary.simpleMessage(
            "You have reached the maximum number of cards. Please remove or update an existing card"),
        "me": MessageLookupByLibrary.simpleMessage("Me"),
        "min_password_chars": MessageLookupByLibrary.simpleMessage(
            "Make sure to enter at least 8 characters"),
        "min_username_chars": MessageLookupByLibrary.simpleMessage(
            "Make sure to enter at least 3 characters"),
        "minimum": MessageLookupByLibrary.simpleMessage("minimum"),
        "minimum_contribution_of":
            MessageLookupByLibrary.simpleMessage("Minimum contribution of"),
        "mins": MessageLookupByLibrary.simpleMessage("mins"),
        "minutes": MessageLookupByLibrary.simpleMessage("Minutes"),
        "monday": MessageLookupByLibrary.simpleMessage("Mon"),
        "monetize_your_time":
            MessageLookupByLibrary.simpleMessage("Monetize your time"),
        "name": MessageLookupByLibrary.simpleMessage("Name"),
        "name_invalid": MessageLookupByLibrary.simpleMessage(
            "First name or last name is not valid"),
        "new_call_link": MessageLookupByLibrary.simpleMessage("New Call Link"),
        "new_password": MessageLookupByLibrary.simpleMessage("New Password"),
        "next": MessageLookupByLibrary.simpleMessage("Next"),
        "no": MessageLookupByLibrary.simpleMessage("No"),
        "no_cards": MessageLookupByLibrary.simpleMessage("No Cards"),
        "no_likes_here": MessageLookupByLibrary.simpleMessage("No likes here"),
        "no_payment": MessageLookupByLibrary.simpleMessage("No Payment"),
        "no_result_found":
            MessageLookupByLibrary.simpleMessage("No Result Found"),
        "no_title": MessageLookupByLibrary.simpleMessage("NO TITLE"),
        "no_tokens": MessageLookupByLibrary.simpleMessage("No Tokens"),
        "no_transactions":
            MessageLookupByLibrary.simpleMessage("No Transactions"),
        "no_upcoming_event":
            MessageLookupByLibrary.simpleMessage("no buy events"),
        "not_like_any_call_link": MessageLookupByLibrary.simpleMessage(
            "You have not liked any call links by"),
        "notes": MessageLookupByLibrary.simpleMessage("Notes"),
        "nothing_here": MessageLookupByLibrary.simpleMessage("Nothing here"),
        "ok": MessageLookupByLibrary.simpleMessage("Ok"),
        "one_on_one": MessageLookupByLibrary.simpleMessage("One-on-One"),
        "one_on_one_sub_title": MessageLookupByLibrary.simpleMessage(
            "Let one guest book a time with you."),
        "open_mail_app": MessageLookupByLibrary.simpleMessage("Open Mail App"),
        "or": MessageLookupByLibrary.simpleMessage("or"),
        "or_drag_drop_file":
            MessageLookupByLibrary.simpleMessage("or drag and drop a file"),
        "order_canceled":
            MessageLookupByLibrary.simpleMessage("Order Canceled"),
        "passes": MessageLookupByLibrary.simpleMessage("PASSES"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "password_invalid": MessageLookupByLibrary.simpleMessage(
            "At least 8 characters and should include letters, numbers, and special characters"),
        "password_required":
            MessageLookupByLibrary.simpleMessage("Password is required"),
        "password_reset_request": MessageLookupByLibrary.simpleMessage(
            "Password reset request sent successfully"),
        "password_reset_successful": MessageLookupByLibrary.simpleMessage(
            "Password reset successful! Please log in with your new password"),
        "pay": MessageLookupByLibrary.simpleMessage("Pay"),
        "pay_with_crypto":
            MessageLookupByLibrary.simpleMessage("Pay with crypto"),
        "pay_with_crypto_wallet":
            MessageLookupByLibrary.simpleMessage("Pay with crypto wallet"),
        "payment_terms": MessageLookupByLibrary.simpleMessage("Payment terms"),
        "payments": MessageLookupByLibrary.simpleMessage("PAYMENTS"),
        "payout": MessageLookupByLibrary.simpleMessage("Payout"),
        "payout_now": MessageLookupByLibrary.simpleMessage("Payout Now"),
        "payout_onboarding_description": MessageLookupByLibrary.simpleMessage(
            "Collect payments in crypto or cash when your guest book a call and reduce no shows."),
        "pending": MessageLookupByLibrary.simpleMessage("pending"),
        "pending_balance":
            MessageLookupByLibrary.simpleMessage("Pending Balance"),
        "phone_number_exists":
            MessageLookupByLibrary.simpleMessage("Phone number already exists"),
        "photo_librar": MessageLookupByLibrary.simpleMessage("Photo Library"),
        "photos": MessageLookupByLibrary.simpleMessage("Photos"),
        "please_check_your_connection": MessageLookupByLibrary.simpleMessage(
            "Please check your connection"),
        "please_enter_new_password": MessageLookupByLibrary.simpleMessage(
            "Please enter a new password."),
        "please_log_in": MessageLookupByLibrary.simpleMessage(
            "Please log in again to continue"),
        "please_log_in_again_to_continue": MessageLookupByLibrary.simpleMessage(
            "Please log in again to continue"),
        "powered_by": MessageLookupByLibrary.simpleMessage("powered by"),
        "preparing": MessageLookupByLibrary.simpleMessage("Preparing"),
        "preview": MessageLookupByLibrary.simpleMessage("Preview"),
        "price": MessageLookupByLibrary.simpleMessage("Price"),
        "privacy_policy":
            MessageLookupByLibrary.simpleMessage("Privacy Policy"),
        "processing": MessageLookupByLibrary.simpleMessage("processing"),
        "processing_video":
            MessageLookupByLibrary.simpleMessage("Processing Video"),
        "product": MessageLookupByLibrary.simpleMessage("Product"),
        "profile_not_found":
            MessageLookupByLibrary.simpleMessage("Profile not found"),
        "provide_email_for_confirmation": MessageLookupByLibrary.simpleMessage(
            "Please provide your email for confirmation."),
        "publish": MessageLookupByLibrary.simpleMessage("Publish"),
        "publish_call_link":
            MessageLookupByLibrary.simpleMessage("Publish Call Link"),
        "published": MessageLookupByLibrary.simpleMessage("Published"),
        "qr_code": MessageLookupByLibrary.simpleMessage("QR Code"),
        "ramp_allows_you_to_buy_cryto": MessageLookupByLibrary.simpleMessage(
            "Ramp allows you to buy crypto with Apple Pay, Google Pay, Credit Card and bank transfer in 170+ countries."),
        "re_schedule": MessageLookupByLibrary.simpleMessage("Re-Schedule"),
        "receive": MessageLookupByLibrary.simpleMessage("Receive"),
        "record_video": MessageLookupByLibrary.simpleMessage("Record a video"),
        "recorded": MessageLookupByLibrary.simpleMessage("Recorded"),
        "recording": MessageLookupByLibrary.simpleMessage("RECORDING"),
        "refreshing_the_page": MessageLookupByLibrary.simpleMessage(
            "Let\'s see if refreshing the page will fix it"),
        "reminder": MessageLookupByLibrary.simpleMessage("Reminder"),
        "remove": MessageLookupByLibrary.simpleMessage("Remove"),
        "remove_card": MessageLookupByLibrary.simpleMessage("Remove Card"),
        "removed": MessageLookupByLibrary.simpleMessage("Removed"),
        "report": MessageLookupByLibrary.simpleMessage("Report"),
        "required": MessageLookupByLibrary.simpleMessage("required"),
        "resend_in": m4,
        "reservation_been_released": MessageLookupByLibrary.simpleMessage(
            "Your reservation has been released."),
        "reset": MessageLookupByLibrary.simpleMessage("Reset"),
        "reset_password":
            MessageLookupByLibrary.simpleMessage("Reset Password"),
        "reset_your_password":
            MessageLookupByLibrary.simpleMessage("Reset Your Password"),
        "restart_booking": MessageLookupByLibrary.simpleMessage(
            "Please re-start your booking."),
        "retry": MessageLookupByLibrary.simpleMessage("Retry"),
        "saturday": MessageLookupByLibrary.simpleMessage("Sat"),
        "save": MessageLookupByLibrary.simpleMessage("Save"),
        "savings": MessageLookupByLibrary.simpleMessage("Savings"),
        "scan": MessageLookupByLibrary.simpleMessage("Scan"),
        "scan_to_call": MessageLookupByLibrary.simpleMessage("Scan to call"),
        "schedules": MessageLookupByLibrary.simpleMessage("schedules"),
        "schedules_not_been_cancelled": MessageLookupByLibrary.simpleMessage(
            "schedule(s) that have not been canceled."),
        "search": MessageLookupByLibrary.simpleMessage("Search"),
        "search_failed": MessageLookupByLibrary.simpleMessage(
            "Search failed, please try again."),
        "secs": MessageLookupByLibrary.simpleMessage("Secs"),
        "see_all_payout":
            MessageLookupByLibrary.simpleMessage("See all payout options"),
        "select": MessageLookupByLibrary.simpleMessage("Select"),
        "select_a_date": MessageLookupByLibrary.simpleMessage("Select a Date"),
        "select_a_time": MessageLookupByLibrary.simpleMessage("Select a Time"),
        "select_a_week_day":
            MessageLookupByLibrary.simpleMessage("Select a week day"),
        "select_all": MessageLookupByLibrary.simpleMessage("Select All"),
        "select_country":
            MessageLookupByLibrary.simpleMessage("Select Country"),
        "select_cover": MessageLookupByLibrary.simpleMessage("Select Cover"),
        "select_date_time":
            MessageLookupByLibrary.simpleMessage("Select a Date and Time"),
        "select_duration":
            MessageLookupByLibrary.simpleMessage("Select Duration"),
        "select_items": MessageLookupByLibrary.simpleMessage("Select Items"),
        "select_time_interval":
            MessageLookupByLibrary.simpleMessage("Select Time Interval"),
        "select_timezone":
            MessageLookupByLibrary.simpleMessage("Select Timezone"),
        "select_video_to_upload":
            MessageLookupByLibrary.simpleMessage("Select video to upload"),
        "selected": MessageLookupByLibrary.simpleMessage("Selected"),
        "sell": MessageLookupByLibrary.simpleMessage("Sell"),
        "sell_all": MessageLookupByLibrary.simpleMessage("Sell All"),
        "send": MessageLookupByLibrary.simpleMessage("Send"),
        "send_me_all_events": MessageLookupByLibrary.simpleMessage(
            "3. Make sure to select \"Send me all events\", to receive all payment updates."),
        "send_only": MessageLookupByLibrary.simpleMessage("Send only"),
        "sent_link_reset_password": MessageLookupByLibrary.simpleMessage(
            "We have sent a link to reset your password to"),
        "sent_verification_link": MessageLookupByLibrary.simpleMessage(
            "We have sent a verification link to your inbox"),
        "service_fee": MessageLookupByLibrary.simpleMessage("Service Fee"),
        "service_unavailable":
            MessageLookupByLibrary.simpleMessage("Service Unavailable"),
        "service_unavailable_region": MessageLookupByLibrary.simpleMessage(
            "This service is currently not available in your region"),
        "set_default": MessageLookupByLibrary.simpleMessage("Set Default"),
        "settings": MessageLookupByLibrary.simpleMessage("Settings"),
        "share": MessageLookupByLibrary.simpleMessage("Share"),
        "share_to": MessageLookupByLibrary.simpleMessage("Share To"),
        "share_to_facebook":
            MessageLookupByLibrary.simpleMessage("Share To Facebook"),
        "share_to_line": MessageLookupByLibrary.simpleMessage("Share To Line"),
        "share_to_linkedln":
            MessageLookupByLibrary.simpleMessage("Share To LinkedIn"),
        "share_to_twitter":
            MessageLookupByLibrary.simpleMessage("Share To Twitter"),
        "share_to_whatsapp":
            MessageLookupByLibrary.simpleMessage("Share To WhatsApp"),
        "show_less": MessageLookupByLibrary.simpleMessage("Show less"),
        "show_more": MessageLookupByLibrary.simpleMessage("Show more"),
        "show_shared_secret": MessageLookupByLibrary.simpleMessage(
            "4. Click \"show shared secret\" and paste into the box above."),
        "sign_in": MessageLookupByLibrary.simpleMessage("Sign in"),
        "sign_in_email":
            MessageLookupByLibrary.simpleMessage("Sign in with email"),
        "sign_up": MessageLookupByLibrary.simpleMessage("Sign up"),
        "sign_up_email":
            MessageLookupByLibrary.simpleMessage("Sign up with email"),
        "sign_up_now": MessageLookupByLibrary.simpleMessage("Sign up now"),
        "sign_up_with_email":
            MessageLookupByLibrary.simpleMessage("Sign up with email"),
        "signin_agreement": MessageLookupByLibrary.simpleMessage(
            "By signing in, you agree to the "),
        "signin_different_user":
            MessageLookupByLibrary.simpleMessage("Sign in as a different user"),
        "signin_link_expired": MessageLookupByLibrary.simpleMessage(
            "Your sign in link has expired."),
        "signin_link_not_valid": MessageLookupByLibrary.simpleMessage(
            "Your sign in link is not valid."),
        "signup_agreement": MessageLookupByLibrary.simpleMessage(
            "By signing up, you agree to the "),
        "signup_dialog_error_default_title":
            MessageLookupByLibrary.simpleMessage("One Moment!"),
        "signup_dialog_error_default_title2":
            MessageLookupByLibrary.simpleMessage("Oh no!"),
        "signup_for_kurobi":
            MessageLookupByLibrary.simpleMessage("Sign Up for Kurobi"),
        "signup_invalid_email_default_error":
            MessageLookupByLibrary.simpleMessage("Your email is not valid :)"),
        "signup_no_name_default_error": MessageLookupByLibrary.simpleMessage(
            "Add your name to let your friends know who they\'re talking to :)"),
        "signup_unique_email_default_error":
            MessageLookupByLibrary.simpleMessage(
                "Your email has already been registered :)"),
        "slippage": MessageLookupByLibrary.simpleMessage("Slippage"),
        "sol_pays_transaction_fee": m5,
        "solona_wallet_linked": MessageLookupByLibrary.simpleMessage(
            "Your Solana Wallet is Linked"),
        "something_went_wrong":
            MessageLookupByLibrary.simpleMessage("Oops! Something went wrong."),
        "sorry_calllink_cannot_deleted": MessageLookupByLibrary.simpleMessage(
            "Sorry, this callLink cannot be deleted because you have"),
        "sorry_calllink_ended": MessageLookupByLibrary.simpleMessage(
            "Sorry, this callLink has ended or expired"),
        "sorry_target_contribution": MessageLookupByLibrary.simpleMessage(
            "Sorry! The target maximum contribution of"),
        "starting": MessageLookupByLibrary.simpleMessage("Starting"),
        "starts": MessageLookupByLibrary.simpleMessage("Starts"),
        "stripe_make_sure_get_paid": MessageLookupByLibrary.simpleMessage(
            "We use Stripe to make sure you get paid on time and to keep your personal bank and details secure."),
        "sunday": MessageLookupByLibrary.simpleMessage("Sun"),
        "supports_bitcoin_etherum": MessageLookupByLibrary.simpleMessage(
            "Supports Bitcoin, Ethereum, DAI, Litecoin, Bitcoin Cash, or USD Coin"),
        "supports_card_payments": MessageLookupByLibrary.simpleMessage(
            "Supports card payments, Apple  Pay, Google Pay."),
        "suscbribe_to_your_event": MessageLookupByLibrary.simpleMessage(
            "You need to add this event to your weekly availability so people can select a convenient time to book or subscribe to your event."),
        "swap": MessageLookupByLibrary.simpleMessage("Swap"),
        "swap_off_from_estimate": MessageLookupByLibrary.simpleMessage(
            "The amount (in units of percent) a swap can be off from the estimate"),
        "swipe_down_create_event":
            MessageLookupByLibrary.simpleMessage("Swipe down to create event"),
        "terms_of_service":
            MessageLookupByLibrary.simpleMessage("Terms of Service"),
        "thank_you": MessageLookupByLibrary.simpleMessage("Thank You"),
        "thank_you_participating": MessageLookupByLibrary.simpleMessage(
            "Thank You For Participating!!!"),
        "thursday": MessageLookupByLibrary.simpleMessage("Thu"),
        "time": MessageLookupByLibrary.simpleMessage("Time"),
        "time_left": MessageLookupByLibrary.simpleMessage("Time Left"),
        "time_limit_reached":
            MessageLookupByLibrary.simpleMessage("Time Limit Reached"),
        "time_passes_appear_here": MessageLookupByLibrary.simpleMessage(
            "time passes will appear here"),
        "time_zone": MessageLookupByLibrary.simpleMessage("Time Zone"),
        "timepass_coming_soon":
            MessageLookupByLibrary.simpleMessage("TimePass is coming soon"),
        "title": MessageLookupByLibrary.simpleMessage("Title"),
        "to": MessageLookupByLibrary.simpleMessage("To"),
        "to_complete_setup": MessageLookupByLibrary.simpleMessage(
            "to complete your account set-up."),
        "to_contribute": MessageLookupByLibrary.simpleMessage("to contribute"),
        "to_sigin_in": MessageLookupByLibrary.simpleMessage("to sign in."),
        "to_this_addres_any_digital_asset_loss":
            MessageLookupByLibrary.simpleMessage(
                "to this address. Sending any other digital asset will result in permanent loss"),
        "tokens": MessageLookupByLibrary.simpleMessage("TOKENS"),
        "tolerance": MessageLookupByLibrary.simpleMessage("Tolerance"),
        "top_up": MessageLookupByLibrary.simpleMessage("Top Up"),
        "total": MessageLookupByLibrary.simpleMessage("Total"),
        "trade": MessageLookupByLibrary.simpleMessage("Trade"),
        "transaction_confirmed":
            MessageLookupByLibrary.simpleMessage("Transaction confirmed"),
        "transaction_id":
            MessageLookupByLibrary.simpleMessage("Transaction Id"),
        "transaction_signature":
            MessageLookupByLibrary.simpleMessage("Transaction Signature"),
        "transaction_successful":
            MessageLookupByLibrary.simpleMessage("Transaction Successful"),
        "transaction_type":
            MessageLookupByLibrary.simpleMessage("Transaction Type"),
        "transak_supports_debit_card_bank_transfer":
            MessageLookupByLibrary.simpleMessage(
                "Transak supports debit card and bank transfers (depending on location) in 60+ countries."),
        "try_again": MessageLookupByLibrary.simpleMessage("Try Again"),
        "tuesday": MessageLookupByLibrary.simpleMessage("Tues"),
        "unavailable": MessageLookupByLibrary.simpleMessage("Unavailable"),
        "unfortunately_cant_process_order": MessageLookupByLibrary.simpleMessage(
            "Unfortunately, we cannot process your order as the reservation was canceled or expired. Rest assured, you won\'t be charged."),
        "unknown_error": MessageLookupByLibrary.simpleMessage(
            "An unknown error has occurred. Please try again..."),
        "unknown_screen":
            MessageLookupByLibrary.simpleMessage("Unknown Screen"),
        "unpublish": MessageLookupByLibrary.simpleMessage("Unpublish"),
        "unpublish_call_link":
            MessageLookupByLibrary.simpleMessage("Unpublish Call Link"),
        "unverified": MessageLookupByLibrary.simpleMessage("Unverified"),
        "up_next": MessageLookupByLibrary.simpleMessage("Up Next"),
        "up_to": MessageLookupByLibrary.simpleMessage("up to"),
        "updated": MessageLookupByLibrary.simpleMessage("Updated"),
        "upload_video_explains": MessageLookupByLibrary.simpleMessage(
            "Upload a short video that explains"),
        "uploading": MessageLookupByLibrary.simpleMessage("Uploading"),
        "user_not_found":
            MessageLookupByLibrary.simpleMessage("User not found."),
        "username": MessageLookupByLibrary.simpleMessage("Username"),
        "username_already_exists":
            MessageLookupByLibrary.simpleMessage("Username already exists"),
        "username_lt_max_chars": MessageLookupByLibrary.simpleMessage(
            "Make sure to use less than 30 characters"),
        "username_must_end_in_letter_or_num":
            MessageLookupByLibrary.simpleMessage(
                "Uh oh! Usernames must end in a letter or number"),
        "username_must_include_latin_chars": MessageLookupByLibrary.simpleMessage(
            "Oops! Usernames can only include letters, numbers and 1 \"-\",\"_\",or\".\", but no special characters"),
        "username_or_email":
            MessageLookupByLibrary.simpleMessage("Username or Email"),
        "username_required":
            MessageLookupByLibrary.simpleMessage("Username is required"),
        "usernmae_already_exists": MessageLookupByLibrary.simpleMessage(
            "An account with this username already exists"),
        "using_webhook_allows_coinbase": MessageLookupByLibrary.simpleMessage(
            "Using webhooks allows Coinbase Commerce to notify Gotok when a payment has been confirmed in real time."),
        "verification_code_expired":
            MessageLookupByLibrary.simpleMessage("Verification code expired"),
        "verification_code_sent":
            MessageLookupByLibrary.simpleMessage("Verification code sent"),
        "verified": MessageLookupByLibrary.simpleMessage("Verified"),
        "verify": MessageLookupByLibrary.simpleMessage("Verify"),
        "verify_email": MessageLookupByLibrary.simpleMessage("Verify Email"),
        "verify_email_body": MessageLookupByLibrary.simpleMessage(
            "Your email is not yet verified. Please verify your email to continue"),
        "verify_identity_plaform_safe": MessageLookupByLibrary.simpleMessage(
            "You must verify your identity in order for us to make our platform safe, trustworthy and to comply with KYC requirements."),
        "verify_profile":
            MessageLookupByLibrary.simpleMessage("Verify Profile"),
        "verify_your_email":
            MessageLookupByLibrary.simpleMessage("Verify your email"),
        "verify_your_identity":
            MessageLookupByLibrary.simpleMessage("Verify Your Identity"),
        "video_too_short":
            MessageLookupByLibrary.simpleMessage("Oops! Video too short."),
        "view_all_transactions":
            MessageLookupByLibrary.simpleMessage("View All Transactions"),
        "view_on": MessageLookupByLibrary.simpleMessage("View on"),
        "visible_accept_bookings": MessageLookupByLibrary.simpleMessage(
            "Call link will be visible and can accept bookings."),
        "wallet": MessageLookupByLibrary.simpleMessage("Wallet"),
        "wallet_powered_by_torus": MessageLookupByLibrary.simpleMessage(
            "Your wallet is powered by Torus decentralized non-custodial PKI infrastructure."),
        "we_are_processing_order": MessageLookupByLibrary.simpleMessage(
            "We are processing your order"),
        "weak_password":
            MessageLookupByLibrary.simpleMessage("Password is too weak"),
        "webbook_shared_secret":
            MessageLookupByLibrary.simpleMessage("Webhook Shared Secret"),
        "wednesday": MessageLookupByLibrary.simpleMessage("Wed"),
        "with_ftx_pay": MessageLookupByLibrary.simpleMessage("with FTX Pay"),
        "with_ramp": MessageLookupByLibrary.simpleMessage("with RAMP"),
        "with_transak": MessageLookupByLibrary.simpleMessage("with Transak"),
        "would_sign_in_different_email": MessageLookupByLibrary.simpleMessage(
            "Would you like to sign in with a different email?"),
        "wrong_password": MessageLookupByLibrary.simpleMessage(
            "Invalid username or password"),
        "yes": MessageLookupByLibrary.simpleMessage("Yes"),
        "you_are_scheduled_with":
            MessageLookupByLibrary.simpleMessage("You are scheduled with"),
        "you_can_manage_api_key_coinbase": MessageLookupByLibrary.simpleMessage(
            "You can manage your API keys within the Coinbase Commerce Settings page. available here"),
        "you_have_no_event":
            MessageLookupByLibrary.simpleMessage("You have no events"),
        "you_receive": MessageLookupByLibrary.simpleMessage("You receive"),
        "your": MessageLookupByLibrary.simpleMessage("Your"),
        "your_call_link":
            MessageLookupByLibrary.simpleMessage("your call link"),
        "your_coinbase_account": MessageLookupByLibrary.simpleMessage(
            "Your coinbase account is connected"),
        "your_contribution_accepted_proccessing":
            MessageLookupByLibrary.simpleMessage(
                "Your contribution has been accepted and we are now processing it."),
        "your_email": MessageLookupByLibrary.simpleMessage("Your Email"),
        "your_stripe_account_is_connected":
            MessageLookupByLibrary.simpleMessage(
                "Your stripe account is connected"),
        "your_tokens_will_appear_to_make_payment":
            MessageLookupByLibrary.simpleMessage(
                "Your tokens will appear here to make payment")
      };
}
