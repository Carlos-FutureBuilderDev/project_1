import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project_1/models/user.dart';
import 'package:project_1/ui/routes/edit_profile_route.dart';
import 'package:project_1/ui/routes/forgot_password_route.dart';
import 'package:project_1/ui/routes/home_route.dart';
import 'package:project_1/ui/routes/landing_route.dart';
import 'package:project_1/ui/routes/party_route.dart';
import 'package:project_1/ui/routes/preferences_route.dart';
import 'package:project_1/ui/routes/profile_route.dart';
import 'package:project_1/ui/routes/settings_route.dart';
import 'package:project_1/ui/routes/sign_in_route.dart';
import 'package:project_1/ui/routes/sign_up_route.dart';
import 'package:project_1/ui/themes/app_themes.dart';
import 'package:project_1/utils/common/common.dart';

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();

    // ignore: discarded_futures
    // _lockOrientation();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: Common.appName(),
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      theme: AppThemes.buildTheme(),
    );
  }

  final GoRouter _router = GoRouter(
    routes: <RouteBase>[
      // GoRoute(path: '/', builder: (BuildContext context, GoRouterState state) {return const HomePage();},),
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const LandingRoute();
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'home',
            name: 'home',
            builder: (BuildContext context, GoRouterState state) {
              User user = User();
              user = state.extra as User;

              return HomeRoute(
                user: user,
              );
              // return PartyRoute(
              //   // currentAddress: state.pathParameters['currentAddress'],
              //   User: state.pathParameters['User'],
              // );
            },
          ),
          GoRoute(
            path: 'sign_in',
            name: 'sign_in',
            builder: (BuildContext context, GoRouterState state) {
              return const SignInRoute();
            },
          ),
          GoRoute(
            path: 'forgot_password',
            name: 'forgot_password',
            builder: (BuildContext context, GoRouterState state) {
              return const ForgotPasswordRoute();
            },
          ),
          GoRoute(
            path: 'sign_up',
            name: 'sign_up',
            builder: (BuildContext context, GoRouterState state) {
              return const SignUpRoute();
            },
          ),
          GoRoute(
            path: 'profile',
            name: 'profile',
            builder: (BuildContext context, GoRouterState state) {
              List<Object> list = state.extra as List<Object>;
              User user = User();
              User viewedUser = User();
              user = list.first as User;
              viewedUser = list.last as User;

              return ProfileRoute(
                user: user,
                viewedUser: viewedUser,
              );
              // return ProfileRoute(
              //   User: state.pathParameters['User'],
              //   viewedUser: state.pathParameters['currentAddress'],
              // );
            },
          ),
          GoRoute(
            path: 'edit_profile',
            name: 'edit_profile',
            builder: (BuildContext context, GoRouterState state) {
              User user = User();
              user = state.extra as User;

              return EditProfileRoute(
                user: user,
              );
            },
          ),
          GoRoute(
            path: 'preferences',
            name: 'preferences',
            builder: (BuildContext context, GoRouterState state) {
              return const PreferencesRoute();
            },
          ),
          GoRoute(
            path: 'settings',
            name: 'settings',
            builder: (BuildContext context, GoRouterState state) {
              return const SettingsRoute();
            },
          ),
          GoRoute(
            path: 'party',
            name: 'party',
            builder: (BuildContext context, GoRouterState state) {
              User user = User();
              user = state.extra as User;

              return PartyRoute(
                user: user,
              );
              // return PartyRoute(
              //   // currentAddress: state.pathParameters['currentAddress'],
              //   User: state.pathParameters['User'],
              // );
            },
          ),
        ],
      ),
    ],
  );

  Future<void> _deleteCache() async {
    final Directory cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  Future<void> _deleteFiles() async {
    if (await Common.isOnline()) {
      _deleteSqliteDB();
      _deleteCache();
    }
  }

  Future<void> _deleteSqliteDB() async {
    getApplicationDocumentsDirectory().then((final Directory dir) async {
      String path = dir.path;
      if (path.substring(path.length - 1) == '/') {
        path += 'DB.sqlite';
      } else {
        path += '/DB.sqlite';
      }

      final bool fileExists = FileSystemEntity.isFileSync(path);
      if (fileExists) {
        File(path).deleteSync();
      }
    });
  }

  Future<void> _lockOrientation() async {
    //Lock portrait mode
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
