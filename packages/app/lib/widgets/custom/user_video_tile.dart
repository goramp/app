import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:recase/recase.dart';
import '../../models/index.dart';
import '../helpers/index.dart';
import 'package:goramp/generated/l10n.dart';

class UserVideoTile extends StatefulWidget {
  final CallLink? event;
  final bool? isSelected;
  final double? width;
  final VoidCallback? onTap;

  UserVideoTile({Key? key, this.event, this.onTap, this.isSelected, this.width})
      : super(key: key);

  @override
  _UserVideoTileState createState() {
    return _UserVideoTileState();
  }
}

class _UserVideoTileState extends State<UserVideoTile>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _shrinkController;
  late Animation<double> _borderWidthTween;
  late Animation<double> _opacityTween;
  late Animation<EdgeInsets> _paddingTween;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _shrinkController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    _shrinkController.addStatusListener((AnimationStatus status) {
      if (widget.isSelected!) {
        if (status == AnimationStatus.completed) {
          _shrinkController.reverse();
          _controller.forward();
        }
      }
    });

    _opacityTween = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
      ),
    );
    _borderWidthTween = Tween<double>(
      begin: 0.0,
      end: 2.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
      ),
    );
    _paddingTween = EdgeInsetsTween(
      begin: const EdgeInsets.all(0.0),
      end: const EdgeInsets.all(2.0),
    ).animate(
      CurvedAnimation(
        parent: _shrinkController,
        curve: Curves.fastOutSlowIn,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(UserVideoTile oldVideoTile) {
    super.didUpdateWidget(oldVideoTile);
    if (oldVideoTile.isSelected != widget.isSelected) {
      if (widget.isSelected!) {
        if (_shrinkController.status == AnimationStatus.completed) {
          _shrinkController.reverse();
          _controller.forward();
        } else {
          _shrinkController.forward().orCancel;
        }
      } else {
        _controller.reverse().orCancel;
      }
    }
  }

  BoxDecoration _buildShadowAndRoundedCorners() {
    Color borderColor = Colors.white.withOpacity(_opacityTween.value);
    double borderWidth = _borderWidthTween.value;
    return BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      border: Border.all(color: borderColor, width: borderWidth),
      image: DecorationImage(
          fit: BoxFit.cover,
          image: CachedNetworkImageProvider(
              widget.event?.video?.thumbnail?.url! ?? '')),
      boxShadow: <BoxShadow>[
        BoxShadow(
          spreadRadius: 2.0,
          blurRadius: 10.0,
          color: Colors.black26,
        ),
      ],
    );
  }

  Widget _buildCallButton() {
    return Material(
      color: Colors.green[500],
      shape: CircleBorder(),
      elevation: 8.0,
      clipBehavior: Clip.none,
      child: InkResponse(
        onTap: () {
          // TODO
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            Icons.call,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      clipBehavior: Clip.antiAlias,
      child: SizedBox.expand(
        child: CachedNetworkImage(
          imageUrl: widget.event?.hostImageUrl ?? '',
          placeholder: (BuildContext context, String val) => Placeholder(),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildInfo(BuildContext context) {
    final imageUrl = widget.event?.hostImageUrl;
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
              width: 32.0,
              height: 32.0,
              child: CircleAvatar(
                backgroundImage: imageUrl != null
                    ? CachedNetworkImageProvider(imageUrl)
                    : null,
                child: imageUrl != null
                    ? null
                    : Icon(
                        Icons.person_outline,
                        color: Colors.white,
                        size: 16.0,
                      ),
              ),
            ),
            SizedBox(
              width: 8.0,
            ),
            Expanded(
              child: Text(
                ReCase(widget.event?.ownerName ?? '').titleCase,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.white70, shadows: TEXT_SHADOW),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              width: 8.0,
            ),
//            Icon(
//              EvaIcons.phoneOutline,
//              color: Colors.green[300],
//            ),
//            SizedBox(
//              width: 8.0,
//            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventTitle() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
      child: Text(
        ReCase(widget.event?.title ?? '').titleCase,
        style: Theme.of(context)
            .textTheme
            .subtitle1!
            .copyWith(color: Colors.white, shadows: TEXT_SHADOW),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildEventDuration() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            ReCase('${widget.event?.duration?.inMinutes} ${S.of(context).mins}')
                .titleCase,
            style: Theme.of(context)
                .textTheme
                .caption!
                .copyWith(color: Colors.white70, shadows: TEXT_SHADOW),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  @override
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
              padding: _paddingTween.value,
              child: Container(
                decoration: _buildShadowAndRoundedCorners(),
                constraints: BoxConstraints.expand(),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.black45,
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildEventDuration(),
                Expanded(child: SizedBox.expand()),
                _buildEventTitle(),
                _buildInfo(context),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: _controller,
    );
  }
}
