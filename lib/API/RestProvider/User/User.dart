part of '../RestProvider.dart';


class _UserProvider{
  static userReg (String email, String password)async{
    String urlQuery = urlConstructor(Methods.user.reg);
    Map <String,dynamic> body = Map();
    body['email'] = email;
    body['password'] = password;
    print(urlQuery);
    var response;
    response =await  Rest.post(urlQuery, body);
    if(response is Put) {
      return response;
    }else{
      return jsonDecode(response['token']);
    }
  }
  static  userLogin (String email, String password)async{
    String urlQuery = urlConstructor(Methods.user.login);
    String token = await tokenDB();
    Map <String,dynamic> body = Map();
    body['email'] = email;
    body['password'] = password;
    print(urlQuery);
    var response;
    response =await  Rest.post(urlQuery, body);
    if(response is Put) {
      return response;
    }else{
      return response;
    }
  }

  static Future<Put>userSetName (String name)async{
    String urlQuery = urlConstructor(Methods.user.setName);
    String token = await tokenDB();
    Map <String,dynamic> body = Map();
    body['name'] = name;
    body['token'] = token;
    print(urlQuery);
    var response;
    response =await  Rest.post(urlQuery, body);
    if(response is Put) {
      return response;
    }else{
      return Put.fromJson(response);
    }
  }

  static Future<Put> userSetAddress (Address address)async{
    String urlQuery = urlConstructor(Methods.user.setAddress);
    String token = await tokenDB();
    Map <String,dynamic> body = Map();
    body['address'] = address.toMap();
    body['token'] = token;
    print(urlQuery);
    var response;
    response =await  Rest.post(urlQuery, body);
    if(response is Put) {
      return response;
    }else{
      return Put.fromJson(response);
    }
  }

  static Future<Put> userSetPhone (String phone)async{
    String urlQuery = urlConstructor(Methods.user.setPhone);
    String token = await tokenDB();
    Map <String,dynamic> body = Map();
    body['phone'] = phone;
    body['token'] = token;
    print(urlQuery);
    var response;
    response =await  Rest.post(urlQuery, body);
    if(response is Put) {
      return response;
    }else{
      return Put.fromJson(response);
    }
  }


  static Future<Put> userSetEmail (String email)async{
    String urlQuery = urlConstructor(Methods.user.setEmail);
    String token = await tokenDB();
    Map <String,dynamic> body = Map();
    body['email'] = email;
    body['token'] = token;
    print(urlQuery);
    var response;
    response =await  Rest.post(urlQuery, body);
    if(response is Put) {
      return response;
    }else{
      return Put.fromJson(response);
    }
  }
}


