import 'package:flutter/material.dart';
import 'package:kz/API/RestProvider/RestProvider.dart';
import 'package:kz/Style.dart';
import 'package:kz/UI/General/Pages/News/ContentNewsAll.dart';
import 'package:kz/UI/General/Pages/News/ContentNewsLocal.dart';
import 'package:kz/UI/widgets/SelectRegion.dart';
import 'package:kz/models/NewItem.dart';
import 'package:kz/models/Region.dart';
import 'package:kz/routes.dart';
import 'package:kz/utils/regionDB.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {

  bool local = true;
  List<NewItem> newsLocal;
  List<NewItem> newsAll;
  List<Region> listRegions;
  bool loadingState = true;

  load()async{
    loadingState = true;
    setState(() {
    });
    newsLocal = await NewsProvider.get(idRegion: await regionDB());
    newsAll = await NewsProvider.get();
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
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          behavior: HitTestBehavior.deferToChild,
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, color: cBlack, size: 24,),
        ),
        centerTitle: true,
        title: Text("LOGO", style: TextStyle(color: cBlack, fontFamily: fontFamily, fontWeight: FontWeight.w700, fontSize: 24),),
        actions: [
          GestureDetector(
              onTap: ()async{
                await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SelectRegion(update: (){load();},)) );

              },
              child: Icon(Icons.filter_list_alt))
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container(height: 20, width: 20, color: cRed,),
                SizedBox(height: 20,),
                title(),
                SizedBox(height: 15,),
                tapPanel(),
                Divider(),
                loadingState?Center(child: CircularProgressIndicator(),):local?ContentNewsLocal(newsAll):ContentNewsLocal(newsLocal),
              ],
            ),
          ),
        ),
      ),

    );
  }

  Widget title(){
    return Text("Новости", style: TextStyle(color: cBlack, fontSize: 24, fontWeight: FontWeight.w700, fontFamily: fontFamily),);
  }


  Widget tapPanel(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
            onTap: (){
              setState(() {
                local = true;
              });
            },
            child: Text("Общие", style: TextStyle(color: local?cBlack:cBlack.withOpacity(0.1), fontWeight: FontWeight.w600, fontFamily: fontFamily, fontSize: 24),)),
        SizedBox(width: 20,),
        GestureDetector(
            onTap: (){
              setState(() {
                local = false;
              });
            },
            child: Text("Местные", style: TextStyle(color: !local?cBlack:cBlack.withOpacity(0.1),fontWeight: FontWeight.w600, fontFamily: fontFamily, fontSize:24),)),
      ],
    );
  }
}
