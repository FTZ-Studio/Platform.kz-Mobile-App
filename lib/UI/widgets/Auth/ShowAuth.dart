import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kz/Controllers/GeneralController.dart';
import 'package:kz/Style.dart';
import 'package:kz/generated/l10n.dart';
import 'package:kz/utils/app_keys.dart';
import 'package:kz/utils/svg/IconSVG.dart';

showAuth(GeneralController controller)async {
  // AppKeys.scaffoldKey.currentState.showBottomSheet(
  //      (context) {
  //       return ContentAuth(controller);
  //     },
  //     backgroundColor: Colors.transparent);

  // showBottomSheet(context: AppKeys.scaffoldKey.currentState.context, builder: (context){
  //   return ContentAuth(controller);
  // });

  await showModalBottomSheet(
    backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: AppKeys.scaffoldKey.currentContext, builder: (context)=>ContentAuth(controller));
}

class ContentAuth extends StatefulWidget {

  final GeneralController controller;
  ContentAuth(this.controller);

  @override
  _ContentAuthState createState() => _ContentAuthState();
}

class _ContentAuthState extends State<ContentAuth> {
  
  
  
  TextEditingController controllerLEmail = TextEditingController();
  TextEditingController controllerLPass = TextEditingController();
  TextEditingController controllerRName = TextEditingController();
  TextEditingController controllerREmail = TextEditingController();
  TextEditingController controllerRPass = TextEditingController();
  

  bool login = true;

  @override
  Widget build(BuildContext context) {
    return    Container(
        height: MediaQuery.of(context).size.height * 0.80,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              decoration: BoxDecoration(
                  color: cBlack,
                  borderRadius: BorderRadius.vertical(top:Radius.circular(20),),),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal:18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(S.of(context).auth, style: TextStyle(color: cWhite, fontSize: 18, fontFamily: fontFamily, fontWeight: FontWeight.w700),),
                    SizedBox(),
                    SizedBox(),
                    GestureDetector(
                        behavior: HitTestBehavior.deferToChild,
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.close, size: 26, color: cWhite,))
                  ],
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.80-60,
              color: cWhite,
              child: SingleChildScrollView(
                child: Container(
                  color: cWhite,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        tabBarLogin(),
                        SizedBox(height: 30,),
                        login?loginContent():regContent(),
                        SizedBox(height: 60,)

                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

    );
  }


  Widget tabBarLogin(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: (){
            setState(() {
              login = true;
            });
          },
            child: Text(S.of(context).loginIn, style: TextStyle(color: login?cBlack:cBlack.withOpacity(0.1), fontWeight: FontWeight.w700, fontFamily: fontFamily, fontSize: 24),)),
        GestureDetector(
            onTap: (){
              setState(() {
                login = false;
              });
            },
            child: Text(S.of(context).loginReg, style: TextStyle(color: !login?cBlack:cBlack.withOpacity(0.1),fontWeight: FontWeight.w700, fontFamily: fontFamily, fontSize:24),)),
        SizedBox(),
        SizedBox(),
      ],
    );

  }

  Widget regContent(){
    return Column(
      children: [
        regForm(),
        SizedBox(height: 28,),
        buttonReg(),
        SizedBox(height: 60,)
      ],
    );

  }
  Widget loginContent(){
    return Column(
      children: [
        //Text(S.of(context).login_desk, style: TextStyle(color: cBlack, fontSize: 18, fontFamily: fontFamily, fontWeight: FontWeight.w500),),
        SizedBox(height: 20,),
        loginForm(),
        SizedBox(height: 28,),
        buttonsLogin(),
        SizedBox(height: 60,)

      ],
    );
  }


  Widget loginForm(){
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            border: Border.all(color: cBlack.withOpacity(0.1)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(

              controller: controllerLEmail,
              decoration: InputDecoration(

                icon: IconSvg(IconsSvg.letter, width: 24),
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: 14,
                  fontFamily: fontFamily,
                  fontWeight: FontWeight.w400,
                  color: cBlack,
                ),
                hintText: "Логин или почта",
              ),
              style: TextStyle(
                  color: cBlack,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: fontFamily),
            ),
          ),
        ),
        SizedBox(height: 15,),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            border: Border.all(color: cBlack.withOpacity(0.1)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              keyboardType: TextInputType.visiblePassword,
              controller: controllerLPass,
              decoration: InputDecoration(

                icon: IconSvg(IconsSvg.lock, width: 24),
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: 14,
                  fontFamily: fontFamily,
                  fontWeight: FontWeight.w400,
                  color: cBlack,
                ),
                hintText: "Пароль",
              ),
              style: TextStyle(
                  color: cBlack,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: fontFamily),
            ),
          ),
        ),
      ],
    );
  }

  Widget buttonsLogin(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.deferToChild,
          child: Text("Забыли пароль?", style: TextStyle(color: cBlue, fontWeight: FontWeight.w600, fontFamily: fontFamily, fontSize: 14),),
        ),
        GestureDetector(
          behavior: HitTestBehavior.deferToChild,
          onTap: ()async{
            if(controllerLEmail.text.isNotEmpty && controllerLPass.text.isNotEmpty){
              await widget.controller.logIn(controllerLEmail.text, controllerLPass.text);
              Navigator.pop(context);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: cBlue,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
              child: Text("Войти", style: TextStyle(color: cWhite, fontSize: 14, fontFamily: fontFamily, fontWeight: FontWeight.w600),          ),
            ),
          ),
        )
      ],
    );
  }

  Widget regForm(){
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            border: Border.all(color: cBlack.withOpacity(0.1)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              keyboardType: TextInputType.name,
              controller: controllerRName,
              decoration: InputDecoration(

                icon: IconSvg(IconsSvg.person, width: 24),
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: 14,
                  fontFamily: fontFamily,
                  fontWeight: FontWeight.w400,
                  color: cBlack,
                ),
                hintText: "Фамилия имя",
              ),
              style: TextStyle(
                  color: cBlack,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: fontFamily),
            ),
          ),
        ),
        SizedBox(height: 15,),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            border: Border.all(color: cBlack.withOpacity(0.1)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              controller: controllerREmail,
              decoration: InputDecoration(

                icon: IconSvg(IconsSvg.letter, width: 24),
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: 14,
                  fontFamily: fontFamily,
                  fontWeight: FontWeight.w400,
                  color: cBlack,
                ),
                hintText: "Email",
              ),
              style: TextStyle(
                  color: cBlack,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: fontFamily),
            ),
          ),
        ),
        SizedBox(height: 15,),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            border: Border.all(color: cBlack.withOpacity(0.1)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              keyboardType: TextInputType.visiblePassword,
              controller: controllerRPass,
              decoration: InputDecoration(

                icon: IconSvg(IconsSvg.lock, width: 24),
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: 14,
                  fontFamily: fontFamily,
                  fontWeight: FontWeight.w400,
                  color: cBlack,
                ),
                hintText: "Пароль",
              ),
              style: TextStyle(
                  color: cBlack,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: fontFamily),
            ),
          ),
        ),
        SizedBox(height: 15,),
      ],
    );
  }


  Widget buttonReg(){
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTap: ()async {
        if(
        controllerRName.text.isNotEmpty&&
        controllerRPass.text.isNotEmpty&&
        controllerREmail.text.isNotEmpty
        ) {
          if(await widget.controller.reg(controllerREmail.text, controllerRPass.text, controllerRName.text)){
            Navigator.pop(context);
          }

        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: cBlue,
          borderRadius: BorderRadius.all(Radius.circular(4)),

        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
            child: Text("Зарегистрроваться", style: TextStyle(color: cWhite, fontSize: 16, fontFamily: fontFamily, fontWeight: FontWeight.w600),          ),
          ),
        ),
      ),
    );
  }





}
