import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:project_1/models/user.dart';
import 'package:project_1/ui/themes/app_colors.dart';

class HomeDrawer extends StatefulWidget {
  final User? user;

  const HomeDrawer({Key? key, required this.user}) : super(key: key);

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  late User? _user;

  void initState() {
    super.initState();
    _user = widget.user;
  }

  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.orange,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(_user != null ? _user!.Username : ''),
            accountEmail: Text(
              _user != null ? _user!.Email! : '',
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.blue,
              child: ClipOval(
                // child: Icon(Icons.arrow_back),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Flex(
                    direction: Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.undo,
                        color: AppColors.darkOrange,
                      ),
                      Text(
                        'CLOSE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.0,
                          fontFamily: 'Anton',
                          fontStyle: FontStyle.italic,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: AppColors.darkOrange,
              // image: DecorationImage(
              //   image: AssetImage('assets/codelab.png'),
              //   fit: BoxFit.cover,
              // ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.favorite,
              color: Colors.blue,
            ),
            title: Text(
              'Favorites',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () => null,
          ),
          ListTile(
            leading: Icon(
              Icons.people,
              color: Colors.blue,
            ),
            title: Text(
              'Friends',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () => null,
          ),
          ListTile(
            leading: Icon(
              Icons.share,
              color: Colors.blue,
            ),
            title: Text(
              'Share',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () => null,
          ),
          ListTile(
            leading: Icon(
              Icons.notifications,
              color: Colors.blue,
            ),
            title: Text(
              'Request',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            trailing: ClipOval(
              child: Container(
                color: Colors.red,
                width: 20.0,
                height: 20.0,
                child: Center(
                  child: Text(
                    '7',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ),
            ),
            onTap: () => null,
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Colors.blue,
            ),
            title: Text(
              'Sign-In Screen',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () => _navigate('sign_in', null),
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Colors.blue,
            ),
            title: Text(
              'Sign-Up Screen',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () => _navigate('sign_up', null),
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Colors.blue,
            ),
            title: Text(
              'Forgot Password Screen',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () => _navigate('forgot_password', null),
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Colors.blue,
            ),
            title: Text(
              'Profile',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () => _navigateWithParams('profile', _user),
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Colors.blue,
            ),
            title: Text(
              'Edit Profile Screen',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () => _navigateWithParams('edit_profile', _user),
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Colors.blue,
            ),
            title: Text(
              'Preferences',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () => _navigate('preferences', null),
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Colors.blue,
            ),
            title: Text(
              'Settings',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () => _navigate('settings', null),
          ),
          ListTile(
            leading: Icon(
              Icons.description,
              color: Colors.blue,
            ),
            title: Text(
              'Policies',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () => null,
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Colors.blue,
            ),
            title: Text(
              'Sign Out',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () => _signOut(),
          ),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.blue,
            ),
            title: Text(
              'Exit',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () => _exit(),
          ),
        ],
      ),
    );
  }

  Future<void> _clearData() async {
    //TODO: FINISH IMPLEMENTATION
    // await FileSystemManager.deleteFile(null, 'user.json');
  }

  void _navigate(String path, dynamic params) {
    context.goNamed(path);
  }

  void _navigateWithParams(String path, dynamic params) {
    context.goNamed(path, extra: params);
  }

  Future<void> _exit() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (final BuildContext context) => new AlertDialog(
        title: Text(
          'Are you sure you want to exit the app?',
        ),
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: AppColors.red8,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: Text(
              'No',
              style: const TextStyle(
                color: AppColors.white,
              ),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (final Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    //post-press
                    return AppColors.red8;
                  } else {
                    //pre-press
                    return AppColors.declineRed;
                  }
                },
              ),
            ),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            child: Text(
              'Yes',
              style: const TextStyle(
                color: AppColors.white,
              ),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (final Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    //post-press
                    return AppColors.acceptButtonPressed;
                  } else {
                    //pre-press
                    return AppColors.acceptGreen;
                  }
                },
              ),
            ),
            onPressed: () => SystemNavigator.pop(),
          ),
        ],
      ),
    );
  }

  Future<void> _signOut() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (final BuildContext context) => new AlertDialog(
        title: Text(
          'Are you sure you want to sign out and clear data on this device?',
        ),
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: AppColors.red8,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: Text(
              'No',
              style: const TextStyle(
                color: AppColors.white,
              ),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (final Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    //post-press
                    return AppColors.red8;
                  } else {
                    //pre-press
                    return AppColors.declineRed;
                  }
                },
              ),
            ),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            child: Text(
              'Yes',
              style: const TextStyle(
                color: AppColors.white,
              ),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (final Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    //post-press
                    return AppColors.acceptButtonPressed;
                  } else {
                    //pre-press
                    return AppColors.acceptGreen;
                  }
                },
              ),
            ),
            onPressed: () async {
              _clearData();
              SystemNavigator.pop();
            },
          ),
        ],
      ),
    );
  }
}
