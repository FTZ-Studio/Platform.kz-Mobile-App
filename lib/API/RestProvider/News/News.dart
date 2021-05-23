part of '../RestProvider.dart';

class NewsProvider {
  static Future<List<NewItem>> get ({int idRegion})async{
    String urlQuery = urlConstructor(Methods.news.get);
    Map <String,dynamic> body = Map();
    print(urlQuery);
    if(idRegion != null){
      body['region'] = idRegion;
    }
    var response;

    response =await  Rest.post(urlQuery, body);
    if(response is Put) {
      return [];
    }else{
      return response['news'].map((i)=>NewItem.fromMap(i)).toList().cast<NewItem>();
    }
  }
}