// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_1/models/user.dart';

class ForgotPasswordRoute extends StatefulWidget {
  const ForgotPasswordRoute({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordRoute> createState() => _ForgotPasswordRouteState();
}

class _ForgotPasswordRouteState extends State<ForgotPasswordRoute> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  late User _user;
  String _email = '';

  @override
  void initState() {
    super.initState();
    _user = User();
    _user.Username = 'Carlos Degollado';
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
      body: _body(), //BODY
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text(
        "Forgot Password?",
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
        Text(
          'To reset your password, enter your email address.',
          style: TextStyle(
            color: Colors.black,
            fontSize: 13.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              left: 16.0, top: 8.0, right: 16.0, bottom: 8.0),
          child: _emailField(),
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
              onPressed: () => _submitEmail(),
              child: Text(
                'Submit',
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

  TextFormField _emailField() {
    return TextFormField(
      focusNode: _emailFocusNode,
      controller: _emailController,
      decoration: InputDecoration(
        fillColor: Colors.transparent,
        labelText: 'Email',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      style: TextStyle(
        color: Colors.grey,
      ),
      onChanged: (String text) => setState(() {
        _email = text;
      }),
      onSaved: (String? text) => setState(() {
        _email = text!;
      }),
      validator: (String? text) {
        if (text == null || text.isEmpty) {
          return 'Required';
        }

        if (!RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(text)) {
          return 'Not a valid email address';
        }

        return null;
      },
    );
  }

  void _submitEmail() {
    //TODO: Submit email function
  }
}
