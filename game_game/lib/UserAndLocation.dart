import 'dart:async';
import 'package:geolocator/geolocator.dart';

class UserLocation {
  static Position userPos;

  static bool userLocationOk = false;
  static bool positionDataEnabled = false;

  GeolocationStatus geolocationStatus;

  List<Placemark> eventAddress;
  Future<Position> getCurrentLocation() async {
    //update the current location
    userPos = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return userPos;
  }

  void getEventAddressIntoPlacemark() async {
    eventAddress =
        await Geolocator().placemarkFromAddress("Heikinkatu 7, Kotka");
  }

  void checkGeolocationPermissionStatus() async {
    geolocationStatus = await Geolocator().checkGeolocationPermissionStatus();
    //print('Geolocation status: ' + geolocationStatus.value.toString());
    if (geolocationStatus.value != 2) {
      //check if location status is anything but granted
      positionDataEnabled = false;
    } else {
      positionDataEnabled = true;
    }
  }

  void updateUserDistanceFromEvent() async {
    getEventAddressIntoPlacemark();

    //follow user position
    StreamSubscription<Position> userPositionStream = Geolocator()
        .getPositionStream(LocationOptions(
            accuracy: LocationAccuracy.best, distanceFilter: 20))
        .listen((Position pos) {
      if (pos != null) {
        userPos = pos;
      }
    });

    //calculate distance between user and event address
    double distanceInMeters = await Geolocator().distanceBetween(
        eventAddress[0].position.latitude,
        eventAddress[0].position.longitude,
        userPos.latitude,
        userPos.latitude);

    if (distanceInMeters <= 100) {
      userLocationOk = true;
    } else {
      userLocationOk = false;
    }
  }
}
