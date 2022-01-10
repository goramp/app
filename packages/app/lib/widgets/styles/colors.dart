import 'package:flutter/material.dart';

const double COLOR_OPACITY = 0.8;

const primary = const Color(0xff6200ee);
const primaryLight = const Color(0xff3700b3);
const primaryDark = const Color(0xFFb3001f);
// const secondary = const Color(0xFF5ce18c);
// const secondaryLight = const Color(0xFF93ffbd);
// const secondaryDark = const Color(0xFF16ae5e);

ColorScheme kLightColorScheme = ColorScheme.light(
  surface: Colors.white,
  background: Colors.white,
  secondary: const Color(0xffF9B925),
  secondaryContainer: const Color(0xfff7a11e),
  onSecondary: const Color(0xff17173A),
);

ColorScheme kDarkColorScheme =  ColorScheme.dark(
    surface: Color(0xff121212),
    secondary: const Color(0xffbb86fc),
    secondaryContainer: const Color(0xff3700B3));

ColorScheme lightColorScheme = ColorScheme.light(
  surface: Colors.white,
  background: Colors.white,
  secondary: const Color(0xffF9B925),
  secondaryVariant: const Color(0xfff7a11e),
  onSecondary: const Color(0xff17173A),
);
// this.surface = const Color(0xff121212),
// this.background = const Color(0xff121212),
// ColorScheme darkColorScheme = ColorScheme.dark();
ColorScheme darkColorScheme = ColorScheme.dark(
    surface: Color(0xff121212),
    secondary: const Color(0xffbb86fc),
    secondaryVariant: const Color(0xff3700B3));
const lightSurfaceColor = Colors.white;
const lightBackgroundColor = Colors.white;

const primaryDarkTheme = const MaterialColor(0xFF212121, {
  700: const Color(0xFF000000),
  200: const Color(0xFF484848),
});

const accentSwatch = const MaterialColor(0xFF212121, {
  900: const Color(0xFFfa6901),
  800: const Color(0xFFfa8900),
  700: const Color(0xFFfa9a00),
  600: const Color(0xFFfaad00),
  500: const Color(0xFFfabb02),
  400: const Color(0xFFfbc526),
  300: const Color(0xFFfcd04d),
  200: const Color(0xFFfddd80),
  100: const Color(0xFFfeeab2),
  50: const Color(0xFFfff7e0),
});

const primarySwatch = const MaterialColor(0xFF212121, {
  900: const Color(0xFF94003e),
  800: const Color(0xFFb60041),
  700: const Color(0xFFc90042),
  600: const Color(0xFFde0045),
  500: const Color(0xFFee0245),
  400: const Color(0xFFf33460),
  300: const Color(0xFFf85b7b),
  200: const Color(0xFFfc8ba0),
  100: const Color(0xFFfeb9c6),
  50: const Color(0xFFffe3e8),
});

// ColorScheme altColorScheme = ColorScheme.light(
//     primary: primaryLight,
//     primaryVariant: primaryDark,
//     secondary: accentSwatch[400],
//     secondaryVariant: accentSwatch[700],
//     background: primary,
//     onBackground: Colors.white);

// ColorScheme altDarkColorScheme = ColorScheme.dark(
//   primary: primarySwatch[200],
//   primaryVariant: primaryDark,
//   secondary: accentSwatch[200],
//   secondaryVariant: accentSwatch[700],
// );

const secondarySwatch = const MaterialColor(0xFF212121, {
  900: const Color(0xFFbd001b),
  800: const Color(0xFFcc0f28),
  700: const Color(0xFFd91b2f),
  600: const Color(0xFFeb2735),
  500: const Color(0xFFfa3336),
  400: const Color(0xFFf44951),
  300: const Color(0xFFe96e74),
  200: const Color(0xFFf2979b),
  100: const Color(0xFFf2979b),
  50: const Color(0xFFffeaee),
});

const accent = const Color(0xFFFCCF4D);
const primaryText = const Color(0xFF00957a);
const textPrimary = const Color(0xFF525966);
const secondaryDarkText = const Color(0xFF898989);
const placeholderTextColor = const Color(0xFFA9A9A9);
const toolButtonColor = const Color(0xFF656B6A);
const iconColor = const Color(0xFF2e2e2e);
const badge = const Color(0xFFFF0000);
const backgroundColor = const Color(0xFFEFEFF2);
const iconDark = const Color(0x64000000);
const iconLight = const Color(0x64FFFFFF);
const bgGradStart = const Color(0xFFA179EF);
const bgGradEnd = const Color(0xFF673FB4);
const inputAccent = const Color(0xFFf9f3e3);
const inputText = const Color(0xFF434343);
const pressedButton = const Color(0xFF673fb4);
const disabledButton = const Color(0xFFFDECB8);
const disabledText = const Color(0xFF979797);
const buttonText = const Color(0xFF333333);
const disabledDark = const Color(0xFFF3F3F3);
const disabledYellow = const Color(0xFFf7de94);
const color1 = Color.fromRGBO(151, 200, 145, COLOR_OPACITY);
const color2 = Color.fromRGBO(255, 56, 80, COLOR_OPACITY);
const color3 = Color.fromRGBO(103, 63, 180, COLOR_OPACITY);
const color4 = Color.fromRGBO(247, 199, 48, COLOR_OPACITY);
const color5 = Color.fromRGBO(74, 144, 226, COLOR_OPACITY);
const color6 = Color.fromRGBO(1, 22, 39, COLOR_OPACITY);
const color7 = Color.fromRGBO(151, 223, 252, COLOR_OPACITY);
const color8 = Color.fromRGBO(101, 66, 54, COLOR_OPACITY);
const color9 = Color.fromRGBO(155, 155, 155, COLOR_OPACITY);
const color10 = Color.fromRGBO(1, 128, 144, COLOR_OPACITY);

const tileSwatch = [
  Color.fromRGBO(151, 200, 145, COLOR_OPACITY),
  Color.fromRGBO(255, 56, 80, COLOR_OPACITY),
  Color.fromRGBO(103, 63, 180, COLOR_OPACITY),
  Color.fromRGBO(247, 199, 48, COLOR_OPACITY),
  Color.fromRGBO(74, 144, 226, COLOR_OPACITY),
  Color.fromRGBO(1, 22, 39, COLOR_OPACITY),
  Color.fromRGBO(151, 223, 252, COLOR_OPACITY),
  Color.fromRGBO(101, 66, 54, COLOR_OPACITY),
  Color.fromRGBO(155, 155, 155, COLOR_OPACITY),
  Color.fromRGBO(1, 128, 144, COLOR_OPACITY)
];
