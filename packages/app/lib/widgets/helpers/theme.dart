import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goramp/app_config.dart';
import 'package:goramp/widgets/index.dart';
import 'package:provider/provider.dart';
import '../utils/index.dart';

class ThemeHelper {
  static ThemeData buildMaterialAppThemeWithContext(BuildContext context,
      {Brightness brightness = Brightness.light}) {
    AppConfig config = Provider.of(context, listen: false);
    ColorScheme colorScheme;
    if (config.isKuro) {
      colorScheme =
          brightness == Brightness.light ? kLightColorScheme : kDarkColorScheme;
    } else {
      colorScheme =
          brightness == Brightness.light ? lightColorScheme : darkColorScheme;
    }
    return buildMaterialAppTheme(context, colorScheme, brightness: brightness);
  }

  static ThemeData buildMaterialAppTheme(
      BuildContext context, ColorScheme colorScheme,
      {Brightness brightness = Brightness.light}) {
    final ThemeData base = ThemeData(
      brightness: brightness,
      fontFamily: 'Gilroy',
    );
    return _build(base, context, colorScheme);
  }

  static ThemeData _build(
      ThemeData base, BuildContext context, ColorScheme colorScheme) {
    // final TextStyle dialogTextStyle =
    //     base.textTheme.subhead.copyWith(color: base.textTheme.caption.color);
    // final TextStyle dialogTitleTextStyle = base.textTheme.title;
    final bool isDark = base.brightness == Brightness.dark;
    final cavasColor = isDark
        ? Color.alphaBlend(
            colorScheme.onSurface.withOpacity(0.05), colorScheme.surface)
        : colorScheme.surface;
    final scaffoldBackgroundColor = colorScheme.background;
    final primaryTextTheme = _buildPrimaryTextTheme(
      base,
      colorScheme,
    );
    final mainTextTheme = textTheme(
      base.textTheme,
    );
    return base.copyWith(
      colorScheme: colorScheme,
      appBarTheme: buildAppBarTheme(base, colorScheme),
      primaryColor: colorScheme.primary,
      primaryColorDark: colorScheme.primaryVariant,
      primaryColorLight: colorScheme.primary,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      canvasColor: cavasColor,
      accentColor: colorScheme.primary,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: mainTextTheme,
      primaryTextTheme: primaryTextTheme,
      toggleableActiveColor: colorScheme.secondary,
      sliderTheme: _buildSliderTheme(base.sliderTheme, colorScheme),
      snackBarTheme: base.snackBarTheme.copyWith(
          backgroundColor: colorScheme.secondary,
          contentTextStyle: mainTextTheme.bodyText1!
              .copyWith(color: colorScheme.onSecondary)),
      primaryIconTheme: base.iconTheme.copyWith(
        color: Colors.white,
      ),
      popupMenuTheme: PopupMenuThemeData(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      dialogTheme: buildDialogThene(base, colorScheme),

      // DialogTheme(
      //   titleTextStyle: dialogTitleTextStyle,
      //   contentTextStyle: dialogTextStyle,
      //   shape: RoundedRectangleBorder(borderRadius: kMediumBorderRadius),
      // ),
      //backgroundColor: primaryHighlight,
      // iconTheme: base.iconTheme.copyWith(
      //   color: colorScheme.onSurface,
      // ),
      // textTheme: GoogleFonts.rubikTextTheme(
      //   base.textTheme,
      // ),
      errorColor: colorScheme.error,
      inputDecorationTheme: _buildInputDecoratorTheme(base, colorScheme),
      indicatorColor: base.brightness == Brightness.light
          ? colorScheme.primary
          : Colors.white,
      tabBarTheme: _buildTabBarTheme(base, colorScheme),
      cupertinoOverrideTheme: _buildCupertinoAppTheme(base, context),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary),
      dividerColor: _dividerColor(base),
      bottomNavigationBarTheme:
          _buildBottomNavigationBarTheme(base, colorScheme),
      selectedRowColor: Color.alphaBlend(
          colorScheme.primary.withOpacity(0.20), colorScheme.surface),
    );
  }

  static TextTheme textTheme([TextTheme? textTheme]) {
    textTheme ??= ThemeData.light().textTheme;
    //const fontFallback = ['Rubik'];
    return TextTheme(
      headline1: textTheme.headline1!.withZoomFix,
      headline2: textTheme.headline2!.withZoomFix,
      headline3: textTheme.headline3!.withZoomFix,
      headline4: textTheme.headline4!.withZoomFix,
      headline5: textTheme.headline5!.withZoomFix,
      headline6: textTheme.headline6!.withZoomFix,
      subtitle1: textTheme.subtitle1!.withZoomFix,
      subtitle2: textTheme.subtitle2!.withZoomFix,
      bodyText1: textTheme.bodyText1!.withZoomFix,
      bodyText2: textTheme.bodyText2!.withZoomFix,
      caption: textTheme.caption!.withZoomFix,
      button: textTheme.button!.withZoomFix,
      overline: textTheme.overline!.withZoomFix,
    );
    // return TextTheme(
    //   headline1:
    //       GoogleFonts.sourceSansPro(textStyle: textTheme.headline1).withZoomFix,
    //   headline2:
    //       GoogleFonts.sourceSansPro(textStyle: textTheme.headline2).withZoomFix,
    //   headline3:
    //       GoogleFonts.sourceSansPro(textStyle: textTheme.headline3).withZoomFix,
    //   headline4:
    //       GoogleFonts.sourceSansPro(textStyle: textTheme.headline4).withZoomFix,
    //   headline5:
    //       GoogleFonts.sourceSansPro(textStyle: textTheme.headline5).withZoomFix,
    //   headline6:
    //       GoogleFonts.sourceSansPro(textStyle: textTheme.headline6).withZoomFix,
    //   subtitle1:
    //       GoogleFonts.sourceSansPro(textStyle: textTheme.subtitle1).withZoomFix,
    //   subtitle2:
    //       GoogleFonts.sourceSansPro(textStyle: textTheme.subtitle2).withZoomFix,
    //   bodyText1:
    //       GoogleFonts.sourceSansPro(textStyle: textTheme.bodyText1).withZoomFix,
    //   bodyText2:
    //       GoogleFonts.sourceSansPro(textStyle: textTheme.bodyText2).withZoomFix,
    //   caption:
    //       GoogleFonts.sourceSansPro(textStyle: textTheme.caption).withZoomFix,
    //   button:
    //       GoogleFonts.sourceSansPro(textStyle: textTheme.button).withZoomFix,
    //   overline:
    //       GoogleFonts.sourceSansPro(textStyle: textTheme.overline).withZoomFix,
    // );
  }

  static Color? _dividerColor(ThemeData base) {
    return base.brightness == Brightness.light
        ? Colors.grey[200]
        : Colors.grey[800];
  }

  static InputDecorationTheme _buildInputDecoratorTheme(
      ThemeData base, ColorScheme colorScheme) {
    InputDecorationTheme baseDecoTheme = base.inputDecorationTheme;
    return baseDecoTheme.copyWith(
      //hintStyle: base.textTheme.subhead.copyWith(color: base.accentColor),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: _dividerColor(base)!,
        ),
      ),
      // labelStyle: TextStyle(color: colorScheme.primary),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: colorScheme.primary,
        ),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: colorScheme.error,
        ),
      ),
    );
  }

  static TabBarTheme _buildTabBarTheme(
      ThemeData base, ColorScheme colorScheme) {
    return base.tabBarTheme.copyWith(
      unselectedLabelColor: base.textTheme.caption!.color,
      labelColor: colorScheme.primary,
    );
  }

  static BottomNavigationBarThemeData _buildBottomNavigationBarTheme(
      ThemeData base, ColorScheme colorScheme) {
    bool isDark = base.brightness == Brightness.dark;
    // print(
    //     'surface: ${Color.alphaBlend(colorScheme.onSurface.withOpacity(0.10), colorScheme.surface).toHex()}');
    return base.bottomNavigationBarTheme.copyWith(
      backgroundColor: isDark
          ? Color.alphaBlend(
              colorScheme.onSurface.withOpacity(0.10), colorScheme.surface)
          : colorScheme.background,
      unselectedItemColor: base.textTheme.caption!.color,
      selectedItemColor: colorScheme.primary,
    );
  }

  static DialogTheme buildDialogThene(ThemeData base, ColorScheme colorScheme) {
    bool isDark = base.brightness == Brightness.dark;
    return base.dialogTheme.copyWith(
      backgroundColor: isDark
          ? Color.alphaBlend(
              colorScheme.onSurface.withOpacity(0.1), colorScheme.surface)
          : colorScheme.background,
      shape: RoundedRectangleBorder(borderRadius: kMediumBorderRadius),
    );
  }

  static AppBarTheme buildAppBarTheme(ThemeData base, ColorScheme colorScheme) {
    bool isDark = base.brightness == Brightness.dark;
    return base.appBarTheme.copyWith(
      color: isDark
          ? Color.alphaBlend(
              colorScheme.onSurface.withOpacity(0.10), colorScheme.surface)
          : colorScheme.background,
      iconTheme: IconThemeData(color: colorScheme.onSurface),
    );
  }

  static Color backgroudColor(BuildContext context) {
    final theme = Theme.of(context);
    bool isDark = theme.brightness == Brightness.dark;
    return isDark
        ? Color.alphaBlend(theme.colorScheme.onSurface.withOpacity(0.08),
            theme.colorScheme.surface)
        : theme.colorScheme.surface;
  }

  static TextTheme _buildPrimaryTextTheme(
      ThemeData base, ColorScheme colorScheme) {
    final basePrimaryTextTheme = textTheme(
      base.primaryTextTheme,
    );
    final color =
        base.brightness == Brightness.light ? Colors.black87 : Colors.white;
    return basePrimaryTextTheme.copyWith(
      headline6: basePrimaryTextTheme.headline6!
          .copyWith(fontWeight: FontWeight.w700, color: color, fontSize: 20),
    );
  }

  static SliderThemeData _buildSliderTheme(
      SliderThemeData base, ColorScheme colorScheme) {
    return base.copyWith(
        valueIndicatorColor: colorScheme.primary,
        thumbColor: colorScheme.primary,
        activeTrackColor: colorScheme.primary,
        inactiveTrackColor: colorScheme.primary.withOpacity(0.38));
  }

  static TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      headline5: base.headline5!.copyWith(
        fontWeight: FontWeight.w600,
      ),
      headline6:
          base.headline6!.copyWith(fontSize: 20.0, fontWeight: FontWeight.w600),
      caption: base.caption!.copyWith(
        fontWeight: FontWeight.w400,
        fontSize: 14.0,
      ),
    );
  }

  static CupertinoThemeData _buildCupertinoAppTheme(
      ThemeData base, BuildContext context) {
    bool isDark = base.brightness == Brightness.dark;
    CupertinoTextThemeData textTheme = CupertinoTheme.of(context).textTheme;
    return CupertinoThemeData(
      textTheme: CupertinoTextThemeData(
        dateTimePickerTextStyle: textTheme.dateTimePickerTextStyle.copyWith(
            color: isDark ? Colors.white : Colors.black87,
            fontFamily: 'Averta'),
        primaryColor: primary,
        navTitleTextStyle: textTheme.navActionTextStyle.copyWith(
            fontSize: 22.0, fontWeight: FontWeight.bold, color: primary),
      ),
    );
  }
}
