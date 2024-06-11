import 'package:flutter/material.dart';
import 'package:project_1/ui/themes/app_colors.dart';

class AppThemes {
  static ThemeData buildTheme() {
    final ThemeData base = new ThemeData.light();
    return base.copyWith(
      colorScheme: const ColorScheme(
        primary: AppColors.blue,
        secondary: AppColors.orange,
        primaryContainer: AppColors.darkBlue,
        onError: AppColors.declineRed,
        onBackground: AppColors.transparent,
        error: AppColors.declineRed,
        secondaryContainer: AppColors.orange,
        onPrimary: AppColors.white,
        background: AppColors.transparent,
        brightness: Brightness.light,
        surface: AppColors.tileBackgroundColor,
        onSurface: AppColors.black,
        onSecondary: AppColors.black,
      ),
      // splashColor: AppColors.secondaryColor,
      // highlightColor: AppColors.secondaryColorDark,
      // buttonTheme: ButtonThemeData(
      //   buttonColor: AppColors.buttonYellow,
      // ),
      // iconTheme: base.iconTheme.copyWith(
      //   color: AppColors.black,
      // ),
    );
  }
}
