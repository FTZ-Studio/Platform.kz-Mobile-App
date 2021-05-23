import 'package:flutter/material.dart';
import 'package:kz/Style.dart';
import 'package:kz/UI/widgets/TabBar/MainTabBar.dart';

class MainMenu extends StatefulWidget {



  List<ItemMainTabBar> items;

  MainMenu({@required this.items}): assert(items.isNotEmpty);


  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {



  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      
      child: Container(
        height:  widget.items.length*80.toDouble(),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: List.generate(widget.items.length, (index){
                return GestureDetector(
                  behavior: HitTestBehavior.deferToChild,
                  onTap: (){
                    if(widget.items[index].onTap != null){
                      widget.items[index].onTap();
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: cWhite,
                      border: index != widget.items.length?Border(bottom: BorderSide(color: cBlack.withOpacity(0.4))):null,
                    ),
                      height: 80,
                      child: Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            widget.items[index].icon,
                            SizedBox(width: 12,),
                            widget.items[index].text
                          ],
                        ),
                      ),),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
