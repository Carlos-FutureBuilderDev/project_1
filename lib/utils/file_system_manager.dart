import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileSystemManager {
  static String _documentDirectory = '';
  static String _imageDirectory = '';
  static String _tempImageDirectory = '';

  static void setDocDirectory(final Directory directory) {
    _documentDirectory = directory.path;
  }

  static Future<void> setImagesDirectory() async {
    await getApplicationDocumentsDirectory().then((final Directory directory) {
      final Directory imageDirectory = Directory('${directory.path}/Images/');

      if (!imageDirectory.existsSync()) {
        //if folder does not exist, create folder
        imageDirectory.createSync(recursive: true);
      }

      _imageDirectory = imageDirectory.path;
    });
  }

  static Future<void> setTempImageDirectory() async {
    _tempImageDirectory = '${(await getTemporaryDirectory()).path}/';
  }

  static String documentDirectory() {
    return _documentDirectory;
  }

  static String imageDirectory() {
    return _imageDirectory;
  }

  static String tempImageDirectory() {
    return _tempImageDirectory;
  }

  static Future<void> deleteFile(
    final String? folder,
    final String filename,
  ) async {
    // final Directory dir = await getApplicationDocumentsDirectory();
    // String path = dir.path;
    String path = documentDirectory();
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

  static Future<void> deleteFolder(final String folder) async {
    // final Directory dir = await getApplicationDocumentsDirectory();
    // String path = dir.path;
    String path = documentDirectory();

    if (path.substring(path.length - 1) == '/') {
      path += folder;
    } else {
      path = '$path/$folder';
    }

    bool dirExists = FileSystemEntity.isDirectorySync(path);
    if (dirExists) {
      final Directory dir = Directory(path);
      if (dir.listSync().isEmpty) {
        Directory(path).deleteSync();
        dirExists = FileSystemEntity.isDirectorySync(path);
      } else {
        for (final FileSystemEntity file in dir.listSync()) {
          File(file.path).deleteSync();
        }

        Directory(path).deleteSync();
        dirExists = FileSystemEntity.isDirectorySync(path);
      }
    }
    // return dirExists;
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
    final Directory dir = new Directory(documentDirectory());
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
}
