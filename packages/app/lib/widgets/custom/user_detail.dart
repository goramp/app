import 'package:browser_adapter/browser_adapter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:goramp/app_config.dart';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/services/index.dart';
import 'package:goramp/widgets/custom/share_list.dart';
import 'package:goramp/widgets/router/routes/index.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sized_context/sized_context.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/link.dart';
import 'package:goramp/generated/l10n.dart';
import '../../models/user.dart';
import '../../widgets/index.dart';

const double _kImageSize = 100;

class VeirifedBadge extends StatelessWidget {
  final double size;
  const VeirifedBadge({this.size = 24.0});
  build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomRight,
      child: Container(
        height: size,
        width: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.all(
            Radius.circular(size / 2),
          ),
        ),
        child: Icon(
          Icons.verified,
          size: size,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}

class Count extends StatelessWidget {
  final int? value;
  final String? text;
  const Count({this.value, this.text});
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
          text: "$value",
          style: Theme.of(context).textTheme.subtitle1,
          children: [
            TextSpan(
              text: " . ",
              style: Theme.of(context).textTheme.caption,
            ),
            TextSpan(
              text: text,
              style: Theme.of(context).textTheme.subtitle1,
            )
          ]),
    );

    // Chip(
    //   backgroundColor: Colors.grey[200],
    //   label: Text("10 Events"),
    //   labelStyle: Theme.of(context).textTheme.caption,
    // ),
  }
}

class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final String? username;
  final double size;

  const UserAvatar(
      {this.imageUrl, this.name, this.username, this.size = _kImageSize});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          width: size,
          height: size,
          child: ImageButton(
            imageUrl: imageUrl,
            buttonRadius: size / 2,
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        FlatButton(
          onPressed: () {},
          child: Text(
            S.of(context).edit_profile,
            style: Theme.of(context)
                .textTheme
                .button!
                .copyWith(fontWeight: FontWeight.w700),
          ),
          //color: secondary,
        ),
      ],
    );
  }
}

class ProfileImage extends StatelessWidget {
  final UserProfile? profile;
  final ImageCallback? onImage;
  final ValueNotifier<bool>? uploading;
  final bool showEdit;
  final bool showUserName;
  final bool showButtons;
  ProfileImage(this.profile,
      {this.onImage,
      this.uploading,
      this.showEdit = true,
      this.showUserName = false,
      this.showButtons = true});

  Widget _buildAvatar(BuildContext context, UserProfile? profile) {
    return SizedBox(
      width: _kImageSize,
      height: _kImageSize,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          ImageButton(
            imageUrl: profile?.photoUrl,
            buttonRadius: _kImageSize / 2,
            showIcon: false,
            onImage: onImage,
            uploading: uploading,
            //iconData: Icons.person_outline,
          ),
          if (profile != null && profile.kycVerified) const VeirifedBadge()
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    final isDesktop = isDisplayDesktop(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        if (isDesktop)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _buildAvatar(
                context,
                profile,
              ),
              const SizedBox(
                width: 32.0,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildName(context, profile),
                        if (showUserName) _buildUsername(context, profile),
                      ],
                    ),
                    if (showButtons) VSpace(Insets.m),
                    if (showButtons)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (showEdit) _buildEdit(context),
                          if (showEdit) HSpace(Insets.m),
                          _copy(context),
                        ],
                      )
                  ],
                ),
              ),
            ],
          ),
        if (!isDesktop) ...[
          _buildAvatar(context, profile),
          VSpace(
            Insets.m,
          ),
          _buildName(context, profile),
          if (showUserName) _buildUsername(context, profile),
          if (showButtons)
            VSpace(
              Insets.ls,
            ),
          if (showButtons)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (showEdit) _buildEdit(context),
                if (showEdit) HSpace(Insets.m),
                _copy(context),
              ],
            ),
        ],
        const SizedBox(
          height: 16.0,
        ),
        const SizedBox(
          height: 16.0,
        ),
      ],
    );
  }

  String shareLink(BuildContext context) {
    final path = ProfilePath(profile?.username ?? '');
    final AppConfig appConfig = Provider.of(context, listen: false);
    return 'https://${appConfig.webDomain}${path.location}';
  }

  Widget _buildName(BuildContext context, UserProfile? profile) {
    return Link(
        uri: Uri.parse(shareLink(context)),
        builder: (context, onTap) {
          return TextButton(
            style: textButtonStyle,
            onPressed: onTap,
            child: Text(
              '${profile?.name ?? ''}',
              style: Theme.of(context).textTheme.headline5,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
        });
  }

  Widget _buildUsername(BuildContext context, UserProfile? profile) {
    final theme = Theme.of(context);
    String username = '';
    if (profile != null) {
      username = '@${profile.username}';
    }

    return Link(
        uri: Uri.parse(shareLink(context)),
        builder: (context, onTap) {
          return TextButton(
            style: textButtonStyle,
            onPressed: onTap,
            child: Text(
              '$username',
              style: theme.textTheme.bodyText1!
                  .copyWith(color: theme.textTheme.caption!.color),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
        });
  }

  bool get showNativeShare {
    return (!UniversalPlatform.isWeb ||
        (UniversalPlatform.isWeb && !isDesktopBrowser()));
  }

  ButtonStyle get textButtonStyle {
    return TextButton.styleFrom(
        elevation: 0,
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: StadiumBorder(),
        visualDensity: VisualDensity.compact);
  }

  Widget _copy(BuildContext context) {
    final style = OutlinedButton.styleFrom(
      elevation: 0,
      padding: EdgeInsets.zero,
      //textStyle: theme.textTheme.button.copyWith(fontWeight: FontWeight.bold),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: CircleBorder(),
    );
    final icon = SizedBox(
      width: 40.0,
      height: 40.0,
      child: Center(
        child: Icon(
          CupertinoIcons.arrowshape_turn_up_right,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
    return showNativeShare
        ? OutlinedButton(
            style: style,
            child: icon,
            onPressed: () {
              Share.share(
                shareLink(context),
              );
            },
          )
        : SharePopUpButton(
            shareLink(context),
            builder: (context, onPressed) {
              return OutlinedButton(
                style: style,
                child: icon,
                onPressed: onPressed,
              );
            },
          );
  }

  Widget _buildEdit(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 40.0,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          elevation: 0,
          textStyle:
              theme.textTheme.button!.copyWith(fontWeight: FontWeight.bold),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: StadiumBorder(),
          visualDensity: VisualDensity.comfortable,
        ),
        icon: Icon(Icons.edit_outlined),
        label: Text(
          S.of(context).edit_profile,
        ),
        onPressed: profile == null
            ? null
            : () {
              },
      ),
    );
  }
}

class MyUserDetail extends StatefulWidget {
  final bool showUsername;
  final bool showButtons;
  final bool canEdit;
  final UserProfile? profile;

  const MyUserDetail({
    this.showUsername = false,
    this.showButtons = true,
    this.canEdit = true,
    this.profile,
    Key? key,
  }) : super(key: key);

  @override
  _MyUserDetailState createState() => _MyUserDetailState();
}

class _MyUserDetailState extends State<MyUserDetail> {
  final ValueNotifier<bool> _uploading = ValueNotifier<bool>(false);

  Future<void> _handleProfileChange(XFile? file) async {
    final update = UserProfileUpdate(image: file, removePhoto: file == null);
    try {
      _uploading.value = true;
      MyAppModel model = context.read();
      AppConfig config = context.read();
      await UserService.updateProfile(model.currentUser!.id, update, config);
    } catch (error) {
      print("error: $error");
    } finally {
      _uploading.value = false;
    }
  }

  Widget build(
    BuildContext context,
  ) {
    double maxWidth = 500;
    if (context.widthInches > 8) {
      //Panel size gets a little bigger as the screen size grows
      maxWidth += (context.widthInches - 8) * 12;
    }
    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        padding: EdgeInsets.all(16.0).copyWith(bottom: 0),
        child: ProfileImage(
          widget.profile,
          onImage: widget.canEdit ? _handleProfileChange : null,
          uploading: widget.canEdit ? _uploading : null,
          showUserName: widget.showUsername,
          showButtons: widget.showButtons,
          showEdit: widget.canEdit,
        ),
      ),
    );
  }
}

class ProfileUserDetail extends StatelessWidget {
  final UserProfile? userProfile;
  ProfileUserDetail(
    this.userProfile, {
    Key? key,
  }) : super(key: key);

  Widget _buildPublicUserDetail(
    BuildContext context,
    User? user,
  ) {
    double maxWidth = 500;
    if (context.widthInches > 8) {
      //Panel size gets a little bigger as the screen size grows
      maxWidth += (context.widthInches - 8) * 12;
    }
    final showEdit =
        (user != null && userProfile != null && user.id == userProfile!.uid);
    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        padding: EdgeInsets.all(16.0).copyWith(bottom: 0),
        child: ProfileImage(
          userProfile,
          showEdit: showEdit,
          showButtons: showEdit,
        ),
      ),
    );
  }

  Widget build(
    BuildContext context,
  ) {
    final user = context.select<MyAppModel, User?>((model) => model.currentUser);
    final isCurrentUser =
        (user != null && userProfile != null && user.id == userProfile!.uid);
    return AnimatedSwitcher(
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      duration: kThemeAnimationDuration,
      child: isCurrentUser
          ? MyUserDetail(
              profile: userProfile,
            )
          : _buildPublicUserDetail(context, user),
    );
  }
}
