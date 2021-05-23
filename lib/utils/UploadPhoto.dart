import 'dart:convert';
import 'dart:io';

import 'package:kz/API/API.dart';
import 'package:http/http.dart' as http;

Stream<String> uploadPhoto (String filename) async* {
  String url = Server.relevant+"/"+Api.api+"/upload.photo";
  print(url);
  print(filename);
  String response;
  var request = http.MultipartRequest('POST', Uri.parse(url));
  request.files.add(
      http.MultipartFile(
          'var_file',
          File(filename).readAsBytes().asStream(),
          File(filename).lengthSync(),
          filename: filename.split("/").last
      )
  );
  var res = await request.send();

  Stream st = res.stream.transform(utf8.decoder);

  await st.listen((event) async{ response =  await(json.decode(event)['url']);},onDone: (){return response;});

  await res.stream.transform(utf8.decoder).listen(await(value)async {
    print(value);
    return await(json.decode(value)['url']);
  });


}