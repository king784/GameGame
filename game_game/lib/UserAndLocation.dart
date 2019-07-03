import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class UserLocation {
  GeolocationStatus geolocationStatus;
  
  static Position currentPos;
  static bool positionDataEnabled;

  void updateCurrentLocation() async {
    //update the current location
    currentPos = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  void checkGeolocationStatus() async {
    geolocationStatus = await Geolocator().checkGeolocationPermissionStatus();
    print('Geolocation status: ' + geolocationStatus.value.toString());
    if (geolocationStatus.value != 2) {
      //check if location status is anything but granted
      positionDataEnabled = false;
    } else {
      //geolocation status is ok
      updateCurrentLocation();
      positionDataEnabled = true;
    }
  }
}
