// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_1/models/user.dart';
import 'package:project_1/ui/themes/app_colors.dart';

class CreateUserRoute extends StatefulWidget {
  const CreateUserRoute({Key? key}) : super(key: key);

  @override
  State<CreateUserRoute> createState() => _CreateUserRouteState();
}

class _CreateUserRouteState extends State<CreateUserRoute> {
  final GlobalKey<FormState> _signUpFormKey =
      new GlobalKey<FormState>(debugLabel: '_signUpFormKey');
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();
  final TextEditingController _firstNameController = TextEditingController();
  final FocusNode _firstNameFocusNode = FocusNode();
  final TextEditingController _lastNameController = TextEditingController();
  final FocusNode _lastNameFocusNode = FocusNode();
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();
  final TextEditingController _ageController = TextEditingController();
  final FocusNode _ageFocusNode = FocusNode();
  final TextEditingController _interestsController = TextEditingController();
  final FocusNode _interestsFocusNode = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  final TextEditingController _usernameController = TextEditingController();
  final FocusNode _usernameFocusNode = FocusNode();
  final TextEditingController _bioController = TextEditingController();
  final FocusNode _bioFocusNode = FocusNode();
  final TextEditingController _cityOfBirthController = TextEditingController();
  final FocusNode _cityOfBirthFocusNode = FocusNode();
  final TextEditingController _stateOfBirthController = TextEditingController();
  final FocusNode _stateOfBirthFocusNode = FocusNode();
  final TextEditingController _sexController = TextEditingController();
  final FocusNode _sexFocusNode = FocusNode();
  final TextEditingController _pronounController = TextEditingController();
  final FocusNode _pronounFocusNode = FocusNode();
  final TextEditingController _preferenceController = TextEditingController();
  final FocusNode _preferenceFocusNode = FocusNode();
  final TextEditingController _westernZodiacController =
      TextEditingController();
  final FocusNode _westernZodiacFocusNode = FocusNode();
  final TextEditingController _chineseZodiacController =
      TextEditingController();
  final FocusNode _chineseZodiacFocusNode = FocusNode();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
  late User _user;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _user = User();
    // _user.Username = _usernameController.text = 'loswitthemost';
    // _user.Password = _passwordController.text = 'PasswordTest123';
    // _user.DateOfBirth = _selectedDate = (DateTime(1988, 8, 31));
    // _user.FirstName = _firstNameController.text = 'Carlos';
    // _user.LastName = _lastNameController.text = 'Degollado';
    // _user.Phone = _phoneController.text = '3125555555';
    // _user.Email = _emailController.text = 'carlos@email.com';
    // _user.Age = 35;
    // _ageController.text = '35';
    // _user.WesternZodiacSignID = 1;
    // _westernZodiacController.text = '1';
    // _user.ChineseZodiacSignID = 1;
    // _chineseZodiacController.text = '1';
    // _user.Bio = _bioController.text = 'Hello world!';
    // _user.CityOfBirth = _cityOfBirthController.text = 'Hammond';
    // _user.StateOfBirth = _stateOfBirthController.text = 'Indiana';
    // _user.PronounTypeID = 1;
    // _pronounController.text = '1';
    // _user.Sex = _sexController.text = 'Male';
    // _user.PreferenceTypeID = 1;
    // _preferenceController.text = '1';
    // _user.Interests = _interestsController.text = 'coding~';
  }

  @override
  void dispose() {
    _messageController.dispose();
    _messageFocusNode.dispose();
    _firstNameController.dispose();
    _firstNameFocusNode.dispose();
    _lastNameController.dispose();
    _lastNameFocusNode.dispose();
    _ageController.dispose();
    _ageFocusNode.dispose();
    _usernameController.dispose();
    _usernameFocusNode.dispose();
    _bioController.dispose();
    _bioFocusNode.dispose();
    _confirmPasswordController.dispose();
    _confirmPasswordFocusNode.dispose();
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    _interestsController.dispose();
    _interestsFocusNode.dispose();
    _emailController.dispose();
    _emailFocusNode.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    _cityOfBirthController.dispose();
    _cityOfBirthFocusNode.dispose();
    _stateOfBirthController.dispose();
    _stateOfBirthFocusNode.dispose();
    _sexController.dispose();
    _sexFocusNode.dispose();
    _pronounController.dispose();
    _pronounFocusNode.dispose();
    _preferenceController.dispose();
    _preferenceFocusNode.dispose();
    _westernZodiacController.dispose();
    _westernZodiacFocusNode.dispose();
    _chineseZodiacController.dispose();
    _chineseZodiacFocusNode.dispose();
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
        "Join the Party!",
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
      key: _signUpFormKey,
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
                  'Become a user',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontFamily: 'Anton',
                    fontStyle: FontStyle.italic,
                    letterSpacing: 0.5,
                  ),
                ),
                onPressed: null,
                // onPressed: () => _signUp(),
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

        if (text != _user.Password) {
          return 'Passwords do not match';
        }

        return null;
      },
      // onChanged: (final String changedValue) {
      //   _user.password = changedValue;
      // },
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

  // TextFormField _gender() {
  //   return TextFormField(
  //     // focusNode: _lastNameFocusNode,
  //     // controller: _lastNameController,
  //     decoration: InputDecoration(
  //       fillColor: Colors.transparent,
  //       labelText: 'Gender',
  //       border: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(10.0),
  //         borderSide: BorderSide(color: Colors.grey),
  //       ),
  //       focusedBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(10.0),
  //         borderSide: BorderSide(color: Colors.blue),
  //       ),
  //     ),
  //     style: TextStyle(
  //       color: Colors.white,
  //     ),
  //     textInputAction: TextInputAction.next,
  //     validator: (String? text) {
  //       if (text == null || text.isEmpty) {
  //         return 'Required';
  //       }
  //
  //       return null;
  //     },
  //     // onChanged: (final String changedValue) {
  //     //   _user.gender = changedValue;
  //     // },
  //     // onSaved: (final String? savedValue) {
  //     //   if (savedValue != null) {
  //     //     setState(() {
  //     //       _user.gender = savedValue;
  //     //     });
  //     //   }
  //     // },
  //   );
  // }

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
        _user.Password = changedValue;
      },
      // onSaved: (final String? savedValue) {
      //   if (savedValue != null) {
      //     setState(() {
      //       _user.password = savedValue;
      //     });
      //   }
      // },
    );
  }

  // void _signUp() {
  //   if (_signUpFormKey.currentState!.validate()) {
  //     UserAPI userAPI = UserAPI();
  //     userAPI
  //         .createUser(_user)
  //         .then((final dynamic response) => _navigate('sign_in'));
  //   }
  // }

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
