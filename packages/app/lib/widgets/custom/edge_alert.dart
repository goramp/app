import 'package:flutter/material.dart';

class EdgeAlert {
  static final int LENGTH_SHORT = 1; //1 seconds
  static final int LENGTH_LONG = 2; // 2 seconds
  static final int LENGTH_VERY_LONG = 3; // 3 seconds

  static final int TOP = 1;
  static final int BOTTOM = 2;

  static void show(BuildContext context,
      {String? title,
      TextStyle? titleStyle,
      String? description,
      TextStyle? descriptionStyle,
      int? duration,
      int? gravity,
      Color? backgroundColor,
      Widget? icon}) {
    OverlayView.createView(context,
        title: title,
        titleStyle: titleStyle,
        description: description,
        descriptionStyle: descriptionStyle,
        duration: duration,
        gravity: gravity,
        backgroundColor: backgroundColor,
        icon: icon);
  }
}

class OverlayView {
  static final OverlayView _singleton = new OverlayView._internal();

  factory OverlayView() {
    return _singleton;
  }

  OverlayView._internal();

  static OverlayState? _overlayState;
  static OverlayEntry? _overlayEntry;
  static bool _isVisible = false;

  static void createView(BuildContext context,
      {String? title,
      String? description,
      int? duration,
      int? gravity,
      Color? backgroundColor,
      TextStyle? titleStyle,
      TextStyle? descriptionStyle,
      Widget? icon}) {
    _overlayState = Navigator.of(context).overlay;

    if (!_isVisible) {
      _isVisible = true;

      _overlayEntry = OverlayEntry(builder: (context) {
        return EdgeOverlay(
          title: title,
          titleStyle: titleStyle == null
              ? const TextStyle(color: Colors.white, fontSize: 22)
              : titleStyle,
          description: description,
          descriptionStyle: descriptionStyle == null
              ? const TextStyle(color: Colors.white, fontSize: 14)
              : descriptionStyle,
          overlayDuration: duration == null ? EdgeAlert.LENGTH_SHORT : duration,
          gravity: gravity == null ? EdgeAlert.TOP : gravity,
          backgroundColor:
              backgroundColor == null ? Colors.grey : backgroundColor,
          icon: icon == null
              ? const Icon(
                  Icons.notifications,
                  size: 35,
                  color: Colors.white,
                )
              : icon,
        );
      });

      _overlayState!.insert(_overlayEntry!);
    }
  }

  static dismiss() async {
    if (!_isVisible) {
      return;
    }
    _isVisible = false;
    _overlayEntry?.remove();
  }
}

class EdgeOverlay extends StatefulWidget {
  final String? title;
  final String? description;
  final TextStyle? titleStyle;
  final TextStyle? descriptionStyle;
  final int? overlayDuration;
  final int? gravity;
  final Color? backgroundColor;
  final Widget? icon;

  EdgeOverlay({
    this.title,
    this.description,
    this.overlayDuration,
    this.gravity,
    this.backgroundColor,
    this.icon,
    this.titleStyle,
    this.descriptionStyle,
  });

  @override
  _EdgeOverlayState createState() => _EdgeOverlayState();
}

class _EdgeOverlayState extends State<EdgeOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Tween<Offset> _positionTween;
  late Animation<Offset> _positionAnimation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 750));

    if (widget.gravity == 1) {
      _positionTween =
          Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset.zero);
    } else {
      _positionTween =
          Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0));
    }

    _positionAnimation = _positionTween.animate(
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));

    _controller.forward();

    listenToAnimation();
  }

  listenToAnimation() async {
    _controller.addStatusListener((listener) async {
      if (listener == AnimationStatus.completed) {
        await Future.delayed(Duration(seconds: widget.overlayDuration!));
        _controller.reverse();
        await Future.delayed(Duration(milliseconds: 700));
        OverlayView.dismiss();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double bottomHeight = MediaQuery.of(context).padding.bottom;

    return Positioned(
      top: widget.gravity == 1 ? 0 : null,
      bottom: widget.gravity == 2 ? 0 : null,
      child: SlideTransition(
        position: _positionAnimation,
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            boxShadow: <BoxShadow>[
              BoxShadow(
                spreadRadius: 1.0,
                blurRadius: 4.0,
                color: Colors.black12,
              ),
            ],
          ),
          padding: EdgeInsets.fromLTRB(
              20,
              widget.gravity == 1 ? statusBarHeight + 20 : bottomHeight + 20,
              20,
              widget.gravity == 1 ? 20 : 35),
          child: OverlayWidget(
            title: widget.title,
            titleStyle: widget.titleStyle,
            description: widget.description,
            descriptionStyle: widget.descriptionStyle,
            icon: widget.icon,
          ),
        ),
      ),
    );
  }
}

class OverlayWidget extends StatelessWidget {
  final String? title;
  final String? description;
  final Widget? icon;
  final TextStyle? titleStyle;
  final TextStyle? descriptionStyle;

  OverlayWidget({
    this.title = '',
    this.titleStyle,
    this.description = '',
    this.descriptionStyle,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Row(
        children: <Widget>[
          AnimatedIcon(icon: icon),
          Padding(padding: EdgeInsets.only(right: 15)),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              title == null
                  ? Container()
                  : Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        title!,
                        style: titleStyle,
                      ),
                    ),
              description == null
                  ? Container()
                  : Text(
                      description!,
                      style: descriptionStyle!.copyWith(color: Colors.red),
                    )
            ],
          )),
        ],
      ),
    );
  }
}

class AnimatedIcon extends StatefulWidget {
  final Widget? icon;

  AnimatedIcon({this.icon});

  @override
  _AnimatedIconState createState() => _AnimatedIconState();
}

class _AnimatedIconState extends State<AnimatedIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        lowerBound: 0.8,
        upperBound: 1.1,
        duration: Duration(milliseconds: 600));

    _controller.forward();
    listenToAnimation();
  }

  listenToAnimation() async {
    _controller.addStatusListener((listener) async {
      if (listener == AnimationStatus.completed) {
        _controller.reverse();
      }
      if (listener == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AnimatedBuilder(
        animation: _controller,
        child: widget.icon,
        builder: (context, widget) =>
            Transform.scale(scale: _controller.value, child: widget),
      ),
    );
  }
}
