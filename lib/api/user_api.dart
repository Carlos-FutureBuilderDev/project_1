import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:project_1/models/user.dart';
// import 'package:project_1/models/user_login.dart';
import 'package:project_1/utils/common/common.dart';
import 'package:project_1/utils/error/error.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAPI {
  late String _url;

  UserAPI() {
    _url = Common.baseUrl();
  }

  Future<dynamic> getValues() async {
    print('userAPI - getValues()');
    if (await Common.isOnline()) {
      final Map<String, String> headers = new Map<String, String>();
      headers['Connection'] = 'keep-alive';
      headers['ConnectionTimeout'] = '60000';
      headers['Accept'] = 'application/json';

      try {
        final Response response = await get(
          Uri.parse(
            _url + '/Values',
          ),
          headers: headers,
        );
        if (response.statusCode == 200) {
          final String jsonString = response.body;
          if (jsonString.contains('Message Failed') ||
              jsonString.contains('Failed')) {
            final Error error = new Error.fromJson(
              jsonDecode(jsonString) as Map<String, dynamic>,
            );
            print(error.message);
            return error;
          }

          if (jsonString.contains('No user found')) {
            final Error error = new Error.fromJson(
              jsonDecode(jsonString) as Map<String, dynamic>,
            );
            print(error.message);
            return error;
          }

          // if (jsonString.contains('Text Sent')) {
          //   final SharedPreferences prefs = await SharedPreferences.getInstance();
          //   prefs.setBool('txtSent', true);
          //   return null;
          // }
        } else {
          print('Error occurred: Status Code ${response.statusCode}');
          return null;
        }
      } on Exception catch (e) {
        print(e);
        return null;
      }
    } else {
      print('Network offline');
      return null;
    }
  }

  Future<dynamic> getUserValues() async {
    print('userAPI - getuserValues()');
    if (await Common.isOnline()) {
      final Map<String, String> headers = new Map<String, String>();
      headers['Connection'] = 'keep-alive';
      headers['ConnectionTimeout'] = '60000';
      headers['Accept'] = 'application/json';

      try {
        final Response response = await get(
          Uri.parse(
            _url + '/user/Values',
          ),
          headers: headers,
        );
        if (response.statusCode == 200) {
          final String jsonString = response.body;
          if (jsonString.contains('Message Failed') ||
              jsonString.contains('Failed')) {
            final Error error = new Error.fromJson(
              jsonDecode(jsonString) as Map<String, dynamic>,
            );
            print(error.message);
            return error;
          }

          if (jsonString.contains('No user found')) {
            final Error error = new Error.fromJson(
              jsonDecode(jsonString) as Map<String, dynamic>,
            );
            print(error.message);
            return error;
          }

          // if (jsonString.contains('Text Sent')) {
          //   final SharedPreferences prefs = await SharedPreferences.getInstance();
          //   prefs.setBool('txtSent', true);
          //   return null;
          // }
        } else {
          print('Error occurred: Status Code ${response.statusCode}');
          return null;
        }
      } on Exception catch (e) {
        print(e);
        return null;
      }
    }

    // Future<dynamic> userLogin(UserLogin userLogin) async {
    //   print('userAPI - userLogin()');
    //   if (await Common.isOnline()) {
    //     final Map<String, String> headers = new Map<String, String>();
    //     headers['Connection'] = 'keep-alive';
    //     headers['Content-Type'] = 'application/json';
    //     headers['ConnectionTimeout'] = '60000';
    //     headers['Accept'] = 'application/json';
    //
    //     try {
    //       final String json = jsonEncode(userLogin);
    //       print(json);
    //
    //       final Response response = await post(
    //         Uri.parse(
    //           _url + '/Auth/PostuserLogin/',
    //         ),
    //         headers: headers,
    //         body: jsonEncode(userLogin),
    //       );
    //       if (response.statusCode == 200) {
    //         final List<String> split = response.body.split('^');
    //
    //         String clipped = split[0].replaceAll('\"', '');
    //
    //         SharedPreferences.getInstance()
    //             .then((final SharedPreferences sharedPreferences) {
    //           sharedPreferences.setString('API_KEY', clipped);
    //           return 'Success';
    //         });
    //
    //         final String jsonString = split[1].replaceAll('\\', '');
    //         final String clippedJsonString =
    //             jsonString.substring(0, jsonString.length - 1);
    //
    //         final User user = User.fromJson(
    //           jsonDecode(clippedJsonString) as Map<String, dynamic>,
    //         );
    //
    //         Common.saveFile(clippedJsonString, null, 'user.json');
    //
    //         final String encoded = jsonEncode(user);
    //         print(encoded);
    //
    //         return user;
    //       } else {
    //         print(
    //             'Error occurred: Status Code ${response.statusCode}, Message ${response.body}');
    //         return null;
    //       }
    //     } on Exception catch (e) {
    //       print(e);
    //       return null;
    //     }
    //   } else {
    //     print('Network offline');
    //     return null;
    //   }
    // }

    Future<dynamic> getuserByuserID(int id) async {
      print('userAPI - getuserByuserID()');
      if (await Common.isOnline()) {
        // storage.read(key: 'key').then((final String? key) async {
        SharedPreferences.getInstance()
            .then((final SharedPreferences sharedPreferences) async {
          final Map<String, String> headers = new Map<String, String>();
          headers['Connection'] = 'keep-alive';
          headers['ConnectionTimeout'] = '60000';
          headers['Accept'] = 'application/json';

          try {
            final Response response = await get(
              Uri.parse(
                _url + '/user/GetuserByID?userID=' + id.toString(),
              ),
              headers: headers,
            );
            if (response.statusCode == 200) {
              final String jsonString = response.body;

              final User user = new User.fromJson(
                jsonDecode(jsonString) as Map<String, dynamic>,
              );

              Common.saveFile(jsonString, null, 'user.json');

              final String encoded = jsonEncode(user);
              print(encoded);

              return user;

              // if (jsonString.contains('Message Failed') ||
              //     jsonString.contains('Failed')) {
              //   final Error error = new Error.fromJson(
              //     jsonDecode(jsonString) as Map<String, dynamic>,
              //   );
              //   print(error.message);
              //   return error;
              // }
              //
              // if (jsonString.contains('No user found')) {
              //   final Error error = new Error.fromJson(
              //     jsonDecode(jsonString) as Map<String, dynamic>,
              //   );
              //   print(error.message);
              //   return error;
              // }

              // if (jsonString.contains('Text Sent')) {
              //   final SharedPreferences prefs = await SharedPreferences.getInstance();
              //   prefs.setBool('txtSent', true);
              //   return null;
              // }
            } else {
              print('Error occurred: Status Code ${response.statusCode}');
              return null;
            }
          } on Exception catch (e) {
            print(e);
            return null;
          }
        });
        // });
        // } else {
        //   print('Network offline');
        //   return null;
        // }
      }
    }

    Future<dynamic> newUser(final User user) async {
      print('UserAPI - newUser()');
      if (await Common.isOnline()) {
        final Map<String, String> headers = new Map<String, String>();
        headers['Connection'] = 'keep-alive';
        headers['Content-Type'] = 'application/json';
        headers['ConnectionTimeout'] = '60000';
        headers['Accept'] = 'application/json';

        try {
          final String json = jsonEncode(user);
          print(json);

          final Response response = await post(
            Uri.parse(
              _url + '/Auth/PostAdduser/',
            ),
            headers: headers,
            body: jsonEncode(user),
          );
          if (response.statusCode == 200) {
            final String jsonString = response.body;

            String clipped = jsonString.replaceAll('\"', '');

            SharedPreferences.getInstance()
                .then((final SharedPreferences sharedPreferences) {
              sharedPreferences.setString('API_KEY', clipped);
              return 'Success';
            });

            FlutterSecureStorage storage = new FlutterSecureStorage();
            storage.write(key: 'key', value: clipped);

            if (jsonString.contains('Message Failed') ||
                jsonString.contains('Failed')) {
              final Error error = new Error.fromJson(
                jsonDecode(jsonString) as Map<String, dynamic>,
              );
              print(error.message);
              return 'Fail';
            }

            if (jsonString.contains('Error adding user')) {
              final Error error = new Error.fromJson(
                jsonDecode(jsonString) as Map<String, dynamic>,
              );
              print(error.message);
              return 'Fail';
            }

            // if (jsonString.contains('Text Sent')) {
            //   final SharedPreferences prefs = await SharedPreferences.getInstance();
            //   prefs.setBool('txtSent', true);
            //   return null;
            // }
          } else {
            print(
                'Error occurred: Status Code ${response.statusCode}, Message ${response.body}');
            return 'Fail';
          }
        } on Exception catch (e) {
          print(e);
          return 'Fail';
        }
      } else {
        print('Network offline');
        return 'Fail';
      }
    }
  }
}
