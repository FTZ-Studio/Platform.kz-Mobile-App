part of '../RestProvider.dart';

class _AppealProvider {
  static Future<Put> create(Appeal appeal) async {
    String urlQuery = urlConstructor(Methods.appeal.create);

    Map<String, dynamic> body = appeal.toMap();
    if (appeal.anonim != null && !appeal.anonim) {
      body['token'] = await tokenDB();
    }
    print(urlQuery);
    var response;
    response = await Rest.post(urlQuery, body);
    if (response is Put) {
      return response;
    } else {
      return Put.fromJson(response);
    }
  }

  static Future<Put> update(Appeal appeal) async {
    String urlQuery = urlConstructor(Methods.appeal.update);

    Map<String, dynamic> body = appeal.toMap();
    if (appeal.anonim != null && !appeal.anonim) {
      body['token'] = await tokenDB();
    }
    print(urlQuery);
    var response;
    response = await Rest.post(urlQuery, body);
    if (response is Put) {
      return response;
    } else {
      return Put.fromJson(response);
    }
  }

  static Future<Put> commentAdd(String comment, bool anon) async {
    String urlQuery = urlConstructor(Methods.appeal.commentAdd);
    Map<String, dynamic> body = Map();
    body['comment'] = comment;
    body['anonim'] = anon;
    if (!anon) {
      body['token'] = await tokenDB();
    }
    var response;
    response = await Rest.post(urlQuery, body);
    if (response is Put) {
      return response;
    } else {
      return Put.fromJson(response);
    }
  }


  static Future<Put> deleteComment(int id)async{
    String urlQuery = urlConstructor(Methods.appeal.commentDelete);
    Map<String, dynamic> body = Map();
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

  static Future<Put> likeComment(int id)async{
    String urlQuery = urlConstructor(Methods.appeal.commentLike);
    Map<String, dynamic> body = Map();
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
  static Future<Put> dislikeComment(int id)async{
    String urlQuery = urlConstructor(Methods.appeal.commentDislike);
    Map<String, dynamic> body = Map();
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
  static Future<Put> unlikeComment(int id)async{
    String urlQuery = urlConstructor(Methods.appeal.commentUnlike);
    Map<String, dynamic> body = Map();
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

  static Future<List<Appeal>> get ()async{
    String urlQuery = urlConstructor(Methods.appeal.get);
    Map<String, dynamic> body = Map();
    var response;
    response = await Rest.post(urlQuery, body);
    if (response is Put) {
      return [];
    } else {
      return response['appealinfo'].map((i)=> Appeal.fromMap(i)).toList().cast<Appeal>();
    }
  }

  static Future<Put> delete (int id)async{
    String urlQuery = urlConstructor(Methods.appeal.delete);
    Map<String, dynamic> body = Map();
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







}
