import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_editor/image_editor.dart';
import 'package:project_1/models/user.dart';
import 'package:project_1/ui/themes/app_colors.dart';
import 'package:project_1/utils/common/common.dart';
import 'package:project_1/utils/error/error.dart';
import 'package:project_1/utils/file_system_manager.dart';
import 'package:project_1/widgets/camera/cropper.dart';

class Camera extends StatefulWidget {
  final User _user;
  final CameraDescription rearCam;
  final CameraDescription frontCam;

  const Camera(this._user, this.rearCam, this.frontCam, {super.key});

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> with TickerProviderStateMixin {
  late CameraController _controller;
  String _currentCam = 'rear';
  late String _fileName;
  late String _tempImagePath;
  final String _tempDirectoryPath = FileSystemManager.tempImageDirectory();
  final String _imageDirectoryPath = FileSystemManager.imageDirectory();
  String _localImagePath = '';
  bool _retake = false;
  bool _displayImage = false;
  XFile? _imageTaken;
  late FToast _fToast;
  late Widget _makeBody;
  Flex _bBar = Flex(direction: Axis.horizontal);
  late Future<void> _initializedControllerFuture;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _currentZoomLevel = 1.0;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _currentExposureOffset = 0.0;

  late AnimationController _flashModeControlRowAnimationController;
  late Animation<double> _flashModeControlRowAnimation;

  // ignore: unused_field
  Widget _retakeButton = Container();
  // ignore: unused_field
  Widget _cropButton = Container();
  // ignore: unused_field
  Widget _takePictureButton = Container();
  // ignore: unused_field
  Widget _switchCameraButton = Container();
  // ignore: unused_field
  final Widget _moreImagesButton = Container();
  // ignore: unused_field
  Widget _acceptImageButton = Container();
  // ignore: unused_field
  final GlobalKey _cropperKey = GlobalKey(debugLabel: 'cropperKey');
  // ignore: unused_field
  late Future<Uint8List> _imageToCropFuture;
  // ignore: unused_field
  late Uint8List _imageToCrop;
  // ignore: unused_field
  late Uint8List _croppedImage;

  _CameraState();

  @override
  void initState() {
    super.initState();
    // ignore: discarded_futures
    _initCamera(widget.rearCam);
    _fToast = FToast();
    _fToast.init(context);
    _bBar = Flex(direction: Axis.horizontal);
    _flashModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _flashModeControlRowAnimation = CurvedAnimation(
      parent: _flashModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );
  }

  @override
  void dispose() {
    // ignore: discarded_futures
    _controller.dispose();
    _flashModeControlRowAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    if (_imageTaken != null) {
      _displayImage = true;
      _makeBody = Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Expanded(child: Image.file(File(_localImagePath))),
          const SizedBox(height: 15.0),
          _buttons(),
        ],
      );
    } else {
      _displayImage = false;
      _makeBody = FutureBuilder<void>(
        future: _initializedControllerFuture,
        builder:
            (final BuildContext context, final AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return Flex(
              direction: Axis.vertical,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  flex: 8,
                  child: Stack(
                    children: <Widget>[
                      CameraPreview(_controller),
                      Positioned(
                        right: 1.0,
                        top: 10.0,
                        child: IntrinsicHeight(
                          child: _verticalExposureSlider(),
                        ),
                      ),
                      Positioned(
                        right: 1.0,
                        bottom: 20.0,
                        child: IntrinsicHeight(
                          child: _verticalZoomSlider(),
                        ),
                      ),
                      Visibility(
                        visible: _currentCam == 'rear',
                        child: Positioned(
                          bottom: 20.0,
                          left: 20.0,
                          child: IntrinsicHeight(
                            child: _flashModeControlRowWidget(),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Flexible(child: _buttons()),
              ],
            );
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: _appBar(),
        body: _makeBody,
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text(
        "Say Cheese!",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.blue,
      iconTheme: IconThemeData(
        color: Colors.orange,
      ),
    );
  }

  Column _verticalExposureSlider() {
    return Column(
      children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _currentExposureOffset.toStringAsFixed(1) + 'x',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        Expanded(
          child: RotatedBox(
            quarterTurns: 3,
            child: SizedBox(
              height: 80.0,
              child: Slider(
                value: _currentExposureOffset,
                min: _minAvailableExposureOffset,
                max: _maxAvailableExposureOffset,
                activeColor: Colors.black,
                inactiveColor: Colors.grey,
                onChanged: (final double value) async {
                  setState(() {
                    _currentExposureOffset = value;
                  });
                  await _controller.setExposureOffset(value);
                },
              ),
            ),
          ),
        )
      ],
    );
  }

  SizeTransition _flashModeControlRowWidget() {
    return SizeTransition(
      sizeFactor: _flashModeControlRowAnimation,
      child: ClipRect(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.flash_off),
              color: _controller.value.flashMode == FlashMode.off
                  ? Colors.orange
                  : Colors.blue,
              onPressed: () async =>
                  _onSetFlashModeButtonPressed(FlashMode.off),
            ),
            IconButton(
              icon: const Icon(Icons.flash_auto),
              color: _controller.value.flashMode == FlashMode.auto
                  ? Colors.orange
                  : Colors.blue,
              onPressed: () async =>
                  _onSetFlashModeButtonPressed(FlashMode.auto),
            ),
            IconButton(
              icon: const Icon(Icons.flash_on),
              color: _controller.value.flashMode == FlashMode.always
                  ? Colors.orange
                  : Colors.blue,
              onPressed: () async =>
                  _onSetFlashModeButtonPressed(FlashMode.always),
            ),
            IconButton(
              icon: const Icon(Icons.highlight),
              color: _controller.value.flashMode == FlashMode.torch
                  ? Colors.orange
                  : Colors.blue,
              onPressed: () async =>
                  _onSetFlashModeButtonPressed(FlashMode.torch),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSetFlashModeButtonPressed(final FlashMode mode) async {
    setFlashMode(mode).then((final _) {
      if (mounted) {
        setState(() {});
      }
      Common.showSnackBar(
        context,
        'Flash mode set to ${mode.toString().split('.').last}',
        AppColors.acceptGreen,
        AppColors.white,
        const Duration(seconds: 1),
      );
    });
  }

  Flex _buttons() {
    if (_displayImage) {
      _bBar = Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _retakeButton = Flexible(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
                right: 5.0,
                bottom: 10.0,
              ),
              child: FloatingActionButton.extended(
                heroTag: null,
                label: Text(
                  'Try Again',
                  style: const TextStyle(color: AppColors.white),
                ),
                icon: const Icon(Icons.refresh, color: AppColors.white),
                backgroundColor: AppColors.declineRed,
                onPressed: () async {
                  setState(() {
                    _retake = true;
                    _imageTaken = null;
                  });
                  Common.deleteFileByPath(_localImagePath);
                },
              ),
            ),
          ),
          _cropButton = Flexible(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 5.0,
                right: 5.0,
                bottom: 10.0,
              ),
              child: FloatingActionButton.extended(
                heroTag: null,
                label: Text(
                  'Crop',
                  style: const TextStyle(color: AppColors.white),
                ),
                icon: const Icon(
                  Icons.crop,
                  color: AppColors.white,
                ),
                backgroundColor: AppColors.primaryColor,
                onPressed: () async {
                  _navigateToCropper(context, _imageTaken!);
                  setState(() {
                    _retake = false;
                    // _imageTaken = null;
                  });
                },
              ),
            ),
          ),
          _acceptImageButton = Flexible(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 5.0,
                right: 10.0,
                bottom: 10.0,
              ),
              child: FloatingActionButton.extended(
                heroTag: null,
                label: Text(
                  'Cool',
                  style: const TextStyle(color: AppColors.white),
                ),
                icon: const Icon(
                  Icons.check,
                  color: AppColors.white,
                ),
                backgroundColor: AppColors.acceptGreen,
                onPressed: () async {
                  // _imageTaken!.saveTo(_picDirPath + _fileName);
                  // _imagePath = _picDirPath + _fileName;

                  setState(() {
                    Common.showToast(
                      _fToast,
                      'All Good!',
                      AppColors.acceptGreen,
                      AppColors.white,
                      AppColors.white,
                    );
                  });

                  _retake = true;
                  Common.deleteFileByPath(_localImagePath);
                  Navigator.pop(context, _imageTaken);
                },
              ),
            ),
          ),
        ],
      );
    } else {
      _bBar = new Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _switchCameraButton = Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 60.0,
              height: 60.0,
              margin: const EdgeInsets.only(left: 5.0, right: 5.0),
              child: RawMaterialButton(
                shape: const CircleBorder(),
                fillColor: Theme.of(context).colorScheme.primary,
                elevation: 0.0,
                child: const Icon(
                  Icons.switch_camera,
                  size: 40.0,
                  color: AppColors.white,
                ),
                onPressed: () {
                  setState(() {
                    if (_currentCam == 'rear') {
                      _initCamera(widget.frontCam);
                      _currentCam = 'front';
                    } else {
                      _initCamera(widget.rearCam);
                      _currentCam = 'rear';
                    }

                    // _controller = CameraController(
                    //   widget.frontCam,
                    //   ResolutionPreset.max,
                    // );
                  });
                },
              ),
            ),
          ),
          _takePictureButton = Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 60.0,
              height: 60.0,
              margin: const EdgeInsets.only(left: 5.0, right: 5.0),
              child: RawMaterialButton(
                shape: const CircleBorder(),
                fillColor: Theme.of(context).colorScheme.primary,
                elevation: 0.0,
                child: const Icon(
                  Icons.camera,
                  size: 40.0,
                  color: AppColors.white,
                ),
                onPressed: () async {
                  try {
                    if (_retake) {
                      _fileName = _getUniqueFileNamePNG();
                      final File file = File('$_tempDirectoryPath$_fileName');
                      if (file.existsSync()) {
                        file.deleteSync();
                      }
                    }

                    // Attempt to take a picture and log where it's been saved.
                    final XFile xFile = await _controller.takePicture();
                    _fileName = _getUniqueFileNamePNG();

                    if (_currentCam == 'front') {
                      // 1. read the image from disk into memory
                      var file = File(xFile.path);
                      Uint8List? imageBytes = await file.readAsBytes();

                      // 2. flip the image on the X axis
                      final ImageEditorOption option = ImageEditorOption();
                      option.addOption(FlipOption(horizontal: true));
                      imageBytes = await ImageEditor.editImage(
                          image: imageBytes, imageEditorOption: option);

                      // 3. write the image back to disk
                      await file.delete();
                      await file.writeAsBytes(imageBytes!);
                    }

                    xFile.saveTo(_imageDirectoryPath + _fileName);
                    _tempImagePath = _tempDirectoryPath + _fileName;
                    _localImagePath = _imageDirectoryPath + _fileName;

                    setState(() {
                      _imageTaken = xFile;
                    });
                  } on Exception catch (e) {
                    print(e);
                  }
                },
              ),
            ),
          ),
        ],
      );
    }

    return _bBar;
  }

  String _getUniqueFileNamePNG() {
    String userId = widget._user.UserID.toString();

    final String dateInMillis = Common.currentDateTimeInMillis().toString();
    return _fileName = userId + '_' + dateInMillis + '_0' + '.png';
  }

  Future<void> _initCamera(CameraDescription cam) async {
    _controller = new CameraController(
      // Get a specific camera from the list of available cameras.
      cam,
      // Define the resolution to use.
      ResolutionPreset.max,
    );

    _initializedControllerFuture = _controller.initialize();
    await _initializedControllerFuture;

    //Set FlashMode
    _controller.setFlashMode(FlashMode.auto);
    _controller.lockCaptureOrientation(DeviceOrientation.portraitUp);
    //Set Zoom Min/Max
    _maxAvailableZoom = await _controller.getMaxZoomLevel();
    _minAvailableZoom = await _controller.getMinZoomLevel();
    _minAvailableExposureOffset = await _controller.getMinExposureOffset();
    _maxAvailableExposureOffset = await _controller.getMaxExposureOffset();
    setState(() {});
  }

  void onFlashModeButtonPressed() {
    if (_flashModeControlRowAnimationController.value == 1) {
      _flashModeControlRowAnimationController.reverse();
    } else {
      _flashModeControlRowAnimationController.forward();
    }
  }

  Future<void> setFlashMode(final FlashMode mode) async {
    try {
      await _controller.setFlashMode(mode);
    } on CameraException catch (e) {
      Error.logAndDisplayCameraError(context, e);
    }
  }

  Column _verticalZoomSlider() {
    return Column(
      children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _currentZoomLevel.toStringAsFixed(1) + 'x',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        Expanded(
          child: RotatedBox(
            quarterTurns: 3,
            child: SizedBox(
              height: 80.0,
              child: Slider(
                value: _currentZoomLevel,
                min: _minAvailableZoom,
                max: _maxAvailableZoom,
                activeColor: Colors.black,
                inactiveColor: Colors.grey,
                onChanged: (final double value) async {
                  setState(() {
                    _currentZoomLevel = value;
                  });
                  await _controller.setZoomLevel(value);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  ///ROUTE NAVIGATION///
  Future<XFile?> _navigateToCropper(
    final BuildContext context,
    final XFile imageFile,
  ) async {
    final Uint8List imageUint = await imageFile.readAsBytes();

    await Navigator.push(
      context,
      MaterialPageRoute<Widget>(
        builder: (final BuildContext context) => new Cropper(
          imageUint: imageUint,
          imageTaken: imageFile,
          user: widget._user,
        ),
      ),
    );

    final List<FileSystemEntity> fileSystemEntityList =
        new Directory(FileSystemManager.tempImageDirectory()).listSync();

    int mostRecentMilli = 0;
    for (final FileSystemEntity fse in fileSystemEntityList) {
      if (fse.path.split('/').last.contains('image_cropper')) {
        final String last = fse.path.split('/').last;
        List<String> split = last.split('_');
        split = split[2].split('.');
        final int milli = int.parse(split[0]);
        if (milli > mostRecentMilli) {
          mostRecentMilli = milli;
        }
      }
    }

    final String croppedImagePath =
        '${FileSystemManager.tempImageDirectory()}image_cropper_' +
            mostRecentMilli.toString() +
            '.jpg';

    setState(() {
      _localImagePath = croppedImagePath;
      _imageTaken = XFile(croppedImagePath);
    });

    return XFile(croppedImagePath);
  }
}
