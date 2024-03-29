import 'dart:convert';

import 'package:kz/API/API.dart';
import 'package:kz/API/Rest.dart';
import 'package:kz/models/Address.dart';
import 'package:kz/models/Appeal.dart';
import 'package:kz/models/Categories.dart';
import 'package:kz/models/NewItem.dart';
import 'package:kz/models/Put.dart';
import 'package:kz/utils/tokenDB.dart';

part 'Appeal/Appeal.dart';
part 'User/User.dart';
part 'Categories/Categories.dart';
part 'News/News.dart';


class RestProvider {
  static get user => _UserProvider();
  static get appeal => _AppealProvider();
  static get category => _CategoryProvider();
  static get news => _NewsProvider();
}


