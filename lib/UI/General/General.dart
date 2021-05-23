
import 'package:flutter/material.dart';
import 'package:kz/API/RestProvider/RestProvider.dart';
import 'package:kz/Controllers/GeneralController.dart';
import 'package:kz/Style.dart';
import 'package:kz/UI/General/Pages/Home.dart';
import 'package:kz/UI/General/Pages/ViewAppeal/MapAppeals.dart';
import 'package:kz/UI/widgets/Auth/ShowAuth.dart';
import 'package:kz/UI/widgets/MainAppBar.dart';
import 'package:kz/UI/widgets/MainMenu.dart';
import 'package:kz/UI/widgets/TabBar/MainTabBar.dart';
import 'package:kz/models/Appeal.dart';
import 'package:kz/utils/app_keys.dart';
import 'package:kz/utils/svg/IconSVG.dart';
import 'package:kz/utils/tokenDB.dart';

class General extends StatefulWidget {
  @override
  _GeneralState createState() => _GeneralState();
}

class _GeneralState extends State<General> {

  GeneralController controller;

  TextEditingController controllerComment = TextEditingController();
  ScrollController scrollController = ScrollController();
  Appeal currentAppeal;

  updateAppeal(Appeal appeal)async{

    currentAppeal = appeal;

    setState(() {

    });
    await Future.delayed(Duration(milliseconds: 1));
    scrollController.animateTo(scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 200), curve: Curves.easeOut);
  }

  List<Appeal> appeals;

  bool loading = true;
  bool errors = false;

  load()async{
    appeals = await  AppealProvider.get(all: true);
    if(appeals == null){
      errors = true;
    }

    if(currentAppeal != null){
      for(int i = 0; i < appeals.length; i++){
        if(appeals[i].id == currentAppeal.id){
          currentAppeal = appeals[i];
        }
      }
    }
    loading = false;
    setState(() {});
  }

  @override
  initState(){
    super.initState();
    controller = GeneralController();
    load();
  }


  bool menu = false;
  bool menuProfile = false;
  TextStyle styleMenu = TextStyle(color: cBlack, fontSize: 16, fontWeight: FontWeight.w500, fontFamily: fontFamily);

  // GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();


  @override
  Widget build(BuildContext context) {
    return Container(
      color: cWhite,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(

        controller: scrollController,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Scaffold(
                    key: AppKeys.scaffoldKey,
                    appBar: MainAppBar(
                      profileTap: (){
                        controller.profileMenuTap();
                      },
                      activeMenu: controller.streamMenu,
                      menuTap: (){
                        controller.menuTap();
                      },
                    ),
                    backgroundColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                    body: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            color: Colors.red,
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: Image.asset("assets/images/back.png", fit: BoxFit.fill,),
                          ),
                        ),
                        PageView(
                          children: [
                            Home(controller)
                          ],
                        ),
                        menuWidget(),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: MainTabBar(
                            listItems: [
                              ItemMainTabBar(text: Text("Сообщить"), icon:  IconSvg(IconsSvg.document, width: 24, ), onTap: (){
                                controller.addAppeal();
                              }),
                              ItemMainTabBar(text: Text("Новости"), icon:  IconSvg(IconsSvg.message, width: 24, ), onTap: (){
                                controller.newsOpen();
                              }),
                              ItemMainTabBar(text: Text("Тендеры"), icon:  IconSvg(IconsSvg.trands, width: 24,), onTap: (){controller.tenderOpen(context);}),
                              ItemMainTabBar(text: Text("Идеи"), icon:  IconSvg(IconsSvg.lamp, width: 24, ), onTap: (){
                                controller.ideaOpen();
                              }),
                            ],

                          ),
                        )
                      ],
                    ),
                  ),

                ],
              ),
            ),
            errors?SizedBox():Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.70,
              child: loading?Center(child: CircularProgressIndicator(),):MapAppeals(appeals, setAppeal: updateAppeal,),
            ),
            currentAppeal == null?SizedBox():_appealWidget(),
          ],
        ),
      ),
    );
  }


  Widget menuWidget(){
    return StreamBuilder(
        stream: controller.streamMenu,
        builder: (context, data){
          if(!data.hasData){
            return SizedBox();
          }else{
            MenuState state =  data.data;
            if(state.menuState){
              return MainMenu(
                items: [
                  ItemMainTabBar(icon: IconSvg(IconsSvg.document, width: 24, color: cRed), text: Text("Сообщайте о проблемах", style: styleMenu,), onTap: (){controller.addAppeal();}),
                  ItemMainTabBar(icon: IconSvg(IconsSvg.message, width: 24, color: cBlue), text: Text("Местные новости", style: styleMenu), onTap: (){controller.newsOpen();}),
                  ItemMainTabBar(icon: IconSvg(IconsSvg.lamp, width: 24, color: cGreen), text: Text("Идеи и предложения", style: styleMenu), onTap: (){controller.ideaOpen();}),
                  ItemMainTabBar(icon: IconSvg(IconsSvg.trands, width: 24, color: cBlueSoso), text: Text("Обсуждения тендеров", style: styleMenu), onTap: (){controller.tenderOpen(context);}),
                  ItemMainTabBar(icon: IconSvg(IconsSvg.warn, width: 24, color: cOrange), text: Text("Контакты", style: styleMenu) ,onTap: (){controller.contactsOpen(context);}),
                ],
              );
            }else if(state.profileMenuState){
              return MainMenu(
                items: [
                  ItemMainTabBar(icon: IconSvg(IconsSvg.person, width: 24, color: cGrey), text: Text("Личный кабинет", style: styleMenu), onTap: (){controller.profileOpen(context);}),
                  ItemMainTabBar(icon: IconSvg(IconsSvg.letterArrow, width: 24, color: cGrey), text: Text("Мои обращения", style: styleMenu), onTap: (){controller.appealOpen(context);}),
                ],
              );
            }else{
              return SizedBox();
            }
          }
        });
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
                    profileImage(url: currentAppeal.user == null?null:currentAppeal.user.photo== null?null:currentAppeal.user.photo),
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
                              currentAppeal.anonim?textName("Анонимно"):textName(currentAppeal.user.name),
                              Spacer(),
                              status(currentAppeal.status),
                            ],
                          ),
                          SizedBox(height: 3,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              date(currentAppeal.date),
                              SizedBox(width: 3,),
                              idText(currentAppeal.id),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 12,),
              categoryText(currentAppeal.category.name),
              SizedBox(height: 12,),

              addressText(currentAppeal.addressText??"..."),
              SizedBox(height: 19,),

              commentText(currentAppeal.comment),
              SizedBox(height: 30,),

              photoList(currentAppeal.photos),

              SizedBox(height: 8,),
              Divider(),
              Container(
                  child: response(currentAppeal)),
              SizedBox(height: 8,),
              currentAppeal.openComments?commentsOpen():commentsClose()
            ],
          ),
        ),
      ),
    );
  }

  Widget response(Appeal item){
    print("RESPONSE ${item.response}");
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
        currentAppeal.openComments = true;
        setState(() {

        });
      },
      child: Row(
        children: [
          Row(
            children: [
              IconSvg(IconsSvg.comment),
              SizedBox(width: 10,),
              Text(currentAppeal.comments.length == 0?"Нет ответов":"${currentAppeal.comments.length} ответов",  style: TextStyle(color: cGrey),),
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
                  if(await tokenDB() =="null"){controller.auth();}else
                  if(controllerComment.text.isNotEmpty){
                    await AppealProvider.commentAdd(controllerComment.text, false, currentAppeal.id);
                    controllerComment.text = "";
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
        children: List.generate(currentAppeal.comments.length , (index){
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
                    child: profileImage(url: currentAppeal.comments[index].anonim?null:currentAppeal.comments[index].author.photo??null),
                  ),
                  SizedBox(width: 10,),
                  Container(
                    width: MediaQuery.of(context).size.width - 40 -60,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(currentAppeal.comments[index].anonim?"Аноним":currentAppeal.comments[index].author.name??"Аноним", style: TextStyle(color: cBlack, fontFamily: fontFamily, fontSize: 16, fontWeight: FontWeight.w600),),
                        SizedBox(height: 5,),
                        Text(currentAppeal.comments[index].text, style: TextStyle(color: cBlack, fontFamily: fontFamily, fontSize: 14, fontWeight: FontWeight.w400),),
                        SizedBox(height: 5,),
                        Text(currentAppeal.comments[index].date, style: TextStyle(color: cGrey, fontWeight: FontWeight.w400, fontSize: 12, fontFamily: fontFamily,),)

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
            currentAppeal.openComments = false;
            setState(() {

            });
          },
          child: Row(
            children: [
              Row(
                children: [
                  IconSvg(IconsSvg.comment),
                  SizedBox(width: 10,),
                  Text(currentAppeal.comments.length == 0?"Нет ответов":"${currentAppeal.comments.length} ответов",  style: TextStyle(color: cGrey),),
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

}
