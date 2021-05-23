import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kz/API/RestProvider/RestProvider.dart';
import 'package:kz/UI/General/Pages/Profile/Profile.dart';
import 'package:kz/UI/widgets/AddAppeal/showAddAppeal.dart';
import 'package:kz/UI/widgets/Auth/ShowAuth.dart';
import 'package:kz/models/Put.dart';
import 'package:kz/routes.dart';
import 'package:kz/utils/app_keys.dart';
import 'package:kz/utils/regionDB.dart';
import 'package:kz/utils/tokenDB.dart';

class MenuState{
  final bool menuState;
  final bool profileMenuState;
  MenuState({
    @required this.menuState,
    @required this.profileMenuState
  });
}

class GeneralController{

  GeneralController(){
    menuState = false;
    profileMenuState = false;
    _streamControllerMenu.sink.add(MenuState(menuState: menuState, profileMenuState: profileMenuState));
  }

  final _streamControllerMenu = StreamController<MenuState>.broadcast();
  get streamMenu => _streamControllerMenu.stream;
  bool menuState;
  bool profileMenuState;



  profileOpen(BuildContext context)async{
    String auth = await tokenDB();
    if(auth != "null"){
      Navigator.pushNamed(context, Routes.profile);
    }else {
      closeMenu();
      showAuth(this);
    }
  }



  tenderOpen(BuildContext context)async{
    String auth = await tokenDB();
    if(auth != "null"){
      Navigator.pushNamed(context, Routes.tenders);
    }else {
      closeMenu();
      showAuth(this);
    }
  }

  appealOpen(BuildContext context)async{
    String auth = await tokenDB();
    if(auth != "null"){
      Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(appeal: true,)));
    }else {
      closeMenu();
      showAuth(this);
    }
  }

  newsOpen()async{
    if(await regionDB() == 0){
      Navigator.pushNamed(AppKeys.scaffoldKey.currentContext, Routes.regions);
    }else
    Navigator.pushNamed(AppKeys.scaffoldKey.currentContext, Routes.news);
  }

  contactsOpen(BuildContext context)async{
    Navigator.pushNamed(context, Routes.contacts);
  }


  addAppeal()async{
    closeMenu();
    if(await tokenDB() == "null"){
      await showAuth(this);
      if(await tokenDB() != "null"){
        await showAddAppeal();
      }
    }else
    await showAddAppeal();
  }
  auth()async{
    await showAuth(this);
  }

  ideaOpen()async{
    Navigator.pushNamed(AppKeys.scaffoldKey.currentContext, Routes.idea);
  }


  logIn(String login, String pass)async{
    var response = await UserProvider.userLogin(login, pass);
    if(response is Put){}else{
      await tokenDB(token: response);
    }
  }



  reg(String login, String pass, String name)async{
    var response = await UserProvider.userReg(login, pass);
    if(response is Put){}else{
      await tokenDB(token: response);
      await UserProvider.userSetName(name);
      return true;
    }
    return false;
  }


  profileMenuTap(){
    menuState = false;
    profileMenuState= !profileMenuState;
    sendMenuState();
  }
  menuTap(){
    profileMenuState = false;
    menuState = !menuState;
    sendMenuState();
  }

  closeMenu(){
    profileMenuState = false;
    menuState = false;
    sendMenuState();
  }


  sendMenuState(){
    _streamControllerMenu.sink.add(MenuState(menuState: menuState, profileMenuState: profileMenuState));
  }

  close(){
    _streamControllerMenu.close();
  }
}