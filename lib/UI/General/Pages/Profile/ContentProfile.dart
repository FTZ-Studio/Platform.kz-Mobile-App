import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kz/API/API.dart';
import 'package:kz/API/RestProvider/RestProvider.dart';
import 'package:kz/Style.dart';
import 'package:kz/models/User.dart';
import 'package:kz/utils/svg/IconSVG.dart';
import 'package:http/http.dart' as http;


class ContentProfile extends StatefulWidget {

  ContentProfile();
  @override
  _ContentProfileState createState() => _ContentProfileState();
}

class _ContentProfileState extends State<ContentProfile> {
  User user;
  bool edit = false;

  bool loadingState = true;
  bool errors = false;
  List<String> responsePhoto = [];

  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerAddress = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPhone = TextEditingController();
  TextEditingController controllerVk = TextEditingController();

  load()async{
    user = await UserProvider.get();
    if(user.error != 200 || user.error == null){
      errors = true;
    }
    if(user != null) {
      if (user.name != null) {
        controllerName.text = user.name;
      }
      if (user.address != null) {
        controllerAddress.text = user.address;
      }
      if (user.email != null) {
        controllerEmail.text = user.email;
      }
      if (user.vk != null) {
        controllerVk.text = user.vk;
      }
      if (user.phone != null) {
        controllerPhone.text = user.phone;
      }
    }
    loadingState = false;
    setState(() {});
    print(" $loadingState $errors");
  }

  @override
  void initState() {
    super.initState();
    load();
  }



  save()async{
    setState(() {
      loadingState = true;
    });
    if(controllerPhone.text.isNotEmpty){
      await UserProvider.userSetPhone(controllerPhone.text);
    }
    if(controllerVk.text.isNotEmpty){
      await UserProvider.setVk(controllerVk.text);
    }
    if(controllerEmail.text.isNotEmpty){
      await UserProvider.userSetEmail(controllerEmail.text);
    }
    if(controllerName.text.isNotEmpty){
      await UserProvider.userSetName(controllerName.text);
    }
    if(controllerAddress.text.isNotEmpty){
      await UserProvider.userSetAddress(controllerAddress.text);
    }
    if(responsePhoto.isNotEmpty){
      await UserProvider.setPhoto(responsePhoto.last);

    }
    load();


  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: loadingState?loadingWidget():errors?errorWidget():edit?editWidget():viewWidget(),
    );
  }




  Widget viewWidget(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20,),
        photo(),
        SizedBox(height: 30,),
        name(),
        SizedBox(height: 20,),
        address(),
        SizedBox(height: 20,),
        email(),
        SizedBox(height: 20,),
        phone(),
        SizedBox(height: 20,),
        vk(),
        SizedBox(height: 30,),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 60,
          child: _buttonEdit(onTap: (){
            setState(() {
              edit = true;
            });
          }),
        )
      ],
    );
  }
  Widget editWidget(){
    return Column(
      children: [
        SizedBox(height: 20,),
        photoEdit(),
        SizedBox(height: 30,),
        nameEdit(),
        SizedBox(height: 20,),
        addressEdit(),
        SizedBox(height: 20,),
        emailEdit(),
        SizedBox(height: 20,),
        phoneEdit(),
        SizedBox(height: 20,),
        vkEdit(),
        SizedBox(height: 30,),
        buttonsEdit(),
      ],
    );
  }





  Widget photo(){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        border: Border.all(color: user.photo == null|| user.photo =="null"? cGrey:Colors.transparent),
      ),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child:  user.photo == null|| user.photo =="null"?Center(
          child: Icon(Icons.photo, size: 30, color: cGrey,),
        ):Image.network(user.photo, fit: BoxFit.cover,),
      ),
    );
  }



  Widget photoEdit(){
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTap: ()async{
        print('on tap ');
        final picker = ImagePicker();
        final pickedFile = await picker.getImage(source: ImageSource.gallery);
        loadingState = true;
        setState(() {

        });
        await uploadPhoto(pickedFile.path);
        user.photo = responsePhoto.last;
        loadingState = false;
        setState(() {

        });
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              border: Border.all(color: user.photo == null|| user.photo =="null"? cGrey:Colors.transparent),
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child:  user.photo == null|| user.photo =="null"?Center(
                child: Icon(Icons.photo, size: 30, color: Colors.transparent,),
              ):Image.network(user.photo, fit: BoxFit.cover,),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.4),
              borderRadius: BorderRadius.all(Radius.circular(20)),
              border: Border.all(color: user.photo == null|| user.photo =="null"? cGrey:Colors.transparent),
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            child: Center(
              child: IconSvg(IconsSvg.upload),
            ),
          ),
        ],
      ),
    );
  }



  Widget name(){
    return Text(user.name??"Имя", overflow: TextOverflow.ellipsis, style: TextStyle(color: cBlack, fontFamily: fontFamily, fontWeight: FontWeight.w700, fontSize: 24),);
  }

  Widget address(){
    return Row(
      children: [
        IconSvg(IconsSvg.marker,),
        SizedBox(width: 18,),
        Text(user.address == null||user.address ==""?"Адрес не указан":user.address, style: TextStyle(color: cBlack, fontSize: 14, fontWeight: FontWeight.w500, fontFamily: fontFamily),)
      ],
    );
  }
  Widget email(){
    return Row(
      children: [
        IconSvg(IconsSvg.letter,),
        SizedBox(width: 18,),
        Text(user.email == null || user .email == ""?"Email не указан":user .email, style: TextStyle(color: cBlack, fontSize: 14, fontWeight: FontWeight.w500, fontFamily: fontFamily),)
      ],
    );
  }
  Widget phone(){
    return Row(
      children: [
        IconSvg(IconsSvg.phone,),
        SizedBox(width: 18,),
        Text(user.phone == null || user .phone == ""?"Телефон не указан": user .phone , style: TextStyle(color: cBlack, fontSize: 14, fontWeight: FontWeight.w500, fontFamily: fontFamily),)
      ],
    );
  }
  Widget vk(){
    return Row(
      children: [
        IconSvg(IconsSvg.vk,),
        SizedBox(width: 18,),
        Text(user.vk == null || user .vk == ""?"VK не указан": user .vk , style: TextStyle(color: cBlack, fontSize: 14, fontWeight: FontWeight.w500, fontFamily: fontFamily),)
      ],
    );
  }

  Widget _buttonEdit({Function onTap}) {
    return InkWell(
      onTap: () {
        onTap == null ? null : onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          color: cBlue,
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Редактировать",
                style: TextStyle(
                    color: cWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: fontFamily),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget nameEdit(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textEdit("ФИО"),
        SizedBox(height: 10,),
        textFieldEdit("ФИО", controllerName),
      ],
    );
  }
  Widget addressEdit(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textEdit("Адрес"),
        SizedBox(height: 10,),
        textFieldEdit("Адрес", controllerAddress),
      ],
    );
  }
  Widget emailEdit(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textEdit("Email"),
        SizedBox(height: 10,),
        textFieldEdit("Email", controllerEmail),
      ],
    );
  }
  Widget phoneEdit(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textEdit("Телефон"),
        SizedBox(height: 10,),
        textFieldEdit("Телефон", controllerPhone),
      ],
    );
  }
  Widget vkEdit(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textEdit("ВКонтакте"),
        SizedBox(height: 10,),
        textFieldEdit("ВКонтакте", controllerVk),
      ],
    );
  }

  Widget textEdit(String text){
    return Text(text, style: TextStyle(color: cBlack, fontFamily: fontFamily, fontWeight: FontWeight.w500, fontSize: 16),);
  }
  Widget textFieldEdit(String hint, TextEditingController controller,){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        border: Border.all(color: cBlack.withOpacity(0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: TextField(
          keyboardType: TextInputType.name,
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintStyle: TextStyle(
              fontSize: 14,
              fontFamily: fontFamily,
              fontWeight: FontWeight.w400,
              color: cBlack,
            ),
            hintText: hint,
          ),
          style: TextStyle(
              color: cBlack,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontFamily: fontFamily),
        ),
      ),
    );
  }

  Widget buttonsEdit(){
    return         Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            width: MediaQuery.of(context).size.width / 2 - 18,
            child: _buttonBack(onTap: () {
              edit = false;
              setState(() {

              });


            })),
        Container(
            width: MediaQuery.of(context).size.width / 2 - 18,
            child: _buttonNext(onTap: () {
              save();
              setState(() {

                edit = false;
              });
            })),
      ],
    );
  }

  Widget _buttonBack({Function onTap}) {
    return InkWell(
      onTap: () {
        onTap == null ? null : onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          color: cBlack.withOpacity(0.15),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Отмена",
                style: TextStyle(
                    color: cBlack,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: fontFamily),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buttonNext({Function onTap}) {
    return InkWell(
      onTap: () {
        onTap == null ? null : onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          color: cBlue,
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Сохранить",
                style: TextStyle(
                    color: cWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: fontFamily),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget loadingWidget(){
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
  Widget errorWidget(){
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Text("Ошибка загрузки"),
      ),
    );
  }

  Future<bool> uploadPhoto (String filename) async {
    String url = Server.relevant+"/"+Api.api+"/upload.photo";

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
    //     .then((value){
    //
    // });
    await res.stream.transform(utf8.decoder).listen(await(value)async {
      print(value);
      await responsePhoto.add(json.decode(value)['url']);
    });

  }
}
