import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kz/Style.dart';

const String key = "AIzaSyAEBsJIE-UAlDTLpYBKbbshsew12e_vquw";

class GoogleMapPage extends StatefulWidget {

  LatLng center;
  bool chk;

  GoogleMapPage(this.center, {this.chk});
  @override
  _GoogleMapPageState createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {

  LatLng _currentPosition ;
  Set<Marker> _markers = {};
  int count = 0;


  _onMapCreated(GoogleMapController controller) {
    _markers = {};
      _markers.add(
        Marker(
          markerId: MarkerId("id-$count"),
          position: widget.center,
          draggable: true,
          onDragEnd: (point){

            widget.center = point;
            _currentPosition = point;
              //todo setPosition widget.center
              _onMapCreated(controller);

          }
        ),
      );
      setState(() {});
      count++;

  }



  @override
  void initState() {
    super.initState();
    _currentPosition = widget.center;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: cWhite,
        centerTitle: true,
        title: Text("Удерживайте маркер для перемещения", style: TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),),
        leading: GestureDetector(
          onTap:(){
            Navigator.pop(context, _currentPosition);
          },
          behavior: HitTestBehavior.deferToChild,
          child: Container(
            child: Icon(Icons.save, color: cBlue,),
          ),
        ),
      ),
      body: GoogleMap(

        onMapCreated: _onMapCreated,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        markers: _markers,
        initialCameraPosition: CameraPosition(
          target: widget.center,
          zoom: 15,
        ),
      ),
    );
  }
}
