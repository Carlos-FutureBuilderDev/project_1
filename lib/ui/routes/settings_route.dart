// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_1/models/user.dart';

class SettingsRoute extends StatefulWidget {
  const SettingsRoute({Key? key}) : super(key: key);

  @override
  State<SettingsRoute> createState() => _SettingsRouteState();
}

class _SettingsRouteState extends State<SettingsRoute> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocus = FocusNode();
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = User();
    _user.Username = 'Carlos Degollado';
  }

  @override
  void dispose() {
    _messageController.dispose();
    _messageFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(), //APP BAR
      backgroundColor: Colors.blue,
      body: _body(), //BODY
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text(
        "Settings",
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

  Flex _body() {
    return Flex(
      direction: Axis.vertical,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, top: 8.0, right: 16.0, bottom: 8.0),
              child: TextFormField(),
            ),
          ),
        ),
        Flexible(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, top: 8.0, right: 16.0, bottom: 8.0),
              child: TextFormField(),
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToSignInPage() {
    context.go('sign-in');
  }
}
