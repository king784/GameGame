import 'dart:async';
import 'package:geolocator/geolocator.dart';

class UserLocation {
  static Position userPos;

  bool userLocationOk = false;
  bool positionDataEnabled = false;
  bool locationOn = false;
  bool loadingLocation = true;

  static bool userLocOkForMenu = false;//used only for menu, don't change. it works ok.

  GeolocationStatus geolocationStatus;
  //static StreamSubscription<Position> userPositionStream;
  double _distanceInMeters;
  double _radiusFromEvent = 100;

  List<Placemark> eventAddress;

  Future getCurrentLocation() async {
    //print('waiting for user location.');
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

    // print('user location found: ' + userPos.toString() + '.');
  }

  Future getEventAddressIntoPlacemark() async {
    //print('waiting for event address.');
    eventAddress =
        await Geolocator().placemarkFromCoordinates(60.487251, 26.892282);
  }

  Future<void> checkGeolocationPermissionStatus() async {
    geolocationStatus = await Geolocator().checkGeolocationPermissionStatus();
    //print('Geolocation status: ' + geolocationStatus.value.toString());
    if (geolocationStatus.value == 2) {
      //check if location status is granted
      positionDataEnabled = true;
    } else {
      positionDataEnabled = false;
    }

    //print('checking geolocation status: ' + geolocationStatus.value.toString());
  }

  void updateUserDistanceFromEvent() async {
    await checkIfLocationIsOn();
    if (eventAddress == null) {
      await getEventAddressIntoPlacemark();
    }
    if (positionDataEnabled && locationOn) {
      await getCurrentLocation();

      //calculate distance between user and event address
      _distanceInMeters = await Geolocator().distanceBetween(
          eventAddress[0].position.latitude,
          eventAddress[0].position.longitude,
          userPos.latitude,
          userPos.longitude);

      if (_distanceInMeters < _radiusFromEvent) {
        userLocationOk = true;
        userLocOkForMenu = true;
      } else {
        userLocationOk = false;
        userLocOkForMenu = false;
      }
    }

    if (loadingLocation) {
      loadingLocation = false;
    }

    // print('updating user location, distance from event is ' +
    //     distanceInMeters.toString() +
    //     ' meters. bool userLocationOk = ' +
    //     userLocationOk.toString() +
    //     '.');
  }

  Future<void> checkIfLocationIsOn() async {
    await Geolocator().isLocationServiceEnabled().then((val) {
      locationOn = val;
    });
  }

  int distanceFromRadius() {
    int dist;
    if (_distanceInMeters != null) {
      dist = _distanceInMeters.round() - _radiusFromEvent.round();
    }
    return dist;
  }
}
