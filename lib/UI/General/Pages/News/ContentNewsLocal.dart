import 'package:flutter/material.dart';
import 'package:kz/Style.dart';
import 'package:kz/models/NewItem.dart';

class ContentNewsLocal extends StatefulWidget {
  List<NewItem> news;
  Function update;
  ContentNewsLocal(this.news, );
  @override
  _ContentNewsLocalState createState() => _ContentNewsLocalState();
}

class _ContentNewsLocalState extends State<ContentNewsLocal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListNewsGenerator(),
    );
  }

  Widget ListNewsGenerator() {
    if (widget.news.isEmpty) {
      return Center(
        child: Text("Нет новостей"),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: List.generate(widget.news.length, (index) {
          NewItem item = widget.news[index];
          return Column(
            children: [
              SizedBox(height: 20,),
              GestureDetector(
                behavior: HitTestBehavior.deferToChild,
                onTap: (){
                  widget.news[index].open = !widget.news[index].open;
                  setState(() {

                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: item.open?Color.fromRGBO(241,250,248,1):Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: item.open?contentOpen(item):contentClose(item),
                  ),
                ),
              ),
            ],
          );
        }),
      );
    }
  }

  Widget contentOpen(NewItem item){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(item.title, style: TextStyle(color: cBlack, fontSize: 18, fontWeight: FontWeight.w600, fontFamily: fontFamily),),
        SizedBox(height: 8,),
        Text(item.time, style: TextStyle(color: cGrey, fontFamily: fontFamily, fontWeight: FontWeight.w500, fontSize: 12),),
        SizedBox(height: 15,),
        generateContentNew(item.items)
      ],
    );
  }
  Widget contentClose(NewItem item){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(item.time, style: TextStyle(color: cGrey, fontFamily: fontFamily, fontWeight: FontWeight.w500, fontSize: 12),),
        SizedBox(height: 10,),
        Text(item.title, style: TextStyle(color: cBlack, fontSize: 16, fontWeight: FontWeight.w500, fontFamily: fontFamily),),
        SizedBox(height: 20,),
        Divider()
        // generateContentNew(item.items)
      ],
    );
  }

  Widget generateContentNew(List<NewItemElement> items){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(items.length, (index) {
        if(items[index].type == "photo"){
          print("PHOTO ${items[index].url}");
          return Image.network(items[index].url);
        }else{
          return Padding(
            padding: const EdgeInsets.symmetric(vertical:12.0),
            child: Text(items[index].text??"", style: TextStyle(color: cBlack, fontFamily: fontFamily, fontWeight: FontWeight.w400, fontSize: 14),),
          );
        }
      }),
    );
  }
}
