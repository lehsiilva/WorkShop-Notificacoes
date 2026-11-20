
import 'package:geolocator/geolocator.dart';
 
enum LocationAccess {
  granted, 
  denied, 
  deniedForever, 
  serviceDisabled, 
 
class LocationPermissionService {
  Future<LocationAccess> check() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return LocationAccess.serviceDisabled;
    }
    return _map(await Geolocator.checkPermission());
  }
 

  Future<LocationAccess> request() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return LocationAccess.serviceDisabled;
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return _map(permission);
  }
 
  
  Future<bool> ensureGranted() async =>
      (await request()) == LocationAccess.granted;
 
  
  Future<bool> openAppSettings() => Geolocator.openAppSettings();
 
 
  Future<bool> openLocationSettings() => Geolocator.openLocationSettings();
 
  LocationAccess _map(LocationPermission p) {
    switch (p) {
      case LocationPermission.whileInUse:
      case LocationPermission.always:
        return LocationAccess.granted;
      case LocationPermission.deniedForever:
        return LocationAccess.deniedForever;
      case LocationPermission.denied:
      case LocationPermission.unableToDetermine:
        return LocationAccess.denied;
    }
  }
}
 