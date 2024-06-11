import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project_1/models/user.dart';
import 'package:project_1/models/user_image.dart';
import 'package:project_1/ui/home_drawer.dart';
import 'package:project_1/ui/themes/app_colors.dart';
import 'package:project_1/utils/file_system_manager.dart';
import 'package:project_1/widgets/views/photo_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhotoGrid extends StatefulWidget {
  final User user;

  const PhotoGrid(this.user, {super.key});

  @override
  _PhotoGridTransition createState() => _PhotoGridTransition();
}

class _PhotoGridTransition extends State<PhotoGrid> {
  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.transparent,
          body: LayoutBuilder(
            builder:
                (final BuildContext context, final BoxConstraints constraints) {
              return ColoredBox(
                color: AppColors.transparent,
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 1300),
                  child: PhotoGridContent(widget.user),
                  builder: (
                    final BuildContext context,
                    final double value,
                    final Widget? child,
                  ) {
                    return ShaderMask(
                      shaderCallback: (final Rect rect) {
                        return RadialGradient(
                          radius: value * 5,
                          colors: const <Color>[
                            AppColors.white,
                            AppColors.white,
                            AppColors.transparent,
                            AppColors.transparent
                          ],
                          stops: const <double>[0.0, 0.55, 0.60, 1.0],
                          center: const FractionalOffset(
                            0.50,
                            0.90,
                          ), //set for icon button area
                        ).createShader(rect);
                      },
                      child: child,
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////////////////////////

class PhotoGridContent extends StatefulWidget {
  final User _user;

  const PhotoGridContent(this._user, {super.key});

  @override
  _PhotoGridContentState createState() => _PhotoGridContentState();
}

class _PhotoGridContentState extends State<PhotoGridContent>
    with WidgetsBindingObserver {
  late User _user;
  final List<UserImage> _images = <UserImage>[];
  // ignore: unused_field
  final String _page = 'receipt';
  String imageCountDirPath =
      '${FileSystemManager.documentDirectory()}/ImageCount/';
  String receiptsDirPath = '${FileSystemManager.documentDirectory()}/Receipts/';
  int _imageCount = 0;
  bool _isImageAdded = false;

  _PhotoGridContentState();

  @override
  void initState() {
    super.initState();
    _user = widget._user;

    _checkFolderForImageCount();

    // ignore: discarded_futures
    _setIsGallery(true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: HomeDrawer(
          user: _user,
        ), //DRAWER
        appBar: _appBar(), //APP BAR
        backgroundColor: AppColors.grey,
        body: Column(
          children: <Widget>[
            Expanded(child: _receiptGridView()), //RECEIPT GRIDVIEW
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _cancelBtn(),
                Visibility(
                  visible: _isImageAdded,
                  child: _saveImages(),
                ),
              ],
            ), //ATTACH RECEIPTS BUTTON
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text(
        "Photos",
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

  ElevatedButton _saveImages() {
    return ElevatedButton(
      child: Row(
        children: <Widget>[
          Text(
            'Save Images',
            style: const TextStyle(
              color: AppColors.primaryColor,
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
        padding:
            MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(10.0)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: const BorderSide(color: AppColors.buttonOutlineYellow),
          ),
        ),
        elevation: MaterialStateProperty.resolveWith(
          (final Set<MaterialState> states) => 20.0,
        ),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (final Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              //post-press
              return AppColors.buttonYellowPressed;
            } else {
              //pre-press
              return AppColors.buttonYellow;
            }
          },
        ),
      ),
      onPressed: () async {
        _setIsGallery(false);
        Navigator.pop(context, _images);
      },
    );
  }

  ElevatedButton _cancelBtn() {
    return ElevatedButton(
      child: Row(
        children: <Widget>[
          Text(
            'Cancel',
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
      onPressed: () async {
        _setIsGallery(false);
        Navigator.pop(context);
      },
    );
  }

  void _checkFolderForImageCount() {
    final bool folderExists =
        FileSystemEntity.isDirectorySync(imageCountDirPath);
    if (folderExists) {
      final List<FileSystemEntity> files =
          Directory(imageCountDirPath).listSync().toList();
      for (final FileSystemEntity file in files) {
        final bool fileExists = FileSystemEntity.isFileSync(file.path);
        if (fileExists) {}
      }
    }
  }

  // ignore: use_setters_to_change_properties
  void _handleImageAdded(final bool isAdded) {
    setState(() {
      _isImageAdded = isAdded;
    });
  }

  CustomScrollView _receiptGridView() {
    return CustomScrollView(
      primary: false,
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.all(15.0),
          sliver: new PhotoGridView(
            _images,
            _user,
            _imageCount,
            _handleImageAdded,
          ),
        ),
      ],
    );
  }

  Future<void> _setIsGallery(final bool flag) async {
    SharedPreferences.getInstance().then((final SharedPreferences prefs) {
      prefs.setBool('isGallery', flag);
      prefs.setInt('lifecycle-count', 1);
    });
  }
}
