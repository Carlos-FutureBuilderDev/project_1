// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_1/models/user.dart';
import 'package:project_1/models/user_image.dart';
import 'package:project_1/ui/routes/photo_grid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileRoute extends StatefulWidget {
  final User user;

  const EditProfileRoute({Key? key, required this.user}) : super(key: key);

  @override
  State<EditProfileRoute> createState() => _EditProfileRouteState();
}

class _EditProfileRouteState extends State<EditProfileRoute> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocus = FocusNode();
  late User _user;
  List<UserImage>? _photos;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _user.Username = 'username';
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
        "Edit Profile",
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
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
            ),
          ),
        ),
        Flexible(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, top: 8.0, right: 16.0, bottom: 8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
            ),
          ),
        ),
        Flexible(
          child: Center(
            child: ElevatedButton(
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
              onPressed: () => _navigateToPhotoGrid(),
              child: Text(
                'Manage Photos',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontFamily: 'Anton',
                  fontStyle: FontStyle.italic,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Future<void> _navigateToPhotoGrid() async {
    final List<UserImage>? result = await Navigator.of(context).push(
      PageRouteBuilder<List<UserImage>>(
        pageBuilder: (
          final BuildContext context,
          final Animation<double> animation,
          final _,
        ) {
          return new PhotoGrid(_user);
        },
        opaque: false,
      ),
    );

    if (result != null) {
      _photos = result;
    } else {
      SharedPreferences.getInstance().then((final SharedPreferences prefs) {
        prefs.setBool('PrivacyPolicyAccepted', false);
      });
    }
  }
}
