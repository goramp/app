// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ja locale. All the
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
  String get localeName => 'ja';

  static String m0(email) => "Click the link we sent to ${email} to continue";

  static String m1(token) => "入金する: ${token}";

  static String m2(token) =>
      "トランザクション手数料の支払いに必要な${token}が不足しています。入金してから再度お試しください。";

  static String m3(fees, token) =>
      "ネットワーク料金${fees}の残高不足です。${token}アカウントに入金してください。";

  static String m4(time) => "RE-SEND IN ${time}";

  static String m5(token) => "${token} はトランザクションの支払いに使用されます。";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "accept_crypto_payment":
            MessageLookupByLibrary.simpleMessage("暗号資産支払いを受け付ける"),
        "accept_nft_timepass":
            MessageLookupByLibrary.simpleMessage("NFTタイムパスを受け付ける"),
        "accept_payment_stripe":
            MessageLookupByLibrary.simpleMessage("Stripeのカード支払いを受け付ける"),
        "accept_terms_error_confirmation": MessageLookupByLibrary.simpleMessage(
            "Please confirm your age and agree with Kurobi Terms of Service"),
        "account_already_exist":
            MessageLookupByLibrary.simpleMessage("同じメールアドレスのアカウントがすでに存在します。"),
        "account_disabled": MessageLookupByLibrary.simpleMessage("アカウントが無効です。"),
        "account_does_not_exist": MessageLookupByLibrary.simpleMessage(
            "We couldn\'t find an account with that email"),
        "account_exists": MessageLookupByLibrary.simpleMessage("アカウントが存在します"),
        "account_id": MessageLookupByLibrary.simpleMessage("アカウントID"),
        "account_with_email_exists": MessageLookupByLibrary.simpleMessage(
            "An account with this email already exists"),
        "add_a_payment_provider":
            MessageLookupByLibrary.simpleMessage("Stripe等の決済プロバイダーを追加してください"),
        "add_card": MessageLookupByLibrary.simpleMessage("カードを追加"),
        "add_details": MessageLookupByLibrary.simpleMessage("詳細を追加"),
        "add_funds": MessageLookupByLibrary.simpleMessage("資金を追加"),
        "add_interval": MessageLookupByLibrary.simpleMessage("休止時間を追加"),
        "add_notes": MessageLookupByLibrary.simpleMessage("メモを追加"),
        "add_payment_method": MessageLookupByLibrary.simpleMessage("決済方法を追加"),
        "add_payment_provider":
            MessageLookupByLibrary.simpleMessage("決済プロバイダーを追加"),
        "add_price": MessageLookupByLibrary.simpleMessage("価格を追加"),
        "add_this_on_phone_record_watch": MessageLookupByLibrary.simpleMessage(
            "端末に追加し、一緒にビデオを録画および視聴できるようにします"),
        "add_this_to_phone_watch_record": MessageLookupByLibrary.simpleMessage(
            "端末に追加し、一緒にビデオ視聴および録画をできるようにします"),
        "add_your_rescheduling":
            MessageLookupByLibrary.simpleMessage("スケジュール変更とキャンセルのポリシーを追加します。"),
        "address": MessageLookupByLibrary.simpleMessage("住所"),
        "age_too_low": MessageLookupByLibrary.simpleMessage(
            "You don\'t meet the age requirement."),
        "all_signin_options":
            MessageLookupByLibrary.simpleMessage("すべてのサインインオプションを表示"),
        "allow_access_camera":
            MessageLookupByLibrary.simpleMessage("カメラへのアクセスを許可"),
        "allow_access_microphone":
            MessageLookupByLibrary.simpleMessage("マイクへのアクセスを許可"),
        "almost_there": MessageLookupByLibrary.simpleMessage("もうすぐです！"),
        "amount": MessageLookupByLibrary.simpleMessage("総額"),
        "ampm": MessageLookupByLibrary.simpleMessage("AM/PM"),
        "an_account_already_exists": MessageLookupByLibrary.simpleMessage(
            "An account already exists with a different credentials."),
        "an_error_occurred":
            MessageLookupByLibrary.simpleMessage("エラーが発生しました。 もう一度やり直してください"),
        "and": MessageLookupByLibrary.simpleMessage("と"),
        "api_key": MessageLookupByLibrary.simpleMessage("APIキー"),
        "apologies_something_went_wrong":
            MessageLookupByLibrary.simpleMessage("申し訳ありませんが、問題が発生しました。"),
        "are_you_sure_cancel_payment":
            MessageLookupByLibrary.simpleMessage("本当に支払いをキャンセルしますか？"),
        "are_you_sure_delete_card":
            MessageLookupByLibrary.simpleMessage("このカードを削除しますか"),
        "availablity": MessageLookupByLibrary.simpleMessage("可能時間"),
        "balance": MessageLookupByLibrary.simpleMessage("バランス"),
        "base_commission_rate":
            MessageLookupByLibrary.simpleMessage("基本コミッション率"),
        "bio": MessageLookupByLibrary.simpleMessage("プロフィール"),
        "birthday": MessageLookupByLibrary.simpleMessage("誕生日"),
        "book": MessageLookupByLibrary.simpleMessage("予約"),
        "booking_confirmed": MessageLookupByLibrary.simpleMessage("予約確認済み"),
        "buy": MessageLookupByLibrary.simpleMessage("購入"),
        "buy_now": MessageLookupByLibrary.simpleMessage("今すぐ購入"),
        "call_link": MessageLookupByLibrary.simpleMessage("通話リンク"),
        "call_link_accept_new_booking":
            MessageLookupByLibrary.simpleMessage("通話リンクは新規予約を受け付けていません"),
        "call_link_can_accept_booking":
            MessageLookupByLibrary.simpleMessage("通話リンクは予約受付が可能です"),
        "call_link_live":
            MessageLookupByLibrary.simpleMessage("通話リンクは有効になり、予約受付を開始します"),
        "call_link_not_visible":
            MessageLookupByLibrary.simpleMessage("通話リンクは表示されず、予約を受け付けません。"),
        "call_links": MessageLookupByLibrary.simpleMessage("Call Links"),
        "camera": MessageLookupByLibrary.simpleMessage("カメラ"),
        "cancel": MessageLookupByLibrary.simpleMessage("キャンセル"),
        "cancel_callback":
            MessageLookupByLibrary.simpleMessage("通話リンクをキャンセルしますか？"),
        "cancel_payment": MessageLookupByLibrary.simpleMessage("支払いをキャンセルする"),
        "canceled": MessageLookupByLibrary.simpleMessage("キャンセルしました"),
        "canceling": MessageLookupByLibrary.simpleMessage("キャンセルしています"),
        "cant_validate_address":
            MessageLookupByLibrary.simpleMessage("Can\'t validate address"),
        "cards": MessageLookupByLibrary.simpleMessage("カード"),
        "change": MessageLookupByLibrary.simpleMessage("変更"),
        "character_less_than_255": MessageLookupByLibrary.simpleMessage(
            "Make sure to use less than 255 characters"),
        "check_your_inbox":
            MessageLookupByLibrary.simpleMessage("受信ボックスを確認してください"),
        "checkout": MessageLookupByLibrary.simpleMessage("お支払い"),
        "choose_cover_photo": MessageLookupByLibrary.simpleMessage("カバー写真を選択"),
        "claim_now": MessageLookupByLibrary.simpleMessage("今すぐ請求"),
        "clear": MessageLookupByLibrary.simpleMessage("クリア"),
        "click_add_on_endpoint": MessageLookupByLibrary.simpleMessage(
            "2. \"Add an endpoin\"をクリックして、次のURLを貼り付けてください。"),
        "click_link_sent": m0,
        "close": MessageLookupByLibrary.simpleMessage("閉じる"),
        "closed": MessageLookupByLibrary.simpleMessage("Closed"),
        "code_expired": MessageLookupByLibrary.simpleMessage("Code expired"),
        "code_is_number": MessageLookupByLibrary.simpleMessage(
            "Code must be a 6 digit number"),
        "code_not_found":
            MessageLookupByLibrary.simpleMessage("Code not found"),
        "code_required": MessageLookupByLibrary.simpleMessage("Code required"),
        "coinbase_commerce_before":
            MessageLookupByLibrary.simpleMessage("価格設定前にコインベース・コマースへ。"),
        "coinbase_commerce_setting": MessageLookupByLibrary.simpleMessage(
            "1. コインベース・コマース設定ページで、\"Webhook subscriptions\"セクションまでスクロールしてください。"),
        "collect_payment": MessageLookupByLibrary.simpleMessage("支払い"),
        "collect_payment_card_apple_google_pay":
            MessageLookupByLibrary.simpleMessage(
                "カード、Apple Pay、GooglePayで支払う。"),
        "collect_payment_sol_usd_kuro":
            MessageLookupByLibrary.simpleMessage("KURO、USDC、USDT、SOLで支払う"),
        "complete_your_profile":
            MessageLookupByLibrary.simpleMessage("プロフィールを完成"),
        "confirm": MessageLookupByLibrary.simpleMessage("確認"),
        "confirm_age_terms": MessageLookupByLibrary.simpleMessage(
            "I confirm that I am 18 years of age or older and agree with"),
        "confirm_password": MessageLookupByLibrary.simpleMessage("パスワードを確認する"),
        "confirm_password_is_required": MessageLookupByLibrary.simpleMessage(
            "Confirm password is required"),
        "confirmed": MessageLookupByLibrary.simpleMessage("確認されました"),
        "connect": MessageLookupByLibrary.simpleMessage("接続"),
        "connect_bank_earn": MessageLookupByLibrary.simpleMessage("銀行へ接続"),
        "connect_coinbase":
            MessageLookupByLibrary.simpleMessage("コインベース・コマースを接続"),
        "connect_solana_wallet":
            MessageLookupByLibrary.simpleMessage("Solanaウォレットを接続"),
        "connect_wallet_earn": MessageLookupByLibrary.simpleMessage("ウォレットに接続"),
        "connect_your_stripe_account":
            MessageLookupByLibrary.simpleMessage("Stripeアカウントに接続"),
        "connect_your_wallet": MessageLookupByLibrary.simpleMessage("ウォレットを接続"),
        "connecting": MessageLookupByLibrary.simpleMessage("接続中"),
        "connection_error": MessageLookupByLibrary.simpleMessage("接続エラー！"),
        "content_violates_policy": MessageLookupByLibrary.simpleMessage(
            "この動画はポリシーに違反するコンテンツが含まれている可能性があります。 間違いの場合は動画アップロード時に手動レビューをリクエストしてください。"),
        "continue_apple": MessageLookupByLibrary.simpleMessage("Appleで続行"),
        "continue_email": MessageLookupByLibrary.simpleMessage("メールで続行"),
        "continue_facebook":
            MessageLookupByLibrary.simpleMessage("Facebookで続行"),
        "continue_google": MessageLookupByLibrary.simpleMessage("Googleで続行"),
        "continue_string": MessageLookupByLibrary.simpleMessage("続ける"),
        "continue_twitter": MessageLookupByLibrary.simpleMessage("Twitterで続行"),
        "contribute": MessageLookupByLibrary.simpleMessage("拠出"),
        "copied": MessageLookupByLibrary.simpleMessage("コピーされました"),
        "copied_to_clipboard":
            MessageLookupByLibrary.simpleMessage("クリップボードにコピーされました"),
        "copy_address": MessageLookupByLibrary.simpleMessage("住所をコピーするs"),
        "copy_link": MessageLookupByLibrary.simpleMessage("リンクをコピー"),
        "could_not_open_mail_app":
            MessageLookupByLibrary.simpleMessage("メールアプリを開けません"),
        "country": MessageLookupByLibrary.simpleMessage("国"),
        "create": MessageLookupByLibrary.simpleMessage("作成"),
        "create_a_call_lin": MessageLookupByLibrary.simpleMessage(
            "通話リンクを作成して、1：1通話の受け付けまたはスケジュールを開始"),
        "create_a_calllink_receive":
            MessageLookupByLibrary.simpleMessage("通話リンクを作成して受け付けを開始"),
        "create_a_title": MessageLookupByLibrary.simpleMessage("タイトルを作成"),
        "create_account": MessageLookupByLibrary.simpleMessage("アカウントを作成"),
        "create_new_account":
            MessageLookupByLibrary.simpleMessage("新しいアカウントを作成"),
        "create_title": MessageLookupByLibrary.simpleMessage("タイトルを作成"),
        "current_price": MessageLookupByLibrary.simpleMessage("現在の価格"),
        "data_not_stored": MessageLookupByLibrary.simpleMessage("データは保存されません"),
        "date": MessageLookupByLibrary.simpleMessage("日付"),
        "days": MessageLookupByLibrary.simpleMessage("日"),
        "default_error_title":
            MessageLookupByLibrary.simpleMessage("もう一度やり直してください。"),
        "default_error_title2":
            MessageLookupByLibrary.simpleMessage("何かが正しくないようです。確認しています..."),
        "delete": MessageLookupByLibrary.simpleMessage("削除"),
        "delete_calllink":
            MessageLookupByLibrary.simpleMessage("通話リンクを削除しますか？"),
        "deposit": MessageLookupByLibrary.simpleMessage("入金"),
        "deposit_fund_on_ftx_account": MessageLookupByLibrary.simpleMessage(
            "FTXアカウントから入金します。複数のブロックチェーン、クレジットカードなどで暗号資産を使用して資金を追加できます"),
        "deposit_token": m1,
        "destination_address": MessageLookupByLibrary.simpleMessage("宛先アドレス"),
        "details": MessageLookupByLibrary.simpleMessage("詳細"),
        "dialog_positive_default": MessageLookupByLibrary.simpleMessage("OK"),
        "didnt_recognize_email":
            MessageLookupByLibrary.simpleMessage("メールが確認できません"),
        "discard": MessageLookupByLibrary.simpleMessage("破棄"),
        "discard_call_link":
            MessageLookupByLibrary.simpleMessage("通話リンクを破棄しますか？"),
        "discard_video_changes":
            MessageLookupByLibrary.simpleMessage("ビデオとすべての変更が破棄されます。"),
        "disconnect": MessageLookupByLibrary.simpleMessage("切断"),
        "disconnect_coinbase":
            MessageLookupByLibrary.simpleMessage("コインベース・コマースを切断しますか？"),
        "disconnect_stripe":
            MessageLookupByLibrary.simpleMessage("Stripeを切断しますか？"),
        "discount": MessageLookupByLibrary.simpleMessage("割引"),
        "dismiss": MessageLookupByLibrary.simpleMessage("消す"),
        "done": MessageLookupByLibrary.simpleMessage("完了"),
        "dont_have_an_account":
            MessageLookupByLibrary.simpleMessage("アカウントをお持ちではありませんか？"),
        "dst_ady_mint_dont_match": MessageLookupByLibrary.simpleMessage(
            "Destination address mint does not match"),
        "duration": MessageLookupByLibrary.simpleMessage("持続時間"),
        "edit": MessageLookupByLibrary.simpleMessage("編集"),
        "edit_call_link": MessageLookupByLibrary.simpleMessage("通話リンクの編集"),
        "edit_profile": MessageLookupByLibrary.simpleMessage("プロフィールの編集"),
        "email": MessageLookupByLibrary.simpleMessage("Eメール"),
        "email_already_exists":
            MessageLookupByLibrary.simpleMessage("Email already exists"),
        "email_associated_with_account": MessageLookupByLibrary.simpleMessage(
            "アカウントに紐づくメールアドレスを入力してください。受信トレイに魔法のリンクを送信します。"),
        "email_immutable":
            MessageLookupByLibrary.simpleMessage("Email can\'t change"),
        "email_invalid":
            MessageLookupByLibrary.simpleMessage("Email is not valid"),
        "email_link_reset_password": MessageLookupByLibrary.simpleMessage(
            "パスワード・リセットのリンクを受け取るためのメールアドレスを入力してください。"),
        "email_required":
            MessageLookupByLibrary.simpleMessage("Email required"),
        "email_verified": MessageLookupByLibrary.simpleMessage("メールが確認されました"),
        "end_cant_be_before_start":
            MessageLookupByLibrary.simpleMessage("終了時刻は開始時刻より前にはできません"),
        "ended": MessageLookupByLibrary.simpleMessage("終了しました"),
        "ending": MessageLookupByLibrary.simpleMessage("終了しています"),
        "ends": MessageLookupByLibrary.simpleMessage("終了"),
        "enter": MessageLookupByLibrary.simpleMessage("入力"),
        "enter_a_price": MessageLookupByLibrary.simpleMessage("価格を入力してください"),
        "enter_email_address":
            MessageLookupByLibrary.simpleMessage("Enter your email address"),
        "enter_email_create_account":
            MessageLookupByLibrary.simpleMessage("メールアドレスを入力してアカウントを作成してください。"),
        "enter_valid_email":
            MessageLookupByLibrary.simpleMessage("有効なメールアドレスを入力してください"),
        "error": MessageLookupByLibrary.simpleMessage("エラー"),
        "estimated": MessageLookupByLibrary.simpleMessage("推定"),
        "example_com": MessageLookupByLibrary.simpleMessage("name@example.com"),
        "exceeded_maximum_amount":
            MessageLookupByLibrary.simpleMessage("最大値を超えました:"),
        "exceeded_remaining_amount":
            MessageLookupByLibrary.simpleMessage("残額を超えました:"),
        "expired": MessageLookupByLibrary.simpleMessage("期限切れ"),
        "expiry": MessageLookupByLibrary.simpleMessage("有効期限"),
        "external": MessageLookupByLibrary.simpleMessage("外部"),
        "fail_fetch_call_link":
            MessageLookupByLibrary.simpleMessage("通話リンクを取得できませんでした"),
        "fail_fetch_card":
            MessageLookupByLibrary.simpleMessage("カードを取得できませんでした"),
        "fail_to_fetch_tokens":
            MessageLookupByLibrary.simpleMessage("トークンを取得できませんでした"),
        "failed": MessageLookupByLibrary.simpleMessage("失敗しました"),
        "failed_fetch_transactions":
            MessageLookupByLibrary.simpleMessage("トランザクションの取得に失敗しました"),
        "failed_fetch_wallet":
            MessageLookupByLibrary.simpleMessage("ウォレットの詳細を取得できませんでした"),
        "failed_to_fetch": MessageLookupByLibrary.simpleMessage("取得できませんでした"),
        "failed_to_fetch_card":
            MessageLookupByLibrary.simpleMessage("Failed to fetch card"),
        "failed_to_fetch_cards":
            MessageLookupByLibrary.simpleMessage("Failed to fetch cards..."),
        "failed_to_fetch_event_details":
            MessageLookupByLibrary.simpleMessage("イベント詳細を取得できませんでした。"),
        "failed_to_fetch_payment_method":
            MessageLookupByLibrary.simpleMessage("支払い方法を取得できませんでした"),
        "failed_to_fetch_profile":
            MessageLookupByLibrary.simpleMessage("Failed to fetch profile"),
        "failed_to_fetch_schedules":
            MessageLookupByLibrary.simpleMessage("スケジュールを取得できませんでした。"),
        "failed_to_fetch_transaction":
            MessageLookupByLibrary.simpleMessage("Failed to fetch transaction"),
        "failed_to_load_payment_method":
            MessageLookupByLibrary.simpleMessage("支払い方法を読み込めませんでした"),
        "failed_to_load_profile":
            MessageLookupByLibrary.simpleMessage("プロフィールを読み込めませんでした"),
        "failed_to_send_confirmation_link":
            MessageLookupByLibrary.simpleMessage(
                "Failed to re-send confimation link, please try again."),
        "fee": MessageLookupByLibrary.simpleMessage("手数料"),
        "feedback": MessageLookupByLibrary.simpleMessage("フィードバック"),
        "fetching_card": MessageLookupByLibrary.simpleMessage("カードを取得"),
        "fetching_cards":
            MessageLookupByLibrary.simpleMessage("Fetching cards..."),
        "fetching_payments": MessageLookupByLibrary.simpleMessage("支払い方法を取得"),
        "fetching_token": MessageLookupByLibrary.simpleMessage("トークンを取得"),
        "fetching_transactions":
            MessageLookupByLibrary.simpleMessage("トランザクションを取得"),
        "finish_creating_account":
            MessageLookupByLibrary.simpleMessage("アカウントの作成を完了し、本格的な体験が可能に。"),
        "first_name": MessageLookupByLibrary.simpleMessage("First Name"),
        "first_name_required":
            MessageLookupByLibrary.simpleMessage("First name required"),
        "forgot_password":
            MessageLookupByLibrary.simpleMessage("パスワードをお忘れですか？"),
        "free": MessageLookupByLibrary.simpleMessage("無料"),
        "friday": MessageLookupByLibrary.simpleMessage("金曜日"),
        "friend_recieve": MessageLookupByLibrary.simpleMessage("友達が受け取る"),
        "friends_commission_kickback_rate":
            MessageLookupByLibrary.simpleMessage("友達のコミッションキックバック率を設定"),
        "from": MessageLookupByLibrary.simpleMessage("から"),
        "full_name": MessageLookupByLibrary.simpleMessage("フルネーム"),
        "generate_your_link": MessageLookupByLibrary.simpleMessage("リンクを生成"),
        "generating_preview": MessageLookupByLibrary.simpleMessage("プレビューの生成"),
        "get_credit": MessageLookupByLibrary.simpleMessage("クレジットを取得"),
        "get_started": MessageLookupByLibrary.simpleMessage("始める"),
        "grant_access":
            MessageLookupByLibrary.simpleMessage("NFTタイムパスをチケットとして使用してアクセスを許可"),
        "grant_camera_access_record":
            MessageLookupByLibrary.simpleMessage("録画用カメラのアクセスを許可"),
        "group": MessageLookupByLibrary.simpleMessage("Group"),
        "group_sub_title": MessageLookupByLibrary.simpleMessage(
            "Stream to multiple guests at a particular time"),
        "guest": MessageLookupByLibrary.simpleMessage("ゲスト"),
        "helloWorld": MessageLookupByLibrary.simpleMessage("こんにちは"),
        "hey": MessageLookupByLibrary.simpleMessage("やあ"),
        "host": MessageLookupByLibrary.simpleMessage("ホスト"),
        "hours": MessageLookupByLibrary.simpleMessage("時間"),
        "i_m_avaliable": MessageLookupByLibrary.simpleMessage("利用可能"),
        "identity_verified": MessageLookupByLibrary.simpleMessage("本人確認済み"),
        "in_order_accept_bitcoin_etherum": MessageLookupByLibrary.simpleMessage(
            "ビットコイン、イーサリアム、DAI、ライトコイン、ビットコインキャッシュ、USDコイン受け取りにはコインベース・コマースのアカウントを紐づける必要があります。"),
        "in_order_accept_kurobi_solona_usd":
            MessageLookupByLibrary.simpleMessage(
                "kurobi、USDコイン、Solana受け取りにはsolanaウォレットを紐づける必要があります。"),
        "in_order_connect_card_payment": MessageLookupByLibrary.simpleMessage(
            "カード決済にはストライプアカウントを接続する必要があります。 ストライプアカウントを持っていない場合はアカウント作成ページに遷移します。"),
        "inappropriate_content":
            MessageLookupByLibrary.simpleMessage("不適切なコンテンツ"),
        "insufficient_funds": MessageLookupByLibrary.simpleMessage("残高不足"),
        "insufficient_sol_for_fees": m2,
        "insufficient_wallet_balance": m3,
        "interval_overlapping":
            MessageLookupByLibrary.simpleMessage("休止時間が重なっています"),
        "intervals_must_be": MessageLookupByLibrary.simpleMessage("最小休止時間："),
        "intro": MessageLookupByLibrary.simpleMessage(
            "顧客と1対1のビデオ通話をホストし、あなたの時間に対して支払いを受けます"),
        "intro_audience":
            MessageLookupByLibrary.simpleMessage("顧客と1対1のビデオ通話をホストする"),
        "intro_followers":
            MessageLookupByLibrary.simpleMessage("フォロワーと1対1のビデオ通話をホストする"),
        "intro_paid_for_time":
            MessageLookupByLibrary.simpleMessage("そしてあなたの時間に対して支払いを受ける"),
        "invalid_address": MessageLookupByLibrary.simpleMessage("無効なアドレス"),
        "invalid_amount": MessageLookupByLibrary.simpleMessage("無効な金額"),
        "invalid_email_or_password": MessageLookupByLibrary.simpleMessage(
            "Invalid email or password provided"),
        "invalid_expired_action_code":
            MessageLookupByLibrary.simpleMessage("無効または期限切れのアクションコード。"),
        "invalid_expired_code": MessageLookupByLibrary.simpleMessage(
            "無効または期限切れのコード。 メールアドレスをもう一度確認してください。"),
        "invalid_price": MessageLookupByLibrary.simpleMessage("価格が無効です"),
        "invalid_verification_code":
            MessageLookupByLibrary.simpleMessage("Invalid verification code"),
        "invite_friends": MessageLookupByLibrary.simpleMessage("友達を招待"),
        "item_description": MessageLookupByLibrary.simpleMessage("アイテム説明"),
        "item_name": MessageLookupByLibrary.simpleMessage("項目名"),
        "join_call": MessageLookupByLibrary.simpleMessage("通話に参加"),
        "kuro_claimed_see_wallet":
            MessageLookupByLibrary.simpleMessage("あなたのKUROが獲得され、ウォレットに入りました。"),
        "kuro_will_distributed_sales_end":
            MessageLookupByLibrary.simpleMessage("販売終了後にKUROは自動的に配布されます。"),
        "last_name": MessageLookupByLibrary.simpleMessage("Last Name"),
        "last_name_required":
            MessageLookupByLibrary.simpleMessage("Last name required"),
        "learn_more": MessageLookupByLibrary.simpleMessage("もっと詳しく"),
        "likes": MessageLookupByLibrary.simpleMessage("Likes"),
        "log_in": MessageLookupByLibrary.simpleMessage("ログイン"),
        "log_in_different_user":
            MessageLookupByLibrary.simpleMessage("別のユーザーとしてログイン"),
        "log_out": MessageLookupByLibrary.simpleMessage("ログアウト"),
        "log_out_of": MessageLookupByLibrary.simpleMessage("ログアウト:"),
        "login_to_kurobi":
            MessageLookupByLibrary.simpleMessage("Log in to Kurobi"),
        "login_unauthorized": MessageLookupByLibrary.simpleMessage(
            "おっと！ ユーザー名/メールアドレスまたはパスワードが正しくありません"),
        "login_view_liked_calls":
            MessageLookupByLibrary.simpleMessage("ログインしてお気に入りの通話リンクを表示します"),
        "login_with_email":
            MessageLookupByLibrary.simpleMessage("Login with email"),
        "low_sol_balance":
            MessageLookupByLibrary.simpleMessage("注意: SOLの残高が不足しています "),
        "low_sol_balance_info": MessageLookupByLibrary.simpleMessage(
            "ソラナのネットワーク手数料にはSOLが必要です。トランザクション失敗を防ぐために0.05SOLの最低残高を推奨します。"),
        "max": MessageLookupByLibrary.simpleMessage("最大"),
        "max_cards_reached": MessageLookupByLibrary.simpleMessage(
            "You have reached the maximum number of cards. Please remove or update an existing card"),
        "maximum": MessageLookupByLibrary.simpleMessage("最大で"),
        "maximum_number_card": MessageLookupByLibrary.simpleMessage(
            "カードの最大数に達しました。 既存のカードを削除または更新してください"),
        "me": MessageLookupByLibrary.simpleMessage("自分"),
        "min_password_chars": MessageLookupByLibrary.simpleMessage(
            "Make sure to enter at least 8 characters"),
        "min_username_chars": MessageLookupByLibrary.simpleMessage(
            "Make sure to enter at least 3 characters"),
        "minimum": MessageLookupByLibrary.simpleMessage("最小"),
        "minimum_contribution_of":
            MessageLookupByLibrary.simpleMessage("最低拠出額:"),
        "mins": MessageLookupByLibrary.simpleMessage("分"),
        "minutes": MessageLookupByLibrary.simpleMessage("分"),
        "monday": MessageLookupByLibrary.simpleMessage("月曜日"),
        "monetize_your_time": MessageLookupByLibrary.simpleMessage("自分の時間を収益化"),
        "name": MessageLookupByLibrary.simpleMessage("名前"),
        "name_invalid": MessageLookupByLibrary.simpleMessage(
            "First name or last name is not valid"),
        "new_call_link": MessageLookupByLibrary.simpleMessage("新しい通話リンク"),
        "new_password": MessageLookupByLibrary.simpleMessage("新しいパスワード"),
        "next": MessageLookupByLibrary.simpleMessage("次"),
        "no": MessageLookupByLibrary.simpleMessage("番号"),
        "no_cards": MessageLookupByLibrary.simpleMessage("No Cards"),
        "no_likes_here": MessageLookupByLibrary.simpleMessage("お気に入りはありません"),
        "no_payment": MessageLookupByLibrary.simpleMessage("支払いはありません"),
        "no_result_found": MessageLookupByLibrary.simpleMessage("結果が見つかりません"),
        "no_title": MessageLookupByLibrary.simpleMessage("タイトルなし"),
        "no_tokens": MessageLookupByLibrary.simpleMessage("トークンなし"),
        "no_transactions": MessageLookupByLibrary.simpleMessage("トランザクションなし"),
        "no_upcoming_event":
            MessageLookupByLibrary.simpleMessage("今後の予定はありません"),
        "not_like_any_call_link":
            MessageLookupByLibrary.simpleMessage("お気に入りされた通話リンクはありません："),
        "notes": MessageLookupByLibrary.simpleMessage("メモ"),
        "nothing_here": MessageLookupByLibrary.simpleMessage("なし"),
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "one_on_one": MessageLookupByLibrary.simpleMessage("One-on-One"),
        "one_on_one_sub_title": MessageLookupByLibrary.simpleMessage(
            "Let one guest book a time with you."),
        "open_mail_app": MessageLookupByLibrary.simpleMessage("メールアプリを開く"),
        "or": MessageLookupByLibrary.simpleMessage("または"),
        "or_drag_drop_file":
            MessageLookupByLibrary.simpleMessage("またはファイルをドラッグアンドドロップします"),
        "order_canceled": MessageLookupByLibrary.simpleMessage("注文がキャンセルされました"),
        "passes": MessageLookupByLibrary.simpleMessage("パス"),
        "password": MessageLookupByLibrary.simpleMessage("パスワード"),
        "password_invalid": MessageLookupByLibrary.simpleMessage(
            "At least 8 characters and should include letters, numbers, and special characters"),
        "password_required": MessageLookupByLibrary.simpleMessage("パスワードが必要です"),
        "password_reset_request": MessageLookupByLibrary.simpleMessage(
            "Password reset request sent successfully"),
        "sell": MessageLookupByLibrary.simpleMessage("過去"),
        "pay": MessageLookupByLibrary.simpleMessage("支払い"),
        "pay_with_crypto": MessageLookupByLibrary.simpleMessage("暗号資産で支払う"),
        "pay_with_crypto_wallet":
            MessageLookupByLibrary.simpleMessage("暗号資産ウォレットで支払う"),
        "payment_terms": MessageLookupByLibrary.simpleMessage("支払い条件"),
        "payments": MessageLookupByLibrary.simpleMessage("支払い"),
        "payout": MessageLookupByLibrary.simpleMessage("支払い"),
        "payout_now": MessageLookupByLibrary.simpleMessage("今すぐ支払い"),
        "payout_onboarding_description": MessageLookupByLibrary.simpleMessage(
            "ゲストが予約した時点で暗号資産または現金で決済されるため無断キャンセルを減らすことができます。"),
        "pending": MessageLookupByLibrary.simpleMessage("pending"),
        "pending_balance": MessageLookupByLibrary.simpleMessage("保留中の残高"),
        "phone_number_exists":
            MessageLookupByLibrary.simpleMessage("Phone number already exists"),
        "photo_librar": MessageLookupByLibrary.simpleMessage("フォトライブラリ"),
        "photos": MessageLookupByLibrary.simpleMessage("写真"),
        "please_check_your_connection": MessageLookupByLibrary.simpleMessage(
            "Please check your connection"),
        "please_enter_new_password":
            MessageLookupByLibrary.simpleMessage("新しいパスワードを入力してください。"),
        "powered_by": MessageLookupByLibrary.simpleMessage("搭載："),
        "preparing": MessageLookupByLibrary.simpleMessage("準備中"),
        "preview": MessageLookupByLibrary.simpleMessage("プレビュー"),
        "price": MessageLookupByLibrary.simpleMessage("価格"),
        "privacy_policy": MessageLookupByLibrary.simpleMessage("プライバシーポリシー"),
        "processing": MessageLookupByLibrary.simpleMessage("処理中"),
        "processing_video": MessageLookupByLibrary.simpleMessage("ビデオの処理中"),
        "product": MessageLookupByLibrary.simpleMessage("製品"),
        "profile_not_found":
            MessageLookupByLibrary.simpleMessage("プロフィールが見つかりません"),
        "provide_email_for_confirmation":
            MessageLookupByLibrary.simpleMessage("確認のためメールアドレスを入力してください。"),
        "publish": MessageLookupByLibrary.simpleMessage("公開"),
        "publish_call_link": MessageLookupByLibrary.simpleMessage("通話リンクを公開"),
        "published": MessageLookupByLibrary.simpleMessage("公開済み"),
        "qr_code": MessageLookupByLibrary.simpleMessage("QRコード"),
        "ramp_allows_you_to_buy_cryto": MessageLookupByLibrary.simpleMessage(
            "Rampで170か国以上でApple Pay、Google Pay、クレジットカード、銀行振込で暗号資産を購入できます。"),
        "re_schedule": MessageLookupByLibrary.simpleMessage("スケジュールを変更"),
        "receive": MessageLookupByLibrary.simpleMessage("受け取る"),
        "home": MessageLookupByLibrary.simpleMessage("最近"),
        "record_video": MessageLookupByLibrary.simpleMessage("ビデオを録画"),
        "recorded": MessageLookupByLibrary.simpleMessage("録画済み"),
        "recording": MessageLookupByLibrary.simpleMessage("録画中"),
        "refreshing_the_page":
            MessageLookupByLibrary.simpleMessage("ページを更新して直るか試してみましょう"),
        "reminder": MessageLookupByLibrary.simpleMessage("リマインダー"),
        "remove": MessageLookupByLibrary.simpleMessage("削除"),
        "remove_card": MessageLookupByLibrary.simpleMessage("カードを削除"),
        "removed": MessageLookupByLibrary.simpleMessage("削除しました"),
        "report": MessageLookupByLibrary.simpleMessage("報告"),
        "required": MessageLookupByLibrary.simpleMessage("必須"),
        "resend_in": m4,
        "reservation_been_released":
            MessageLookupByLibrary.simpleMessage("予約が解除されました。"),
        "reset": MessageLookupByLibrary.simpleMessage("リセット"),
        "reset_password": MessageLookupByLibrary.simpleMessage("パスワード再設定"),
        "reset_your_password":
            MessageLookupByLibrary.simpleMessage("パスワードをリセット"),
        "restart_booking":
            MessageLookupByLibrary.simpleMessage("予約受付を再開してください。"),
        "retry": MessageLookupByLibrary.simpleMessage("再試行"),
        "saturday": MessageLookupByLibrary.simpleMessage("土曜日"),
        "save": MessageLookupByLibrary.simpleMessage("保存"),
        "scan": MessageLookupByLibrary.simpleMessage("スキャン"),
        "scan_to_call": MessageLookupByLibrary.simpleMessage("スキャンして通話"),
        "schedules": MessageLookupByLibrary.simpleMessage("スケジュール"),
        "schedules_not_been_cancelled":
            MessageLookupByLibrary.simpleMessage("キャンセルされていないスケジュール。"),
        "search": MessageLookupByLibrary.simpleMessage("検索"),
        "search_failed":
            MessageLookupByLibrary.simpleMessage("検索に失敗しました。やり直してください。"),
        "secs": MessageLookupByLibrary.simpleMessage("秒"),
        "see_all_payout": MessageLookupByLibrary.simpleMessage("すべての支払い方法を見る"),
        "select": MessageLookupByLibrary.simpleMessage("選択"),
        "select_a_date": MessageLookupByLibrary.simpleMessage("日付を選択"),
        "select_a_time": MessageLookupByLibrary.simpleMessage("時間を選択"),
        "select_a_week_day": MessageLookupByLibrary.simpleMessage("平日を選択"),
        "select_all": MessageLookupByLibrary.simpleMessage("すべて選択"),
        "select_country": MessageLookupByLibrary.simpleMessage("国を選択"),
        "select_cover": MessageLookupByLibrary.simpleMessage("カバーを選択"),
        "select_date_time": MessageLookupByLibrary.simpleMessage("日付と時間を選択"),
        "select_duration": MessageLookupByLibrary.simpleMessage("持続時間を選択"),
        "select_items": MessageLookupByLibrary.simpleMessage("アイテムを選択"),
        "select_time_interval": MessageLookupByLibrary.simpleMessage("休止時間を選択"),
        "select_timezone": MessageLookupByLibrary.simpleMessage("タイムゾーンを選択"),
        "select_video_to_upload":
            MessageLookupByLibrary.simpleMessage("アップロードするビデオを選択"),
        "selected": MessageLookupByLibrary.simpleMessage("選択済み"),
        "sell_all": MessageLookupByLibrary.simpleMessage("すべて販売"),
        "send": MessageLookupByLibrary.simpleMessage("送信"),
        "send_me_all_events": MessageLookupByLibrary.simpleMessage(
            "3.すべての支払い方法のアップデートを受け取るには必ず \"Send me all events\"を選択してください。"),
        "send_only": MessageLookupByLibrary.simpleMessage("送信のみ"),
        "sent_link_reset_password":
            MessageLookupByLibrary.simpleMessage("パスワードをリセットするためのリンクを送信しました"),
        "sent_verification_link": MessageLookupByLibrary.simpleMessage(
            "We have sent a verification link to your inbox"),
        "service_fee": MessageLookupByLibrary.simpleMessage("サービス料"),
        "service_unavailable":
            MessageLookupByLibrary.simpleMessage("サービスは利用できません"),
        "service_unavailable_region": MessageLookupByLibrary.simpleMessage(
            "このサービスは現在、お住まいの地域ではご利用いただけません"),
        "set_default": MessageLookupByLibrary.simpleMessage("デフォルトに設定"),
        "settings": MessageLookupByLibrary.simpleMessage("設定"),
        "share": MessageLookupByLibrary.simpleMessage("共有"),
        "share_to": MessageLookupByLibrary.simpleMessage("共有:"),
        "share_to_facebook":
            MessageLookupByLibrary.simpleMessage("Facebookに共有"),
        "share_to_line": MessageLookupByLibrary.simpleMessage("ラインに共有"),
        "share_to_linkedln":
            MessageLookupByLibrary.simpleMessage("LinkedInに共有"),
        "share_to_twitter": MessageLookupByLibrary.simpleMessage("Twitterで共有"),
        "share_to_whatsapp":
            MessageLookupByLibrary.simpleMessage("WhatsAppに共有"),
        "show_less": MessageLookupByLibrary.simpleMessage("表示を減らす"),
        "show_more": MessageLookupByLibrary.simpleMessage("もっと表示"),
        "show_shared_secret": MessageLookupByLibrary.simpleMessage(
            "4. \"show shared secret\"をクリックして、上のボックスに貼り付けます。"),
        "sign_in": MessageLookupByLibrary.simpleMessage("サインイン"),
        "sign_in_email": MessageLookupByLibrary.simpleMessage("メールでサインイン"),
        "sign_up": MessageLookupByLibrary.simpleMessage("Sign up"),
        "sign_up_email": MessageLookupByLibrary.simpleMessage("メールでサインアップ"),
        "sign_up_now": MessageLookupByLibrary.simpleMessage("今すぐサインアップ"),
        "sign_up_with_email":
            MessageLookupByLibrary.simpleMessage("Sign up with email"),
        "signin_agreement":
            MessageLookupByLibrary.simpleMessage("サインインで次のことに同意します："),
        "signin_different_user":
            MessageLookupByLibrary.simpleMessage("別のユーザーとしてサインイン"),
        "signin_link_expired":
            MessageLookupByLibrary.simpleMessage("サインインリンクの有効期限が切れています。"),
        "signin_link_not_valid":
            MessageLookupByLibrary.simpleMessage("サインインリンクが無効です。"),
        "signup_agreement":
            MessageLookupByLibrary.simpleMessage("サインアップで次のことに同意します:"),
        "signup_dialog_error_default_title":
            MessageLookupByLibrary.simpleMessage("もう少し！"),
        "signup_dialog_error_default_title2":
            MessageLookupByLibrary.simpleMessage("ああ！"),
        "signup_for_kurobi":
            MessageLookupByLibrary.simpleMessage("Sign Up for Kurobi"),
        "signup_invalid_email_default_error":
            MessageLookupByLibrary.simpleMessage("あなたのメールアドレスは無効です:)"),
        "signup_no_name_default_error": MessageLookupByLibrary.simpleMessage(
            "名前を追加して、友達に誰と話しているのか伝えましょう:)"),
        "signup_unique_email_default_error":
            MessageLookupByLibrary.simpleMessage("あなたのメールアドレスはすでに登録されています:)"),
        "slippage": MessageLookupByLibrary.simpleMessage("スリッページ"),
        "sol_pays_transaction_fee": m5,
        "solona_wallet_linked":
            MessageLookupByLibrary.simpleMessage("Solanaウォレットがリンクされています"),
        "something_went_wrong":
            MessageLookupByLibrary.simpleMessage("おっと！ 何かがうまく行きませんでした。"),
        "sorry_calllink_cannot_deleted":
            MessageLookupByLibrary.simpleMessage("この通話リンクは削除できません。なぜなら："),
        "sorry_calllink_ended":
            MessageLookupByLibrary.simpleMessage("この通話リンクは終了または期限切れになりました"),
        "sorry_target_contribution":
            MessageLookupByLibrary.simpleMessage("目標最大流動性支援額:"),
        "starting": MessageLookupByLibrary.simpleMessage("開始中"),
        "starts": MessageLookupByLibrary.simpleMessage("開始"),
        "savings": MessageLookupByLibrary.simpleMessage("Savings"),
        "stripe_make_sure_get_paid": MessageLookupByLibrary.simpleMessage(
            "Stripeを使用して期限内に支払いが行われるようにし、個人の銀行と詳細を安全に保ちます。"),
        "sunday": MessageLookupByLibrary.simpleMessage("日曜日"),
        "supports_bitcoin_etherum": MessageLookupByLibrary.simpleMessage(
            "ビットコイン、イーサリアム、DAI、ライトコイン、ビットコインキャッシュ、USDコインをサポートしています"),
        "supports_card_payments": MessageLookupByLibrary.simpleMessage(
            "カード決済、Apple Pay、GooglePayをサポートしています。"),
        "suscbribe_to_your_event": MessageLookupByLibrary.simpleMessage(
            "人々がイベントを予約/購読するのに都合の良い時間を選択できるように、このイベントを毎週の空き状況に追加する必要があります。"),
        "swap": MessageLookupByLibrary.simpleMessage("スワップ"),
        "swap_off_from_estimate": MessageLookupByLibrary.simpleMessage(
            "スワップの金額（パーセント単位）は見積もりから外れる可能性があります"),
        "swipe_down_create_event":
            MessageLookupByLibrary.simpleMessage("下にスワイプしてイベントを作成"),
        "terms_of_service": MessageLookupByLibrary.simpleMessage("利用規約"),
        "thank_you": MessageLookupByLibrary.simpleMessage("ありがとうございました"),
        "thank_you_participating":
            MessageLookupByLibrary.simpleMessage("ご参加いただきありがとうございます！！！"),
        "thursday": MessageLookupByLibrary.simpleMessage("木曜日"),
        "time": MessageLookupByLibrary.simpleMessage("時間"),
        "time_left": MessageLookupByLibrary.simpleMessage("残り時間"),
        "time_limit_reached":
            MessageLookupByLibrary.simpleMessage("制限時間に達しました"),
        "time_passes_appear_here":
            MessageLookupByLibrary.simpleMessage("時間の経過はここに表示されます"),
        "time_zone": MessageLookupByLibrary.simpleMessage("タイムゾーン"),
        "timepass_coming_soon":
            MessageLookupByLibrary.simpleMessage("タイムパスはもうすぐ登場"),
        "title": MessageLookupByLibrary.simpleMessage("タイトル"),
        "to": MessageLookupByLibrary.simpleMessage("まで"),
        "to_complete_setup":
            MessageLookupByLibrary.simpleMessage("アカウントの設定を完了"),
        "to_contribute": MessageLookupByLibrary.simpleMessage("拠出"),
        "to_sigin_in": MessageLookupByLibrary.simpleMessage("サインイン"),
        "to_this_addres_any_digital_asset_loss":
            MessageLookupByLibrary.simpleMessage(
                "このアドレスへ。 他のデジタル資産を送信すると永久的な損失が発生します"),
        "tokens": MessageLookupByLibrary.simpleMessage("トークン"),
        "tolerance": MessageLookupByLibrary.simpleMessage("許容範囲"),
        "top_up": MessageLookupByLibrary.simpleMessage("補充"),
        "total": MessageLookupByLibrary.simpleMessage("合計"),
        "trade": MessageLookupByLibrary.simpleMessage("トレード"),
        "transaction_confirmed":
            MessageLookupByLibrary.simpleMessage("トランザクションが確認されました"),
        "transaction_id": MessageLookupByLibrary.simpleMessage("トランザクションID"),
        "transaction_signature":
            MessageLookupByLibrary.simpleMessage("トランザクション署名"),
        "transaction_successful":
            MessageLookupByLibrary.simpleMessage("トランザクションが成功しました"),
        "transaction_type": MessageLookupByLibrary.simpleMessage("トランザクションタイプ"),
        "transak_supports_debit_card_bank_transfer":
            MessageLookupByLibrary.simpleMessage(
                "Transakは60か国以上でデビットカードと銀行送金をサポートしています（地域によって異なります）。"),
        "try_again": MessageLookupByLibrary.simpleMessage("再試行"),
        "tuesday": MessageLookupByLibrary.simpleMessage("火曜日"),
        "unavailable": MessageLookupByLibrary.simpleMessage("利用できません"),
        "unfortunately_cant_process_order": MessageLookupByLibrary.simpleMessage(
            "申し訳ございませんが、予約がキャンセルまたは期限切れとなったため注文を処理できません。 課金されませんのでご安心ください。"),
        "unknown_error": MessageLookupByLibrary.simpleMessage(
            "不明なエラーが発生しました。 もう一度やり直してください..."),
        "unknown_screen": MessageLookupByLibrary.simpleMessage("不明な画面"),
        "unpublish": MessageLookupByLibrary.simpleMessage("非公開"),
        "unpublish_call_link":
            MessageLookupByLibrary.simpleMessage("通話リンクを非公開"),
        "unverified": MessageLookupByLibrary.simpleMessage("未確認"),
        "up_next": MessageLookupByLibrary.simpleMessage("次へ"),
        "up_to": MessageLookupByLibrary.simpleMessage("まで"),
        "up_to_60_secs": MessageLookupByLibrary.simpleMessage("最大60秒"),
        "buy": MessageLookupByLibrary.simpleMessage("今後の予定"),
        "updated": MessageLookupByLibrary.simpleMessage("更新しました"),
        "upload_video_explains":
            MessageLookupByLibrary.simpleMessage("説明用の短いビデオをアップロード"),
        "uploading": MessageLookupByLibrary.simpleMessage("アップロード"),
        "user_not_found": MessageLookupByLibrary.simpleMessage("ユーザーが見つかりません。"),
        "username": MessageLookupByLibrary.simpleMessage("ユーザー名"),
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
            MessageLookupByLibrary.simpleMessage("ユーザー名または電子メール"),
        "username_required":
            MessageLookupByLibrary.simpleMessage("Username is required"),
        "usernmae_already_exists": MessageLookupByLibrary.simpleMessage(
            "An account with this username already exists"),
        "using_webhook_allows_coinbase": MessageLookupByLibrary.simpleMessage(
            "Webhookを使用するとコインベース・コマースは支払いがリアルタイムで確認されたときにGotokに通知します。"),
        "verification_code_expired":
            MessageLookupByLibrary.simpleMessage("Verification code expired"),
        "verification_code_sent":
            MessageLookupByLibrary.simpleMessage("Verification code sent"),
        "verified": MessageLookupByLibrary.simpleMessage("確認済み"),
        "verify": MessageLookupByLibrary.simpleMessage("Verify"),
        "verify_email": MessageLookupByLibrary.simpleMessage("Verify Email"),
        "verify_email_body": MessageLookupByLibrary.simpleMessage(
            "Your email is not yet verified. Please verify your email to continue"),
        "verify_identity_plaform_safe": MessageLookupByLibrary.simpleMessage(
            "プラットフォームを安全で信頼できるものにし、KYC要件に準拠するために本人確認を行う必要があります。"),
        "verify_profile": MessageLookupByLibrary.simpleMessage("プロフィールの確認"),
        "verify_your_email":
            MessageLookupByLibrary.simpleMessage("Verify your email"),
        "verify_your_identity": MessageLookupByLibrary.simpleMessage("本人確認"),
        "video_too_short":
            MessageLookupByLibrary.simpleMessage("おっと！ ビデオが短すぎます。"),
        "view_all_transactions":
            MessageLookupByLibrary.simpleMessage("すべてのトランザクションを表示"),
        "view_on": MessageLookupByLibrary.simpleMessage("見る:"),
        "visible_accept_bookings":
            MessageLookupByLibrary.simpleMessage("通話リンクが表示され、予約を受けられます。"),
        "wallet": MessageLookupByLibrary.simpleMessage("ウォレット"),
        "wallet_powered_by_torus": MessageLookupByLibrary.simpleMessage(
            "ウォレットはTorusの分散自己管理型PKIインフラストラクチャを利用しています。"),
        "we_are_processing_order":
            MessageLookupByLibrary.simpleMessage("注文処理中"),
        "weak_password":
            MessageLookupByLibrary.simpleMessage("Password is too weak"),
        "webbook_shared_secret":
            MessageLookupByLibrary.simpleMessage("Webhookの共有秘密鍵"),
        "wednesday": MessageLookupByLibrary.simpleMessage("水曜日"),
        "with_ftx_pay": MessageLookupByLibrary.simpleMessage("FTXPayを使用"),
        "with_ramp": MessageLookupByLibrary.simpleMessage("RAMPを使用"),
        "with_transak": MessageLookupByLibrary.simpleMessage("Transakを使用"),
        "would_sign_in_different_email":
            MessageLookupByLibrary.simpleMessage("別のメールでサインインしますか？"),
        "wrong_password": MessageLookupByLibrary.simpleMessage(
            "Invalid username or password"),
        "yes": MessageLookupByLibrary.simpleMessage("はい"),
        "you_are_scheduled_with":
            MessageLookupByLibrary.simpleMessage("スケジュールされています:"),
        "you_can_manage_api_key_coinbase": MessageLookupByLibrary.simpleMessage(
            "コインベース・コマースの設定ページでAPIキーを管理できます。 ここから"),
        "you_have_no_event": MessageLookupByLibrary.simpleMessage("イベントはありません"),
        "you_receive": MessageLookupByLibrary.simpleMessage("受け取る"),
        "your": MessageLookupByLibrary.simpleMessage("あなたの"),
        "your_call_link": MessageLookupByLibrary.simpleMessage("あなたの通話リンク"),
        "your_coinbase_account":
            MessageLookupByLibrary.simpleMessage("コインベースアカウントが接続されています"),
        "your_contribution_accepted_proccessing":
            MessageLookupByLibrary.simpleMessage("あなたの流動性への支援は受け付けられ、現在処理中です。"),
        "your_email": MessageLookupByLibrary.simpleMessage("あなたのEメール"),
        "your_stripe_account_is_connected":
            MessageLookupByLibrary.simpleMessage("ストライプアカウントが接続されています"),
        "your_tokens_will_appear_to_make_payment":
            MessageLookupByLibrary.simpleMessage("トークンがここに表示され、支払いができます。")
      };
}
