import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_1/models/user.dart';
import 'package:project_1/ui/themes/app_colors.dart';

import '../../api/user_api.dart';

class CreateUserRoute extends StatefulWidget {
  const CreateUserRoute({Key? key}) : super(key: key);

  @override
  State<CreateUserRoute> createState() => _CreateUserRouteState();
}

class _CreateUserRouteState extends State<CreateUserRoute> {
  final GlobalKey<FormState> _createUserFormKey =
      new GlobalKey<FormState>(debugLabel: '_signUpFormKey');
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  final TextEditingController _usernameController = TextEditingController();
  final FocusNode _usernameFocusNode = FocusNode();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
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
    _emailController.dispose();
    _emailFocusNode.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
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
        "Create new user",
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
      key: _createUserFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, top: 8.0, right: 16.0, bottom: 8.0),
            child: _username(),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, top: 8.0, right: 16.0, bottom: 8.0),
            child: _password(),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, top: 8.0, right: 16.0, bottom: 8.0),
            child: _confirmPassword(),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, top: 8.0, right: 16.0, bottom: 8.0),
            child: _email(),
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
                  'Create user',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontFamily: 'Anton',
                    fontStyle: FontStyle.italic,
                    letterSpacing: 0.5,
                  ),
                ),
                onPressed: () => _createUser(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextFormField _confirmPassword() {
    return TextFormField(
      obscureText: true,
      focusNode: _confirmPasswordFocusNode,
      controller: _confirmPasswordController,
      decoration: InputDecoration(
        fillColor: Colors.transparent,
        labelText: 'Confirm Password',
        labelStyle: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontFamily: 'Anton',
          fontStyle: FontStyle.italic,
          letterSpacing: 0.5,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: AppColors.lightOrange),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: AppColors.lightOrange),
        ),
      ),
      style: TextStyle(
        color: Colors.white,
      ),
      validator: (String? text) {
        if (text != _user.Password) {
          return 'Passwords do not match';
        }

        return null;
      },
      onSaved: (final String? savedValue) {
        if (savedValue != null) {
          setState(() {
            _user.Password = savedValue;
          });
        }
      },
    );
  }

  TextFormField _email() {
    return TextFormField(
      focusNode: _emailFocusNode,
      controller: _emailController,
      decoration: InputDecoration(
        fillColor: Colors.transparent,
        labelText: 'Email',
        labelStyle: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontFamily: 'Anton',
          fontStyle: FontStyle.italic,
          letterSpacing: 0.5,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: AppColors.lightOrange),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: AppColors.lightOrange),
        ),
      ),
      style: TextStyle(
        color: Colors.white,
      ),
      validator: (String? text) {
        if (text == null || text.isEmpty) {
          return 'Required';
        }

        if (!RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(text)) {
          return 'Not a valid email address';
        }

        return null;
      },
      onChanged: (final String changedValue) {
        _user.Email = changedValue;
      },
      onSaved: (final String? savedValue) {
        if (savedValue != null) {
          setState(() {
            _user.Email = savedValue;
          });
        }
      },
    );
  }

  TextFormField _password() {
    return TextFormField(
      obscureText: true,
      focusNode: _passwordFocusNode,
      controller: _passwordController,
      decoration: InputDecoration(
        fillColor: Colors.transparent,
        labelText: 'Password',
        labelStyle: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontFamily: 'Anton',
          fontStyle: FontStyle.italic,
          letterSpacing: 0.5,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: AppColors.lightOrange),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: AppColors.lightOrange),
        ),
      ),
      style: TextStyle(
        color: Colors.white,
      ),
      onChanged: (final String changedValue) {
        _user.Password = changedValue;
      },
    );
  }

  void _createUser() {
    if (_createUserFormKey.currentState!.validate()) {
      UserAPI userAPI = UserAPI();
      userAPI
          .createUser(_user)
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
