import 'package:json_annotation/json_annotation.dart';

part 'user_login.g.dart';

@JsonSerializable()
class UserLogin {
  String username = '';
  String password = '';

  UserLogin();

  Map<String, dynamic> toJson() => _$UserLoginToJson(this);

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = Map<String, dynamic>();

    map['Username'] = username;
    map['Password'] = password;

    return map;
  }
}
