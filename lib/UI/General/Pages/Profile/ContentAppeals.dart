import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kz/API/RestProvider/RestProvider.dart';
import 'package:kz/Style.dart';
import 'package:kz/UI/General/Pages/ViewAppeal/ViewAppeal.dart';
import 'package:kz/models/Address.dart';
import 'package:kz/models/Appeal.dart';
import 'package:kz/utils/svg/IconSVG.dart';
import 'package:yandex_geocoder/yandex_geocoder.dart' as ya;


const String ya_key = "3980e55c-3d0b-4c4e-a3f2-0ea6db1984d7";


class ContentAppeals extends StatefulWidget {
  @override
  _ContentAppealsState createState() => _ContentAppealsState();
}

class _ContentAppealsState extends State<ContentAppeals> {

  List<Appeal> listAppeal;
  bool loadingState = true;


  load()async{
    listAppeal = await AppealProvider.get();
    for(int i =0; i < listAppeal.length; i++){
      listAppeal[i].addressText = await getLocation(listAppeal[i].address);
    }
    loadingState = false;
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    load();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: loadingState?loadingWidget():Column(
        children: [
          appealsList()
        ],
      ),
    );
  }

  Widget appealsList(){
    return Column(
      children: List.generate(listAppeal.length, (index) {
        Appeal item = listAppeal[index];
        return Padding(
          padding: const EdgeInsets.only(bottom:10.0),
          child: GestureDetector(
            behavior: HitTestBehavior.deferToChild,
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> ViewAppeal(item.id)));
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color.fromRGBO(249,249,249,1),
                borderRadius: BorderRadius.all(Radius.circular(20))
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 40,
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          profileImage(url: listAppeal[index].user == null?null:listAppeal[index].user.photo== null?null:listAppeal[index].user.photo),
                          SizedBox(width: 10,),
                          Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width-90,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    item.anonim?textName("Анонимно"):textName(item.user.name),
                                    Spacer(),
                                    status(item.status),
                                  ],
                                ),
                                SizedBox(height: 3,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    date(item.date),
                                    SizedBox(width: 3,),
                                    idText(item.id),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 12,),
                    categoryText(item.category.name),
                    SizedBox(height: 12,),

                    addressText(item.addressText),
                    SizedBox(height: 19,),

                    commentText(item.comment),
                    SizedBox(height: 30,),

                    photoList(item.photos),
                    response(item),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget response(Appeal item){
    if(item.response == null || item.response == ""){
      return SizedBox();
    }else{
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Ответ", style: TextStyle(color: cBlack, fontFamily: fontFamily, fontSize: 16, fontWeight: FontWeight.w600, ),),
          SizedBox(height: 6,),
          Text(item.response, style: TextStyle(color: cBlack, fontSize: 14, fontWeight: FontWeight.w400, fontFamily: fontFamily,),),
          SizedBox(height: 6,),
          Text(item.dateResponse, style: TextStyle(color: cGrey, fontFamily: fontFamily, fontWeight: FontWeight.w400, fontSize: 12))

        ],
      );
    }
  }
  Widget textName(String text){
    return Text(text, style: TextStyle(color: cBlack, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: fontFamily),);
  }
  Widget status(int status){
    String tx;
    Color color;
    switch(status){
      case 0:{tx= "Модерация"; color = cYellow;}break;
      case 1:{tx= "Модерация";color = cYellow;}break;
      case 2:{tx= "Рассмотрение";color = cYellow;}break;
      case 3:{tx= "Отклонена";color = cRed;}break;
      case 4:{tx= "В исполнении";color = cYellow;}break;
      case 5:{tx= "Решено";color = cGreen;}break;
      default:{tx= 'Модерация';color = cYellow;}
    }

    return Text(tx, style: TextStyle(color: color, fontFamily: fontFamily, fontSize: 12, fontWeight: FontWeight.w400),);
  }
  Widget date(String date){
    return Text(date, style: TextStyle(color: cGrey, fontFamily: fontFamily, fontWeight: FontWeight.w400, fontSize: 12),);
  }
  Widget idText(int id){
    return Text('id$id', style: TextStyle(color: cBlue, fontSize: 12, fontWeight: FontWeight.w400, fontFamily: fontFamily),);
  }
  Widget categoryText(String text) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          child: IconSvg(IconsSvg.bag),
        ),
        SizedBox(
          width: 13,
        ),
        Text(text, style: TextStyle(color: cBlack, fontFamily: fontFamily, fontWeight: FontWeight.w400, fontSize: 12,),)
      ],
    );
  }
  Widget addressText(String text) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          child: IconSvg(IconsSvg.marker),
        ),
        SizedBox(
          width: 13,
        ),
        Container(
            width: MediaQuery.of(context).size.width-74,
            child: Text(text, style: TextStyle(color: cBlack, fontFamily: fontFamily, fontWeight: FontWeight.w400, fontSize: 12,),))
      ],
    );
  }

  Widget commentText(String text){
    return Text(text, style: TextStyle(
      color: cBlack, fontSize: 14, fontWeight: FontWeight.w400, fontFamily: fontFamily,
    ),);
  }

  Widget photoList(List<String> images) {
    double _padding = 8;

    List<Widget> items = [];
    double size =
        (MediaQuery
            .of(context)
            .size
            .width - _padding * 7) / 5 - 0 * 2;

    if (images.length > 0) {
      for (int i = 0; i < images.length; i++) {
        items.add(Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                width: size,
                height: size,
                child: Image.network(
                  (images[i]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: _padding,
            )
          ],
        ));
      }
    }

    if(items.length == 0)return SizedBox();
    return Row(
      children: List.generate(items.length, (index) => items[index]),
    );
  }


  Widget profileImage({String url}){
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(50)),
        color: url==null?cGrey:Colors.transparent,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        child: url == null?Center(child: IconSvg(IconsSvg.person, color: cWhite),):Image.network(url, fit: BoxFit.cover,),
      ),
    );
  }


  Widget loadingWidget(){
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
  Widget errorWidget(){
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Text("Обращений нет"),
      ),
    );
  }

  Future<String> getLocation(Address latLongFirst) async {


    ya.YandexGeocoder geocoder = ya.YandexGeocoder(apiKey: ya_key);
    ya.GeocodeResponse geocodeFromPoint = await geocoder.getGeocode(ya.GeocodeRequest(
      geocode: ya.PointGeocode(
          latitude: latLongFirst.latitude, longitude: latLongFirst.longitude),
      lang: ya.Lang.ru,
    ));

    // print("YANDEX geocoder ===========================" +
    //     geocodeFromPoint.response.toString());
    return geocodeFromPoint.firstAddress.formatted;

  }

}
