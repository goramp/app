import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../extensions/index.dart';
import 'package:recase/recase.dart';

const _radius = 6.0;
const _kBorderRadius = BorderRadius.all(Radius.circular(_radius));

class CallLinkAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final VoidCallback? onPressed;

  CallLinkAvatar({this.name, this.imageUrl, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
      child: FlatButton(
        color: Colors.transparent,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        onPressed: () {},
        padding: EdgeInsets.all(0.0),
        highlightColor: Colors.transparent,
        splashColor: Colors.white24,
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 24.0,
              height: 24.0,
              child: CircleAvatar(
                backgroundImage: imageUrl != null
                    ? CachedNetworkImageProvider(imageUrl!)
                    : null,
                child: imageUrl != null
                    ? null
                    : Icon(
                        Icons.person_outline,
                        color: Colors.white,
                        size: 12.0,
                      ),
              ),
            ),
            SizedBox(
              width: 8.0,
            ),
            Expanded(
              child: Text(
                name?.toLowerCase() ?? "",
                style: Theme.of(context).textTheme.caption,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              width: 8.0,
            ),
          ],
        ),
      ),
    );
  }
}

class CallLinkTitle extends StatelessWidget {
  final String? title;

  CallLinkTitle({this.title});

  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
      child: Text(
        ReCase(title ?? '').titleCase,
        style: Theme.of(context).textTheme.subtitle1!.withCanvaskitFontFix,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class CallLinkDuration extends StatelessWidget {
  final Duration? duration;

  CallLinkDuration({this.duration});

  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            '${duration?.inMinutes} mins',
            style: Theme.of(context).textTheme.bodyText1,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class BaseCallLinkPageTile extends StatefulWidget {
  final Widget? child;
  final bool? isSelected;
  final double? width;
  final VoidCallback? onTap;
  final String? imageUrl;
  BaseCallLinkPageTile(
      {Key? key,
      this.child,
      this.onTap,
      this.isSelected,
      this.width,
      this.imageUrl})
      : super(key: key);

  @override
  _BaseCallLinkTileState createState() {
    return _BaseCallLinkTileState();
  }
}

class _BaseCallLinkTileState extends State<BaseCallLinkPageTile>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  AnimationController? _shrinkController;
  late Animation<double> _borderWidthTween;
  late Animation<double> _opacityTween;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: kThemeAnimationDuration);

    _opacityTween = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.easeIn,
      ),
    );
    _borderWidthTween = Tween<double>(
      begin: 0.0,
      end: 2.0,
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.easeIn,
      ),
    );
    if (widget.isSelected!) {
      _controller!.forward();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _shrinkController?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(BaseCallLinkPageTile oldVideoTile) {
    super.didUpdateWidget(oldVideoTile);
    if (oldVideoTile.isSelected != widget.isSelected) {
      if (widget.isSelected!) {
        _controller!.forward();
        // if (_shrinkController.status == AnimationStatus.completed) {
        //   _shrinkController.reverse();
        //   _controller.forward();
        // } else {
        //   _shrinkController.forward();
        // }
      } else {
        _controller!.reverse();
      }
    } else {}
  }

  BoxDecoration _buildShadowAndRoundedCorners() {
    Color borderColor = Colors.white.withOpacity(_opacityTween.value);
    double borderWidth = _borderWidthTween.value;
    return BoxDecoration(
      borderRadius: _kBorderRadius,
      border: Border.all(color: borderColor, width: borderWidth),
      image: widget.imageUrl != null
          ? DecorationImage(
              fit: BoxFit.cover,
              image: CachedNetworkImageProvider(widget.imageUrl!))
          : null,
      boxShadow: <BoxShadow>[
        BoxShadow(
          spreadRadius: 2.0,
          blurRadius: _radius,
          color: Colors.black26,
        ),
      ],
    );
  }

  Widget _buildAnimation(BuildContext context, Widget? child) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: widget.width,
        margin: const EdgeInsets.only(right: 8.0),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.zero, //_paddingTween.value,
              child: Container(
                decoration: _buildShadowAndRoundedCorners(),
                constraints: BoxConstraints.expand(),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: _kBorderRadius,
                    color: Colors.black45,
                  ),
                ),
              ),
            ),
            widget.child ?? Container()
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: _controller!,
    );
  }
}
