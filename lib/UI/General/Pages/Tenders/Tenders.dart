import 'package:flutter/material.dart';
import 'package:kz/API/RestProvider/Tender/TendersProvider.dart';
import 'package:kz/Style.dart';
import 'package:kz/UI/General/Pages/Tenders/Tender.dart';
import 'package:kz/models/Tender.dart';
import 'package:kz/utils/svg/IconSVG.dart';

class TendersPage extends StatefulWidget {
  @override
  _TendersPageState createState() => _TendersPageState();
}

class _TendersPageState extends State<TendersPage> {




  bool loadingState = true;
  bool errors= false;

  List<Tender> items;

  load()async{
    setState(() {
      loadingState = true;
    });


    items = await TendersProvider.get();
    if(items == null){
      errors = true;
    }

    loadingState = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: loadingState?loadingWidget():errors?errorWidget():items.length == 0?errorWidget():_content(),
    );
  }

  Widget _content(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20,),
          Text("Тендеры", style: TextStyle(color: cBlack, fontWeight: FontWeight.w700, fontFamily: fontFamily, fontSize: 24),),
          Column(
            children: List.generate(items.length, (index){
              return _tender(items[index], index);
            }),
          )
        ],
      ),
    );
  }

  Widget _tender(Tender item, int index){
    return Container(
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
            SizedBox(height: 12,),
            commentsClose(index)

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
        Navigator.push(context, MaterialPageRoute(builder: (context)=> TenderPage(items[index])));
      },
      child: Container(
        child: Row(
          children: [
            Row(
              children: [
                IconSvg(IconsSvg.comment),
                SizedBox(width: 10,),
                Text(items[index].comments.length == 0?"Нет ответов":"${items[index].comments.length} ответов",  style: TextStyle(color: cGrey),),
              ],
            ),
          ],
        ),
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






}
