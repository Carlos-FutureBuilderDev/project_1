// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_1/models/user.dart';

class ProfileRoute extends StatefulWidget {
  final User user;
  final User viewedUser;

  const ProfileRoute({
    Key? key,
    required this.user,
    required this.viewedUser,
  }) : super(key: key);

  @override
  State<ProfileRoute> createState() => _ProfileRouteState();
}

class _ProfileRouteState extends State<ProfileRoute> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocus = FocusNode();
  late User _user;
  late User _viewedUser;
  String _currentAddress = 'test_3';

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _viewedUser = widget.viewedUser;
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
      backgroundColor: Colors.orange,
      body: _body(), //BODY
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text(
        "Profile",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.blue,
      iconTheme: IconThemeData(
        color: Colors.orange,
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => _navigateWithObject('party', _user),
      ),
    );
  }

  Flex _body() {
    return Flex(
      direction: Axis.vertical,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              Flexible(
                flex: 2,
                child: Image.asset(_viewedUser.ProfilePicPath!),
              ),
              const Divider(
                color: Colors.black,
              ),
              Flexible(
                flex: 4,
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        _viewedUser.Username,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        'subtitle',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'subtitle 2',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(
          color: Colors.black,
        ),
        Flex(
          direction: Axis.vertical,
          children: [
            Center(
              child: Text(
                'Bio\n',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Text(
              'body',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ],
    );
  }

  ///NAVIGATION///
  void _navigate(String path) {
    context.goNamed(path);
  }

  void _navigateWithObject(String path, dynamic object) {
    context.goNamed(path, extra: object);
  }
}
