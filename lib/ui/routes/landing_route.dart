// import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_1/models/user.dart';
import 'package:project_1/utils/common/common.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingRoute extends StatefulWidget {
  const LandingRoute({Key? key}) : super(key: key);

  @override
  State<LandingRoute> createState() => _LandingRouteState();
}

class _LandingRouteState extends State<LandingRoute> {
  User? _loadeduser;
  String _progressMessage = 'Loading...';
  bool _isProgressLoading = true;

  @override
  void initState() {
    super.initState();
    _builduser();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

  Future<void> _builduser() async {
    // setState(() {
    //   _progressMessage = 'Loading...';
    //   _isProgressLoading = true;
    // });
    await Common.fileContentsByFileName(null, 'user.json')
        .then((final String contents) {
      SharedPreferences.getInstance()
          .then((final SharedPreferences prefs) async {
        if (contents != '' && !contents.contains('Null user')) {
          // setState(() {
          //   _progressMessage = 'Building user...';
          //   _isProgressLoading = true;
          // });
          _loadeduser =
              User.fromJson(jsonDecode(contents) as Map<String, dynamic>);
        }

        if (contents.contains('Null user')) {
          Common.deleteFile(null, 'driver.json');
          prefs.setBool('isAuthenticated', false);
          prefs.setBool('isGallery', false);
          _loadeduser = null;
          setState(() {
            _progressMessage = '';
            _isProgressLoading = false;
          });
        }

        if (contents.isEmpty) {
          prefs.setBool('isAuthenticated', false);
          prefs.setBool('isGallery', false);
          _loadeduser = null;
          setState(() {
            _progressMessage = '';
            _isProgressLoading = false;
          });
        }

        if (_loadeduser != null) {
          _navigateWithParams('home', _loadeduser);
        }
        // setState(() {});
      });
    });
  }

  Center _body() {
    return Center(
      child: Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _isProgressLoading == true
              ? Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: _progressIndicator(
                    _progressMessage,
                    _isProgressLoading,
                  ),
                )
              : Flex(
                  direction: Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        child: Text(
                          'Sign-Up',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontFamily: 'Anton',
                            fontStyle: FontStyle.italic,
                            letterSpacing: 0.5,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
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
                        onPressed: () => _navigate('sign_up'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        child: Text(
                          'Sign-In',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontFamily: 'Anton',
                            fontStyle: FontStyle.italic,
                            letterSpacing: 0.5,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
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
                        onPressed: () => _navigate('sign_in'),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Align _progressIndicator(String message, bool isLoading) {
    return Align(
      child: Common.progressIndicator(
        context,
        message,
        isLoading: isLoading,
      ),
    );
  }

  void _navigate(String path) {
    context.goNamed(path);
  }

  void _navigateWithParams(String path, dynamic params) {
    context.goNamed(path, extra: params);
  }
}
