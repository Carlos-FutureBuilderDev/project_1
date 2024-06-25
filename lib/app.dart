import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_1/ui/routes/create_user_route.dart';
import 'package:project_1/ui/routes/delete_user_route.dart';
import 'package:project_1/ui/routes/landing_route.dart';
import 'package:project_1/ui/routes/read_user_route.dart';
import 'package:project_1/ui/routes/update_user_route.dart';
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
            path: 'create_user',
            name: 'create_user',
            builder: (BuildContext context, GoRouterState state) {
              return const CreateUserRoute();
            },
          ),
          GoRoute(
            path: 'read_user',
            name: 'read_user',
            builder: (BuildContext context, GoRouterState state) {
              return const ReadUserRoute();
            },
          ),
          GoRoute(
            path: 'update_user',
            name: 'update_user',
            builder: (BuildContext context, GoRouterState state) {
              return const UpdateUserRoute();
            },
          ),
          GoRoute(
            path: 'delete_user',
            name: 'delete_user',
            builder: (BuildContext context, GoRouterState state) {
              return const DeleteUserRoute();
            },
          ),
        ],
      ),
    ],
  );
}
