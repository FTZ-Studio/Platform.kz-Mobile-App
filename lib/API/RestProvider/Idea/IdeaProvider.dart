import 'package:kz/API/API.dart';
import 'package:kz/API/Rest.dart';
import 'package:kz/models/Idea.dart';
import 'package:kz/models/Put.dart';
import 'package:kz/utils/tokenDB.dart';

class IdeaProvider{
  static Future<Put> add(String title, String text, List<String> photos)async{
    String urlQuery = urlConstructor(Methods.idea.create);
    String token = await tokenDB();
    Map <String,dynamic> body = Map();
    body['text'] = text;
    body['title'] = title;
    body['token'] = token;
    body['photos'] = photos;

    var response;
    response = await Rest.post(urlQuery, body);
    if (response is Put) {
      return response;
    } else {
      return Put.fromJson(response);
    }
  }

  static Future<List<Idea>> get()async{
    String urlQuery = urlConstructor(Methods.idea.get);
    String token = await tokenDB();
    Map <String,dynamic> body = Map();
    body['token'] = token;
    var response;
    response = await Rest.post(urlQuery, body);
    response =await  Rest.post(urlQuery, body);
    if(response is Put) {
      return [];
    }else{
      return response['ideas'].map((i)=> Idea.fromMap(i)).toList().cast<Idea>();
    }
  }


}