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
      height: 100,
      decoration: BoxDecoration(
        color: widget.backgroundColor??Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        children: List.generate(widget.listItems.length, (index){
          return Container(

            child: Container(
              width: MediaQuery.of(context).size.width/widget.listItems.length,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  widget.listItems[index].icon,
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
