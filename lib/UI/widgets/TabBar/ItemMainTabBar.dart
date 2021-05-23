part of 'MainTabBar.dart';

class ItemMainTabBar {
  final Widget icon;
  final Widget text;
  final Function onTap;

  ItemMainTabBar({
    @required this.icon,
    @required this.text,
    this.onTap
  }) :
        assert(icon != null),
        assert(text!= null);
}