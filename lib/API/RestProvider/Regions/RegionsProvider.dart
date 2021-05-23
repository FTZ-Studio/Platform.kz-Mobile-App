import 'package:kz/API/API.dart';
import 'package:kz/API/Rest.dart';
import 'package:kz/models/Put.dart';
import 'package:kz/models/Region.dart';

class RegionsProvider{
  static Future<List<Region>> get ({int idRegion})async{
    String urlQuery = urlConstructor(Methods.regions.get);
    Map <String,dynamic> body = Map();

    print(urlQuery);
    var response;

    response =await  Rest.post(urlQuery, body);
    if(response is Put) {
      return [];
    }else{
      return response['data'].map((i)=>Region.fromMap(i)).toList().cast<Region>();
    }
  }
}