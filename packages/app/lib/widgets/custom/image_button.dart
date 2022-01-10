import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universal_platform/universal_platform.dart';

import 'photo_button.dart';
import 'platform_circular_progress_indicator.dart';
import 'package:goramp/generated/l10n.dart';

class ImageButton extends StatefulWidget {
  final ImageCallback? onImage;
  final String? imageUrl;
  final ValueNotifier<bool>? uploading;
  final double? buttonRadius;
  final bool showIcon;
  final IconData iconData;
  ImageButton({
    this.onImage,
    this.imageUrl,
    this.uploading,
    this.buttonRadius,
    this.iconData = Icons.photo_camera_outlined,
    this.showIcon = true,
  });

  @override
  _ImageButtonState createState() {
    return _ImageButtonState();
  }
}

class _ImageButtonState extends State<ImageButton> {
  XFile? _image;

  void _showBottomSheet() {
    if (UniversalPlatform.isAndroid) {
      showMaterialBottomSheet();
    } else if (UniversalPlatform.isIOS) {
      showCupertinoAlert();
    } else {
      _getImage(false);
    }
  }

  void showMaterialBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new ListTile(
              leading: new Icon(Icons.photo_camera),
              title: new Text(S.of(context).camera),
              onTap: () {
                Navigator.pop(context, 'Camera');
                _getImage(true);
              },
            ),
            new ListTile(
              leading: new Icon(Icons.photo_album),
              title: new Text(S.of(context).photos),
              onTap: () {
                Navigator.pop(context, 'Photo');
                _getImage(false);
              },
            ),
            new ListTile(
              leading: new Icon(Icons.close),
              title: new Text(S.of(context).remove),
              onTap: () {
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
        );
      },
    );
  }

  void showCupertinoAlert() {
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

  Widget _icon() {
    ThemeData theme = Theme.of(context);
    if (widget.imageUrl == null && _image == null) {
      return SizedBox.expand(
        child: Icon(
          widget.iconData,
          color: theme.brightness == Brightness.light
              ? Colors.grey[500]
              : theme.dividerColor,
          size: 48,
        ),
      );
    }
    if (!widget.showIcon) {
      return const SizedBox.expand();
    } else {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black12,
        child: Icon(
          widget.iconData,
          color: Colors.white54,
          size: 48,
        ),
      );
    }
  }

  Widget _buildButtonInner() {
    return InkWell(
      onTap: widget.onImage != null ? _showBottomSheet : null,
      child: _icon(),
    );
  }

  Widget _buildAvatarButton(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.buttonRadius!),
      child: Container(
        color: theme.brightness == Brightness.light
            ? Colors.grey[100]
            : theme.colorScheme.background,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            _image != null
                ? UniversalPlatform.isWeb
                    ? Image.network(
                        _image!.path,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(_image!.path),
                        fit: BoxFit.cover,
                      )
                : widget.imageUrl != null
                    ? Image.network(
                        widget.imageUrl!,
                        fit: BoxFit.cover,
                      )
                    : const SizedBox.shrink(),
            Material(
              type: MaterialType.circle,
              color: Colors.transparent,
              clipBehavior: Clip.antiAlias,
              child: widget.uploading != null
                  ? ValueListenableBuilder(
                      valueListenable: widget.uploading!,
                      builder: (BuildContext context, bool uploading,
                          Widget? child) {
                        Widget? body = child;
                        if (uploading) {
                          body = SizedBox(
                            width: 40,
                            height: 40,
                            child: PlatformCircularProgressIndicator(
                                Theme.of(context).colorScheme.primary),
                          );
                        }
                        return AnimatedSwitcher(
                          duration: kThemeAnimationDuration,
                          child: body,
                        );
                      },
                      child: _buildButtonInner(),
                    )
                  : _buildButtonInner(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildAvatarButton(context);
  }
}
