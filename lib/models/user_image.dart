import 'package:json_annotation/json_annotation.dart';

part 'user_image.g.dart';

@JsonSerializable()
class UserImage {
  UserImage();

  int? userImageID;
  int userID = 0;
  String name = '';
  String image = '';
  String type = '';

  factory UserImage.fromJson(
    final Map<String, dynamic> json,
  ) =>
      _$UserImageFromJson(json);
  Map<String, dynamic> toJson() => _$UserImageToJson(this);

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = Map<String, dynamic>();
    map['UserImageID'] = userImageID;
    map['UserID'] = userID;
    map['Name'] = name;
    map['Image'] = image;
    map['Type'] = type;

    return map;
  }

  UserImage.fromMap(final Map<String, dynamic> map) {
    userImageID = map['UserImageID'] as int;
    userID = map['UserID'] as int;
    name = map['Name'] as String;
    image = map['Image'] as String;
    type = map['Type'] as String;
  }

  String buildFileName() {
    return userImageID.toString() +
        '_' +
        name +
        '_' +
        userID.toString() +
        '.' +
        type;
  }
}
