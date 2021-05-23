import 'dart:typed_data' as td;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kz/Style.dart';
import 'package:kz/models/Appeal.dart';
import 'package:kz/utils/GetPosition.dart';
import 'dart:ui' as ui;

class MapAppeals extends StatefulWidget {
  List<Appeal> appeals;
  Function (Appeal appeal)setAppeal;

  MapAppeals(this.appeals, {this.setAppeal});
  @override
  _MapAppealsState createState() => _MapAppealsState();
}

class _MapAppealsState extends State<MapAppeals> {

  bool loading = true;
  bool errors = false;
  List<Appeal> list;
  int countAllAppeals = 0;
  int countStatusDone = 0;
  int countStatusAwait = 0;
  int countStatusAwaitModer = 0;
  Set<Marker> _markers = {};
  BitmapDescriptor markerYellow;
  BitmapDescriptor markerGreen;
  BitmapDescriptor markerRed;
  LatLng position;
  int count = 0;


  initMarkers()async{
    markerGreen = await BitmapDescriptor.fromBytes(await getBytesFromAsset('assets/images/markerGreen.png', 100));
    // markerGreen = await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(40,40)), 'assets/images/markerGreen.png',);
    // markerYellow = await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(40,40)), 'assets/images/markerYellow.png');
    markerYellow = await BitmapDescriptor.fromBytes(await getBytesFromAsset('assets/images/markerYellow.png', 100));
    markerRed = await BitmapDescriptor.fromBytes(await getBytesFromAsset('assets/images/markerRed.png', 100));
    // markerRed = await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(40,40), ), 'assets/images/markerRed.png');
  }
  Future<td.Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }


  load()async{

    loading = true;
    setState(() {

    });
    await initMarkers();

    position = await getPosition();
    if(position == null) {errors = true;
    loading = false;
    setState(() {

    });
    return;}
    countAllAppeals = list.length;

    for(int i = 0; i < list.length;i++){
      switch(list[i].status){
        case 0:  countStatusAwaitModer++; break;
        case 1:  countStatusAwaitModer++; break;
        case 2:  countStatusAwaitModer++; break;
        case 3:  countStatusAwaitModer++; break;
        case 4:  countStatusAwait++; break;
        case 5:  countStatusDone++; break;
        default:  countStatusAwaitModer++;
      }
      _markers.add(
        Marker(

          onTap: (){
            if(widget.setAppeal != null){
              widget.setAppeal(list[i]);
            }
          },
          icon: getMarker(list[i].status),
            markerId: MarkerId("id-${list[i].id}$count"),
            position:LatLng(list[i].address.latitude,list[i].address.longitude),
            draggable: false,
        ),
      );
      count++;
    }
    loading = false;
    setState(() {

    });
  }

  setGreen(){
    _markers = {};
    for(int i = 0; i < list.length;i++){
      _markers.add(
        Marker(
          visible: list[i].status==5?true:false,
          onTap: (){
            if(widget.setAppeal != null){
              widget.setAppeal(list[i]);
            }
          },
          icon: getMarker(list[i].status),
          markerId: MarkerId("id-${list[i].id}$count"),
          position:LatLng(list[i].address.latitude,list[i].address.longitude),
          draggable: false,
        ),
      );
    }
    setState(() {

    });
  }
  setAll(){
    _markers = {};
    for(int i = 0; i < list.length;i++){
      _markers.add(
        Marker(
          visible: true,
          onTap: (){
            if(widget.setAppeal != null){
              widget.setAppeal(list[i]);
            }
          },
          icon: getMarker(list[i].status),
          markerId: MarkerId("id-${list[i].id}$count"),
          position:LatLng(list[i].address.latitude,list[i].address.longitude),
          draggable: false,
        ),
      );
    }
    setState(() {

    });
  }
  setRed(){
    _markers = {};
    for(int i = 0; i < list.length;i++){
      _markers.add(
        Marker(
          visible: list[i].status==0||list[i].status==1||list[i].status==2||list[i].status==3?true:false,
          onTap: (){
            if(widget.setAppeal != null){
              widget.setAppeal(list[i]);
            }
          },
          icon: getMarker(list[i].status),
          markerId: MarkerId("id-${list[i].id}$count"),
          position:LatLng(list[i].address.latitude,list[i].address.longitude),
          draggable: false,
        ),
      );
    }
    setState(() {

    });
  }
  setYellow(){
    _markers = {};
    for(int i = 0; i < list.length;i++){
      _markers.add(
        Marker(
          visible: list[i].status==4?true:false,
          onTap: (){
            if(widget.setAppeal != null){
              widget.setAppeal(list[i]);
            }
          },
          icon: getMarker(list[i].status),
          markerId: MarkerId("id-${list[i].id}$count"),
          position:LatLng(list[i].address.latitude,list[i].address.longitude),
          draggable: false,
        ),
      );
    }
    setState(() {

    });
  }


  @override
  void initState() {
    super.initState();
    list = widget.appeals;
    load();
  }

  @override
  Widget build(BuildContext context) {
    return loading?_loadingWidget():errors?_errorWidget():_content();
  }

  Widget _errorWidget(){
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTap: (){
        load();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Text("Не удалось загрузить"),
        ),
      ),
    );
  }

  Widget _loadingWidget(){
    return Center(child: CircularProgressIndicator(),);
  }
  Widget _content(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      child: Stack(
        children: [

          GoogleMap(
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            markers: _markers,
            initialCameraPosition: CameraPosition(
              target: position,
              zoom: 15,
            ),
          ),
          Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: info(),
              ))
        ],
      ),
    );
  }

  Widget info(){
    return Container(
      // height: 60,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 10,),
            GestureDetector(
              behavior: HitTestBehavior.deferToChild,
              onTap: (){
                setAll();
              },
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: cBlack,
                  borderRadius: BorderRadius.all(Radius.circular(15))
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Всего", style: TextStyle(color: cWhite, fontWeight: FontWeight.w600, fontSize: 13, fontFamily: fontFamily),),
                      Text("($countAllAppeals)", style: TextStyle(color: cWhite.withOpacity(0.5), fontWeight: FontWeight.w600, fontSize: 13, fontFamily: fontFamily),),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 10,),
            GestureDetector(
              behavior: HitTestBehavior.deferToChild,
              onTap: (){
                setRed();
              },
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                    color: cRed,
                    borderRadius: BorderRadius.all(Radius.circular(15))
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Не рассмотрено", style: TextStyle(color: cWhite, fontWeight: FontWeight.w600, fontSize: 13, fontFamily: fontFamily),),
                      Text("($countStatusAwaitModer)", style: TextStyle(color: cWhite.withOpacity(0.5), fontWeight: FontWeight.w600, fontSize: 13, fontFamily: fontFamily),),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 10,),
            GestureDetector(
              behavior: HitTestBehavior.deferToChild,
              onTap: (){
                setYellow();
              },
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                    color: cYellow,
                    borderRadius: BorderRadius.all(Radius.circular(15))
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("На рассмотрении", style: TextStyle(color: cWhite, fontWeight: FontWeight.w600, fontSize: 13, fontFamily: fontFamily),),
                      Text("($countStatusAwait)", style: TextStyle(color: cWhite.withOpacity(0.5), fontWeight: FontWeight.w600, fontSize: 13, fontFamily: fontFamily),),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 10,),

            GestureDetector(
              behavior: HitTestBehavior.deferToChild,
              onTap: (){
                setGreen();
              },
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                    color: cGreen,
                    borderRadius: BorderRadius.all(Radius.circular(15))
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Готово", style: TextStyle(color: cWhite, fontWeight: FontWeight.w600, fontSize: 13, fontFamily: fontFamily),),
                      Text("($countStatusDone)", style: TextStyle(color: cWhite.withOpacity(0.5), fontWeight: FontWeight.w600, fontSize: 13, fontFamily: fontFamily),),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  BitmapDescriptor getMarker(int status){
    switch(status){
      case 0: return markerRed; break;
      case 1: return markerRed; break;
      case 2: return markerRed; break;
      case 3: return markerRed; break;
      case 4: return markerYellow; break;
      case 5: return markerGreen; break;
      default: return markerRed;
    }
  }
}
