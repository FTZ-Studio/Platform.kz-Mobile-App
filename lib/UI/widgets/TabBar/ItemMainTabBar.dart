part of 'MainTabBar.dart';

class ItemMainTabBar {
  final Widget icon;
  final Widget text;

  ItemMainTabBar({
    @required this.icon,
    @required this.text
  }) :
        assert(icon != null),
        assert(text!= null);

}