// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_1/api/user_api.dart';
import 'package:project_1/models/user.dart';
import 'package:project_1/ui/themes/app_colors.dart';
import 'package:project_1/utils/common/common.dart';

import '../../models/user_login.dart';

class SignInRoute extends StatefulWidget {
  const SignInRoute({Key? key}) : super(key: key);

  @override
  State<SignInRoute> createState() => _SignInRouteState();
}

class _SignInRouteState extends State<SignInRoute> {
  final GlobalKey<FormState> _signInFormKey =
      new GlobalKey<FormState>(debugLabel: '_signInFormKey');
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();
  final TextEditingController _usernameController = TextEditingController();
  final FocusNode _usernameFocusNode = FocusNode();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  UserLogin _userLogin = UserLogin();

  @override
  void initState() {
    super.initState();
    // _userLogin.username = _usernameController.text = 'loswitthemost';
    // _userLogin.password = _passwordController.text = 'PasswordTest123';
  }

  @override
  void dispose() {
    _messageController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(), //APP BAR
      backgroundColor: Colors.blue,
      body: _signInForm(), //BODY
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text(
        "Welcome back!",
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

  Form _signInForm() {
    return Form(
      key: _signInFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, top: 16.0, right: 16.0, bottom: 16.0),
            child: _username(),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, top: 16.0, right: 16.0, bottom: 16.0),
            child: _password(),
          ),
          Flexible(
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
              child: Text(
                'Sign In',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontFamily: 'Anton',
                  fontStyle: FontStyle.italic,
                  letterSpacing: 0.5,
                ),
              ),
              onPressed: () => _signIn(),
            ),
          )
        ],
      ),
    );
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
        _userLogin.username = changedValue;
      },
      onSaved: (final String? savedValue) {
        if (savedValue != null) {
          setState(() {
            _userLogin.username = savedValue;
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
      validator: (String? text) {
        if (text == null || text.isEmpty) {
          return 'Required';
        }

        if (text.length < 8) {
          return 'Must be more than 8 characters';
        }

        if (text.length > 25) {
          return 'Must be less than 25 characters';
        }

        if (!text.contains(RegExp('[0-9]'))) {
          return 'Must contain at least one number';
        }

        if (!text.contains(RegExp('[a-z]'))) {
          return 'Must contain at least one lowercase letter';
        }

        if (!text.contains(RegExp('[A-Z]'))) {
          return 'Must contain at least one uppercase letter';
        }

        return null;
      },
      onChanged: (final String changedValue) {
        _userLogin.password = changedValue;
      },
      onSaved: (final String? savedValue) {
        if (savedValue != null) {
          setState(() {
            _userLogin.password = savedValue;
          });
        }
      },
    );
  }

  void _signIn() {
    if (_signInFormKey.currentState!.validate()) {
      UserAPI userAPI = UserAPI();
      userAPI.userLogin(_userLogin).then((final dynamic response) {
        if (response.runtimeType == User) {
          _navigateWithParams('home', response);
        } else {
          Common.displayDialog(context, 'Error', response);
        }
      });
    }
  }

  void _navigateWithParams(String path, dynamic params) {
    context.goNamed(path, extra: params);
  }
}
