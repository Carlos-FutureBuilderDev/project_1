import 'package:flutter/material.dart';
import 'package:project_1/ui/themes/app_colors.dart';

class AppTextStyles {
  static TextStyle drawerTabTextStyle() {
    return const TextStyle(
      color: AppColors.black,
      fontSize: 16.0,
      // fontStyle: FontStyle.italic,
    );
  }

  static Color getAccentColor() {
    return AppColors.secondaryColor;
  }

  static TextStyle getButtonTextStyle() {
    return const TextStyle(
      color: AppColors.white,
      fontSize: 14,
    );
  }

  static TextStyle getButtonTextStyleFlat() {
    return const TextStyle(
      color: AppColors.primaryColor,
      fontSize: 14,
    );
  }

  static Color getDefaultColor() {
    return AppColors.primaryColor;
  }

  static Color getDisabledColor() {
    return AppColors.disabledColor;
  }

  static TextStyle getInfoBarTextStyle() {
    return const TextStyle(
      color: AppColors.black,
      fontSize: 16.0,
    );
  }

  static TextStyle getLargeBoldTextStyle() {
    return const TextStyle(
      color: AppColors.black,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle getLargeBoldTextStyleLight() {
    return const TextStyle(
      color: AppColors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle getLargeBoldTextStyleLightWithUnderline() {
    return const TextStyle(
      height: 1.0,
      color: AppColors.transparent,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      shadows: <Shadow>[
        Shadow(
          offset: Offset(0, -5),
          color: AppColors.white,
        ),
      ],
      decoration: TextDecoration.underline,
      decorationColor: AppColors.white,
    );
  }

  static TextStyle getLargeDisabledTextStyle() {
    return const TextStyle(
      color: AppColors.primaryColor,
      fontSize: 20.0,
    );
  }

  static TextStyle getLargeDropdownTextStyle() {
    return const TextStyle(
      color: AppColors.black,
      fontSize: 20.0,
    );
  }

  static TextStyle getLargeTextStyle() {
    return const TextStyle(
      color: AppColors.black,
      fontSize: 20.0,
    );
  }

  static TextStyle getLargeTextStyleMoneyOnWhite() {
    return const TextStyle(
      color: AppColors.darkMoney,
      fontSize: 20.0,
    );
  }

  static TextStyle getLargeTextStyleRed() {
    return const TextStyle(
      color: AppColors.red,
      fontSize: 18.0,
    );
  }

  static TextStyle getMediumTextStyle() {
    return const TextStyle(
      color: AppColors.black,
      fontSize: 14.0,
    );
  }

  static TextStyle getMediumBoldTextStyleLight() {
    return const TextStyle(
      height: 1.0,
      color: AppColors.transparent,
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
      shadows: <Shadow>[
        Shadow(
          offset: Offset(0, -5),
          color: AppColors.white,
        ),
      ],
      // decoration: TextDecoration.underline,
      // decorationColor: AppColors.white,
    );
  }

  static TextStyle getMediumDropdownTextStyle() {
    return const TextStyle(
      color: AppColors.black,
      fontSize: 16.0,
    );
  }

  static TextStyle getMediumLargeDisabledTextStyle() {
    return const TextStyle(
      color: AppColors.primaryColor,
      fontSize: 18.0,
    );
  }

  static TextStyle getMediumLargeTextStyle() {
    return const TextStyle(
      color: AppColors.black,
      fontSize: 16.0,
    );
  }

  static TextStyle getMediumLargeTextStyleRed() {
    return const TextStyle(
      color: AppColors.red,
      fontSize: 16.0,
    );
  }

  static TextStyle getMediumTextStyleMoneyOnWhite() {
    return const TextStyle(
      color: AppColors.darkMoney,
      fontSize: 14.0,
    );
  }

  static TextStyle getMediumTextStyleRed() {
    return const TextStyle(
      color: AppColors.red,
      fontSize: 14.0,
    );
  }

  static TextStyle getMediumBoldItalicTextStyleLight() {
    return const TextStyle(
      color: AppColors.white,
      fontSize: 14.0,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
    );
  }

  static TextStyle getMediumBoldTextStyle() {
    return const TextStyle(
      color: AppColors.black,
      fontSize: 14.0,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle getMediumBoldTextStyleMoneyOnWhite() {
    return const TextStyle(
      color: AppColors.darkMoney,
      fontSize: 14.0,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle getMediumLinkTextStyle() {
    return const TextStyle(
      color: AppColors.hyperlinkBlue,
      fontSize: 14.0,
      decoration: TextDecoration.underline,
      decorationColor: AppColors.hyperlinkBlue,
    );
  }

  static TextStyle getMediumDisabledTextStyle() {
    return const TextStyle(
      color: AppColors.primaryColor,
      fontSize: 14.0,
    );
  }

  static TextStyle getMediumGreyedTextStyle() {
    return const TextStyle(
      color: AppColors.greyDark,
      fontSize: 14.0,
    );
  }

  // static TextStyle getMediumBoldTextStyleLight() {
  //   return TextStyle(
  //     color: AppColors.white,
  //     fontSize: 14.0,
  //   );
  // }

  static TextStyle getMediumItalicTextStyleLight() {
    return const TextStyle(
      height: 1.0,
      color: AppColors.white,
      fontSize: 14.0,
      fontStyle: FontStyle.italic,
    );
  }

  static TextStyle getSmallTextStyle() {
    return const TextStyle(
      color: AppColors.black,
      fontSize: 10.0,
    );
  }

  static TextStyle getSmallBoldTextStyle() {
    return const TextStyle(
      color: AppColors.black,
      fontSize: 10.0,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle getSmallItalicTextStyleLight() {
    return const TextStyle(
      color: AppColors.white,
      fontSize: 10.0,
      fontStyle: FontStyle.italic,
    );
  }

  static TextStyle getTextFieldStyle(final BuildContext context) {
    return Theme.of(context).textTheme.titleLarge!;
  }

  static Color getWarningColor() {
    return AppColors.warningColor;
  }
}
