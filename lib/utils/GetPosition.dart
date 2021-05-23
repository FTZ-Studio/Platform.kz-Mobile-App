import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io';
import 'package:location/location.dart';

Future<LatLng> getPosition()async{

    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    LatLng defPos;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        //todo no Permission
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        //todo NoPermission
        return null;
      }
    }
    _locationData = await location.getLocation();
    print("Location" + _locationData.latitude.toString());
    defPos = LatLng(_locationData.latitude, _locationData.longitude);

    print("LOCATION " +
        _locationData.latitude.toString() +
        " " +
        _locationData.longitude.toString());

    return defPos;

}