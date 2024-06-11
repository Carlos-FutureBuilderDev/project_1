import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  int UserID = -1;
  String Username = '';
  String? Password;
  String? Email;
  String? ProfilePicPath = '';

  User();

  factory User.fromJson(final Map<String, dynamic> json) =>
      _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = Map<String, dynamic>();

    map['UserID'] = UserID;
    map['Username'] = Username;
    map['Password'] = Password;
    map['Email'] = Email;

    return map;
  }

  User.fromMap(final Map<String, dynamic> map) {
    UserID = map['UserID'] as int;
    Username = map['Username'] as String;
    Password = map['Password'] as String?;
    Email = map['Email'] as String?;
  }
}
