import 'package:location/location.dart';
import 'package:prayer_app/app/widgets/snackbar.dart';

class LocationService {
  LocationService._();

  static Location _location = Location();

  static Future<LocationData> determinePosition() async {
    bool serviceEnabled;
    PermissionStatus _permissionGranted;

    _location.enableBackgroundMode(enable: false);

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        showSnackbar(title: 'Error Occured', message: 'Location services are disabled...');
        return null;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        showSnackbar(title: 'Error Occured', message: 'Location permissions are denied...');
        return null;
      }
    }

    if (_permissionGranted == PermissionStatus.deniedForever) {
      showSnackbar(
        title: 'Error Occured',
        message: 'Location permissions are permanently denied, we cannot request permissions...',
      );
      return null;
    }

    return await _location.getLocation();
  }
}
