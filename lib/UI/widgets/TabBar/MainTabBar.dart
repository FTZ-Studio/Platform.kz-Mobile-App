import 'package:flutter/material.dart';

part 'ItemMainTabBar.dart';

class MainTabBar extends StatefulWidget {
  final Color backgroundColor;
  final List<ItemMainTabBar> listItems;



  MainTabBar({this.backgroundColor, this.listItems,}) :assert (listItems.isNotEmpty);

  @override
  _MainTabBarState createState() => _MainTabBarState();
}

class _MainTabBarState extends State<MainTabBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 80,
      decoration: BoxDecoration(
        color: widget.backgroundColor??Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        children: List.generate(widget.listItems.length, (index){
          return GestureDetector(
            behavior: HitTestBehavior.deferToChild,
            onTap: (){
              if(widget.listItems[index].onTap != null){
                widget.listItems[index].onTap();
              }
            },
            child: Container(
              decoration: BoxDecoration(
                border: index ==widget.listItems.length?null:Border(right: BorderSide(color: Color.fromRGBO(220,220,220,1)))
              ),
              width: MediaQuery.of(context).size.width/widget.listItems.length,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.listItems[index].icon,
                  SizedBox(height: 12,),
                  widget.listItems[index].text
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
