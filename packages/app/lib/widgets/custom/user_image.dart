import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const _kDefaultUser = 'assets/images/user/large/user.png';

class UserImage extends StatelessWidget {
  final String imageUrl;
  const UserImage(this.imageUrl);
  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      frameBuilder: (BuildContext _context, Widget child, int? frame,
          bool wasLoadedAsync) {
        if (wasLoadedAsync) {
          return child;
        }
        return AnimatedSwitcher(
          duration: kThemeAnimationDuration,
          child: frame == null ? Image.asset(_kDefaultUser) : child,
        );
      },
    );
  }
}
