import 'package:flutter/material.dart';
import 'package:project_1/models/user.dart';
import 'package:project_1/ui/themes/app_colors.dart';

import 'common.dart';

class CommonStyles {
  static AppBar appBarWithBack(
    final BuildContext context,
    final List<Widget>? appBarActions,
  ) {
    return AppBar(
      iconTheme: const IconThemeData(color: AppColors.secondaryColor),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.primaryColor),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: Text(
              Common.appName(),
              style: const TextStyle(
                color: AppColors.primaryColorDark,
                overflow: TextOverflow.visible,
                fontWeight: FontWeight.w900,
                fontSize: 20.0,
                letterSpacing: -.3,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
      actions: appBarActions,
      backgroundColor: AppColors.white,
      centerTitle: false,
    );
  }

  static AppBar appBarWithNoBack(final BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: AppColors.secondaryColor),
      leading: const Padding(
        padding: EdgeInsets.all(5.0),
        child: Image(
          image: AssetImage('images/icon.png'),
          width: 40.0,
          height: 40.0,
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            Common.appName(),
            style: const TextStyle(
              color: AppColors.primaryColorDark,
              overflow: TextOverflow.visible,
              fontWeight: FontWeight.w900,
              fontSize: 20.0,
              letterSpacing: -.3,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
      actions: const <Widget>[
        Image(
          image: AssetImage('images/logo.png'),
          height: 40.0,
          width: 70.0,
        ),
        SizedBox(width: 10.0),
      ],
      backgroundColor: AppColors.white,
      centerTitle: false,
    );
  }

  static AppBar appBarWithDrawer(
    final BuildContext context,
    final List<Widget>? appBarActions,
  ) {
    return AppBar(
      iconTheme: const IconThemeData(color: AppColors.secondaryColor),
      leading: Builder(
        builder: (final BuildContext context) => new IconButton(
          icon: const Icon(
            Icons.home,
            color: AppColors.secondaryColorDark,
            size: 45.0,
          ),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Flexible(
            child: Text(
              Common.appName(),
              style: const TextStyle(
                color: AppColors.primaryColorDark,
                overflow: TextOverflow.visible,
                fontWeight: FontWeight.w900,
                fontSize: 20.0,
                letterSpacing: -.3,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
      actions: appBarActions,
      backgroundColor: AppColors.white,
      centerTitle: false,
    );
  }

  static List<Widget> appBarActions(
    final BuildContext context,
    final User user,
  ) {
    final List<Widget> actions = <Widget>[];

    actions.add(
      const Padding(
        padding: EdgeInsets.only(left: 16.0),
        child: Image(
          image: AssetImage('images/atclogo.png'),
          height: 40.0,
          width: 70.0,
        ),
      ),
    );

    actions.add(
      const SizedBox(width: 10.0),
    );

    return actions;
  }

  // static List<Widget> imageCaptureAppBarActions(
  //   final BuildContext context,
  //   final user user,
  // ) {
  //   final List<Widget> actions = <Widget>[];
  //   actions.add(
  //     IconButton(
  //       icon: const Icon(
  //         Icons.contact_mail,
  //         color: AppColors.primaryColor,
  //       ),
  //       onPressed: () async {
  //         Navigator.of(context).push(
  //           PageRouteBuilder<Widget>(
  //             pageBuilder: (
  //               final BuildContext context,
  //               final Animation<double> animation,
  //               final _,
  //             ) {
  //               return new UserFeedbackPage(user);
  //             },
  //             opaque: false,
  //           ),
  //         );
  //       },
  //     ),
  //   );
  //
  //   actions.add(
  //     IconButton(
  //       icon: const Icon(
  //         Icons.info,
  //         color: AppColors.primaryColor,
  //       ),
  //       onPressed: () async {
  //         Navigator.of(context).push(
  //           PageRouteBuilder<Widget>(
  //             pageBuilder: (
  //               final BuildContext context,
  //               final Animation<double> animation,
  //               final _,
  //             ) {
  //               return new AboutPage(user);
  //             },
  //             opaque: false,
  //           ),
  //         );
  //       },
  //     ),
  //   );
  //
  //   return actions;
  // }
  //test

  static Widget header(final BuildContext context, final String actTitle) {
    return ColoredBox(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              actTitle,
              style: const TextStyle(
                fontSize: 25.0,
                color: AppColors.white,
                fontFamily: 'Anton',
                letterSpacing: 0.7,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
      color: Theme.of(context).colorScheme.primary,
    );
  }

  static BoxDecoration fieldBorderBottomOnly({required final bool enabled}) {
    return BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: enabled ? AppColors.black : AppColors.disabledColor,
        ),
      ),
    );
  }
}
