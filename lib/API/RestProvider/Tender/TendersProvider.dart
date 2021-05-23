import 'package:kz/API/API.dart';
import 'package:kz/API/Rest.dart';
import 'package:kz/models/Put.dart';
import 'package:kz/models/Tender.dart';
import 'package:kz/utils/tokenDB.dart';

class TendersProvider{
  static Future<List<Tender>> get ({int id})async{
    String urlQuery = urlConstructor(Methods.tenders.get);
    Map <String,dynamic> body = Map();
    if(id != null)body['id'] = id;
    print(urlQuery);
    var response;
    response =await  Rest.post(urlQuery, body);
    if(response is Put) {
      return [];
    }else{
      return response['tenders'].map((i)=> Tender.fromMap(i)).toList().cast<Tender>();
    }
  }
  static Future<Put> addComment(String comment, int id) async {
    String urlQuery = urlConstructor(Methods.tenders.addComment);
    Map<String, dynamic> body = Map();
    body['text'] = comment;
    body['id'] = id;
    body['token'] = await tokenDB();

    var response;
    response = await Rest.post(urlQuery, body);
    if (response is Put) {
      return response;
    } else {
      return Put.fromJson(response);
    }
  }
  static Future<Put> reply(String comment, int id, int tenderId) async {
    String urlQuery = urlConstructor(Methods.tenders.addComment);
    Map<String, dynamic> body = Map();
    body['text'] = comment;
    body['id'] = tenderId;
    body['parent'] = id;
    body['token'] = await tokenDB();

    var response;
    response = await Rest.post(urlQuery, body);
    if (response is Put) {
      return response;
    } else {
      return Put.fromJson(response);
    }
  }



}