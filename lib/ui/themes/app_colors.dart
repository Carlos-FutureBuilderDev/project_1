import 'package:flutter/material.dart';

class AppColors {
  //Opacity
  static const Color transparent = Colors.transparent;

  //Greyscale
  static const Color white = Colors.white;
  static const Color whiteBackground = Color(0xFFf4f4f4);
  static const Color greyLight = Color(0xFFefefef);
  static const Color grey = Color(0xFFbdbdbd);
  static const Color greyDark = Color(0xFF8d8d8d);
  static const Color black = Colors.black;
  static const MaterialColor disabledColor = Colors.grey;
  static const Color tileBackgroundColor = Color(0xFFeeeeee);

  //Primary
  static const Color primaryColorLight = lightBlue;
  static const Color primaryColor = blue;
  static const Color primaryColorDark = darkBlue;

  //Secondary
  static Color? secondaryColorLight = Colors.orange[300];
  static const Color secondaryColor = lightOrange;
  static const Color secondaryColorDark = darkOrange;

  //Tertiary
  static const MaterialColor hyperlinkBlue = Colors.blue;
  static const MaterialColor blue = Colors.blue;
  static const MaterialColor lightBlue = Colors.lightBlue;
  static const Color darkBlue = Color(0xFF01008f);
  static const MaterialColor declineRed = Colors.red;
  static const MaterialColor warningColor = Colors.yellow;
  static const Color green = Color(0xFF43A047);
  static const MaterialColor lightMoney = Colors.green;
  static const Color darkMoney = Color(0xFF43A047);
  static const MaterialColor acceptGreen = Colors.green;
  static const Color acceptButtonPressed = Color(0xFF388E3C);
  static const Color green900 = Color(0xFF1B5E20);
  static const MaterialColor buttonYellow = Colors.yellow;
  static const Color buttonYellowPressed = Color(0xFFF9A825);
  static const Color buttonOutlineYellow = Color(0xFFF9A825);
  static const Color darkYellow = Color(0xFFF57F17);
  static const Color red = Color(0xFFD32F2F);
  static const Color red7 = Color(0xFFD32F2F);
  static const Color red8 = Color(0xFFC62828);
  static const Color red9 = Color(0xFFB71C1C);
  static const Color orange = Color(0xFFE65100);
  static const Color lightOrange = Color(0xFFFFA726);
  static const Color darkOrange = Color(0xFFE65100);
  static const Color pink = Color(0xFFF06292);
  static const MaterialColor purple = Colors.purple;

//----------------------------------------------------------------------------
// OLD GETTERS:

  static Color getDefaultColor() {
    return const Color.fromRGBO(0, 85, 128, 1.0);
  }

  static Color getAccentColor() {
    return const Color.fromRGBO(175, 0, 42, 1.0);
  }

  static Color getWarningColor() {
    return const Color.fromRGBO(255, 211, 0, 1.0);
  }

  static Color getDisabledColor() {
    return const Color.fromRGBO(132, 132, 130, 1.0);
  }

  static TextStyle getButtonTextStyle() {
    return const TextStyle(
      color: Colors.white,
      fontSize: 14,
    );
  }

  static TextStyle getButtonTextStyleFlat() {
    return TextStyle(
      color: getDefaultColor(),
      fontSize: 14,
    );
  }

  static TextStyle getTextFieldStyle(final BuildContext context) {
    return Theme.of(context).textTheme.headlineSmall!;
  }

  static TextStyle getLargeTextStyle() {
    return const TextStyle(
      color: Colors.black,
      fontSize: 20.0,
    );
  }

  static TextStyle getLargeBoldTextStyle() {
    return const TextStyle(
      color: Colors.black,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle getLargeBoldTextStyleLight() {
    return const TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle getMediumTextStyle() {
    return const TextStyle(
      color: Colors.black,
      fontSize: 14.0,
    );
  }

  static TextStyle getMediumBoldTextStyle() {
    return const TextStyle(
      color: Colors.black,
      fontSize: 14.0,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle getMediumLinkTextStyle() {
    return const TextStyle(
      color: Colors.blue,
      fontSize: 14.0,
      decoration: TextDecoration.underline,
      decorationColor: Colors.blue,
    );
  }

  static TextStyle getMediumDisabledTextStyle() {
    return TextStyle(
      color: getDisabledColor(),
      fontSize: 14.0,
    );
  }

  static TextStyle getMediumBoldTextStyleLight() {
    return const TextStyle(
      color: Colors.white,
      fontSize: 14.0,
    );
  }

  static TextStyle getMediumItalicTextStyleLight() {
    return const TextStyle(
      color: Colors.white,
      fontSize: 14.0,
      fontStyle: FontStyle.italic,
    );
  }

  static TextStyle getMediumBoldItalicTextStyleLight() {
    return const TextStyle(
      color: Colors.white,
      fontSize: 14.0,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
    );
  }

  static TextStyle getSmallTextStyle() {
    return const TextStyle(
      color: Colors.black,
      fontSize: 10.0,
    );
  }

  static TextStyle getSmallBoldTextStyle() {
    return const TextStyle(
      color: Colors.black,
      fontSize: 10.0,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle getSmallItalicTextStyleLight() {
    return const TextStyle(
      color: Colors.white,
      fontSize: 10.0,
      fontStyle: FontStyle.italic,
    );
  }

  static BoxDecoration getFieldBorderBottomOnly({required final bool enabled}) {
    return BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: enabled ? Colors.black : getDisabledColor(),
        ),
      ),
    );
  }
}
