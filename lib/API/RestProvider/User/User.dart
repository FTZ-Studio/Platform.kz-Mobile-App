part of '../RestProvider.dart';


class UserProvider{
  const UserProvider();

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
      return response['token'];
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
      return response['token'];
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

  static Future<Put> setVk (String vk)async{
    String urlQuery = urlConstructor(Methods.user.setVk);
    String token = await tokenDB();
    Map <String,dynamic> body = Map();
    body['vk'] = vk;
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
  static Future<Put> setPhoto (String vk)async{
    String urlQuery = urlConstructor(Methods.user.setPhoto);
    String token = await tokenDB();
    Map <String,dynamic> body = Map();
    body['photo'] = vk;
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


  static Future<Put> userSetAddress (String address)async{
    String urlQuery = urlConstructor(Methods.user.setAddress);
    String token = await tokenDB();
    Map <String,dynamic> body = Map();
    body['address'] = address;
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
    var response;
    response =await  Rest.post(urlQuery, body);
    if(response is Put) {
      return response;
    }else{
      return Put.fromJson(response);
    }
  }

  static Future<User> get ()async{
    String urlQuery = urlConstructor(Methods.user.get);
    String token = await tokenDB();
    Map <String,dynamic> body = Map();
    body['token'] = token;
    var response;
    response =await  Rest.post(urlQuery, body);
    if(response is Put) {
      if(response.error == 4){
        await tokenDB(token: "null");
      }
      return User(code: response.error);
    }else{
      return User.fromMap(response['userinfo']);
    }
  }
}


