import 'package:flutter/material.dart';
import 'package:kz/API/RestProvider/RestProvider.dart';
import 'package:kz/Style.dart';
import 'package:kz/UI/General/Pages/Profile/ContentAppeals.dart';
import 'package:kz/UI/General/Pages/ViewAppeal/MapAppeals.dart';
import 'package:kz/models/Appeal.dart';
import 'dart:io';


import 'package:kz/models/Address.dart';
import 'package:kz/utils/svg/IconSVG.dart';
import 'package:yandex_geocoder/yandex_geocoder.dart' as ya;

class ViewAppeal extends StatefulWidget {
  int id;

  ViewAppeal(this.id);
  @override
  _ViewAppealState createState() => _ViewAppealState();
}

class _ViewAppealState extends State<ViewAppeal> {

  ScrollController scrollController = ScrollController();
  TextEditingController controllerComment = TextEditingController();
  bool loading = true;
  bool errors = false;

  Appeal appeal;
  List<Appeal> appeals;



  load()async{
    //todo load
    appeals = await AppealProvider.get(all: true);
    for(int i = 0; i < appeals.length; i++){
      if(appeals[i].id == widget.id){
        appeal = appeals[i];
        appeal.addressText = await getLocation(appeal.address);
      }
    }

    loading = false;
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
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        // iconTheme: ThemeData.dark().iconTheme.copyWith(color: cBlack),
        leading: GestureDetector(
          behavior: HitTestBehavior.deferToChild,
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, color: cBlack, size: 24,),
        ),

        centerTitle: true,
        title: Text("LOGO", style: TextStyle(color: cBlack, fontFamily: fontFamily, fontWeight: FontWeight.w700, fontSize: 24),),
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  // Container(height: 20, width: 20, color: cRed,),
                  SizedBox(height: 20,),
                  loading?Center(child: CircularProgressIndicator(),):errors?Center(child: Text("Ошибка загрузки"),):_content(),
                ],
              ),
            ),
          )
      ),
    );
  }


  Widget _content(){
    return Column(
      children: [
        _appealWidget(),
        Container(
          // color: cRed,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width*1.5,
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: MapAppeals(appeals, setAppeal: (appealMap){
                  scrollController.animateTo(0, duration: Duration(milliseconds: 200), curve: Curves.easeOut);
                  appeal = appealMap;
                  print("set");
                  setState(() {

                  });
                },))),
      ],
    );
  }



  Widget _appealWidget(){
    return Padding(
      padding: const EdgeInsets.only(bottom:10.0),
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
                    profileImage(url: appeal.user == null?null:appeal.user.photo== null?null:appeal.user.photo),
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
                              appeal.anonim?textName("Анонимно"):textName(appeal.user.name),
                              Spacer(),
                              status(appeal.status),
                            ],
                          ),
                          SizedBox(height: 3,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              date(appeal.date),
                              SizedBox(width: 3,),
                              idText(appeal.id),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 12,),
              categoryText(appeal.category.name),
              SizedBox(height: 12,),

              addressText(appeal.addressText??"..."),
              SizedBox(height: 19,),

              commentText(appeal.comment),
              SizedBox(height: 30,),

              photoList(appeal.photos),

              SizedBox(height: 8,),
              Divider(),
              SizedBox(height: 8,),

              appeal.openComments?commentsOpen():commentsClose()
            ],
          ),
        ),
      ),
    );
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
            width: MediaQuery.of(context).size.width-75,
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

  Widget commentsClose(){
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTap: (){
        appeal.openComments = true;
        setState(() {

        });
      },
      child: Row(
        children: [
          Row(
            children: [
              IconSvg(IconsSvg.comment),
              SizedBox(width: 10,),
              Text(appeal.comments.length == 0?"Нет ответов":"${appeal.comments.length} ответов",  style: TextStyle(color: cGrey),),
            ],
          ),
        ],
      ),
    );
  }

  Widget commentsOpen(){
    Widget fieldComment(){
      return Container(
        width: MediaQuery.of(context).size.width -40,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          border: Border.all(color: cGrey),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: MediaQuery.of(context).size.width -86,

              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  keyboardType: TextInputType.name,
                  controller: controllerComment,
                  maxLines: 5,
                  minLines: 1,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      fontSize: 15,
                      fontFamily: fontFamily,
                      fontWeight: FontWeight.w400,
                      color: cGrey,
                    ),
                    hintText: "Напишите свой комменатарий",
                  ),
                  style: TextStyle(
                      color: cBlack,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      fontFamily: fontFamily),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: InkWell(
                onTap: ()async{
                  if(controllerComment.text.isNotEmpty){
                    await AppealProvider.commentAdd(controllerComment.text, false, appeal.id);
                    controllerComment.text = "";
                    widget.id = appeal.id;
                    load();
                  }
                },
                child: Container(
                    width: 44,
                    child: IconSvg(IconsSvg.send)),
              ),
            ),
          ],
        ),
      );
    }
    Widget generatorComments(){
      return Column(
        children: List.generate(appeal.comments.length , (index){
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width - 40 -60,

                      child: Divider()),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 50,
                  height: 50,
                  child: profileImage(url: appeal.comments[index].anonim?null:appeal.comments[index].author.photo??null),
                  ),
                  SizedBox(width: 10,),
                  Container(
                    width: MediaQuery.of(context).size.width - 40 -60,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(appeal.comments[index].anonim?"Аноним":appeal.comments[index].author.name??"Аноним", style: TextStyle(color: cBlack, fontFamily: fontFamily, fontSize: 16, fontWeight: FontWeight.w600),),
                        SizedBox(height: 5,),
                        Text(appeal.comments[index].text, style: TextStyle(color: cBlack, fontFamily: fontFamily, fontSize: 14, fontWeight: FontWeight.w400),),
                        SizedBox(height: 5,),
                        Text(appeal.comments[index].date, style: TextStyle(color: cGrey, fontWeight: FontWeight.w400, fontSize: 12, fontFamily: fontFamily,),)

                      ],
                    ),
                  )
                ],
              ),
            ],
          );
        }),
      );
    }
    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.deferToChild,
          onTap: (){
            appeal.openComments = false;
            setState(() {

            });
          },
          child: Row(
            children: [
              Row(
                children: [
                  IconSvg(IconsSvg.comment),
                  SizedBox(width: 10,),
                  Text(appeal.comments.length == 0?"Нет ответов":"${appeal.comments.length} ответов",  style: TextStyle(color: cGrey),),
                  SizedBox(width: 10,),

                  Text("Скрыть",  style: TextStyle(color: cBlue),),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 20,),

        fieldComment(),
        SizedBox(height: 20,),

        generatorComments()


      ],
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
