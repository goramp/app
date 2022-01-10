import 'dart:async';
import 'package:flutter/material.dart';
import 'package:goramp/widgets/index.dart';
import 'package:sized_context/sized_context.dart';
import 'package:goramp/widgets/pages/identity/verify.dart';
import 'package:goramp/widgets/utils/index.dart';
import 'package:image_picker/image_picker.dart';
import 'package:goramp/generated/l10n.dart';
import 'package:provider/provider.dart';
import '../../../app_config.dart';
import '../../../bloc/index.dart';
import '../../../services/index.dart';
import '../../../utils/index.dart';

import '../../../models/index.dart';

const double _kImageSize = 100.0;
const double _kMaxWidth = 500.0;

class _ProfileDrawerContainer extends StatelessWidget {
  final Widget child;
  const _ProfileDrawerContainer(this.child);
  @override
  Widget build(BuildContext context) {
    double detailsPanelWidth = 400;
    if (context.widthInches > 8) {
      //Panel size gets a little bigger as the screen size grows
      detailsPanelWidth += (context.widthInches - 8) * 12;
    }
    return Container(
      width: detailsPanelWidth,
      child: Drawer(
        child: child,
      ),
    );
  }
}

class EditAvatar extends StatelessWidget {
  final String? imageUrl;
  final ImageCallback? onImage;
  const EditAvatar({this.imageUrl, this.onImage});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: _kImageSize,
          height: _kImageSize,
          child: Stack(
            children: [
              ImageButton(
                  imageUrl: imageUrl,
                  buttonRadius: _kImageSize / 2,
                  onImage: onImage,
                  showIcon: false),
              Container(
                alignment: Alignment.bottomRight,
                child: Container(
                  height: 24.0,
                  width: 24.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Icon(
                    Icons.add_circle,
                    size: 24.0,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

enum EditDrawerMode {
  verify,
  none,
}

class EditProfile extends StatefulWidget {
  final String? username;
  const EditProfile({this.username});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final ValueNotifier<Map<String, ValidationState>> _validationStates =
      ValueNotifier<Map<String, ValidationState>>({});
  final Map<String, StreamSubscription<ValidationState>>
      _validationSubscriptions = {};
  final Map<String, ValidationBloc> _validationBlocs = {};
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, ValueNotifier> _fields = {};
  final ValueNotifier<bool> _saving = ValueNotifier<bool>(false);
  final ValueNotifier<EditDrawerMode> _editDrawerMode =
      ValueNotifier<EditDrawerMode>(EditDrawerMode.none);
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late MyAppModel model;
  @override
  void initState() {
    super.initState();
    // name setup

    model = context.read();
    AppConfig config = context.read();
    final name = model.currentUser!.name ?? '';
    _fields[Constants.NAME_FIELD] = ValueNotifier<String>(name);
    _controllers[Constants.NAME_FIELD] = TextEditingController(text: name);
    _validationBlocs[Constants.NAME_FIELD] = ValidationBloc<String>(
        NameValidator(Constants.NAME_FIELD, context:context),
        initialValue: name);
    _controllers[Constants.NAME_FIELD]!.addListener(() {
      if (_controllers[Constants.NAME_FIELD]!.text == name) {
        return;
      }
      _validationBlocs[Constants.NAME_FIELD]!
          .onTextChanged
          .add(_controllers[Constants.NAME_FIELD]!.text);
    });
    _validationSubscriptions[Constants.NAME_FIELD] =
        _validationBlocs[Constants.NAME_FIELD]!
            .state
            .listen((ValidationState state) {
      _validationStates.value = {
        ..._validationStates.value,
        Constants.NAME_FIELD: state
      };
    });
    final username = model.profile?.username ?? widget.username ?? '';
    _fields[Constants.USERNAME_FIELD] = ValueNotifier<String>(username);
    _controllers[Constants.USERNAME_FIELD] =
        TextEditingController(text: username);
    _validationBlocs[Constants.USERNAME_FIELD] = ValidationBloc<String>(
        UsernameValidator(Constants.USERNAME_FIELD, config, context:context),
        initialValue: username);
    _controllers[Constants.USERNAME_FIELD]!.addListener(() {
      if (_controllers[Constants.USERNAME_FIELD]!.text == username) {
        return;
      }
      _validationBlocs[Constants.USERNAME_FIELD]!
          .onTextChanged
          .add(_controllers[Constants.USERNAME_FIELD]!.text);
    });
    _validationSubscriptions[Constants.USERNAME_FIELD] =
        _validationBlocs[Constants.USERNAME_FIELD]!
            .state
            .listen((ValidationState state) {
      _validationStates.value = {
        ..._validationStates.value,
        Constants.USERNAME_FIELD: state
      };
    });
    _fields[Constants.IMAGE_FIELD] = ValueNotifier<XFile?>(null);
    final bio = model.profile?.bio ?? '';
    _controllers[Constants.BIO_FIELD] = TextEditingController(text: bio);
  }

  @override
  void dispose() {
    super.dispose();
    _validationBlocs.forEach((String _, ValidationBloc bloc) => bloc.dispose());
    _validationSubscriptions
        .forEach((String _, StreamSubscription sub) => sub.cancel());
    _controllers.forEach(
        (String _, TextEditingController controller) => controller.dispose());
    _validationStates.dispose();
  }

  bool get _isValid {
    return _validationStates.value.values.every((ValidationState state) {
      if (state is ValidationResult) {
        return state.isValid;
      }
      if (state is ValidationNoTerm) {
        return state.initial != null;
      }
      return false;
    });
  }

  void _openDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }

  _onSave() async {
    MyAppModel appModel = context.read();
    FocusScope.of(context).unfocus();
    final UserProfileUpdate update = UserProfileUpdate(
      name: _controllers[Constants.NAME_FIELD]!.text,
      bio: _controllers[Constants.BIO_FIELD]!.text,
      username: _controllers[Constants.USERNAME_FIELD]!.text,
      image: _fields[Constants.IMAGE_FIELD]!.value,
      //photoIdToRemove: widget.profile.photoId,
    );
    try {
      _saving.value = true;
      AppConfig config = context.read();
      await UserService.updateProfile(appModel.currentUser!.id, update, config);
      Navigator.of(context).pop();
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).default_error_title2)));
    } finally {
      _saving.value = false;
    }
  }

  Widget _buildAvatar() {
    MyAppModel model = Provider.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Center(
        // height: 150,
        // width: 150,
        // // alignment: Alignment.center,
        // color: Colors.amber,
        child: Column(
      children: [
        EditAvatar(
          imageUrl: model.profile?.photoUrl,
          onImage: (XFile? file) {
            _fields[Constants.IMAGE_FIELD]!.value = file;
          },
        ),
        if (model.profile != null)
          const SizedBox(
            height: 24.0,
          ),
        if (model.profile != null)
          model.profile!.kycVerified
              ? Chip(
                  avatar: Container(
                    height: 24.0,
                    width: 24.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(24),
                      ),
                    ),
                    child: Icon(
                      Icons.verified_user,
                      size: 24.0,
                      color: isDark ? Colors.green[200] : Colors.green[400],
                    ),
                  ),
                  label: Text(S.of(context).verified),
                  labelStyle: theme.textTheme.button?.copyWith(
                      color: isDark ? Colors.green[200] : Colors.green[400]),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: theme.dividerColor),
                    borderRadius: BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                  ),
                )
              : SizedBox(
                  // height: 40.0,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      elevation: 0,
                      textStyle: theme.textTheme.button!
                          .copyWith(fontWeight: FontWeight.bold),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: StadiumBorder(),
                      visualDensity: VisualDensity.comfortable,
                    ),
                    icon: Icon(Icons.shield_outlined),
                    label: Text(
                      S.of(context).verify_profile,
                    ),
                    onPressed: () {
                      if (isDisplayDesktop(context)) {
                        _editDrawerMode.value = EditDrawerMode.verify;
                        _openDrawer();
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (BuildContext context) {
                                return const VerifyPage();
                              },
                              fullscreenDialog: true),
                        );
                      }
                    },
                  ),
                )
      ],
    ));
  }

  Widget _buildName(UserProfile? user) {
    return ListTile(
      //leading: const Icon(Icons.person_outline),
      title: EditTextInput(
        validationBloc: _validationBlocs[Constants.NAME],
        validationEnabled: true,
        icon: const Icon(Icons.account_circle_outlined),
        fieldName: S.of(context).name,
        hint: "",
        controller: _controllers[Constants.NAME_FIELD],
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
      ),
    );
  }

  Widget _buildEmail(UserProfile? user) {
    return ListTile(
      //leading: const Icon(Icons.person_outline),
      title: EditTextInput(
        validationEnabled: false,
        icon: const Icon(Icons.email_outlined),
        fieldName: S.of(context).email,
        value: model.currentUser!.email!,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        enabled: false,
      ),
    );
  }

  Widget _buildUsername(UserProfile? user) {
    return ListTile(
      //leading: const Icon(Icons.person_outline),
      title: EditTextInput(
        validationBloc: _validationBlocs[Constants.USERNAME_FIELD],
        validationEnabled: true,
        icon: const Icon(Icons.person_outline),
        fieldName: S.of(context).username,
        hint: "",
        controller: _controllers[Constants.USERNAME_FIELD],
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
      ),
    );
  }

  Widget _buildBio(UserProfile? user) {
    return ListTile(
      //leading: const Icon(Icons.person_outline),
      title: EditTextInput(
        validationEnabled: false,
        icon: const Icon(Icons.create),
        fieldName: S.of(context).bio,
        hint: "",
        maxLength: 200,
        maxLines: 5,
        controller: _controllers[Constants.BIO_FIELD],
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
      ),
    );
  }

  List<Widget> _buildHeaderSlivers(
      BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      SliverOverlapAbsorber(
        // This widget takes the overlapping behavior of the SliverAppBar,
        // and redirects it to the SliverOverlapInjector below. If it is
        // missing, then it is possible for the nested "inner" scroll view
        // below to end up under the SliverAppBar even when the inner
        // scroll view thinks it has not been scrolled.
        // This is not necessary if the "headerSliverBuilder" only builds
        // widgets that do not overlap the next sliver.
        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        sliver: SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.all(32.0),
            color: Theme.of(context).appBarTheme.backgroundColor,
            //height: _kUserDetailHeight,
            child: _buildAvatar(),
          ),
        ),
      ),
    ];
  }

  Widget _buildDrawer() {
    return ScaffoldMessenger(
      child: ValueListenableBuilder(
        valueListenable: _editDrawerMode,
        builder: (context, EditDrawerMode val, child) {
          late Widget body;
          switch (val) {
            case EditDrawerMode.none:
              body = SizedBox.shrink();
              break;
            case EditDrawerMode.verify:
              body = _ProfileDrawerContainer(const VerifyPage());
              break;
            default:
              body = SizedBox.shrink();
          }
          return body;
        },
      ),
    );
  }

  Widget _buildScaffold() {
    final isDesktop = isDisplayDesktop(context);
    MyAppModel appModel = Provider.of(context, listen: false);
    return Scaffold(
      key: scaffoldKey,
      endDrawer: isDesktop ? _buildDrawer() : null,
      onEndDrawerChanged: (open) {
        if (!open) {
          _editDrawerMode.value = EditDrawerMode.none;
        }
        MyAppModel model = context.read();
        model.hideMainSideNav = open;
      },
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      drawer: null,
      onDrawerChanged: null,
      appBar: AppBar(
        centerTitle: true,
        leading: BackButton(onPressed: () => Navigator.of(context).pop()),
        title: Text(S.of(context).edit_profile),
        elevation: 0,
        actions: <Widget>[
          const SizedBox.shrink()
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: _buildHeaderSlivers,
        body: Scrollbar(
          child: StreamBuilder<UserProfile?>(
            stream: UserService.getProfileStream(appModel.currentUser!.id),
            builder:
                (BuildContext context, AsyncSnapshot<UserProfile?> snapshot) {
              UserProfile? user = snapshot.data;
              return Form(
                key: _formKey,
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverOverlapInjector(
                      // This is the flip side of the SliverOverlapAbsorber above.
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context),
                    ),
                    SliverToBoxAdapter(
                      child: const SizedBox(
                        height: 40.0,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: CenteredWidget(
                        _buildName(user),
                        maxWidth: _kMaxWidth,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: CenteredWidget(
                        _buildEmail(user),
                        maxWidth: _kMaxWidth,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: CenteredWidget(
                        _buildUsername(user),
                        maxWidth: _kMaxWidth,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: CenteredWidget(
                        _buildBio(user),
                        maxWidth: _kMaxWidth,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: CenteredWidget(
                        ListTile(
                          title: Row(
                            children: [
                              ValueListenableBuilder(
                                valueListenable: _validationStates,
                                builder: (context,
                                    Map<String, ValidationState> validation,
                                    _) {
                                  // final canSave = save ?? false;
                                  //       style: theme.textTheme.button!.copyWith(
                                  //           color: _isValid
                                  //               ? theme.colorScheme.secondary
                                  //               : theme.disabledColor,
                                  //           fontWeight: FontWeight.bold)
                                  ThemeData theme = Theme.of(context);
                                  final ButtonStyle raisedButtonStyle =
                                      ElevatedButton.styleFrom(
                                    textStyle: theme.textTheme.button!
                                        .copyWith(fontWeight: FontWeight.bold),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: kInputBorderRadius,
                                    ),
                                    primary: _isValid
                                        ? theme.colorScheme.primary
                                        : theme.colorScheme.surface,
                                    onPrimary: _isValid
                                        ? theme.colorScheme.onPrimary
                                        : theme.colorScheme.onSurface
                                            .withOpacity(0.38),
                                  );
                                  return ElevatedButton(
                                      style: raisedButtonStyle,
                                      child: Text(
                                        S.of(context).save.toUpperCase(),
                                      ),
                                      onPressed: _isValid ? _onSave : null);
                                },
                              ),
                            ],
                          ),
                        ),
                        maxWidth: _kMaxWidth,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _saving,
      builder: (BuildContext context, bool saving, Widget? child) {
        return Stack(
          children: <Widget>[
            child!,
            HUD(
              processing: saving,
            )
          ],
        );
      },
      child: _buildScaffold(),
    );
  }
}
