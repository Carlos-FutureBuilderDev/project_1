import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_1/api/user_api.dart';
import 'package:project_1/models/user.dart';
import 'package:project_1/ui/themes/app_colors.dart';

class DeleteUserRoute extends StatefulWidget {
  const DeleteUserRoute({Key? key}) : super(key: key);

  @override
  State<DeleteUserRoute> createState() => _DeleteUserRouteState();
}

class _DeleteUserRouteState extends State<DeleteUserRoute> {
  final GlobalKey<FormState> _deleteUserFormKey =
      new GlobalKey<FormState>(debugLabel: '_signUpFormKey');
  final TextEditingController _usernameController = TextEditingController();
  final FocusNode _usernameFocusNode = FocusNode();
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = User();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _usernameFocusNode.dispose();
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
        "Delete User",
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

  Form _body() {
    return Form(
      key: _deleteUserFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, top: 8.0, right: 16.0, bottom: 8.0),
            child: _username(),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color>(
                    (final Set<WidgetState> states) {
                      if (states.contains(WidgetState.pressed)) {
                        //post-press
                        return Colors.orange;
                      } else {
                        //pre-press
                        return Colors.orange;
                      }
                    },
                  ),
                ),
                child: Text(
                  'Delete user',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontFamily: 'Anton',
                    fontStyle: FontStyle.italic,
                    letterSpacing: 0.5,
                  ),
                ),
                onPressed: () => _deleteUser(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteUser() {
    if (_deleteUserFormKey.currentState!.validate()) {
      UserAPI userAPI = UserAPI();
      userAPI
          .deleteUserByUsername(_user.Username!)
          .then((final dynamic response) => Navigator.pop(context));
    }
  }

  TextFormField _username() {
    return TextFormField(
      focusNode: _usernameFocusNode,
      controller: _usernameController,
      decoration: InputDecoration(
        fillColor: Colors.transparent,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: AppColors.lightOrange),
        ),
        labelText: 'Username',
        labelStyle: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontFamily: 'Anton',
          fontStyle: FontStyle.italic,
          letterSpacing: 0.5,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: AppColors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: AppColors.lightOrange),
        ),
      ),
      style: TextStyle(
        color: Colors.white,
      ),
      textInputAction: TextInputAction.next,
      validator: (String? text) {
        if (text == null || text.isEmpty) {
          return 'Required';
        }

        return null;
      },
      onChanged: (final String changedValue) {
        _user.Username = changedValue;
      },
      onSaved: (final String? savedValue) {
        if (savedValue != null) {
          setState(() {
            _user.Username = savedValue;
          });
        }
      },
    );
  }

  ///NAVIGATION///
  void _navigate(String path) {
    context.goNamed(path);
  }
}
