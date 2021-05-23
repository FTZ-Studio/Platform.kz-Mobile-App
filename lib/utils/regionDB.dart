import 'package:shared_preferences/shared_preferences.dart';

Future<int> regionDB({int region})async{
  final prefs = await SharedPreferences.getInstance();

  if(region == null){
    var region = await prefs.getInt("region")??0;
    return region;
  }else{
    await prefs.setInt("region",region);
  }
}