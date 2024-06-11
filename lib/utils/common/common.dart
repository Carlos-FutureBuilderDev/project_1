import 'dart:io';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project_1/ui/themes/app_colors.dart';
import 'package:project_1/ui/themes/app_text_styles.dart';
import 'package:project_1/utils/file_system_manager.dart';

class Common {
  static String appName() {
    // return 'project_1 DEV';
    // return 'project_1 STG';
    return 'project_1';
  }

  static String baseUrl() {
    // return 'https://dev.project_1.azure-api.net/v1';
    // return 'https://staging.project_1.azure-api.net/v1';
    return 'https://project_1.azure-api.net/v1';
  }

  static int currentDateTimeInMillis() {
    return new DateTime.now().millisecondsSinceEpoch;
  }

  static String dateFormatterMMDDYYYY(DateTime dateTime) {
    return DateFormat('MM/dd/yyyy').format(dateTime);
  }

  static double decPoint(final double val, final int places) {
    final num mod = pow(10.0, places);
    return (val * mod).round().toDouble() / mod;
  }

  static Future<void> deleteFile(
    final String? folder,
    final String filename,
  ) async {
    // final Directory dir = await getApplicationDocumentsDirectory();
    final Directory dir = new Directory(FileSystemManager.documentDirectory());

    // String path = dir.path;
    String path = dir.path;
    if (folder != null && folder.isNotEmpty) {
      if (path.substring(path.length - 1) == '/') {
        path += folder;
      } else {
        path = '$path/$folder';
      }
    }

    if (path.substring(path.length - 1) == '/') {
      path += filename;
    } else {
      path = '$path/$filename';
    }

    bool fileExists = FileSystemEntity.isFileSync(path);
    if (fileExists) {
      File(path).deleteSync();
      fileExists = FileSystemEntity.isFileSync(path);
    }
    // return fileExists;
  }

  static Future<void> deleteFileByPath(final String filePath) async {
    // print('deleteFileByPath: $filePath');
    bool fileExists = await FileSystemEntity.isFile(filePath);
    // print('filePath exists: $fileExists');
    if (fileExists) {
      // print('prior to deleting file...');
      File(filePath).deleteSync();
      fileExists = await FileSystemEntity.isFile(filePath);
      // print('file deleted, file exists: $fileExists');
    } else {
      print('File does not exist');
    }
  }

  static Future<void> displayDialog(
    final BuildContext context,
    final String title,
    final String msg,
  ) async {
    final AlertDialog alertDialog = new AlertDialog(
      titlePadding: EdgeInsets.zero,
      title: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 24.0,
            ),
          ),
        ),
      ),
      content: Text(msg),
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: AppColors.red8,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(15.0),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(
            'OK',
            style: TextStyle(
              color: AppColors.primaryColor,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (final BuildContext context) => alertDialog,
    );
  }

  static Future<String> fileContentsByFileName(
    final String? folder,
    final String filename,
  ) async {
    String result = '';
    final Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + '/';
    if (folder != null) {
      if (folder.isNotEmpty) {
        if (path.substring(path.length - 1) == '/') {
          path += folder;
        }
      } else {
        path = '$path/$folder';
      }
    }

    if (path.substring(path.length - 1) == '/') {
      path += filename;
    } else {
      path = '$path/$filename';
    }

    final bool fileExits = await FileSystemEntity.isFile(path);
    if (fileExits) {
      result = await new File(path).readAsString();
    }

    return result;
  }

  // Read a specific file and return the result as a string synchronously
  static String fileContentsByFilePathSync(final String filepath) {
    late String result;

    final bool fileExits = FileSystemEntity.isFileSync(filepath);
    if (fileExits) {
      result = new File(filepath).readAsStringSync();
    }

    return result;
  }

  static Future<bool> isOnline() async {
    final Connectivity connectivity = Connectivity();
    final ConnectivityResult result = await connectivity.checkConnectivity();
    if (result != ConnectivityResult.none) {
      return true;
    } else {
      return false;
    }
  }

  static Widget progressIndicator(
    final BuildContext context,
    final String message, {
    required final bool isLoading,
  }) {
    return isLoading
        ? Container(
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(10.0),
              ),
              color: AppColors.whiteBackground,
            ),
            height: 130.0,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 15.0),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  child: Text(
                    message,
                    style: AppTextStyles.getMediumBoldTextStyle(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          )
        : const SizedBox();
  }

  static Future<bool> saveFile(
    final String result,
    final String? folder,
    final String filename,
  ) async {
    final Directory dir = await getApplicationDocumentsDirectory();
    String path = '';
    if (dir.path == '') {
      path = '/data/user/0/com.example.project_1/app_flutter';
    } else {
      path = dir.path + '/';
    }

    if (folder != null) {
      if (folder.isNotEmpty) {
        if (path.substring(path.length - 1) == '/') {
          path += folder;
        }
      } else {
        path = '$path/$folder';
      }
    }

    final bool folderExists = await FileSystemEntity.isDirectory(path);
    if (!folderExists) {
      await new Directory(path).create();
    }

    if (path.substring(path.length - 1) == '/') {
      path += filename;
    } else {
      path = '$path/$filename';
    }

    // Determine if the file exists
    final bool fileExists = await FileSystemEntity.isFile(path);
    if (!fileExists) {
      await (await new File(path).create()).writeAsString(result);
    } else {
      await new File(path).writeAsString(result);
    }

    return true;
  }

  static bool saveFileSync(
    final String result,
    final String? folder,
    final String filename,
  ) {
    final Directory dir = new Directory(FileSystemManager.documentDirectory());
    String path = '';
    if (dir.path == '') {
      path = '/data/user/0/com.example.project_1/app_flutter';
    } else {
      path = dir.path + '/';
    }

    if (folder != null) {
      if (folder.isNotEmpty) {
        if (path.substring(path.length - 1) == '/') {
          path += folder;
        }
      } else {
        path = '$path/$folder';
      }
    } else {
      path = '$path/';
    }

    final bool folderExists = FileSystemEntity.isDirectorySync(path);
    if (!folderExists) {
      new Directory(path).createSync();
    }

    if (path.substring(path.length - 1) == '/') {
      path += filename;
    } else {
      path = '$path/$filename';
    }

    // Determine if the file exists
    final bool fileExists = FileSystemEntity.isFileSync(path);
    if (!fileExists) {
      new File(path).createSync();
      File(path).writeAsStringSync(result);
    } else {
      new File(path).writeAsStringSync(result);
    }

    return true;
  }

  static Future<bool> saveImageByPath(
    final String result,
    final String path,
    final String filename,
  ) async {
    await (await new File(path).create()).writeAsString(result);

    return true;
  }

  static void showSnackBar(
    final BuildContext context,
    final String message,
    final Color backgroundColor,
    final Color textColor,
    final Duration duration,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: textColor),
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        dismissDirection: DismissDirection.startToEnd,
      ),
    );
  }

  static void showToast(
    final FToast fToast,
    final String message,
    final Color backgroundColor,
    final Color textColor,
    final Color iconColor,
  ) {
    final Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: backgroundColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.check,
            color: iconColor,
          ),
          const SizedBox(
            width: 16.0,
          ),
          Text(
            message,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.TOP,
    );
  }
}
