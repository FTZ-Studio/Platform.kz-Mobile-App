import 'package:flutter/material.dart';
import 'package:kz/API/RestProvider/Tender/TendersProvider.dart';
import 'package:kz/Style.dart';
import 'package:kz/models/Tender.dart';
import 'package:kz/models/TenderComment.dart';
import 'package:kz/utils/svg/IconSVG.dart';

class TenderPage extends StatefulWidget {
  Tender tender;
  TenderPage(this.tender);

  @override
  _TenderPageState createState() => _TenderPageState();
}

class _TenderPageState extends State<TenderPage> {

  load()async{
    var res = await TendersProvider.get(id: tender.id);
    if(res != null && res.length >0)tender = res[0];
    setState(() {

    });
  }

  TextEditingController controllerComment = TextEditingController();

  Tender tender;

  TenderComment focusComment;

  @override
  void initState() {
    super.initState();
    tender = widget.tender;
    setState(() {});
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Scaffold(
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
            title:  Image.asset("assets/images/launch.png",fit: BoxFit.fitHeight, height: kToolbarHeight,),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _tender(tender),
                      commentsOpen(),
                      SizedBox(height: 60,),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: fieldComment(),
              )
            ],
          ),
        ),
      ),
    );

  }

  sendReply(int id, String text)async{
    if(text.isNotEmpty) {
      await TendersProvider.reply(text, id, tender.id);
      load();
    }
  }
  sendComment()async{
    if(controllerComment.text.isNotEmpty) {
      await TendersProvider.addComment(controllerComment.text, tender.id);
      load();
      controllerComment.text = "";
    }
  }





  Widget _tender(Tender item){
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Color.fromRGBO(249,249,249,1),
          borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                date(item.date),
                SizedBox(width: 4,),
                idText(item.id)
              ],
            ),
            SizedBox(height: 5,),
            textHeader(item.title),
            SizedBox(height: 12,),
            commentText(item.text),
            SizedBox(height: 18,),
            photoList(item.photos),


          ],
        ),
      ),
    );
  }

  Widget textHeader(String text){
    return Text(text, style: TextStyle(color: cBlack, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: fontFamily),);
  }

  Widget date(String date){
    return Text(date, style: TextStyle(color: cGrey, fontFamily: fontFamily, fontWeight: FontWeight.w400, fontSize: 12),);
  }
  Widget idText(int id){
    return Text('id$id', style: TextStyle(color: cBlue, fontSize: 12, fontWeight: FontWeight.w400, fontFamily: fontFamily),);
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

  Widget commentsClose(int index){
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTap: (){
        tender.openComments = true;
        setState(() {});
      },
      child: Row(
        children: [
          Row(
            children: [
              IconSvg(IconsSvg.comment),
              SizedBox(width: 10,),
              Text(tender.comments.length == 0?"Нет ответов":"${tender.comments.length} ответов",  style: TextStyle(color: cGrey),),
            ],
          ),
        ],
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
        child: Text("Тендеров нет"),
      ),
    );
  }


  Widget fieldReply(TextEditingController controller, int id){
    return Container(
      width: MediaQuery.of(context).size.width,
      color: cWhite,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width -40 - 60,

          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            border: Border.all(color: cGrey),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: MediaQuery.of(context).size.width -86 - 80,

                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    keyboardType: TextInputType.name,
                    controller: controller,
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


                    await sendReply(id, controller.text, );
                    controller.text = "";
                    // if(controllerComment.text.isNotEmpty){
                    //   await AppealProvider.commentAdd(controllerComment.text, false, appeal.id);
                    //   controllerComment.text = "";
                    //   widget.id = appeal.id;
                    //   load();
                    // }
                  },
                  child: Container(
                      width: 44,
                      child: IconSvg(IconsSvg.send)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget fieldComment(){
    return Container(
      width: MediaQuery.of(context).size.width,
      color: cWhite,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
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
                    await sendComment();
                    // if(controllerComment.text.isNotEmpty){
                    //   await AppealProvider.commentAdd(controllerComment.text, false, appeal.id);
                    //   controllerComment.text = "";
                    //   widget.id = appeal.id;
                    //   load();
                    // }
                  },
                  child: Container(
                      width: 44,
                      child: IconSvg(IconsSvg.send)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget commentsOpen(){

    Widget generatorReply(List<TenderComment> list, TextEditingController controller, int id){

      return Column(
        children: [
          list.length == 0?SizedBox():Column(
            children: List.generate(list.length , (index){

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width - 40 -90 ,

                          child: Divider()),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: 50,
                        height: 50,
                        child: profileImage(url: list[index].user.photo??null),
                      ),
                      SizedBox(width: 10,),
                      Container(
                        width: MediaQuery.of(context).size.width - 40 -60 - 60,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(list[index].user.name??"Аноним", style: TextStyle(color: cBlack, fontFamily: fontFamily, fontSize: 16, fontWeight: FontWeight.w600),),
                            SizedBox(height: 5,),
                            Text(list[index].text, style: TextStyle(color: cBlack, fontFamily: fontFamily, fontSize: 14, fontWeight: FontWeight.w400),),
                            SizedBox(height: 5,),
                            Text(list[index].date, style: TextStyle(color: cGrey, fontWeight: FontWeight.w400, fontSize: 12, fontFamily: fontFamily,),),


                          ],
                        ),
                      )
                    ],
                  ),
                ],
              );
            }),
          ),
          SizedBox(height: 12,),

          fieldReply(controller,id ),
          // Container(width: MediaQuery.of(context).size.width,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.all(Radius.circular(12)),
          //     border: Border.all(color: cGrey)
          //   ),
          //   child: Padding(
          //     padding: const EdgeInsets.all(12.0),
          //     child: Text("Ответить", style: TextStyle(color: cGrey),),
          //   ),
          // )
        ],
      );
    }
    Widget generatorComments(){
      return Column(
        children: List.generate(tender.comments.length , (index){
          TextEditingController controller = TextEditingController();
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width - 40 -40,

                      child: Divider()),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 50,
                    height: 50,
                    child: profileImage(url: tender.comments[index].user.photo??null),
                  ),
                  SizedBox(width: 10,),
                  Container(
                    width: MediaQuery.of(context).size.width - 40 -60,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tender.comments[index].user.name??"Аноним", style: TextStyle(color: cBlack, fontFamily: fontFamily, fontSize: 16, fontWeight: FontWeight.w600),),
                        SizedBox(height: 5,),
                        Text(tender.comments[index].text, style: TextStyle(color: cBlack, fontFamily: fontFamily, fontSize: 14, fontWeight: FontWeight.w400),),
                        SizedBox(height: 5,),
                        Text(tender.comments[index].date, style: TextStyle(color: cGrey, fontWeight: FontWeight.w400, fontSize: 12, fontFamily: fontFamily,),),
                        Text("Ответить", style: TextStyle(color: cBlue),),
                        generatorReply(tender.comments[index].reply, controller,tender.comments[index].id )
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.deferToChild,
            onTap: (){
              tender.openComments = false;
              setState(() {

              });
            },
            child: Row(
              children: [
                Row(
                  children: [
                    IconSvg(IconsSvg.comment),
                    SizedBox(width: 10,),
                    Text(tender.comments.length == 0?"Нет ответов":"${tender.comments.length} ответов",  style: TextStyle(color: cGrey),),
                    SizedBox(width: 10,),

                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 20,),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
            child: generatorComments(),
          )


        ],
      ),
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



}
