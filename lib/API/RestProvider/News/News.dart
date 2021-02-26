part of '../RestProvider.dart';

class _NewsProvider {
  static Future<List<NewItem>> get ({Address address})async{
    String urlQuery = urlConstructor(Methods.news.get);
    Map <String,dynamic> body = Map();
    print(urlQuery);
    var response;
    response =await  Rest.post(urlQuery, body);
    if(response is Put) {
      return [];
    }else{
      return response['categories'].map((i)=>NewItem.fromMap(i)).toList().cast<NewItem>();
    }
  }



}