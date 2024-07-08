import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_1/utils/common/common.dart';

class LandingRoute extends StatefulWidget {
  const LandingRoute({Key? key}) : super(key: key);

  @override
  State<LandingRoute> createState() => _LandingRouteState();
}

class _LandingRouteState extends State<LandingRoute> {
  String _progressMessage = 'Loading...';
  bool _isProgressLoading = false;
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
        "App Name",
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
      child: _isProgressLoading == true
          ? Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: _progressIndicator(
                _progressMessage,
                _isProgressLoading,
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _createUserButton(),
                _readUserButton(),
                _updateUserButton(),
                _deleteUserButton(),
              ],
            ),
    );
  }

  ElevatedButton _createUserButton() {
    return ElevatedButton(
      child: Text('Create User'),
      onPressed: () => _navigate('create_user'),
    );
  }

  ElevatedButton _deleteUserButton() {
    return ElevatedButton(
      child: Text('Delete User'),
      onPressed: () => _navigate('delete_user'),
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

  ElevatedButton _readUserButton() {
    return ElevatedButton(
      child: Text('Read User'),
      onPressed: () => _navigate('read_user'),
    );
  }

  ElevatedButton _updateUserButton() {
    return ElevatedButton(
      child: Text('Update User'),
      onPressed: () => _navigate('update_user'),
    );
  }

  void _navigate(String path) {
    context.goNamed(path);
  }

  void _navigateWithParams(String path, dynamic params) {
    context.goNamed(path, extra: params);
  }
}
