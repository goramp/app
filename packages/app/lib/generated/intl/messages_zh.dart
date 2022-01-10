// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
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
  String get localeName => 'zh';

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
        "accept_crypto_payment": MessageLookupByLibrary.simpleMessage("接受加密支付"),
        "accept_nft_timepass":
            MessageLookupByLibrary.simpleMessage("接受 NFT TimePass"),
        "accept_payment_stripe":
            MessageLookupByLibrary.simpleMessage("使用 Stripe 接受卡付款"),
        "accept_terms_error_confirmation": MessageLookupByLibrary.simpleMessage(
            "Please confirm your age and agree with Kurobi Terms of Service"),
        "account_already_exist":
            MessageLookupByLibrary.simpleMessage("已存在具有相同电子邮件地址的帐户。"),
        "account_disabled": MessageLookupByLibrary.simpleMessage("帐户已禁用。"),
        "account_does_not_exist": MessageLookupByLibrary.simpleMessage(
            "We couldn\'t find an account with that email"),
        "account_exists": MessageLookupByLibrary.simpleMessage("帐户存在"),
        "account_id": MessageLookupByLibrary.simpleMessage("帐户ID"),
        "account_with_email_exists": MessageLookupByLibrary.simpleMessage(
            "An account with this email already exists"),
        "add_a_payment_provider":
            MessageLookupByLibrary.simpleMessage("您必须添加支付服务提供商，例如 Stripe 或"),
        "add_card": MessageLookupByLibrary.simpleMessage("添加卡片"),
        "add_details": MessageLookupByLibrary.simpleMessage("添加详细信息"),
        "add_funds": MessageLookupByLibrary.simpleMessage("增加资金"),
        "add_interval": MessageLookupByLibrary.simpleMessage("添加间隔"),
        "add_notes": MessageLookupByLibrary.simpleMessage("添加笔记"),
        "add_payment_method": MessageLookupByLibrary.simpleMessage("添加付款方式"),
        "add_payment_provider": MessageLookupByLibrary.simpleMessage("添加支付提供商"),
        "add_price": MessageLookupByLibrary.simpleMessage("添加价格"),
        "add_this_on_phone_record_watch":
            MessageLookupByLibrary.simpleMessage("将此添加到您的手机上，以便我们可以一起录制和观看视频"),
        "add_this_to_phone_watch_record":
            MessageLookupByLibrary.simpleMessage("将此添加到您的手机，以便我们可以一起观看和录制视频"),
        "add_your_rescheduling":
            MessageLookupByLibrary.simpleMessage("添加您的重新安排和取消政策。"),
        "address": MessageLookupByLibrary.simpleMessage("地址"),
        "age_too_low": MessageLookupByLibrary.simpleMessage(
            "You don\'t meet the age requirement."),
        "all_signin_options": MessageLookupByLibrary.simpleMessage("查看所有登录选项"),
        "allow_access_camera": MessageLookupByLibrary.simpleMessage("允许访问相机"),
        "allow_access_microphone":
            MessageLookupByLibrary.simpleMessage("允许使用麦克风"),
        "almost_there": MessageLookupByLibrary.simpleMessage("差不多好了！"),
        "amount": MessageLookupByLibrary.simpleMessage("数量"),
        "ampm": MessageLookupByLibrary.simpleMessage("AM/PM"),
        "an_account_already_exists": MessageLookupByLibrary.simpleMessage(
            "An account already exists with a different credentials."),
        "an_error_occurred":
            MessageLookupByLibrary.simpleMessage("发生错误。 请再试一次"),
        "and": MessageLookupByLibrary.simpleMessage("和"),
        "api_key": MessageLookupByLibrary.simpleMessage("API 密钥"),
        "apologies_something_went_wrong":
            MessageLookupByLibrary.simpleMessage("抱歉，但出了点问题。"),
        "are_you_sure_cancel_payment": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to cancel the payment?"),
        "are_you_sure_delete_card":
            MessageLookupByLibrary.simpleMessage("您确定要删除此卡吗"),
        "availablity": MessageLookupByLibrary.simpleMessage("可用性"),
        "balance": MessageLookupByLibrary.simpleMessage("平衡"),
        "base_commission_rate": MessageLookupByLibrary.simpleMessage("您的基本佣金率"),
        "bio": MessageLookupByLibrary.simpleMessage("生物"),
        "birthday": MessageLookupByLibrary.simpleMessage("生日"),
        "book": MessageLookupByLibrary.simpleMessage("书"),
        "booking_confirmed": MessageLookupByLibrary.simpleMessage("预订确认"),
        "buy": MessageLookupByLibrary.simpleMessage("买"),
        "buy_now": MessageLookupByLibrary.simpleMessage("立即购买"),
        "call_link": MessageLookupByLibrary.simpleMessage("呼叫链接"),
        "call_link_accept_new_booking":
            MessageLookupByLibrary.simpleMessage("电话链接不能接受新的预订"),
        "call_link_can_accept_booking":
            MessageLookupByLibrary.simpleMessage("电话链接可以接受预订"),
        "call_link_live":
            MessageLookupByLibrary.simpleMessage("您的电话链接将生效并开始接受预订"),
        "call_link_not_visible":
            MessageLookupByLibrary.simpleMessage("您的电话链接将不可见且不接受预订。"),
        "call_links": MessageLookupByLibrary.simpleMessage("Call Links"),
        "camera": MessageLookupByLibrary.simpleMessage("相机"),
        "cancel": MessageLookupByLibrary.simpleMessage("取消"),
        "cancel_callback": MessageLookupByLibrary.simpleMessage("取消 CallLink？"),
        "cancel_payment":
            MessageLookupByLibrary.simpleMessage("Cancel Payment"),
        "canceled": MessageLookupByLibrary.simpleMessage("取消"),
        "canceling": MessageLookupByLibrary.simpleMessage("取消"),
        "cant_validate_address":
            MessageLookupByLibrary.simpleMessage("Can\'t validate address"),
        "cards": MessageLookupByLibrary.simpleMessage("牌"),
        "change": MessageLookupByLibrary.simpleMessage("Change"),
        "character_less_than_255": MessageLookupByLibrary.simpleMessage(
            "Make sure to use less than 255 characters"),
        "check_your_inbox": MessageLookupByLibrary.simpleMessage("检查你的收件箱"),
        "checkout": MessageLookupByLibrary.simpleMessage("查看"),
        "choose_cover_photo": MessageLookupByLibrary.simpleMessage("カバー写真を選択"),
        "claim_now": MessageLookupByLibrary.simpleMessage("现在宣称"),
        "claims": MessageLookupByLibrary.simpleMessage("宣称"),
        "clear": MessageLookupByLibrary.simpleMessage("清除"),
        "click_add_on_endpoint":
            MessageLookupByLibrary.simpleMessage("2. 单击“添加端点”并粘贴以下网址："),
        "click_link_sent": m0,
        "close": MessageLookupByLibrary.simpleMessage("关闭"),
        "closed": MessageLookupByLibrary.simpleMessage("Closed"),
        "code_expired": MessageLookupByLibrary.simpleMessage("Code expired"),
        "code_is_number": MessageLookupByLibrary.simpleMessage(
            "Code must be a 6 digit number"),
        "code_not_found":
            MessageLookupByLibrary.simpleMessage("Code not found"),
        "code_required": MessageLookupByLibrary.simpleMessage("Code required"),
        "coinbase_commerce_before": MessageLookupByLibrary.simpleMessage(
            "Coinbase Commerce，然后您才能设定价格。"),
        "coinbase_commerce_setting": MessageLookupByLibrary.simpleMessage(
            "1. 在您的 Coinbase Commerce 设置页面中，滚动到“Webhook 订阅”部分。"),
        "collect_payment": MessageLookupByLibrary.simpleMessage("收款"),
        "collect_payment_card_apple_google_pay":
            MessageLookupByLibrary.simpleMessage(
                "使用卡、Apple Pay、Google Pay 收款。"),
        "collect_payment_sol_usd_kuro":
            MessageLookupByLibrary.simpleMessage("以 KURO、USDC、USDT 和 SOL 收款"),
        "complete_your_profile":
            MessageLookupByLibrary.simpleMessage("完成您的个人资料"),
        "confirm": MessageLookupByLibrary.simpleMessage("确认"),
        "confirm_age_terms": MessageLookupByLibrary.simpleMessage(
            "I confirm that I am 18 years of age or older and agree with"),
        "confirm_password": MessageLookupByLibrary.simpleMessage("确认密码"),
        "confirm_password_is_required": MessageLookupByLibrary.simpleMessage(
            "Confirm password is required"),
        "confirmed": MessageLookupByLibrary.simpleMessage("确认的"),
        "connect": MessageLookupByLibrary.simpleMessage("连接"),
        "connect_bank_earn": MessageLookupByLibrary.simpleMessage("连接银行赚取"),
        "connect_coinbase":
            MessageLookupByLibrary.simpleMessage("连接 Coinbase 商务"),
        "connect_solana_wallet":
            MessageLookupByLibrary.simpleMessage("连接 Solana 钱包"),
        "connect_wallet": MessageLookupByLibrary.simpleMessage("连接钱包"),
        "connect_wallet_earn": MessageLookupByLibrary.simpleMessage("连接钱包赚取"),
        "connect_your_stripe_account":
            MessageLookupByLibrary.simpleMessage("连接您的 Stripe 帐户"),
        "connect_your_wallet":
            MessageLookupByLibrary.simpleMessage("Connect Your Wallet"),
        "connecting": MessageLookupByLibrary.simpleMessage("Connecting"),
        "connection_error": MessageLookupByLibrary.simpleMessage("连接错误！"),
        "content_violates_policy": MessageLookupByLibrary.simpleMessage(
            "该视频可能包含违反我们政策的内容。 如果我们犯了错误，请在视频上传后继续请求人工审核。"),
        "continue_apple": MessageLookupByLibrary.simpleMessage("继续使用 Apple"),
        "continue_email": MessageLookupByLibrary.simpleMessage("继续使用电子邮件"),
        "continue_facebook":
            MessageLookupByLibrary.simpleMessage("继续使用 Facebook"),
        "continue_google": MessageLookupByLibrary.simpleMessage("继续使用 Google"),
        "continue_string": MessageLookupByLibrary.simpleMessage("继续"),
        "continue_twitter": MessageLookupByLibrary.simpleMessage("继续推特"),
        "contribute": MessageLookupByLibrary.simpleMessage("贡献"),
        "copied": MessageLookupByLibrary.simpleMessage("已复制"),
        "copied_to_clipboard": MessageLookupByLibrary.simpleMessage("复制到剪贴板"),
        "copy_address": MessageLookupByLibrary.simpleMessage("Copy Address"),
        "copy_link": MessageLookupByLibrary.simpleMessage("复制链接"),
        "could_not_open_mail_app":
            MessageLookupByLibrary.simpleMessage("无法打开邮件应用"),
        "country": MessageLookupByLibrary.simpleMessage("Country"),
        "create": MessageLookupByLibrary.simpleMessage("创建"),
        "create_a_call_lin":
            MessageLookupByLibrary.simpleMessage("创建呼叫链接以开始接收或安排 1:1 呼叫"),
        "create_a_calllink_receive":
            MessageLookupByLibrary.simpleMessage("创建呼叫链接以开始接收"),
        "create_a_title": MessageLookupByLibrary.simpleMessage("创建标题"),
        "create_account": MessageLookupByLibrary.simpleMessage("创建账户"),
        "create_new_account": MessageLookupByLibrary.simpleMessage("创建一个新账户"),
        "create_title": MessageLookupByLibrary.simpleMessage("创建标题"),
        "current_price": MessageLookupByLibrary.simpleMessage("目前的价格"),
        "data_not_stored": MessageLookupByLibrary.simpleMessage("数据不会被存储"),
        "date": MessageLookupByLibrary.simpleMessage("日にち"),
        "days": MessageLookupByLibrary.simpleMessage("天"),
        "default_error_title": MessageLookupByLibrary.simpleMessage("请再试一次。"),
        "default_error_title2":
            MessageLookupByLibrary.simpleMessage("似乎有些不对劲，我们正在检查..."),
        "delete": MessageLookupByLibrary.simpleMessage("删除"),
        "delete_calllink": MessageLookupByLibrary.simpleMessage("删除CallLink？"),
        "deposit": MessageLookupByLibrary.simpleMessage("订金"),
        "deposit_fund_on_ftx_account": MessageLookupByLibrary.simpleMessage(
            "从 FTX 账户存入资金，您可以在其中使用多个区块链、信用卡等上的加密货币添加资金。"),
        "deposit_token": m1,
        "destination_address": MessageLookupByLibrary.simpleMessage("目的地地址"),
        "details": MessageLookupByLibrary.simpleMessage("细节"),
        "dialog_positive_default": MessageLookupByLibrary.simpleMessage("好的"),
        "didnt_recognize_email":
            MessageLookupByLibrary.simpleMessage("申し訳ありませんが、そのメールを認識できませんでした。"),
        "discard": MessageLookupByLibrary.simpleMessage("丢弃"),
        "discard_call_link": MessageLookupByLibrary.simpleMessage("放弃呼叫链接？"),
        "discard_video_changes":
            MessageLookupByLibrary.simpleMessage("这将放弃您的视频和所有更改。"),
        "disconnect": MessageLookupByLibrary.simpleMessage("断开"),
        "disconnect_coinbase":
            MessageLookupByLibrary.simpleMessage("断开 Coinbase Commerce？"),
        "disconnect_stripe": MessageLookupByLibrary.simpleMessage("断开条纹？"),
        "discount": MessageLookupByLibrary.simpleMessage("折扣"),
        "dismiss": MessageLookupByLibrary.simpleMessage("解雇"),
        "done": MessageLookupByLibrary.simpleMessage("完毕"),
        "dont_have_an_account": MessageLookupByLibrary.simpleMessage("没有账号？"),
        "dst_ady_mint_dont_match": MessageLookupByLibrary.simpleMessage(
            "Destination address mint does not match"),
        "duration": MessageLookupByLibrary.simpleMessage("期间"),
        "edit": MessageLookupByLibrary.simpleMessage("编辑"),
        "edit_call_link": MessageLookupByLibrary.simpleMessage("编辑呼叫链接"),
        "edit_profile": MessageLookupByLibrary.simpleMessage("编辑个人资料"),
        "email": MessageLookupByLibrary.simpleMessage("电子邮件"),
        "email_already_exists":
            MessageLookupByLibrary.simpleMessage("Email already exists"),
        "email_associated_with_account": MessageLookupByLibrary.simpleMessage(
            "输入与您的帐户相关联的电子邮件，我们将向您的收件箱发送一个魔术链接。"),
        "email_immutable":
            MessageLookupByLibrary.simpleMessage("Email can\'t change"),
        "email_invalid":
            MessageLookupByLibrary.simpleMessage("Email is not valid"),
        "email_link_reset_password":
            MessageLookupByLibrary.simpleMessage("请输入您的电子邮件地址以接收重置密码的链接。"),
        "email_required":
            MessageLookupByLibrary.simpleMessage("Email required"),
        "email_verified": MessageLookupByLibrary.simpleMessage("电子邮件已验证"),
        "end_cant_be_before_start":
            MessageLookupByLibrary.simpleMessage("您的结束时间不能早于开始时间"),
        "ended": MessageLookupByLibrary.simpleMessage("结束"),
        "ending": MessageLookupByLibrary.simpleMessage("结尾"),
        "ends": MessageLookupByLibrary.simpleMessage("结束"),
        "enter": MessageLookupByLibrary.simpleMessage("进入"),
        "enter_a_price": MessageLookupByLibrary.simpleMessage("输入价格"),
        "enter_email_address":
            MessageLookupByLibrary.simpleMessage("Enter your email address"),
        "enter_email_create_account":
            MessageLookupByLibrary.simpleMessage("输入您的电子邮件地址以创建一个帐户。"),
        "enter_valid_email":
            MessageLookupByLibrary.simpleMessage("输入一个有效的电子邮件地址"),
        "error": MessageLookupByLibrary.simpleMessage("错误"),
        "estimated": MessageLookupByLibrary.simpleMessage("估计的"),
        "example_com": MessageLookupByLibrary.simpleMessage("姓名@例子.com"),
        "exceeded_maximum_amount":
            MessageLookupByLibrary.simpleMessage("你已经超过了最大值"),
        "exceeded_remaining_amount":
            MessageLookupByLibrary.simpleMessage("您已超过剩余金额"),
        "expired": MessageLookupByLibrary.simpleMessage("已到期"),
        "expiry": MessageLookupByLibrary.simpleMessage("到期"),
        "external": MessageLookupByLibrary.simpleMessage("外部的"),
        "fail_fetch_call_link":
            MessageLookupByLibrary.simpleMessage("无法获取通话链接"),
        "fail_fetch_card": MessageLookupByLibrary.simpleMessage("取卡失败"),
        "fail_to_fetch_tokens": MessageLookupByLibrary.simpleMessage("无法获取令牌"),
        "failed": MessageLookupByLibrary.simpleMessage("失败的"),
        "failed_fetch_transactions":
            MessageLookupByLibrary.simpleMessage("获取交易失败"),
        "failed_fetch_wallet":
            MessageLookupByLibrary.simpleMessage("无法获取钱包详细信息"),
        "failed_to_fetch": MessageLookupByLibrary.simpleMessage("无法获取"),
        "failed_to_fetch_card":
            MessageLookupByLibrary.simpleMessage("Failed to fetch card"),
        "failed_to_fetch_cards":
            MessageLookupByLibrary.simpleMessage("Failed to fetch cards..."),
        "failed_to_fetch_event_details":
            MessageLookupByLibrary.simpleMessage("无法获取事件详细信息。"),
        "failed_to_fetch_payment_method":
            MessageLookupByLibrary.simpleMessage("无法获取付款方式"),
        "failed_to_fetch_profile":
            MessageLookupByLibrary.simpleMessage("Failed to fetch profile"),
        "failed_to_fetch_schedules":
            MessageLookupByLibrary.simpleMessage("未能获取时间表"),
        "failed_to_fetch_transaction":
            MessageLookupByLibrary.simpleMessage("Failed to fetch transaction"),
        "failed_to_load_payment_method":
            MessageLookupByLibrary.simpleMessage("无法加载付款方式"),
        "failed_to_load_profile":
            MessageLookupByLibrary.simpleMessage("无法加载配置文件"),
        "failed_to_send_confirmation_link":
            MessageLookupByLibrary.simpleMessage(
                "Failed to re-send confimation link, please try again."),
        "fee": MessageLookupByLibrary.simpleMessage("费用"),
        "feedback": MessageLookupByLibrary.simpleMessage("回馈"),
        "fetching_card": MessageLookupByLibrary.simpleMessage("取卡"),
        "fetching_cards":
            MessageLookupByLibrary.simpleMessage("Fetching cards..."),
        "fetching_payments": MessageLookupByLibrary.simpleMessage("获取付款"),
        "fetching_token": MessageLookupByLibrary.simpleMessage("获取令牌"),
        "fetching_transactions": MessageLookupByLibrary.simpleMessage("获取交易"),
        "finish_creating_account":
            MessageLookupByLibrary.simpleMessage("完成创建帐户以获得完整体验。"),
        "first_name": MessageLookupByLibrary.simpleMessage("First Name"),
        "first_name_required":
            MessageLookupByLibrary.simpleMessage("First name required"),
        "forgot_password": MessageLookupByLibrary.simpleMessage("忘记密码？"),
        "free": MessageLookupByLibrary.simpleMessage("自由"),
        "friday": MessageLookupByLibrary.simpleMessage("星期五"),
        "friend_recieve": MessageLookupByLibrary.simpleMessage("朋友收到"),
        "friends_commission_kickback_rate":
            MessageLookupByLibrary.simpleMessage("设置朋友的佣金回扣率"),
        "from": MessageLookupByLibrary.simpleMessage("从"),
        "full_name": MessageLookupByLibrary.simpleMessage("全名"),
        "generate_your_link": MessageLookupByLibrary.simpleMessage("生成您的链接"),
        "generating_preview": MessageLookupByLibrary.simpleMessage("生成预览"),
        "get_credit": MessageLookupByLibrary.simpleMessage("获得信用"),
        "get_started": MessageLookupByLibrary.simpleMessage("开始"),
        "grant_access":
            MessageLookupByLibrary.simpleMessage("使用 NFT TimePass 作为票证授予访问权限"),
        "grant_camera_access_record":
            MessageLookupByLibrary.simpleMessage("授予相机访问权限以进行记录"),
        "group": MessageLookupByLibrary.simpleMessage("Group"),
        "group_sub_title": MessageLookupByLibrary.simpleMessage(
            "Stream to multiple guests at a particular time"),
        "guest": MessageLookupByLibrary.simpleMessage("客人"),
        "helloWorld": MessageLookupByLibrary.simpleMessage("你好，世界！"),
        "hey": MessageLookupByLibrary.simpleMessage("嘿"),
        "host": MessageLookupByLibrary.simpleMessage("主持人"),
        "hours": MessageLookupByLibrary.simpleMessage("小时"),
        "i_m_avaliable": MessageLookupByLibrary.simpleMessage("我有空"),
        "identity_verified": MessageLookupByLibrary.simpleMessage("身份验证"),
        "in_order_accept_bitcoin_etherum": MessageLookupByLibrary.simpleMessage(
            "ビットコイン、イーサリアム、DAI、ライトコイン、ビットコインキャッシュ、またはUSDコインを受け入れるには、コインベースのコマースアカウントをリンクする必要があります。"),
        "in_order_accept_kurobi_solona_usd":
            MessageLookupByLibrary.simpleMessage(
                "为了接受 kurobi、USD Coin 或 Solana，您需要链接您的 solana 钱包。"),
        "in_order_connect_card_payment": MessageLookupByLibrary.simpleMessage(
            "为了收取卡付款，您需要连接您的 Stripe 帐户。 如果您没有 Stripe 帐户，您将被重定向以创建一个。"),
        "inappropriate_content": MessageLookupByLibrary.simpleMessage("不适当的内容"),
        "insufficient_funds": MessageLookupByLibrary.simpleMessage("不充足的资金"),
        "insufficient_sol_for_fees": m2,
        "insufficient_wallet_balance": m3,
        "interval_overlapping": MessageLookupByLibrary.simpleMessage("间隔重叠"),
        "intervals_must_be": MessageLookupByLibrary.simpleMessage("间隔必须至少"),
        "intro": MessageLookupByLibrary.simpleMessage("与您的观众进行 1:1 视频通话并获得报酬"),
        "intro_audience": MessageLookupByLibrary.simpleMessage("与观众进行一对一视频通话"),
        "intro_followers":
            MessageLookupByLibrary.simpleMessage("与您的关注者进行 1:1 视频通话"),
        "intro_paid_for_time":
            MessageLookupByLibrary.simpleMessage("并为您的时间获得报酬"),
        "invalid_address": MessageLookupByLibrary.simpleMessage("无效地址"),
        "invalid_amount": MessageLookupByLibrary.simpleMessage("金额无效"),
        "invalid_email_or_password": MessageLookupByLibrary.simpleMessage(
            "Invalid email or password provided"),
        "invalid_expired_action_code":
            MessageLookupByLibrary.simpleMessage("无效或过期的操作代码。"),
        "invalid_expired_code":
            MessageLookupByLibrary.simpleMessage("无效或过期的代码。 请再次验证您的电子邮件地址。"),
        "invalid_price": MessageLookupByLibrary.simpleMessage("无效价格"),
        "invalid_verification_code":
            MessageLookupByLibrary.simpleMessage("Invalid verification code"),
        "invite_friends": MessageLookupByLibrary.simpleMessage("邀请朋友"),
        "item_description": MessageLookupByLibrary.simpleMessage("商品描述"),
        "item_name": MessageLookupByLibrary.simpleMessage("项目名称"),
        "join_call": MessageLookupByLibrary.simpleMessage("加入通话"),
        "kuro_claimed_see_wallet":
            MessageLookupByLibrary.simpleMessage("您的 KURO 已被领取，现在应该在您的钱包中。"),
        "kuro_will_distributed_sales_end":
            MessageLookupByLibrary.simpleMessage("您的 KURO 将在销售结束后自动分发。"),
        "last_name": MessageLookupByLibrary.simpleMessage("Last Name"),
        "last_name_required":
            MessageLookupByLibrary.simpleMessage("Last name required"),
        "learn_more": MessageLookupByLibrary.simpleMessage("了解更多"),
        "likes": MessageLookupByLibrary.simpleMessage("Likes"),
        "log_in": MessageLookupByLibrary.simpleMessage("登录"),
        "log_in_different_user":
            MessageLookupByLibrary.simpleMessage("以其他用户身份登录"),
        "log_out": MessageLookupByLibrary.simpleMessage("登出"),
        "log_out_of": MessageLookupByLibrary.simpleMessage("登出"),
        "login_to_kurobi":
            MessageLookupByLibrary.simpleMessage("Log in to Kurobi"),
        "login_unauthorized":
            MessageLookupByLibrary.simpleMessage("哎呀！ 您的用户名/电子邮件地址或密码不正确"),
        "login_view_liked_calls":
            MessageLookupByLibrary.simpleMessage("登录以查看您喜欢的通话链接"),
        "login_with_email":
            MessageLookupByLibrary.simpleMessage("Login with email"),
        "low_sol_balance": MessageLookupByLibrary.simpleMessage(
            "Caution: Your SOL balance is low "),
        "low_sol_balance_info": MessageLookupByLibrary.simpleMessage(
            "SOL is needed for Solana network fees. A minimum balance of 0.05 SOL is recommended to avoid failed transactions."),
        "max": MessageLookupByLibrary.simpleMessage("最大限度"),
        "max_cards_reached": MessageLookupByLibrary.simpleMessage(
            "You have reached the maximum number of cards. Please remove or update an existing card"),
        "maximum": MessageLookupByLibrary.simpleMessage("最大值"),
        "maximum_number_card":
            MessageLookupByLibrary.simpleMessage("您已达到卡的最大数量。 请移除或更新现有卡"),
        "me": MessageLookupByLibrary.simpleMessage("我"),
        "min_password_chars": MessageLookupByLibrary.simpleMessage(
            "Make sure to enter at least 8 characters"),
        "min_username_chars": MessageLookupByLibrary.simpleMessage(
            "Make sure to enter at least 3 characters"),
        "minimum": MessageLookupByLibrary.simpleMessage("最低限度"),
        "minimum_contribution_of": MessageLookupByLibrary.simpleMessage("最低贡献"),
        "mins": MessageLookupByLibrary.simpleMessage("分钟"),
        "minutes": MessageLookupByLibrary.simpleMessage("分钟"),
        "monday": MessageLookupByLibrary.simpleMessage("周一"),
        "monetize_your_time":
            MessageLookupByLibrary.simpleMessage("Monetize your time"),
        "name": MessageLookupByLibrary.simpleMessage("姓名"),
        "name_invalid": MessageLookupByLibrary.simpleMessage(
            "First name or last name is not valid"),
        "new_call_link": MessageLookupByLibrary.simpleMessage("新建呼叫链接"),
        "new_password": MessageLookupByLibrary.simpleMessage("新密码"),
        "next": MessageLookupByLibrary.simpleMessage("下一个"),
        "no": MessageLookupByLibrary.simpleMessage("不"),
        "no_cards": MessageLookupByLibrary.simpleMessage("No Cards"),
        "no_likes_here": MessageLookupByLibrary.simpleMessage("这里没有赞"),
        "no_payment": MessageLookupByLibrary.simpleMessage("没有付款"),
        "no_result_found": MessageLookupByLibrary.simpleMessage("未找到结果"),
        "no_title": MessageLookupByLibrary.simpleMessage("无题"),
        "no_tokens": MessageLookupByLibrary.simpleMessage("没有代币"),
        "no_transactions": MessageLookupByLibrary.simpleMessage("没有交易"),
        "no_upcoming_event": MessageLookupByLibrary.simpleMessage("没有即将发生的事件"),
        "not_like_any_call_link":
            MessageLookupByLibrary.simpleMessage("您还没有喜欢任何电话链接"),
        "notes": MessageLookupByLibrary.simpleMessage("笔记"),
        "nothing_here": MessageLookupByLibrary.simpleMessage("这里没有什么"),
        "ok": MessageLookupByLibrary.simpleMessage("好的"),
        "one_on_one": MessageLookupByLibrary.simpleMessage("One-on-One"),
        "one_on_one_sub_title": MessageLookupByLibrary.simpleMessage(
            "Let one guest book a time with you."),
        "open_mail_app": MessageLookupByLibrary.simpleMessage("打开邮件应用程序"),
        "or": MessageLookupByLibrary.simpleMessage("或者"),
        "or_drag_drop_file": MessageLookupByLibrary.simpleMessage("或拖放文件"),
        "order_canceled": MessageLookupByLibrary.simpleMessage("订单取消"),
        "passes": MessageLookupByLibrary.simpleMessage("通行证"),
        "password": MessageLookupByLibrary.simpleMessage("密码"),
        "password_invalid": MessageLookupByLibrary.simpleMessage(
            "At least 8 characters and should include letters, numbers, and special characters"),
        "password_required": MessageLookupByLibrary.simpleMessage("密码是必需的"),
        "password_reset_request": MessageLookupByLibrary.simpleMessage(
            "Password reset request sent successfully"),
        "sell": MessageLookupByLibrary.simpleMessage("过去的"),
        "pay": MessageLookupByLibrary.simpleMessage("支付"),
        "pay_with_crypto": MessageLookupByLibrary.simpleMessage("用加密支付"),
        "pay_with_crypto_wallet":
            MessageLookupByLibrary.simpleMessage("Pay with crypto wallet"),
        "payment_terms": MessageLookupByLibrary.simpleMessage("付款条件"),
        "payments": MessageLookupByLibrary.simpleMessage("付款"),
        "payout": MessageLookupByLibrary.simpleMessage("支付"),
        "payout_now": MessageLookupByLibrary.simpleMessage("立即付款"),
        "payout_onboarding_description": MessageLookupByLibrary.simpleMessage(
            "Collect payments in crypto or cash when your guest book a call and reduce no shows."),
        "pending": MessageLookupByLibrary.simpleMessage("pending"),
        "pending_balance": MessageLookupByLibrary.simpleMessage("未结余额"),
        "phone_number_exists":
            MessageLookupByLibrary.simpleMessage("Phone number already exists"),
        "photo_librar": MessageLookupByLibrary.simpleMessage("照片库"),
        "photos": MessageLookupByLibrary.simpleMessage("相片"),
        "please_check_your_connection": MessageLookupByLibrary.simpleMessage(
            "Please check your connection"),
        "please_enter_new_password":
            MessageLookupByLibrary.simpleMessage("请输入新密码。"),
        "powered_by": MessageLookupByLibrary.simpleMessage("供电"),
        "preparing": MessageLookupByLibrary.simpleMessage("准备"),
        "preview": MessageLookupByLibrary.simpleMessage("预览"),
        "price": MessageLookupByLibrary.simpleMessage("价钱"),
        "privacy_policy": MessageLookupByLibrary.simpleMessage("隐私政策"),
        "processing": MessageLookupByLibrary.simpleMessage("加工"),
        "processing_video": MessageLookupByLibrary.simpleMessage("处理视频"),
        "product": MessageLookupByLibrary.simpleMessage("产品"),
        "profile_not_found": MessageLookupByLibrary.simpleMessage("未找到个人资料"),
        "provide_email_for_confirmation":
            MessageLookupByLibrary.simpleMessage("请提供您的电子邮件进行确认。"),
        "publish": MessageLookupByLibrary.simpleMessage("发布"),
        "publish_call_link": MessageLookupByLibrary.simpleMessage("发布呼叫链接"),
        "published": MessageLookupByLibrary.simpleMessage("已发表"),
        "qr_code": MessageLookupByLibrary.simpleMessage("二维码"),
        "ramp_allows_you_to_buy_cryto": MessageLookupByLibrary.simpleMessage(
            "Ramp 允许您在 170 多个国家/地区使用 Apple Pay、Google Pay、信用卡和银行转账购买加密货币。"),
        "re_schedule": MessageLookupByLibrary.simpleMessage("改期"),
        "receive": MessageLookupByLibrary.simpleMessage("收到"),
        "home": MessageLookupByLibrary.simpleMessage("最近"),
        "record_video": MessageLookupByLibrary.simpleMessage("录制视频"),
        "recorded": MessageLookupByLibrary.simpleMessage("已录制"),
        "recording": MessageLookupByLibrary.simpleMessage("记录"),
        "refreshing_the_page":
            MessageLookupByLibrary.simpleMessage("让我们看看刷新页面是否会解决它"),
        "reminder": MessageLookupByLibrary.simpleMessage("提醒"),
        "remove": MessageLookupByLibrary.simpleMessage("消除"),
        "remove_card": MessageLookupByLibrary.simpleMessage("移除卡"),
        "removed": MessageLookupByLibrary.simpleMessage("已移除"),
        "report": MessageLookupByLibrary.simpleMessage("报告"),
        "required": MessageLookupByLibrary.simpleMessage("必需的"),
        "resend_in": m4,
        "reservation_been_released":
            MessageLookupByLibrary.simpleMessage("您的预订已解除。"),
        "reset": MessageLookupByLibrary.simpleMessage("重启"),
        "reset_password": MessageLookupByLibrary.simpleMessage("重设密码"),
        "reset_your_password": MessageLookupByLibrary.simpleMessage("重置您的密码"),
        "restart_booking": MessageLookupByLibrary.simpleMessage("请重新开始您的预订。"),
        "retry": MessageLookupByLibrary.simpleMessage("重试"),
        "saturday": MessageLookupByLibrary.simpleMessage("周六"),
        "save": MessageLookupByLibrary.simpleMessage("节省"),
        "scan": MessageLookupByLibrary.simpleMessage("扫描"),
        "scan_to_call": MessageLookupByLibrary.simpleMessage("扫一扫打电话"),
        "schedules": MessageLookupByLibrary.simpleMessage("时间表"),
        "schedules_not_been_cancelled":
            MessageLookupByLibrary.simpleMessage("尚未取消的时间表。"),
        "search": MessageLookupByLibrary.simpleMessage("搜索"),
        "search_failed": MessageLookupByLibrary.simpleMessage("搜索失败，请重试。"),
        "secs": MessageLookupByLibrary.simpleMessage("秒"),
        "see_all_payout": MessageLookupByLibrary.simpleMessage("查看所有支付选项"),
        "select": MessageLookupByLibrary.simpleMessage("选择"),
        "select_a_date": MessageLookupByLibrary.simpleMessage("选择日期"),
        "select_a_time": MessageLookupByLibrary.simpleMessage("选择时间"),
        "select_a_week_day": MessageLookupByLibrary.simpleMessage("选择工作日"),
        "select_all": MessageLookupByLibrary.simpleMessage("全选"),
        "select_country": MessageLookupByLibrary.simpleMessage("选择国家"),
        "select_cover": MessageLookupByLibrary.simpleMessage("选择封面"),
        "select_date_time": MessageLookupByLibrary.simpleMessage("选择日期和时间"),
        "select_duration": MessageLookupByLibrary.simpleMessage("选择持续时间"),
        "select_items": MessageLookupByLibrary.simpleMessage("选择项目"),
        "select_time_interval": MessageLookupByLibrary.simpleMessage("选择时间间隔"),
        "select_timezone": MessageLookupByLibrary.simpleMessage("タイムゾーンを選択"),
        "select_video_to_upload":
            MessageLookupByLibrary.simpleMessage("选择要上传的视频"),
        "selected": MessageLookupByLibrary.simpleMessage("已选"),
        "sell_all": MessageLookupByLibrary.simpleMessage("全部出售"),
        "send": MessageLookupByLibrary.simpleMessage("发送"),
        "send_me_all_events": MessageLookupByLibrary.simpleMessage(
            "3. 确保选择“向我发送所有事件”，以接收所有付款更新。"),
        "send_only": MessageLookupByLibrary.simpleMessage("仅发送"),
        "sent_link_reset_password":
            MessageLookupByLibrary.simpleMessage("我们已将重置密码的链接发送至"),
        "sent_verification_link": MessageLookupByLibrary.simpleMessage(
            "We have sent a verification link to your inbox"),
        "service_fee": MessageLookupByLibrary.simpleMessage("服务费"),
        "service_unavailable": MessageLookupByLibrary.simpleMessage("暂停服务"),
        "service_unavailable_region":
            MessageLookupByLibrary.simpleMessage("此服务目前在您所在的地区不可用"),
        "set_default": MessageLookupByLibrary.simpleMessage("默认设置"),
        "settings": MessageLookupByLibrary.simpleMessage("设置"),
        "share": MessageLookupByLibrary.simpleMessage("分享"),
        "share_to": MessageLookupByLibrary.simpleMessage("分享给"),
        "share_to_facebook":
            MessageLookupByLibrary.simpleMessage("分享至Facebook"),
        "share_to_line": MessageLookupByLibrary.simpleMessage("分享到线路"),
        "share_to_linkedln": MessageLookupByLibrary.simpleMessage("分享到领英"),
        "share_to_twitter": MessageLookupByLibrary.simpleMessage("分享到推特"),
        "share_to_whatsapp":
            MessageLookupByLibrary.simpleMessage("分享到 WhatsApp"),
        "show_less": MessageLookupByLibrary.simpleMessage("显示较少"),
        "show_more": MessageLookupByLibrary.simpleMessage("展示更多"),
        "show_shared_secret":
            MessageLookupByLibrary.simpleMessage("4. 单击“显示共享机密”并粘贴到上面的框中。"),
        "sign_in": MessageLookupByLibrary.simpleMessage("登入"),
        "sign_in_email": MessageLookupByLibrary.simpleMessage("使用电子邮件登录"),
        "sign_up": MessageLookupByLibrary.simpleMessage("Sign up"),
        "sign_up_email": MessageLookupByLibrary.simpleMessage("用电子邮件注册"),
        "sign_up_now": MessageLookupByLibrary.simpleMessage("立即注册"),
        "sign_up_with_email":
            MessageLookupByLibrary.simpleMessage("Sign up with email"),
        "signin_agreement": MessageLookupByLibrary.simpleMessage("登录即表示您同意"),
        "signin_different_user":
            MessageLookupByLibrary.simpleMessage("以其他用户身份登录"),
        "signin_link_expired":
            MessageLookupByLibrary.simpleMessage("您的登录链接已过期。"),
        "signin_link_not_valid":
            MessageLookupByLibrary.simpleMessage("您的登录链接无效。"),
        "signup_agreement": MessageLookupByLibrary.simpleMessage("注册即表示您同意"),
        "signup_dialog_error_default_title":
            MessageLookupByLibrary.simpleMessage("一瞬间！"),
        "signup_dialog_error_default_title2":
            MessageLookupByLibrary.simpleMessage("不好了！"),
        "signup_for_kurobi":
            MessageLookupByLibrary.simpleMessage("Sign Up for Kurobi"),
        "signup_invalid_email_default_error":
            MessageLookupByLibrary.simpleMessage("您的电子邮件无效:)"),
        "signup_no_name_default_error":
            MessageLookupByLibrary.simpleMessage("添加你的名字，让你的朋友知道他们在和谁说话:)"),
        "signup_unique_email_default_error":
            MessageLookupByLibrary.simpleMessage("您的邮箱已被注册:)"),
        "slippage": MessageLookupByLibrary.simpleMessage("滑移"),
        "sol_pays_transaction_fee": m5,
        "solona_wallet_linked":
            MessageLookupByLibrary.simpleMessage("您的 Solana 钱包已关联"),
        "something_went_wrong":
            MessageLookupByLibrary.simpleMessage("哎呀！ 出了些问题。"),
        "sorry_calllink_cannot_deleted":
            MessageLookupByLibrary.simpleMessage("抱歉，无法删除此 callLink，因为您有"),
        "sorry_calllink_ended":
            MessageLookupByLibrary.simpleMessage("抱歉，此通话链接已结束或已过期"),
        "sorry_target_contribution":
            MessageLookupByLibrary.simpleMessage("对不起！ 目标最大贡献"),
        "starting": MessageLookupByLibrary.simpleMessage("开始"),
        "starts": MessageLookupByLibrary.simpleMessage("开始"),
        "savings": MessageLookupByLibrary.simpleMessage("Savings"),
        "stripe_make_sure_get_paid": MessageLookupByLibrary.simpleMessage(
            "我们使用 Stripe 来确保您按时获得付款并确保您的个人银行和详细信息安全。"),
        "sunday": MessageLookupByLibrary.simpleMessage("星期日"),
        "supports_bitcoin_etherum": MessageLookupByLibrary.simpleMessage(
            "支持刷卡支付、Apple Pay、Google Pay。"),
        "supports_card_payments": MessageLookupByLibrary.simpleMessage(
            "支持刷卡支付、Apple Pay、Google Pay。"),
        "suscbribe_to_your_event": MessageLookupByLibrary.simpleMessage(
            "您需要将此活动添加到您的每周可用性中，以便人们可以选择方便的时间来预订或订阅您的活动。"),
        "swap": MessageLookupByLibrary.simpleMessage("交换"),
        "swap_off_from_estimate":
            MessageLookupByLibrary.simpleMessage("掉期可能偏离估计的金额（以百分比为单位）"),
        "swipe_down_create_event":
            MessageLookupByLibrary.simpleMessage("向下滑动创建活动"),
        "terms_of_service": MessageLookupByLibrary.simpleMessage("服务条款"),
        "thank_you": MessageLookupByLibrary.simpleMessage("谢谢你"),
        "thank_you_participating":
            MessageLookupByLibrary.simpleMessage("感谢您的参与"),
        "thursday": MessageLookupByLibrary.simpleMessage("周四"),
        "time": MessageLookupByLibrary.simpleMessage("时间"),
        "time_left": MessageLookupByLibrary.simpleMessage("剩余时间"),
        "time_limit_reached": MessageLookupByLibrary.simpleMessage("达到时间限制"),
        "time_passes_appear_here":
            MessageLookupByLibrary.simpleMessage("时间流逝会出现在这里"),
        "time_zone": MessageLookupByLibrary.simpleMessage("时区"),
        "timepass_coming_soon":
            MessageLookupByLibrary.simpleMessage("TimePass 即将推出"),
        "title": MessageLookupByLibrary.simpleMessage("标题"),
        "to": MessageLookupByLibrary.simpleMessage("到"),
        "to_complete_setup": MessageLookupByLibrary.simpleMessage("完成您的帐户设置。"),
        "to_contribute": MessageLookupByLibrary.simpleMessage("贡献"),
        "to_sigin_in": MessageLookupByLibrary.simpleMessage("登录。"),
        "to_this_addres_any_digital_asset_loss":
            MessageLookupByLibrary.simpleMessage("到这个地址。 发送任何其他数字资产将导致永久丢失"),
        "tokens": MessageLookupByLibrary.simpleMessage("代币"),
        "tolerance": MessageLookupByLibrary.simpleMessage("宽容"),
        "top_up": MessageLookupByLibrary.simpleMessage("充值"),
        "total": MessageLookupByLibrary.simpleMessage("全部的"),
        "trade": MessageLookupByLibrary.simpleMessage("贸易"),
        "transaction_confirmed": MessageLookupByLibrary.simpleMessage("交易确认"),
        "transaction_id": MessageLookupByLibrary.simpleMessage("交易编号"),
        "transaction_signature": MessageLookupByLibrary.simpleMessage("交易签名"),
        "transaction_successful": MessageLookupByLibrary.simpleMessage("交易成功"),
        "transaction_type": MessageLookupByLibrary.simpleMessage("交易类型"),
        "transak_supports_debit_card_bank_transfer":
            MessageLookupByLibrary.simpleMessage(
                "Transak 支持 60 多个国家/地区的借记卡和银行转账（取决于位置）。"),
        "try_again": MessageLookupByLibrary.simpleMessage("再试一次"),
        "tuesday": MessageLookupByLibrary.simpleMessage("周二"),
        "unavailable": MessageLookupByLibrary.simpleMessage("不可用"),
        "unfortunately_cant_process_order":
            MessageLookupByLibrary.simpleMessage(
                "很遗憾，我们无法处理您的订单，因为预订已取消或已过期。 请放心，不会向您收费。"),
        "unknown_error":
            MessageLookupByLibrary.simpleMessage("出现未知错误。 请再试一次..."),
        "unknown_screen": MessageLookupByLibrary.simpleMessage("未知屏幕"),
        "unpublish": MessageLookupByLibrary.simpleMessage("取消发布"),
        "unpublish_call_link": MessageLookupByLibrary.simpleMessage("取消发布呼叫链接"),
        "unverified": MessageLookupByLibrary.simpleMessage("未经证实"),
        "up_next": MessageLookupByLibrary.simpleMessage("下一个"),
        "up_to": MessageLookupByLibrary.simpleMessage("取决于"),
        "up_to_60_secs": MessageLookupByLibrary.simpleMessage("长达 60 秒"),
        "buy": MessageLookupByLibrary.simpleMessage("即将到来"),
        "updated": MessageLookupByLibrary.simpleMessage("更新"),
        "upload_video_explains":
            MessageLookupByLibrary.simpleMessage("上传一段解释说明的短视频"),
        "uploading": MessageLookupByLibrary.simpleMessage("上传"),
        "user_not_found": MessageLookupByLibrary.simpleMessage("未找到用户。"),
        "username": MessageLookupByLibrary.simpleMessage("用户名"),
        "username_already_exists":
            MessageLookupByLibrary.simpleMessage("Username already exists"),
        "username_lt_max_chars": MessageLookupByLibrary.simpleMessage(
            "Make sure to use less than 30 characters"),
        "username_must_end_in_letter_or_num":
            MessageLookupByLibrary.simpleMessage(
                "Uh oh! Usernames must end in a letter or number"),
        "username_must_include_latin_chars": MessageLookupByLibrary.simpleMessage(
            "Oops! Usernames can only include letters, numbers and 1 \"-\",\"_\",or\".\", but no special characters"),
        "username_or_email": MessageLookupByLibrary.simpleMessage("用户名或电子邮件"),
        "username_required":
            MessageLookupByLibrary.simpleMessage("Username is required"),
        "usernmae_already_exists": MessageLookupByLibrary.simpleMessage(
            "An account with this username already exists"),
        "using_webhook_allows_coinbase": MessageLookupByLibrary.simpleMessage(
            "使用 webhooks 允许 Coinbase Commerce 在实时确认付款时通知 Gotok。"),
        "verification_code_expired":
            MessageLookupByLibrary.simpleMessage("Verification code expired"),
        "verification_code_sent":
            MessageLookupByLibrary.simpleMessage("Verification code sent"),
        "verified": MessageLookupByLibrary.simpleMessage("已验证"),
        "verify": MessageLookupByLibrary.simpleMessage("Verify"),
        "verify_email": MessageLookupByLibrary.simpleMessage("Verify Email"),
        "verify_email_body": MessageLookupByLibrary.simpleMessage(
            "Your email is not yet verified. Please verify your email to continue"),
        "verify_identity_plaform_safe": MessageLookupByLibrary.simpleMessage(
            "您必须验证您的身份，以便我们使我们的平台安全、值得信赖并符合 KYC 要求。"),
        "verify_profile": MessageLookupByLibrary.simpleMessage("验证个人资料"),
        "verify_your_email":
            MessageLookupByLibrary.simpleMessage("Verify your email"),
        "verify_your_identity": MessageLookupByLibrary.simpleMessage("验证您的身份"),
        "video_too_short": MessageLookupByLibrary.simpleMessage("哎呀！ 视频太短。"),
        "view_all_transactions": MessageLookupByLibrary.simpleMessage("查看所有交易"),
        "view_on": MessageLookupByLibrary.simpleMessage("查看"),
        "visible_accept_bookings":
            MessageLookupByLibrary.simpleMessage("呼叫链接将可见并且可以接受预订。"),
        "wallet": MessageLookupByLibrary.simpleMessage("钱包"),
        "wallet_powered_by_torus": MessageLookupByLibrary.simpleMessage(
            "您的钱包由 Torus 去中心化非托管 PKI 基础设施提供支持。"),
        "we_are_processing_order":
            MessageLookupByLibrary.simpleMessage("我们正在处理您的订单"),
        "weak_password":
            MessageLookupByLibrary.simpleMessage("Password is too weak"),
        "webbook_shared_secret":
            MessageLookupByLibrary.simpleMessage("Webhook Shared Secret"),
        "wednesday": MessageLookupByLibrary.simpleMessage("周三"),
        "with_ftx_pay": MessageLookupByLibrary.simpleMessage("使用 FTX 支付"),
        "with_ramp": MessageLookupByLibrary.simpleMessage("和RAMP"),
        "with_transak": MessageLookupByLibrary.simpleMessage("与 Transak"),
        "would_sign_in_different_email":
            MessageLookupByLibrary.simpleMessage("您想使用其他电子邮件登录吗？"),
        "wrong_password": MessageLookupByLibrary.simpleMessage(
            "Invalid username or password"),
        "yes": MessageLookupByLibrary.simpleMessage("是的"),
        "you_are_scheduled_with": MessageLookupByLibrary.simpleMessage("你被安排与"),
        "you_can_manage_api_key_coinbase": MessageLookupByLibrary.simpleMessage(
            "您可以在 Coinbase Commerce 设置页面中管理您的 API 密钥。 在这里可用"),
        "you_have_no_event": MessageLookupByLibrary.simpleMessage("您没有活动"),
        "you_receive": MessageLookupByLibrary.simpleMessage("你收到"),
        "your": MessageLookupByLibrary.simpleMessage("您的"),
        "your_call_link": MessageLookupByLibrary.simpleMessage("你的通话链接"),
        "your_coinbase_account":
            MessageLookupByLibrary.simpleMessage("您的 coinbase 帐户已连接"),
        "your_contribution_accepted_proccessing":
            MessageLookupByLibrary.simpleMessage("您的贡献已被接受，我们正在处理它。"),
        "your_email": MessageLookupByLibrary.simpleMessage("你的邮件"),
        "your_stripe_account_is_connected":
            MessageLookupByLibrary.simpleMessage("您的条带帐户已连接"),
        "your_tokens_will_appear_to_make_payment":
            MessageLookupByLibrary.simpleMessage(
                "Your tokens will appear here to make payment")
      };
}
