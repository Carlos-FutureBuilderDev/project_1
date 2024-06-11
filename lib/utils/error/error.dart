import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'error.g.dart';

@JsonSerializable()
class Error {
  Error(this.code, this.message);

  int code;
  String message;

  factory Error.fromJson(final Map<String, dynamic> json) =>
      _$ErrorFromJson(json);
  Map<String, dynamic> toJson() => _$ErrorToJson(this);

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = Map<String, dynamic>();
    map['code'] = code;
    map['message'] = message;

    return map;
  }

  static void logAndDisplayCameraError(
    final BuildContext context,
    final CameraException e,
  ) {
    if (e.description != null) {
      print('Error: $e.code\nError Message: $e.description');
    } else {
      print('Error: $e.code');
    }
    final String snackBarMessage = 'Error: ${e.code}\n${e.description}';
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(snackBarMessage)));
  }
}
