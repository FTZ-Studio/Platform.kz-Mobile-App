import 'package:flutter/material.dart';
import 'package:kz/API/RestProvider/Idea/IdeaProvider.dart';
import 'package:kz/Style.dart';
import 'package:kz/models/Idea.dart';
import 'package:kz/utils/svg/IconSVG.dart';

import 'AddIdea.dart';

class IdeasPage extends StatefulWidget {
  @override
  _IdeasPageState createState() => _IdeasPageState();
}

class _IdeasPageState extends State<IdeasPage> {

  bool loading = true;
  bool errors = false;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  List<Idea> items;
  load()async{
    setState(() {
      loading = true;
    });
    items = await IdeaProvider.get();
    if(items == null)errors = true;
    setState(() {
      loading = false;
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
      key: scaffoldKey,
      appBar: AppBar(
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
      body: loading?loadingWidget():errors?error():items.isEmpty?noIdea():_content(),
    );
  }

  Widget _content(){
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            SizedBox(height: 12,),

            buttonAddIdea(),
            SizedBox(height: 12,),
            Column(
              children: List.generate(items.length, (index) {
                Idea item =  items[index];
                return Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(241,250,248,1),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                profileImage(url: item.user.photo),
                                SizedBox(width: 12,),
                                textName(item.user.name),
                              ],
                            ),
                            SizedBox(height: 5,),

                            Text(item.date,style: TextStyle(color: cGrey, fontFamily: fontFamily, fontWeight: FontWeight.w500, fontSize: 12),),
                            SizedBox(height: 5,),
                            Text(item.title, style: TextStyle(color: cBlack, fontSize: 18, fontWeight: FontWeight.w500, fontFamily: fontFamily),),
                            SizedBox(height: 12,),
                            Text(item.text??"Без текста", style: TextStyle(color: cBlack, fontFamily: fontFamily, fontWeight: FontWeight.w400, fontSize: 14),),
                            SizedBox(height: 24,),
                            photoList(item.photo)
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 12,),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }



  Widget noIdea(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Тут пока ничего нет", style: TextStyle(color: cBlack, fontFamily: fontFamily, fontWeight: FontWeight.w600, fontSize: 18),),
          SizedBox(height: 20,),
          Container(
            decoration: BoxDecoration(
              color: cBlue,
              borderRadius: BorderRadius.all(Radius.circular(12))
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text("Предложить", style: TextStyle(color: cWhite, fontWeight: FontWeight.w500, fontFamily: fontFamily, fontSize: 16),),
            ),
          )
        ],
      ),
    );
  }

  Widget textName(String text){
    return Text(text, style: TextStyle(color: cBlack, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: fontFamily),);
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


  Widget error(){
    return Center(
      child: Text('Не удалось загрузить', style: TextStyle(color: cBlack, fontFamily: fontFamily),),
    );
  }


  Widget loadingWidget(){
    return Center(
      child: CircularProgressIndicator(),
    );
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


  Future<bool> showAddIdea() async {
    await scaffoldKey.currentState.showBottomSheet(
      (context) { return AddIdea(); },
      backgroundColor: Colors.transparent,
    );
    return true;
  }

  Widget buttonAddIdea(){
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTap: ()async{
        showAddIdea();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: cBlue,
          borderRadius: BorderRadius.all(Radius.circular(12)),

        ),
        child: Center(child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text("Предложить", style: TextStyle(color: cWhite, fontFamily: fontFamily, fontWeight: FontWeight.w600, fontSize: 18),),
        )),
      ),
    );
  }


}
