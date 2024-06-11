// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
// import 'package:project_1/api/location_api.dart';
// import 'package:project_1/models/current_location.dart';
import 'package:project_1/models/user.dart';
import 'package:project_1/ui/themes/app_colors.dart';

class PartyRoute extends StatefulWidget {
  // final String? currentAddress;
  final User user;

  const PartyRoute({Key? key, required this.user}) : super(key: key);

  @override
  State<PartyRoute> createState() => _PartyRouteState();
}

class _PartyRouteState extends State<PartyRoute> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocus = FocusNode();
  late User _user;
  final User _user2 = User();
  final User _user3 = User();
  final User _user4 = User();
  late String? _currentAddress = '[Please Check-In]';
  late String? _displayAddress = '[Please Check-In]';
  bool _switch1 = false;

  @override
  void initState() {
    super.initState();
    // _currentAddress = widget.currentAddress;
    _user = widget.user;
    _populateTestUsers();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _messageFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(), //APP BAR
      backgroundColor: Colors.blue,
      body: _body(), //BODY
    );
  }

  void _populateTestUsers() {
    _user2.UserID = 2;
    _user2.Username = 'Hillbilly123';
    _user2.Email = 'Sara@therapy.com';
    _user2.ProfilePicPath = 'assets/Sarah.jpg';

    _user3.UserID = 3;
    _user3.Username = 'JohnstonDough420';
    _user3.Email = 'Juda@lee.com';
    _user3.ProfilePicPath = 'assets/Juda.jpg';

    _user4.UserID = 4;
    _user4.Username = 'RealJessicaAlba';
    _user4.Email = 'Jessica@alba.com';
    _user4.ProfilePicPath = 'assets/JessicaAlba.jpg';
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text(
        "Welcome to the Party!",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.blue,
      iconTheme: IconThemeData(
        color: Colors.orange,
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => _navigateWithParams('home', _user),
      ),
    );
  }

  Flex _body() {
    return Flex(
      direction: Axis.vertical,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flex(
          direction: Axis.horizontal,
          children: [
            Flexible(
              flex: 4,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
                child: Text(
                  'Address is: \n' + _displayAddress!,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(child: SizedBox()),
            Flexible(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, top: 16.0, right: 8.0, bottom: 16.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (final Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          //post-press
                          return Colors.orange;
                        } else {
                          //pre-press
                          return Colors.orange;
                        }
                      },
                    ),
                  ),
                  // onPressed: () => _checkIn(),
                  onPressed: () => null,
                  child: Text(
                    'Check-In',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontFamily: 'Anton',
                      fontStyle: FontStyle.italic,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const Divider(
          color: AppColors.darkOrange,
          thickness: 4,
        ),
        Flexible(child: _partyListView()),
      ],
    );
  }

  ListView _partyListView() {
    ListView partyList = ListView(
      children: [
        ListTile(
          title: Text(
            _user2.Username,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            'subtitle',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          leading: Image.asset(_user2.ProfilePicPath!),
          trailing: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: Text(
                  'VISIBLE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.0,
                    fontFamily: 'Anton',
                    fontStyle: FontStyle.italic,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Flexible(
                child: Switch(
                  activeColor: AppColors.acceptGreen,
                  activeTrackColor: AppColors.grey,
                  inactiveTrackColor: AppColors.red,
                  value: _switch1,
                  onChanged: (bool value) {
                    setState(() {
                      if (_switch1) {
                        _switch1 = false;
                      } else {
                        _switch1 = true;
                      }
                    });
                  },
                ),
              ),
            ],
          ),
          // onTap: () => _navigateWithParams('profile', _user2),
          onTap: () => _navigateToProfile('profile', [_user, _user2]),
        ),
        const Divider(
          color: AppColors.grey,
        ),
        ListTile(
          title: Text(
            _user4.Username,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            'subtitle',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          leading: Image.asset(_user4.ProfilePicPath!),
          onTap: () => _navigateToProfile('profile', [_user, _user4]),
        ),
        const Divider(
          color: AppColors.grey,
        ),
      ],
    );

    return partyList;
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<String> _getAddressFromLatAndLong(Position position) async {
    String address = '';

    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print('Placemarks are: ' + placemark.toString());

    Placemark place = placemark[0];
    address =
        '${place.street},${place.locality},${place.administrativeArea},${place.postalCode}';
    print('Address is: ' + address);

    return address;
  }

  // void _checkIn() async {
  //   Position position = await _determinePosition();
  //   print('Latitude is: ' + position.latitude.toString());
  //   // _currentAddress = position.accuracy;
  //
  //   _currentAddress = await _getAddressFromLatAndLong(position);
  //
  //   List<String> splitLocation = _currentAddress!.split(',');
  //   List<String> splitAddress = splitLocation[0].split(' ');
  //
  //   _displayAddress = splitLocation[0] +
  //       '.\n' +
  //       splitLocation[1] +
  //       ', ' +
  //       splitLocation[2] +
  //       ' ' +
  //       splitLocation[3];
  //
  //   CurrentLocation currentLocation = CurrentLocation();
  //   currentLocation.userID = _user.userID;
  //
  //   if (splitAddress.length == 3) {
  //     currentLocation.StreetNumber = splitAddress[0];
  //     currentLocation.StreetName = splitAddress[1];
  //     currentLocation.StreetType = splitAddress[2];
  //   } else if (splitAddress.length == 4) {
  //     currentLocation.StreetNumber = splitAddress[0];
  //     currentLocation.StreetDirection = splitAddress[1];
  //     currentLocation.StreetName = splitAddress[2];
  //     currentLocation.StreetType = splitAddress[3];
  //   } else {
  //     //TODO: TEST CASE
  //   }
  //
  //   currentLocation.City = splitLocation[1];
  //   currentLocation.State = splitLocation[2];
  //   currentLocation.ZipCode = splitLocation[3];
  //   currentLocation.CheckInDateTime = DateTime.now().toUtc();
  //
  //   LocationAPI locationAPI = LocationAPI();
  //   locationAPI.checkIn(currentLocation);
  //
  //   setState(() {});
  // }

  ///NAVIGATION///
  void _navigate(String path) {
    context.goNamed(path);
  }

  void _navigateWithParams(String path, dynamic params) {
    context.goNamed(path, extra: params);
  }

  void _navigateToProfile(String path, List<Object> params) {
    context.goNamed(path, extra: params);
  }
}
