import 'dart:async';
import 'package:geolocator/geolocator.dart';

class UserLocation {
  static Position userPos;

  bool userLocationOk = false;
  bool positionDataEnabled = false;
  bool loadingLocation = true;

  GeolocationStatus geolocationStatus;
  //static StreamSubscription<Position> userPositionStream;
  static double distanceInMeters;

  List<Placemark> eventAddress;

  Future getCurrentLocation() async {
    print('waiting for user location.');
    //update the current location
    userPos = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

// //follow user position, don't use anymore
//     userPositionStream = Geolocator()
//         .getPositionStream(
//             LocationOptions(accuracy: LocationAccuracy.best, timeInterval: 2))
//         .listen((Position pos) {
//       print('user pos: ' + userPos.toString());
//       if (pos != null) {
//         userPos = pos;
//       }
//     });

    print('user location found: ' + userPos.toString() + '.');
  }

  Future getEventAddressIntoPlacemark() async {
    print('waiting for event address.');
    eventAddress =
        await Geolocator().placemarkFromCoordinates(60.459403, 26.932751);
  }

  void checkGeolocationPermissionStatus() async {
    geolocationStatus = await Geolocator().checkGeolocationPermissionStatus();
    //print('Geolocation status: ' + geolocationStatus.value.toString());
    if (geolocationStatus.value == 2) {
      //check if location status is granted
      positionDataEnabled = true;
    } else {
      positionDataEnabled = false;
    }
    print('checking geolocation status: ' + geolocationStatus.value.toString());
  }

  void updateUserDistanceFromEvent() async {
    if (eventAddress == null) {
      await getEventAddressIntoPlacemark();
    }

    await getCurrentLocation();

    //calculate distance between user and event address
    distanceInMeters = await Geolocator().distanceBetween(
        eventAddress[0].position.latitude,
        eventAddress[0].position.longitude,
        userPos.latitude,
        userPos.longitude);

    if (distanceInMeters < 100 && positionDataEnabled) {
      userLocationOk = true;
    } else {
      userLocationOk = false;
    }

    if (loadingLocation) {
      loadingLocation = false;
    }

    print('updating user location, distance from event is ' +
        distanceInMeters.toString() +
        ' meters. bool userLocationOk = ' +
        userLocationOk.toString() +
        '.');
  }
}
