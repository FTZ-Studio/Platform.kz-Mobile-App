import 'package:flutter/material.dart';
import 'package:kz/API/RestProvider/RestProvider.dart';
import 'package:kz/Style.dart';
import 'package:kz/UI/General/Pages/Profile/ContentAppeals.dart';
import 'package:kz/UI/General/Pages/Profile/ContentProfile.dart';
import 'package:kz/models/User.dart';

class Profile extends StatefulWidget {

  bool appeal;
  Profile({this.appeal = false});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {



  bool profile = true;
  bool loading = true;
  bool errors = false;
  User user;

  load()async{
    loading = false;
    setState(() {});
    print("$profile $loading $errors");
  }

  @override
  void initState() {
    super.initState();
    profile =! widget.appeal;
    setState(() {

    });
    load();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        // iconTheme: ThemeData.dark().iconTheme.copyWith(color: cBlack),
        leading: GestureDetector(
          behavior: HitTestBehavior.deferToChild,
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, color: cBlack, size: 24,),
        ),

        centerTitle: true,
        title:  Image.asset("assets/images/launch.png",fit: BoxFit.fitHeight, height: kToolbarHeight,),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                // Container(height: 20, width: 20, color: cRed,),
                SizedBox(height: 20,),
                tapPanel(),
                Divider(),
                loading?Center(child: CircularProgressIndicator(),):errors?Center(child: Text("Ошибка загрузки"),):profile?ContentProfile():ContentAppeals(),
              ],
            ),
          ),
        ),
      ),

    );
  }


  Widget tapPanel(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
            onTap: (){
              setState(() {
                profile = true;
              });
            },
            child: Text("Обо мне", style: TextStyle(color: profile?cBlack:cBlack.withOpacity(0.1), fontWeight: FontWeight.w700, fontFamily: fontFamily, fontSize: 24),)),
        GestureDetector(
            onTap: (){
              setState(() {
                profile = false;
              });
            },
            child: Text("Мои обращения", style: TextStyle(color: !profile?cBlack:cBlack.withOpacity(0.1),fontWeight: FontWeight.w700, fontFamily: fontFamily, fontSize:24),)),
      ],
    );
  }

  Widget contentProfile(){
    return Column(
      children: [Container(height: 20, width: 20, color: cRed,)],
    );
  }


  Widget contentAppeals(){
    return Column();
  }



}
