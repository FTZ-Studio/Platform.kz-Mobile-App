import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kz/API/API.dart';
import 'package:kz/API/RestProvider/Idea/IdeaProvider.dart';
import 'package:kz/Style.dart';
import 'package:kz/utils/DialogsIntegron/DialogIntegron.dart';

class AddIdea extends StatefulWidget {
  @override
  _AddIdeaState createState() => _AddIdeaState();
}

class _AddIdeaState extends State<AddIdea> {

  TextEditingController controllerText= TextEditingController();
  TextEditingController controllerTitle= TextEditingController();
  List<String> responsePhoto = [];
  List<String> images = [];
  final picker = ImagePicker();



  @override
  Widget build(BuildContext context) {




    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height * 0.80,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: 60,
              decoration: BoxDecoration(
                color: cBlack,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                    "Предложить",
                      style: TextStyle(
                          color: cWhite,
                          fontSize: 18,
                          fontFamily: fontFamily,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(),
                    SizedBox(),
                    GestureDetector(
                        behavior: HitTestBehavior.deferToChild,
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.close,
                          size: 26,
                          color: cWhite,
                        ))
                  ],
                ),
              ),
            ),
            Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.80 - 60,
              color: cWhite,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _descriptionText("Опишите свою идею"),
                    SizedBox(height: 12,),

                    titleField(),
                    SizedBox(height: 12,),
                    commentField(),
                    SizedBox(height: 18,),
                    _descriptionText("Добавьте фотографии"),
                    SizedBox(height: 12,),

                    _photoList(0),
                    Spacer(),
                    buttonAddIdea()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _descriptionText(String text) {
    return Text(
      text,
      style: TextStyle(
          color: cBlack,
          fontFamily: fontFamily,
          fontWeight: FontWeight.w400,
          fontSize: 18),
    );
  }

  Widget titleField() {
    return
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          border: Border.all(color: cBlack.withOpacity(0.1)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextField(
            minLines: 1,
            maxLines: 1,
            keyboardType: TextInputType.text,
            controller: controllerTitle,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintStyle: TextStyle(
                fontSize: 14,
                fontFamily: fontFamily,
                fontWeight: FontWeight.w400,
                color: cBlack. withOpacity(0.3),
              ),
              hintText: "Тема",
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

  Widget commentField() {
    return
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          border: Border.all(color: cBlack.withOpacity(0.1)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextField(
            minLines: 6,
            maxLines: 6,
            keyboardType: TextInputType.name,
            controller: controllerText,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintStyle: TextStyle(
                fontSize: 14,
                fontFamily: fontFamily,
                fontWeight: FontWeight.w400,
                color: cBlack. withOpacity(0.3),
              ),
              hintText: "Описание",
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

  Widget buttonAddIdea(){
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTap: ()async{
        if(controllerText.text.isNotEmpty && controllerTitle.text.isNotEmpty){
          if (images.isNotEmpty) {
            for (int i = 0; i < images.length; i++) {
              await uploadPhoto(images[i]);
            }
          }
          IdeaProvider.add(controllerTitle.text, controllerText.text, responsePhoto);
          Navigator.pop(context);
          showDialogIntegronError(context, "Ваше предложение будет опубликовано после модерации");

        }else{
          showDialogIntegronError(context, "Заполните все поля для отправки");
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: cBlue,
          borderRadius: BorderRadius.all(Radius.circular(12)),

        ),
        child: Center(child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text("Предложить", style: TextStyle(color: cWhite, fontFamily: fontFamily, fontWeight: FontWeight.w600, fontSize: 18),),
        )),
      ),
    );
  }

  Widget _photoList(double padding) {
    double _padding = 8;

    List<Widget> items = [];
    double size =
        (MediaQuery
            .of(context)
            .size
            .width - _padding * 7) / 5 - padding * 2;

    if (images.length > 0) {
      for (int i = 0; i < images.length; i++) {
        items.add(Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                width: size,
                height: size,
                child: Image.file(
                  File(images[i]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: _padding,
            )
          ],
        ));
      }
    }
    if (images.length < 5) {
      items.add(InkWell(
        onTap: () async {
          await _addImage();
        },
        child: Container(
          decoration: BoxDecoration(
            color: cBlack.withOpacity(0.1),
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          width: size,
          height: size,
          child: Center(
            child: Icon(
              Icons.add,
              color: cBlack.withOpacity(0.7),
            ),
          ),
        ),
      ));
    }
    return Row(
      children: List.generate(items.length, (index) => items[index]),
    );
  }
  Future _addImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        images.add(pickedFile.path);

        setState(() {});
      } else {
        print('No image selected.');
      }
    });
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
