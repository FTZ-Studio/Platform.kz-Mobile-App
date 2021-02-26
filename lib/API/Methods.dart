part of 'API.dart';

class Methods{
 static _UserMethods            get user         => _UserMethods();
 static _CategoriesMethods      get categories   => _CategoriesMethods();
 static _AppealMethods          get appeal       => _AppealMethods();
 static _NewsMethods            get news         => _NewsMethods();
}

class _UserMethods{
  String get reg => "user.reg";
  String get login => "user.login";
  String get setName => "user.setname";
  String get setAddress => "user.setaddress";
  String get setPhone => "user.setphone";
  String get setEmail => "user.setemail";
}

class _AppealMethods{
  String get create => "appeal.create";
  String get commentAdd => "appeal.commentadd";
  String get commentDelete => "appeal.deletecomment";
  String get commentUnlike => "appeal.unlike";
  String get commentDislike => "appeal.dislikecomment";
  String get commentLike => "appeal.likecomment";
  String get update => "appeal.update";
  String get get => "appeal.get";
  String get delete => "appeal.delete";
}
class _CategoriesMethods{
  String get add => "category.add";
  String get edit => "category.edit";
  String get delete => "category.delete";
  String get get => "category.get";
}
class _NewsMethods{
  String get create => "news.create";
  String get update => "news.update";
  String get get => "news.get";
}
