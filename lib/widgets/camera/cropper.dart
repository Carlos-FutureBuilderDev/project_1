import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_1/models/user.dart';
import 'package:project_1/ui/themes/app_colors.dart';
import 'package:project_1/utils/common/common.dart';
import 'package:project_1/utils/file_system_manager.dart';

class Cropper extends StatefulWidget {
  final User user;
  final Uint8List imageUint;
  final XFile imageTaken;

  const Cropper({
    super.key,
    required this.user,
    required this.imageUint,
    required this.imageTaken,
  });

  @override
  State<Cropper> createState() => _CropperState();
}

enum AppState {
  free,
  picked,
  cropped,
}

class _CropperState extends State<Cropper> {
  late AppState state;
  late CroppedFile? imageFile;
  // ignore: unused_field
  late XFile _imageTaken;
  late FloatingActionButton _button;

  @override
  void initState() {
    super.initState();
    _imageTaken = widget.imageTaken;
    state = AppState.picked;

    if (state == AppState.picked) {
      final String tempDir = FileSystemManager.tempImageDirectory();
      final String currentMilli = Common.currentDateTimeInMillis().toString();
      // File('${tempDir}image_' + currentMilli + '.png').createSync();
      final File file = File('${tempDir}image_' + currentMilli + '.png');
      file.writeAsBytesSync(widget.imageUint);
      imageFile = CroppedFile('${tempDir}image_' + currentMilli + '.png');
    }
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Cropper'),
      ),
      body: Center(
        child:
            imageFile != null ? Image.file(File(imageFile!.path)) : Container(),
      ),
      floatingActionButton: _cropButton(),
    );
  }

  Widget _buildButtonIcon() {
    if (state == AppState.free) {
      return const Icon(Icons.add);
    } else if (state == AppState.picked) {
      return const Icon(Icons.crop);
    } else if (state == AppState.cropped) {
      return const Icon(Icons.clear);
    } else {
      return Container();
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    imageFile = pickedImage != null ? CroppedFile(pickedImage.path) : null;
    if (imageFile != null) {
      setState(() {
        state = AppState.picked;
      });
    }
  }

  Future<void> _cropImage() async {
    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile!.path,
      aspectRatioPresets: Platform.isAndroid
          ? <CropAspectRatioPreset>[
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : <CropAspectRatioPreset>[
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      uiSettings: <PlatformUiSettings>[
        AndroidUiSettings(
          toolbarTitle: 'Image Cropper',
          toolbarColor: AppColors.primaryColor,
          toolbarWidgetColor: AppColors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Cropper',
        )
      ],
    );

    if (croppedFile != null) {
      imageFile = croppedFile;
      setState(() {
        _imageTaken = XFile(imageFile!.path);
        state = AppState.cropped;
      });
    }
  }

  FloatingActionButton _cropButton() {
    _button = FloatingActionButton(
      backgroundColor: Colors.deepOrange,
      onPressed: () async {
        if (state == AppState.free) {
          _pickImage();
        } else if (state == AppState.picked) {
          _cropImage();
        } else if (state == AppState.cropped) {
          _clearImage();
        }
      },
      child: _buildButtonIcon(),
    );
    _button.onPressed!();
    return _button;
  }

  void _clearImage() {
    imageFile = null;
    state = AppState.free;

    Navigator.pop(context);
  }
}
