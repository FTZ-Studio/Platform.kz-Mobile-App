part of 'API.dart';

class Methods{
 static _UserMethods            get user         => _UserMethods();
 static _CategoriesMethods      get categories   => _CategoriesMethods();
 static _AppealMethods          get appeal       => _AppealMethods();
 static _NewsMethods            get news         => _NewsMethods();
 static _RegionsMethods         get regions      => _RegionsMethods();
 static _IdeaMethods            get idea         => _IdeaMethods();
 static _TendersMethods         get tenders      => _TendersMethods();
}

class _UserMethods{
  String get reg => "user.reg";
  String get login => "user.login";
  String get setName => "user.setname";
  String get setAddress => "user.setaddress";
  String get setPhone => "user.setphone";
  String get setEmail => "user.setemail";
  String get setVk => "user.setvk";
  String get setPhoto => "user.setphoto";
  String get get => "user.get";
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
  String get getMy => "appeal.getMy";
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
class _RegionsMethods{
  String get get => "region.get";
}

class _IdeaMethods{
  String get create => "idea.create";
  String get get => "idea.get";
  String get edit => "idea.edit";
  String get delete => "idea.delete";
}

class _TendersMethods{
  String get get => "tender.get";
  String get addComment => "tender.commentadd";
  String get addReply => "tender.addReply";
}




