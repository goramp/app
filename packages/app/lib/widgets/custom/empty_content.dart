import 'package:flutter/material.dart';

class EmptyAction extends StatelessWidget {
  final String title;
  final Color textColor;
  final Color? buttonColor;
  final VoidCallback? onTap;
  EmptyAction(this.title, {Color? textColor, this.buttonColor, this.onTap})
      : this.textColor = textColor ?? Colors.white;
  Widget build(BuildContext context) {
    return RaisedButton(
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      color: Theme.of(context).primaryColor,
      textColor: Colors.white,
      child: Text(title),
      onPressed: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(4.0),
        ),
      ),
    );
  }
}

class EmptyContent extends StatelessWidget {
  final Widget? icon;
  final Widget? action;
  final Widget? title;
  final Widget? subtitle;
  final double? topSpacing;
  const EmptyContent(
      {Key? key,
      this.title,
      this.subtitle,
      this.icon,
      this.action,
      this.topSpacing = 60.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: topSpacing,
            ),
            if (icon != null)
              Container(
                  height: 100.0,
                  width: 100.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    //  color: Colors.black12,
                  ),
                  child: icon),
            if (title != null) SizedBox(height: 16.0),
            if (title != null) title!,
            if (subtitle != null) SizedBox(height: 8.0),
            if (subtitle != null) subtitle!,
            if (action != null) SizedBox(height: 16.0),
            if (action != null) action!
          ],
        ),
      ),
    );
  }
}
