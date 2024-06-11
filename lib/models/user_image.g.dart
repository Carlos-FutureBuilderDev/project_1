// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserImage _$UserImageFromJson(Map<String, dynamic> json) => UserImage()
  ..userImageID = (json['userImageID'] as num?)?.toInt()
  ..userID = (json['userID'] as num).toInt()
  ..name = json['name'] as String
  ..image = json['image'] as String
  ..type = json['type'] as String;

Map<String, dynamic> _$UserImageToJson(UserImage instance) => <String, dynamic>{
      'userImageID': instance.userImageID,
      'userID': instance.userID,
      'name': instance.name,
      'image': instance.image,
      'type': instance.type,
    };
