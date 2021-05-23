library focused_menu;

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:kz/Style.dart';




class FocusedMenuItem {
  Color backgroundColor;
  Widget title;
  Widget iconCustom;
  Icon trailingIcon;
  Function onPressed;

  FocusedMenuItem(
      {this.backgroundColor,
        @required this.title,
        this.trailingIcon,
        this.iconCustom,
        @required this.onPressed});
}

class FilterMenuHolder extends StatefulWidget {
  int currentItem;
  final Widget child;
  final double menuItemExtent;
  final double menuWidth;
  final List<FocusedMenuItem> menuItems;
  final bool animateMenuItems;
  final BoxDecoration menuBoxDecoration;
  final Function onPressed;
  final Duration duration;
  final double blurSize;
  final Color blurBackgroundColor;
  final double bottomOffsetHeight;
  final double menuOffset;

  FilterMenuHolder(
      {Key key,
        @required this.child,
        @required this.onPressed,
        @required this.menuItems,
        this.duration,
        this.menuBoxDecoration,
        this.menuItemExtent,
        this.animateMenuItems,
        this.blurSize,
        this.blurBackgroundColor,
        this.menuWidth,
        this.bottomOffsetHeight,
        this.menuOffset,
        @required this.currentItem})
      : super(key: key);

  @override
  _FilterMenuHolderState createState() => _FilterMenuHolderState();
}

class _FilterMenuHolderState extends State<FilterMenuHolder> {
  GlobalKey containerKey = GlobalKey();
  Offset childOffset = Offset(0, 0);
  Size childSize;

  getOffset() {
    RenderBox renderBox = containerKey.currentContext.findRenderObject();
    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    setState(() {
      this.childOffset = Offset(offset.dx, offset.dy);
      childSize = size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        key: containerKey,
        //onTap: widget.onPressed,
        onTap: () async {
          getOffset();
          await Navigator.push(
              context,
              PageRouteBuilder(
                  transitionDuration:
                  widget.duration ?? Duration(milliseconds: 100),
                  pageBuilder: (context, animation, secondaryAnimation) {
                    animation = Tween(begin: 0.0, end: 1.0).animate(animation);
                    return FadeTransition(
                        opacity: animation,
                        child: FocusedMenuDetails(
                          itemExtent: widget.menuItemExtent,
                          menuBoxDecoration: widget.menuBoxDecoration,
                          child: widget.child,
                          childOffset: childOffset,
                          childSize: childSize,
                          menuItems: widget.menuItems,
                          blurSize: widget.blurSize,
                          menuWidth: widget.menuWidth,
                          blurBackgroundColor: widget.blurBackgroundColor,
                          animateMenu: widget.animateMenuItems ?? true,
                          bottomOffsetHeight: widget.bottomOffsetHeight ?? 0,
                          menuOffset: widget.menuOffset ?? 0,
                          currentItem: widget.currentItem,
                        ));
                  },
                  fullscreenDialog: true,
                  opaque: false));
        },
        child: widget.child);
  }
}

class FocusedMenuDetails extends StatelessWidget {
  final currentItem;
  final List<FocusedMenuItem> menuItems;
  final BoxDecoration menuBoxDecoration;
  final Offset childOffset;
  final double itemExtent;
  final Size childSize;
  final Widget child;
  final bool animateMenu;
  final double blurSize;
  final double menuWidth;
  final Color blurBackgroundColor;
  final double bottomOffsetHeight;
  final double menuOffset;

  const FocusedMenuDetails(
      {Key key,
        @required this.menuItems,
        @required this.child,
        @required this.childOffset,
        @required this.childSize,
        @required this.menuBoxDecoration,
        @required this.itemExtent,
        @required this.animateMenu,
        @required this.blurSize,
        @required this.blurBackgroundColor,
        @required this.menuWidth,
        @required this.currentItem,
        this.bottomOffsetHeight,
        this.menuOffset})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final maxMenuHeight = size.height * 0.45;
    final listHeight = menuItems.length * (itemExtent ?? 50.0);

    final maxMenuWidth = menuWidth ?? (size.width * 0.40);
    final menuHeight = listHeight < maxMenuHeight ? listHeight : maxMenuHeight;
    final leftOffset = (childOffset.dx + maxMenuWidth) < size.width
        ? childOffset.dx
        : (childOffset.dx - maxMenuWidth + childSize.width+12);
    final topOffset = (childOffset.dy + menuHeight + childSize.height) <
        size.height - bottomOffsetHeight
        ? childOffset.dy + childSize.height + menuOffset
        : childOffset.dy - menuHeight - menuOffset;
    final upward = (childOffset.dy + menuHeight + childSize.height) <
        size.height - bottomOffsetHeight;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                      sigmaX: blurSize ?? 4, sigmaY: blurSize ?? 4),
                  child: Container(
                    color:
                    (blurBackgroundColor ?? Colors.transparent),
                  ),
                )),
            Positioned(
              top: topOffset,
              left: leftOffset,
              child: TweenAnimationBuilder(
                duration: Duration(milliseconds: 200),
                builder: (BuildContext context, value, Widget child) {
                  return Transform.scale(
                    scale: value,
                    alignment: Alignment.center,
                    child: child,
                  );
                },
                tween: Tween(begin: 0.0, end: 1.0),
                child: Container(
                  width: maxMenuWidth,
                  height: menuHeight,
                  decoration: menuBoxDecoration ??
                      BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          const BorderRadius.all(Radius.circular(5.0)),
                          boxShadow: [
                            const BoxShadow(
                                color: Color.fromRGBO(122,139,163,0.3),
                                blurRadius: 20,
                                spreadRadius: 0)
                          ]
                      ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                    child: Column(
                      children: [
                        //todo UP
                        Container(height: upward?45:0,color: cWhite,),
                        Container(
                          width: maxMenuWidth,
                          height: menuHeight-50,
                          child: ListView.builder(
                            itemCount: menuItems.length,
                            padding: EdgeInsets.zero,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              FocusedMenuItem item = menuItems[index];
                              Widget listItem = GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    item.onPressed();
                                  },
                                  child: Container(
                                      alignment: Alignment.center,
                                      //margin: const EdgeInsets.only(bottom: 1),
                                      color: item.backgroundColor ?? Colors.white,
                                      height: itemExtent ?? 50.0,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 14),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            item.title,
                                            if (item.trailingIcon != null||item.iconCustom!=null) ...[
                                              item.iconCustom != null?item.iconCustom:item.trailingIcon
                                            ]
                                          ],
                                        ),
                                      )));
                              if (animateMenu) {
                                return index == currentItem?SizedBox():TweenAnimationBuilder(
                                    builder: (context, value, child) {
                                      return Transform(
                                        transform: Matrix4.rotationX(1.5708 * value),
                                        alignment: Alignment.bottomCenter,
                                        child: child,
                                      );
                                    },
                                    tween: Tween(begin: 1.0, end: 0.0),
                                    duration: Duration(milliseconds: index * 200),
                                    child: listItem);
                              } else {
                                return index == currentItem?SizedBox():listItem;
                              }
                            },
                          ),
                        ),
                        Container(height: !upward?45:0,
                        color: cWhite,),

                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
                top: childOffset.dy,
                left: childOffset.dx,
                child: AbsorbPointer(
                    absorbing: true,
                    child: Container(
                        width: childSize.width,
                        height: childSize.height,
                        child: child))),
          ],
        ),
      ),
    );
  }
}
