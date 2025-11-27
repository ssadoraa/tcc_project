import 'package:flutter/material.dart';
import 'app_colors_light.dart';
import 'app_colors_dark.dart';

class AppColors {
  static bool _isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Color primary(BuildContext context) =>
      _isDark(context) ? AppColorsDark.primary : AppColorsLight.primary;

  static Color primaryStrong(BuildContext context) =>
      _isDark(context) ? AppColorsDark.primaryStrong : AppColorsLight.primaryStrong;

  static Color secondary(BuildContext context) =>
      _isDark(context) ? AppColorsDark.secondary : AppColorsLight.secondary;

  static Color secondaryStrong(BuildContext context) =>
      _isDark(context) ? AppColorsDark.secondaryStrong : AppColorsLight.secondaryStrong;

  static Color lightGreen(BuildContext context) =>
      _isDark(context) ? AppColorsDark.lightGreen : AppColorsLight.lightGreen;

  static Color lightOrange(BuildContext context) =>
      _isDark(context) ? AppColorsDark.lightOrange : AppColorsLight.lightOrange;

  static Color earthBrown(BuildContext context) =>
      _isDark(context) ? AppColorsDark.earthBrown : AppColorsLight.earthBrown;

  static Color lightOrangeOpacity(BuildContext context) =>
      _isDark(context) ? AppColorsDark.lightOrangeOpacity : AppColorsLight.lightOrangeOpacity;

  static Color background(BuildContext context) =>
      _isDark(context) ? AppColorsDark.background : AppColorsLight.background;

  static Color border(BuildContext context) =>
      _isDark(context) ? AppColorsDark.border : AppColorsLight.border;

  static Color textPrimary(BuildContext context) =>
      _isDark(context) ? AppColorsDark.textPrimary : AppColorsLight.textPrimary;

  static Color textSecondary(BuildContext context) =>
      _isDark(context) ? AppColorsDark.textSecondary : AppColorsLight.textSecondary;

  static Color textThird(BuildContext context) =>
      _isDark(context) ? AppColorsDark.textThird : AppColorsLight.textThird;

  static Color black(BuildContext context) =>
      _isDark(context) ? AppColorsDark.black : AppColorsLight.black;

  static Color white(BuildContext context) =>
      _isDark(context) ? AppColorsDark.white : AppColorsLight.white;
}
