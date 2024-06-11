import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_1/models/user.dart';
import 'package:project_1/ui/home_drawer.dart';
import 'package:project_1/utils/common/common.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeRoute extends StatefulWidget {
  final User user;

  const HomeRoute({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<HomeRoute> createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    if (_user == null) {
      if (_user == null) {
        _buildUser();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawer(
        user: _user,
      ), //DRAWER
      appBar: _appBar(), //APP BAR
      backgroundColor: Colors.blue,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _body(),
      ), //BODY
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text(
        "project_1",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.blue,
      iconTheme: IconThemeData(
        color: Colors.orange,
      ),
    );
  }

  Center _body() {
    return Center(
      child: Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              child: Text(
                'Enter The Party',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontFamily: 'Anton',
                  fontStyle: FontStyle.italic,
                  letterSpacing: 0.5,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (final Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      //post-press
                      return Colors.orange;
                    } else {
                      //pre-press
                      return Colors.orange;
                    }
                  },
                ),
              ),
              onPressed: () => _navigateWithParams('party', _user),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _buildUser() async {
    await Common.fileContentsByFileName(null, 'user.json')
        .then((final String contents) {
      SharedPreferences.getInstance()
          .then((final SharedPreferences prefs) async {
        if (contents != '' && !contents.contains('Null User')) {
          _user = User.fromJson(jsonDecode(contents) as Map<String, dynamic>);
        }

        if (contents.contains('Null User')) {
          Common.deleteFile(null, 'driver.json');
          prefs.setBool('isAuthenticated', false);
          prefs.setBool('isGallery', false);
          _user = null;
        }

        if (contents.isEmpty) {
          prefs.setBool('isAuthenticated', false);
          prefs.setBool('isGallery', false);
          _user = null;
        }

        setState(() {});
      });
    });
  }

  void _navigate(String path) {
    context.goNamed(path);
  }

  void _navigateWithParams(String path, dynamic params) {
    context.goNamed(path, extra: params);
  }
}
