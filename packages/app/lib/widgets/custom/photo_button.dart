import 'dart:io';
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:goramp/generated/l10n.dart';

const _kDefaultUser = 'assets/images/user/large/user.png';

typedef ImageCallback = void Function(XFile? image);

class PhotoButton extends StatefulWidget {
  final ImageCallback? onImage;
  final String? imageUrl;

  PhotoButton({this.onImage, this.imageUrl});

  @override
  _PhotoButtonState createState() {
    return _PhotoButtonState();
  }
}

class _PhotoButtonState extends State<PhotoButton> {
  final buttonRadius = 50.0;
  XFile? _image;

  void _showBottomSheet() {
    if (UniversalPlatform.isIOS) {
      _showCupertinoAlert();
    } else {
      _showMaterialBottomSheet();
    }
  }

  void _showMaterialBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: Text(S.of(context).camera),
              onTap: () {
                _getImage(true);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_album),
              title: Text(S.of(context).photos),
              onTap: () {
                _getImage(false);
              },
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: Text(S.of(context).remove),
              onTap: () {
                setState(() {
                  _image = null;
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _showCupertinoAlert() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text(S.of(context).camera),
            onPressed: () {
              Navigator.pop(context, 'Camera');
              _getImage(true);
            },
          ),
          CupertinoActionSheetAction(
            child: Text(S.of(context).photo_librar),
            onPressed: () {
              Navigator.pop(context, 'Photo');
              _getImage(false);
            },
          ),
          CupertinoActionSheetAction(
            child: Text(S.of(context).remove),
            onPressed: () {
              Navigator.pop(context, 'Remove');
              setState(() {
                _image = null;
              });
              if (widget.onImage != null) {
                widget.onImage!(null);
              }
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(S.of(context).cancel),
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context, 'Cancel');
          },
        ),
      ),
    );
  }

  Future<void> _getImage(bool isCamera) async {
    final picker = ImagePicker();
    var image = await picker.pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 500,
      maxHeight: 500,
      imageQuality: 80,
    );
    if (image == null) {
      return null;
    }
    setState(() {
      _image = image;
    });

    if (widget.onImage != null) {
      widget.onImage!(image);
    }
  }

  Widget _crossFade(Widget first, Widget second, bool isExpanded) {
    return AnimatedCrossFade(
      firstChild: first,
      secondChild: second,
      firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
      secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
      sizeCurve: Curves.fastOutSlowIn,
      crossFadeState:
          isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 200),
    );
  }

  Widget _buildIconButton(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isDark = theme.brightness == Brightness.dark;

    return PhysicalModel(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(buttonRadius),
      child: Container(
        width: 88.0,
        height: 88.0,
        decoration: BoxDecoration(
          shape: BoxShape
              .circle, // You can use like this way or like the below line
          color: Color.alphaBlend(theme.colorScheme.onSurface.withOpacity(0.08),
              theme.colorScheme.surface),
        ),
        child: Stack(
          // overflow: Overflow.visible,
          children: <Widget>[
            Material(
              type: MaterialType.circle,
              color: Colors.transparent,
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: _showBottomSheet,
                child: Center(
                  child: Icon(Icons.camera_alt,
                      size: 48.0,
                      color: theme.colorScheme.onSurface.withOpacity(0.4)),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Icon(Icons.add_circle,
                  size: 24.0, color: theme.colorScheme.secondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarButton(BuildContext context) {
    return CircleAvatar(
      radius: buttonRadius,
      backgroundImage: _image != null
          ? (UniversalPlatform.isWeb
              ? NetworkImage((_image!.path))
              : FileImage(File(_image!.path))) as ImageProvider<Object>?
          : (widget.imageUrl != null
              ? CachedNetworkImageProvider(widget.imageUrl!)
              : AssetImage(
                  _kDefaultUser,
                )) as ImageProvider<Object>?,
      child: Material(
        type: MaterialType.circle,
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: _showBottomSheet,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _crossFade(
        _buildIconButton(context), _buildAvatarButton(context), _image != null);
  }
}
