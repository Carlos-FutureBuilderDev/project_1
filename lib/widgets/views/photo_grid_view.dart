import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_1/models/user.dart';
import 'package:project_1/models/user_image.dart';
import 'package:project_1/permission/permission_service.dart';
import 'package:project_1/ui/themes/app_colors.dart';
import 'package:project_1/utils/common/common.dart';
import 'package:project_1/utils/file_system_manager.dart';
import 'package:project_1/widgets/camera/camera.dart';
import 'package:project_1/widgets/camera/cropper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhotoGridView extends StatefulWidget {
  final List<UserImage> _userImages;
  final User _user;
  final int _imageCount;
  final ValueChanged<bool> _isImageAdded;

  const PhotoGridView(
    this._userImages,
    this._user,
    this._imageCount,
    this._isImageAdded, {
    super.key,
  });

  @override
  _PhotoGridViewState createState() => _PhotoGridViewState();
}

class _PhotoGridViewState extends State<PhotoGridView> {
  late List<UserImage> _userImages;
  final Map<dynamic, bool> _imageFilesToChooseFrom = Map<dynamic, bool>();
  final PermissionService _service = new PermissionService();
  bool _hasStoragePermission = false;
  List<CameraDescription> _camera = <CameraDescription>[];
  String receiptDirPath = '${FileSystemManager.documentDirectory()}/Receipts/';
  String imageCountDirPath =
      '${FileSystemManager.documentDirectory()}/ImageCount/';
  List<Widget> gridTiles = <Widget>[];
  final List<String> _imageIndexByName = <String>[];
  //ignore: unused_field
  late int _imageCount;
  late int _existingImageCount;
  // ignore: unused_field
  late XFile _imageCropped;
  XFile? xFileFromFile;
  late dynamic file;
  late AlertDialog alertDialog;
  late ValueChanged<bool> _isImageAdded;

  @override
  void initState() {
    super.initState();
    _userImages = widget._userImages;
    _isImageAdded = widget._isImageAdded;

    // ignore: discarded_futures
    availableCameras().then((final List<CameraDescription> onValue) {
      setState(() {
        _camera = onValue;
      });
    });

    // ignore: discarded_futures
    _checkPermission();

    for (final UserImage image in _userImages) {
      String nameWithoutExtension;
      if (image.name!.contains('.')) {
        final List<String> split = image.name.split('.');
        nameWithoutExtension = split[0];
      } else {
        nameWithoutExtension = image.name;
      }

      // ignore: discarded_futures
      Common.fileContentsByFileName('UserImages', '$nameWithoutExtension.json')
          // ignore: discarded_futures
          .then((final String userImageJSON) {
        if (userImageJSON != '') {
          final Map<String, dynamic> userImageMap =
              jsonDecode(userImageJSON) as Map<String, dynamic>;
          final UserImage userImage = UserImage.fromMap(userImageMap);
          setState(() {
            _imageFilesToChooseFrom[userImage] = true;
          });
        }
      });

      // ignore: discarded_futures
      _setIsGallery(true);
    }

    _imageCount = widget._imageCount;
    _existingImageCount = _userImages.length;
  }

  @override
  void dispose() {
    // ignore: discarded_futures
    SharedPreferences.getInstance().then((final SharedPreferences prefs) {
      // ignore: discarded_futures
      prefs.setBool('isGallery', false);
    });
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return SliverGrid.count(
      crossAxisCount: 2,
      crossAxisSpacing: 5.0,
      mainAxisSpacing: 16.0,
      children: _buildReceiptGrid(context),
    );
  }

  // Future<void> _addFileToList(final File file) async {
  //   List<String> split;
  //   late String fileType;
  //
  //   split = file.path.split('.');
  //   fileType = split[split.length - 1];
  //
  //   if (_hasStoragePermission) {
  //     setState(() {
  //       _imageFilesToChooseFrom[file.path] = true;
  //       UserImage userImage = _userImages.firstWhere(
  //         (final UserImage image) => image.name == file.path,
  //         orElse: () => UserImage(),
  //       );
  //
  //       userImage = new UserImage();
  //       userImage.userImageID = -1;
  //       userImage.name = file.path;
  //       userImage.type = fileType;
  //       _userImages.add(userImage);
  //
  //       _imageIndexByName.add(userImage.name);
  //     });
  //
  //     Future<dynamic>.delayed(Duration.zero, () {
  //       _isImageAdded(true);
  //     });
  //   } else {
  //     Common.displayDialog(
  //       context,
  //       'Error',
  //       'Unable to save file to list.',
  //     );
  //   }
  // }

  Future<void> _addGalleryImageToList(final XFile imageFile) async {
    List<String> split;
    late String fileType;

    split = imageFile.path.split('.');
    fileType = split[split.length - 1];

    if (_hasStoragePermission) {
      setState(() {
        _imageFilesToChooseFrom[imageFile.path] = true;
        UserImage userImage = _userImages.firstWhere(
          (final UserImage image) => image.name == imageFile.path,
          orElse: () => UserImage(),
        );

        userImage = new UserImage();
        userImage.userImageID = -1;
        userImage.name = imageFile.path;
        userImage.type = fileType;
        _userImages.add(userImage);

        _imageIndexByName.add(userImage.name);
      });

      Future<dynamic>.delayed(Duration.zero, () {
        _isImageAdded(true);
      });
    } else {
      Common.displayDialog(
        context,
        'Error',
        'Unable to save image to list.',
      );
    }
  }

  //CAMERA IMAGE
  Future<void> _addImageToList(final XFile imageFile) async {
    final Map<String, dynamic> args = Map<String, dynamic>();

    List<String> split;
    late String fileType;
    late String fileNameLonger;
    late String fileName;

    split = imageFile.path.split('.');
    fileNameLonger = split.first;
    fileName = fileNameLonger.split('/')[2];
    fileType = split[split.length - 1];

    //PREP TO SAVE WITH itemID and bytes
    final int imageID =
        widget._user.UserID + new DateTime.now().millisecondsSinceEpoch;

    // args['imageName'] = imageID;
    // args['imgBytes'] = await imageFile.readAsBytes();

    UserImage userImage = UserImage();
    userImage.userImageID = imageID;
    userImage.image = await imageFile.readAsBytes().toString();

    String imageName = imageID.toString();

    final bool result = await Common.saveFileSync(
        userImage.toString(), 'UserImages', imageName);

    // split = result.split('.');
    // fileType = split[split.length - 1];
    //TODO:HERE
    setState(() {
      _imageFilesToChooseFrom[imageFile.path] = true;
      UserImage userImage = _userImages.firstWhere(
        (final UserImage image) => image.name == result,
        orElse: () => UserImage(),
      );

      userImage = new UserImage();
      userImage.userImageID = -1;
      userImage.name = imageName;
      userImage.type = fileType;
      _userImages.add(userImage);

      _imageIndexByName.add(userImage.name);
    });

    Future<dynamic>.delayed(Duration.zero, () {
      _isImageAdded(true);
    });
  }

  List<Widget> _buildReceiptGrid(final BuildContext context) {
    gridTiles = <Widget>[];

    // Always include the first tile to be an Add New Image
    gridTiles.add(
      ElevatedButton(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.add_circle_outline,
                color: AppColors.white,
                size: 40.0,
              ),
              const SizedBox(height: 10.0),
              Text(
                'Add New Photo',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 20.0,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (final Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                //post-press
                return Theme.of(context).colorScheme.secondary;
              } else {
                //pre-press
                return Theme.of(context).colorScheme.secondaryContainer;
              }
            },
          ),
        ),
        onPressed: () async {
          _displayNewImageDialog(context);
        },
      ),
    );

    // Create a grid tile for each file that has been previously chosen or selected from camera/gallery
    if (_imageFilesToChooseFrom.isNotEmpty) {
      for (final dynamic imgFile in _imageFilesToChooseFrom.keys) {
        gridTiles.add(
          GestureDetector(
            child: ColoredBox(
              color: AppColors.transparent,
              child: Stack(
                children: <Widget>[
                  Center(
                    child: (imgFile.runtimeType == UserImage
                        ? ((imgFile as UserImage).type == 'pdf'
                            ? _pdfPlaceHolder(imgFile)
                            : Image.memory(
                                base64Decode(
                                  imgFile.image,
                                ),
                              ))
                        : (imgFile as String).contains('pdf')
                            ? _pdfPlaceHolder(imgFile)
                            : Image.file(
                                File(imgFile),
                              )) as Widget?,
                  ),
                ],
              ),
            ),
            onTap: () async {
              _displayReceipt(imgFile);
            },
          ),
        );
      }
    } else {
      for (int i = 0; i < _existingImageCount; i++) {
        _uploadingImagePlaceHolder();
      }
    }

    return gridTiles;
  }

  Future<void> _checkPermission() async {
    _hasStoragePermission = await _service.hasStoragePermission();

    if (!_hasStoragePermission) {
      _hasStoragePermission = await _service.requestStoragePermission();
    }
  }

  Padding _cropImageButton(final dynamic imgFile) {
    XFile xFile;
    if (imgFile.runtimeType == String) {
      xFile = XFile(imgFile as String);
    } else {
      if (imgFile.runtimeType == UserImage) {
        xFile = XFile((imgFile as UserImage).image);
      } else {
        xFile = imgFile as XFile;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(
        left: 5.0,
        right: 5.0,
        bottom: 5.0,
      ),
      child: FloatingActionButton.extended(
        heroTag: null,
        label: Text(
          'Crop',
          style: const TextStyle(color: AppColors.white),
        ),
        icon: const Icon(Icons.crop, color: AppColors.white),
        backgroundColor: AppColors.primaryColor,
        onPressed: () async {
          _navigateToCropperScreen(context, xFile).then((final XFile x) {
            file = Image.file(File(x.path));
            xFileFromFile = x;
            Navigator.pop(context);
            setState(() {
              alertDialog = new AlertDialog(
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
                      'PDF',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 18.0,
                        fontFamily: 'Anton',
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                titlePadding: EdgeInsets.zero,
                content: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[file as Widget],
                  ),
                ),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    color: AppColors.red8,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                actionsAlignment: MainAxisAlignment.center,
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Flex(
                      direction: Axis.vertical,
                      children: <Widget>[
                        imgFile.runtimeType == UserImage
                            ? _saveBtn(imgFile, imgFile)
                            : _saveBtn(xFileFromFile, imgFile),
                        imgFile.runtimeType == UserImage
                            ? Container()
                            : imgFile.runtimeType == String
                                ? (imgFile as String).contains('pdf')
                                    ? Container()
                                    : _cropImageButton(xFileFromFile)
                                : _cropImageButton(xFileFromFile),
                        imgFile.runtimeType == UserImage
                            ? Container()
                            : _deleteFileBtn(imgFile),
                      ],
                    ),
                  ),
                ],
              );
              showDialog(
                context: context,
                builder: (final BuildContext context) => alertDialog,
              );
            });
          });
        },
      ),
    );
  }

  Padding _deleteFileBtn(final dynamic imgFile) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        child: Flex(
          direction: Axis.horizontal,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Delete',
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 20.0,
                fontFamily: 'Anton',
                fontStyle: FontStyle.italic,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 5.0),
          ],
        ),
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(
            const EdgeInsets.fromLTRB(13.0, 7.0, 13.0, 7.0),
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
              side: const BorderSide(color: AppColors.red7),
            ),
          ),
          elevation: MaterialStateProperty.resolveWith(
            (final Set<MaterialState> states) => 20.0,
          ),
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (final Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                //post-press
                return AppColors.red8;
              } else {
                //pre-press
                return AppColors.declineRed;
              }
            },
          ),
        ),
        onPressed: () {
          for (int i = 0; i < _imageIndexByName.length; i++) {
            final String element = _imageIndexByName.elementAt(i);
            if (element == imgFile) {
              // print('same');
              setState(() {
                _imageIndexByName.removeAt(i);
                _imageFilesToChooseFrom.remove(imgFile);
              });
            }
          }
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<void> _displayNewImageDialog(final BuildContext context) async {
    final AlertDialog alertDialog = new AlertDialog(
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
            'Add New Photo',
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 18.0,
              fontFamily: 'Anton',
              letterSpacing: 0.5,
              // fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ),
      titlePadding: EdgeInsets.zero,
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              tileColor: Theme.of(context).colorScheme.secondary,
              leading: const Icon(
                Icons.camera,
                color: AppColors.white,
                size: 30.0,
              ),
              title: Text(
                'Camera',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 20.0,
                  fontFamily: 'Anton',
                  letterSpacing: 0.5,
                  fontStyle: FontStyle.italic,
                ),
              ),
              onTap: () async {
                Future<dynamic>.delayed(Duration.zero, () {
                  _isImageAdded(false);
                });

                final XFile? image =
                    await _navigateToCamera(widget._user, context);
//TODO:HERE create object
                if (image != null) {
                  setState(() {
                    _addImageToList(image);
                  });
                }

                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 15.0),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              tileColor: Theme.of(context).colorScheme.secondary,
              leading: const Icon(
                Icons.camera_roll,
                color: AppColors.white,
                size: 30.0,
              ),
              title: Text(
                'Gallery',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 20.0,
                  fontFamily: 'Anton',
                  letterSpacing: 0.5,
                  fontStyle: FontStyle.italic,
                ),
              ),
              onTap: () async {
                Future<dynamic>.delayed(Duration.zero, () {
                  _isImageAdded(false);
                });

                final ImagePicker picker = new ImagePicker();
                final XFile? image = await picker.pickImage(
                  source: ImageSource.gallery,
                );

                if (image != null) {
                  _addGalleryImageToList(image);
                }

                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: AppColors.red8,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(15.0),
      ),
      actions: <Widget>[
        Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextButton(
                child: Text(
                  'Cancel',
                  style: const TextStyle(
                    color: AppColors.red,
                    fontSize: 14.0,
                    fontFamily: 'Anton',
                    // fontStyle: FontStyle.italic,
                    letterSpacing: 0.5,
                  ),
                ),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.fromLTRB(9.0, 3.0, 9.0, 3.0),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (final BuildContext context) => alertDialog,
    );
  }

  Future<void> _displayReceipt(final dynamic imgFile) async {
    //If image is a pdf
    late String name;
    if (imgFile.runtimeType == String) {
      name = (imgFile as String).split('/').last;
    }

    if (imgFile.runtimeType == UserImage) {
      final UserImage imgFilePIRIC = imgFile as UserImage;
      //CAMERA IMAGE
      if (imgFilePIRIC.type != 'pdf') {
        file = Image.memory(
          base64Decode(
            imgFilePIRIC.image,
          ),
        );
      } else {
        //PDF FROM FILE
        file = ElevatedButton(
          child: ColoredBox(
            color: AppColors.primaryColor,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(
                      Icons.picture_as_pdf,
                      color: AppColors.white,
                      size: 40.0,
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      //ignore: prefer_single_quotes
                      "documents_button_pdf_uploaded_document".tr() +
                          '\n' +
                          //ignore: prefer_single_quotes
                          "receipts_dialog_body_pdf_click_to_view".tr(),
                      overflow: TextOverflow.visible,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 20.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          onPressed: () {
            String path;
            imgFile.runtimeType == String
                ? path = imgFile as String //BEFORE PDF IS SAVED TO DB
                : path = receiptDirPath +
                    imgFilePIRIC.name +
                    '.json'; //AFTER PDF IS SAVED TO DB

            // _navigateToPDFViewerPage(context, path);
          },
        );
      }
    } else if (imgFile.runtimeType == String) {
      final String imgFileSTR = imgFile as String;
      if (imgFileSTR.contains('pdf')) {
        //PDF JUST UPLOADED
        file = ElevatedButton(
          child: ColoredBox(
            color: AppColors.primaryColor,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(
                      Icons.picture_as_pdf,
                      color: AppColors.white,
                      size: 40.0,
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      name +
                          '\n' +
                          //ignore: prefer_single_quotes
                          "receipts_dialog_body_pdf_click_to_view".tr(),
                      overflow: TextOverflow.visible,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 20.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          onPressed: () {
            String path;
            imgFile.runtimeType == String
                ? path = imgFileSTR.contains('pdf')
                    ? imgFileSTR
                    : receiptDirPath + (imgFileSTR as UserImage).name + '.json'
                : path = receiptDirPath + (imgFile as UserImage).name + '.json';

            // _navigateToPDFViewerPage(context, path);
          },
        );
      } else {
        //GALLERY IMAGE BEFORE SAVED TO DB
        xFileFromFile = XFile(imgFileSTR);
        file = Image.file(File(imgFileSTR));
      }
    } else if (imgFile.runtimeType == XFile) {
      file = Image.file(File((imgFile as XFile).path));
    }

    alertDialog = new AlertDialog(
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
            'PDF',
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 18.0,
              fontFamily: 'Anton',
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
      titlePadding: EdgeInsets.zero,
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[file as Widget],
        ),
      ),
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: AppColors.red8,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(15.0),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        Flex(
          direction: Axis.vertical,
          children: <Widget>[
            imgFile.runtimeType == UserImage
                ? _saveBtn(imgFile, imgFile)
                : _saveBtn(xFileFromFile, imgFile),
            imgFile.runtimeType == UserImage
                ? Container()
                : imgFile.runtimeType == String
                    ? (imgFile as String).contains('pdf')
                        ? Container()
                        : _cropImageButton(xFileFromFile)
                    : _cropImageButton(xFileFromFile),
            imgFile.runtimeType == UserImage
                ? Container()
                : _deleteFileBtn(imgFile),
          ],
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (final BuildContext context) => alertDialog,
    );
  }

  void _pdfPlaceHolder(final dynamic imgFile) {
    gridTiles.add(
      ElevatedButton(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Icon(
                Icons.picture_as_pdf,
                color: AppColors.white,
                size: 40.0,
              ),
              SizedBox(width: 5.0),
              Text(
                'PDF',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 20.0,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (final Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                //post-press
                return Theme.of(context).colorScheme.primary;
              } else {
                //pre-press
                return Theme.of(context).colorScheme.primaryContainer;
              }
            },
          ),
        ),
        onPressed: () async {
          _displayReceipt(imgFile);
        },
      ),
    );
  }

  Padding _saveBtn(final dynamic image, final dynamic fileToBeRemoved) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        child: Flex(
          direction: Axis.horizontal,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Save',
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 20.0,
                fontFamily: 'Anton',
                fontStyle: FontStyle.italic,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 2.0),
          ],
        ),
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(
            const EdgeInsets.fromLTRB(13.0, 7.0, 13.0, 7.0),
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
              side: const BorderSide(color: AppColors.acceptButtonPressed),
            ),
          ),
          elevation: MaterialStateProperty.resolveWith(
            (final Set<MaterialState> states) => 20.0,
          ),
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (final Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                //post-press
                return AppColors.green900;
              } else {
                //pre-press
                return AppColors.acceptGreen;
              }
            },
          ),
        ),
        onPressed: () async {
          if (fileToBeRemoved.runtimeType != UserImage) {
            if (fileToBeRemoved.runtimeType != String) {
              final XFile fileToBeRemovedStr = fileToBeRemoved as XFile;
              _imageFilesToChooseFrom.remove(fileToBeRemovedStr.path);
              _imageIndexByName.remove(fileToBeRemovedStr.path);

              for (int i = 0; i < _userImages.length; i++) {
                if (_userImages[i].name == fileToBeRemovedStr.path) {
                  _userImages.removeAt(i);
                }
              }

              _addImageToList(image as XFile);
            }
          }

          Navigator.pop(context);
        },
      ),
    );
  }

  Future<void> _setIsGallery(final bool flag) async {
    SharedPreferences.getInstance().then((final SharedPreferences prefs) {
      prefs.setBool('isGallery', flag);
    });
  }

  void _uploadingImagePlaceHolder() {
    gridTiles.add(
      ElevatedButton(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.file_upload,
                color: AppColors.white,
                size: 40.0,
              ),
              const SizedBox(width: 5.0),
              Text(
                //ignore: prefer_single_quotes
                "receipts_dialog_button_uploading".tr(),
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 20.0,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (final Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                //post-press
                return Theme.of(context).colorScheme.primary;
              } else {
                //pre-press
                return Theme.of(context).colorScheme.primaryContainer;
              }
            },
          ),
        ),
        onPressed: null,
      ),
    );
  }

  ///ROUTE NAVIGATION
  Future<XFile?> _navigateToCamera(
    final User user,
    final BuildContext context,
  ) async {
    final CameraDescription firstCamera = _camera.first;
    final CameraDescription secondCamera = _camera.elementAt(1);

    final XFile? image = await Navigator.push(
      context,
      MaterialPageRoute<XFile>(
        builder: (final BuildContext context) =>
            new Camera(user, firstCamera, secondCamera),
      ),
    );

    return image;
  }

  Future<XFile> _navigateToCropperScreen(
    final BuildContext context,
    final XFile imageFile,
  ) async {
    late Uint8List imageUint;

    imageUint = await imageFile.readAsBytes();

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
      if (fse.path.split('/').last.contains('image_cropper_')) {
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
      file = XFile(croppedImagePath);
    });

    return file as XFile;
  }
}
