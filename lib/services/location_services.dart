import 'package:location/location.dart';

class LocationService {
  static final _location = Location();

  static bool _serviceEnabled = false;
  static PermissionStatus _permissionStatus = PermissionStatus.denied;
  static LocationData? currentLocation;

  static Future<void> init() async {
    await _checkService();
    if (_serviceEnabled) {
      await _checkPermission();
    }
  }
  static Future<void> _checkService() async {
    _serviceEnabled = await _location.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
  }

  static Future<void> _checkPermission() async {
    _permissionStatus = await _location.hasPermission();
    if (_permissionStatus == PermissionStatus.denied) {
      _permissionStatus = await _location.requestPermission();
      if (_permissionStatus != PermissionStatus.granted) {
        return;
      }
    }
  }

  static Future<void> fetchCurrentLocation() async {
    if (_serviceEnabled && _permissionStatus == PermissionStatus.granted) {
      currentLocation = await _location.getLocation();
    }
  }

  static Stream<LocationData> fetchLiveLocation() async* {
    yield* _location.onLocationChanged;
  }
}