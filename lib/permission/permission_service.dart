import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project_1/permission/permission_group.dart';

class PermissionService {
  /// Has Permission Section - Determine if specific permission group is enabled
  Future<bool> _hasPermission(final PermissionGroup permission) async {
    Object permissionStatus;
    switch (permission) {
      case PermissionGroup.camera:
        permissionStatus = await Permission.camera.status;
        break;
      case PermissionGroup.location:
        permissionStatus = await Permission.location.status;
        break;
      case PermissionGroup.locationAlways:
        permissionStatus = await Permission.locationAlways.status;
        break;
      case PermissionGroup.locationWhenInUse:
        permissionStatus = await Permission.locationWhenInUse.status;
        break;
      case PermissionGroup.microphone:
        permissionStatus = await Permission.microphone.status;
        break;
      case PermissionGroup.notification:
        permissionStatus = await Permission.notification.status;
        break;
      case PermissionGroup.phone:
        permissionStatus = await Permission.phone.status;
        break;
      case PermissionGroup.photos:
        permissionStatus = await Permission.photos.status;
        break;
      case PermissionGroup.photosAddOnly:
        permissionStatus = await Permission.photosAddOnly.status;
        break;
      case PermissionGroup.storage:
        permissionStatus = await Permission.storage.status;
        break;
      default:
        permissionStatus = false;
        break;
    }

    return permissionStatus == PermissionStatus.granted;
  }

  Future<bool> hasCameraPermission() async {
    return _hasPermission(PermissionGroup.camera);
  }

  Future<bool> hasLocationPermission() async {
    return _hasPermission(PermissionGroup.location);
  }

  Future<bool> hasLocationAlwaysPermission() async {
    return _hasPermission(PermissionGroup.locationAlways);
  }

  Future<bool> hasLocationWhenInUsePermission() async {
    return _hasPermission(PermissionGroup.locationWhenInUse);
  }

  Future<bool> hasMicrophonePermission() async {
    return _hasPermission(PermissionGroup.microphone);
  }

  Future<bool> hasNotificationPermission() async {
    return _hasPermission(PermissionGroup.notification);
  }

  Future<bool> hasPhonePermission() async {
    return _hasPermission(PermissionGroup.phone);
  }

  Future<bool> hasPhotosPermission() async {
    return _hasPermission(PermissionGroup.photos);
  }

  Future<bool> hasPhotoAddOnlyPermission() async {
    return _hasPermission(PermissionGroup.photosAddOnly);
  }

  Future<bool> hasStoragePermission() async {
    return _hasPermission(PermissionGroup.storage);
  }

  /// Request Permission Section - Prompt user to allow specific permission group
  Future<bool> _requestPermission(final PermissionGroup permission) async {
    PermissionStatus result;
    final AndroidDeviceInfo deviceInfo = await DeviceInfoPlugin().androidInfo;

    switch (permission) {
      case PermissionGroup.camera:
        result = await Permission.camera.request();
        break;
      case PermissionGroup.location:
        result = await Permission.location.request();
        break;
      case PermissionGroup.locationAlways:
        result = await Permission.locationAlways.request();
        break;
      case PermissionGroup.locationWhenInUse:
        result = await Permission.locationWhenInUse.request();
        break;
      case PermissionGroup.microphone:
        result = await Permission.microphone.request();
        break;
      case PermissionGroup.notification:
        result = await Permission.notification.request();
        break;
      case PermissionGroup.phone:
        result = await Permission.phone.request();
        break;
      case PermissionGroup.photos:
        result = await Permission.photos.request();
        break;
      case PermissionGroup.photosAddOnly:
        result = await Permission.photosAddOnly.request();
        break;
      case PermissionGroup.storage:
        if (deviceInfo.version.sdkInt > 32) {
          result = PermissionStatus.granted;
        } else {
          result = await Permission.storage.request();
        }
        break;
      default:
        result = PermissionStatus.denied;
        break;
    }

    if (result == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> requestCameraPermission() async {
    return _requestPermission(PermissionGroup.camera);
  }

  Future<bool> requestLocationPermission() async {
    return _requestPermission(PermissionGroup.location);
  }

  Future<bool> requestLocationAlwaysPermission() async {
    return _requestPermission(PermissionGroup.locationAlways);
  }

  Future<bool> requestLocationWhenInUsePermission() async {
    return _requestPermission(PermissionGroup.locationWhenInUse);
  }

  Future<bool> requestMicrophonePermission() async {
    return _requestPermission(PermissionGroup.microphone);
  }

  Future<bool> requestNotificationPermission() async {
    return _requestPermission(PermissionGroup.notification);
  }

  Future<bool> requestPhonePermission() async {
    return _requestPermission(PermissionGroup.phone);
  }

  Future<bool> requestPhotosPermission() async {
    return _requestPermission(PermissionGroup.photos);
  }

  Future<bool> requestPhotosAddOnlyPermission() async {
    return _requestPermission(PermissionGroup.photosAddOnly);
  }

  Future<bool> requestStoragePermission() async {
    return _requestPermission(PermissionGroup.storage);
  }
}
