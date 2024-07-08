// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User()
  ..UserID = (json['UserID'] as num?)?.toInt()
  ..Username = json['Username'] as String?
  ..Password = json['Password'] as String?
  ..Email = json['Email'] as String?;

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'UserID': instance.UserID,
      'Username': instance.Username,
      'Password': instance.Password,
      'Email': instance.Email,
    };
