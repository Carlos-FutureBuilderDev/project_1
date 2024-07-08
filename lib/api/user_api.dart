import 'dart:convert';

import 'package:http/http.dart';
import 'package:project_1/models/user.dart';
import 'package:project_1/utils/common/common.dart';
import 'package:project_1/utils/error/error.dart';

class UserAPI {
  late String _url;

  UserAPI() {
    _url = Common.baseUrl();
  }

  Future<dynamic> createUser(final User user) async {
    print('UserAPI - createUser()');
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
            _url + '/User/PostAddUser/',
          ),
          headers: headers,
          body: jsonEncode(user),
        );
        if (response.statusCode == 200) {
          final String jsonString = response.body;

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

  Future<dynamic> readUserByUsername(final String username) async {
    print('UserAPI - readUserByUsername()');
    if (await Common.isOnline()) {
      final Map<String, String> headers = new Map<String, String>();
      headers['Connection'] = 'keep-alive';
      headers['Content-Type'] = 'application/json';
      headers['ConnectionTimeout'] = '60000';
      headers['Accept'] = 'application/json';

      try {
        final Response response = await get(
          Uri.parse(
            _url + '/User/GetUserByUsername?username=$username',
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
            return 'Fail';
          }

          if (jsonString.contains('Error adding user')) {
            final Error error = new Error.fromJson(
              jsonDecode(jsonString) as Map<String, dynamic>,
            );
            print(error.message);
            return 'Fail';
          }

          //TODO: Figure out why object won't populate
          // User user = new User.fromJson(
          //   jsonDecode(jsonString) as Map<String, dynamic>,
          // );

          var decoded = jsonDecode(jsonString);
          print(decoded);

          User user = User();
          user.UserID = decoded["userID"];
          user.Username = decoded["username"];
          user.Email = decoded["email"];

          return user;
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

  Future<dynamic> updateUser(final User user) async {
    print('UserAPI - updateUser()');
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
            _url + '/User/PostUpdateUser/',
          ),
          headers: headers,
          body: jsonEncode(user),
        );
        if (response.statusCode == 200) {
          final String jsonString = response.body;

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

  Future<dynamic> deleteUserByUsername(final String username) async {
    print('UserAPI - deleteUserByUsername()');
    if (await Common.isOnline()) {
      final Map<String, String> headers = new Map<String, String>();
      headers['Connection'] = 'keep-alive';
      headers['Content-Type'] = 'application/json';
      headers['ConnectionTimeout'] = '60000';
      headers['Accept'] = 'application/json';

      try {
        final Response response = await post(
          Uri.parse(
            _url + '/User/PostDeleteUserByUsername?username=$username',
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
            return 'Fail';
          }

          if (jsonString.contains('Error adding user')) {
            final Error error = new Error.fromJson(
              jsonDecode(jsonString) as Map<String, dynamic>,
            );
            print(error.message);
            return 'Fail';
          }
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
