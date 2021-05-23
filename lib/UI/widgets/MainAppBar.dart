import 'package:flutter/material.dart';
import 'package:kz/Controllers/GeneralController.dart';
import 'package:kz/Style.dart';
import 'package:kz/utils/svg/IconSVG.dart';

const double kToolbarHeight = 56.0;

class MainAppBar extends StatefulWidget implements PreferredSizeWidget{
  Function menuTap;
  Stream<MenuState> activeMenu;
  String urlPhoto;
  Function profileTap;

  MainAppBar({this.menuTap, this.activeMenu, this.urlPhoto, this.profileTap});
  @override
  _MainAppBarState createState() => _MainAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _MainAppBarState extends State<MainAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        IconSvg(IconsSvg.notif,),
        SizedBox(width: 24,),

        profilePhoto(),
        SizedBox(width: 24,),
      ],
      leading: GestureDetector(
          behavior: HitTestBehavior.deferToChild,
          onTap: (){
            widget.menuTap();
          },
          child: StreamBuilder<Object>(
            stream: widget.activeMenu,
            builder: (context, data) {
              MenuState state = data.data;
              return Icon((data.hasData)&&state.menuState?Icons.close:Icons.menu, color: Theme.of(context).appBarTheme.actionsIconTheme.color);
            }
          )),
      centerTitle: true,
      title: Text("LOGO", style: TextStyle(color: cBlack, fontFamily: fontFamily, fontWeight: FontWeight.w700, fontSize: 24),),
    );
  }


  Widget profilePhoto(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.deferToChild,
          onTap: (){
            if(widget.profileTap != null){
              widget.profileTap();
            }
          },
          child: Container(
            height: 32,
            width: 32,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              child: widget.urlPhoto == null?Container(height: 32, width: 32, color: cGrey, child: Center(child: IconSvg(IconsSvg.person, color: cWhite ),),):Image.network(widget.urlPhoto, fit: BoxFit.cover,),
            ),
          ),
        ),
      ],
    );
  }
}
