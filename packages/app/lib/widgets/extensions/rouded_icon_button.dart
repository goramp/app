import 'package:flutter/material.dart';
import 'package:goramp/widgets/utils/index.dart';

extension RoundedIconButton on BuildContext {
  ButtonStyle get roundedButtonStyle {
    final theme = Theme.of(this);
    return TextButton.styleFrom(
      elevation: 0,
      primary: Colors.white,
      backgroundColor: Colors.black12,
      padding: EdgeInsets.zero,
      textStyle: theme.textTheme.button!.copyWith(fontWeight: FontWeight.bold),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: CircleBorder(),
    );
  }

  ButtonStyle get outlineStyle {
    return OutlinedButton.styleFrom(
      padding: EdgeInsets.symmetric(horizontal: 0),
      shape: const RoundedRectangleBorder(
        borderRadius: kInputBorderRadius,
      ),
    );
  }

  ButtonStyle get raisedStyle {
    return ElevatedButton.styleFrom(
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: kInputBorderRadius,
      ),
    );
  }

  ButtonStyle get roundTextStyle {
    final theme = Theme.of(this);
    final isDark = theme.brightness == Brightness.dark;
    return TextButton.styleFrom(
      elevation: 0,
      primary: theme.colorScheme.primary,
      backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
    );
  }

  ButtonStyle get stadiumRoundTextStyle {
    final theme = Theme.of(this);
    final isDark = theme.brightness == Brightness.dark;
    return TextButton.styleFrom(
        elevation: 0,
        primary: theme.colorScheme.primary,
        backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: StadiumBorder(),
        textStyle:
            theme.textTheme.button!.copyWith(fontWeight: FontWeight.bold));
  }

  ButtonStyle get stadiumRoundButtonStyle {
    final theme = Theme.of(this);
    return ElevatedButton.styleFrom(
        elevation: 0,
        primary: theme.colorScheme.primary,
        //backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: StadiumBorder(),
        textStyle:
            theme.textTheme.button!.copyWith(fontWeight: FontWeight.bold));
  }

  ButtonStyle get stadiumRoundOutlineStyle {
    return OutlinedButton.styleFrom(
        elevation: 0,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: StadiumBorder());
  }
}
