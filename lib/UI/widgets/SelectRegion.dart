import 'package:flutter/material.dart';
import 'package:kz/API/RestProvider/Regions/RegionsProvider.dart';
import 'package:kz/Style.dart';
import 'package:kz/models/Region.dart';
import 'package:kz/utils/regionDB.dart';

class SelectRegion extends StatefulWidget {
  Function update;

  SelectRegion({this.update});
  @override
  _SelectRegionState createState() => _SelectRegionState();
}

class _SelectRegionState extends State<SelectRegion> {

  List<Region> items;
  bool loading = true;
  load()async{
    items = await RegionsProvider.get();

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
    return SafeArea(
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
        body: loading?Center(child: CircularProgressIndicator(),):SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: listRegions(),),
      ),
    );
  }

  Widget listRegions(){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: textHeader("Выберите регион из списка"),
        ),
        Column(
          children: List.generate(items.length, (index){
            return ListTile(
              onTap: ()async{
                regionDB(region: items[index].id);
                Navigator.pop(context);
                widget.update!= null?widget.update():null;
              },
              title: Text(items[index].name),
            );
          }),
        ),
      ],
    );
  }
  Widget textHeader(String text){
    return Text(text, style: TextStyle(color: cBlack, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: fontFamily),);
  }
}
