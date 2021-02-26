part of '../RestProvider.dart';

class _CategoryProvider {
  static Future<Put> add (String name, {int parent})async{
    String urlQuery = urlConstructor(Methods.categories.add);
    String token = await tokenDB();
    Map <String,dynamic> body = Map();
    body['name'] = name;
    body['token'] = token;
    body['parent'] = parent??null;
    print(urlQuery);
    var response;
    response =await  Rest.post(urlQuery, body);
    if(response is Put) {
      return response;
    }else{
      return Put.fromJson(response);
    }
  }

  static Future<Put> edit (String name, int id)async{
    String urlQuery = urlConstructor(Methods.categories.edit);
    String token = await tokenDB();
    Map <String,dynamic> body = Map();
    body['name'] = name;
    body['token'] = token;
    body['id'] = id;
    print(urlQuery);
    var response;
    response =await  Rest.post(urlQuery, body);
    if(response is Put) {
      return response;
    }else{
      return Put.fromJson(response);
    }
  }

  static Future<Put> delete (int id)async{
    String urlQuery = urlConstructor(Methods.categories.delete);
    String token = await tokenDB();
    Map <String,dynamic> body = Map();
    body['token'] = token;
    body['id'] = id;
    print(urlQuery);
    var response;
    response =await  Rest.post(urlQuery, body);
    if(response is Put) {
      return response;
    }else{
      return Put.fromJson(response);
    }
  }

  static Future<List<Category>> get ()async{
    String urlQuery = urlConstructor(Methods.categories.get);
    Map <String,dynamic> body = Map();
    print(urlQuery);
    var response;
    response =await  Rest.post(urlQuery, body);
    if(response is Put) {
      return [];
    }else{
      return response['categories'].map((i)=> Category.fromMap(i)).toList().cast<Category>();
    }
  }


}