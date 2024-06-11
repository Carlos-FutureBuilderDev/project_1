import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project_1/ui/themes/app_colors.dart';
import 'package:project_1/utils/file_system_manager.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.primaryColor,
      systemNavigationBarColor: AppColors.primaryColor,
    ),
  );

  getApplicationDocumentsDirectory().then((final Directory directory) {
    FileSystemManager.setDocDirectory(directory);
    FileSystemManager.setImagesDirectory();
    FileSystemManager.setTempImageDirectory();
  });

  runApp(App());
}
