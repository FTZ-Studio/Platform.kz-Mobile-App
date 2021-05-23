import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kz/API/API.dart';
import 'package:kz/API/RestProvider/RestProvider.dart';
import 'package:kz/Style.dart';
import 'package:kz/UI/widgets/AddAppeal/GoogleMapPage.dart';
import 'package:kz/UI/widgets/Filter.dart';
import 'package:kz/generated/l10n.dart';
import 'package:kz/models/Address.dart';
import 'package:kz/models/Appeal.dart';
import 'package:kz/models/Categories.dart';
import 'package:kz/models/Put.dart';
import 'package:kz/utils/DialogsIntegron/DialogIntegron.dart';
import 'package:kz/utils/GetPosition.dart';
import 'package:kz/utils/UploadPhoto.dart';
import 'package:kz/utils/app_keys.dart';
import 'package:kz/utils/svg/IconSVG.dart';
import 'package:http/http.dart' as http;

const String key = "AIzaSyAEBsJIE-UAlDTLpYBKbbshsew12e_vquw";

Future<bool> showAddAppeal() async {
  // await AppKeys.scaffoldKey.currentState.showBottomSheet(
  //       (context) {
  //     return ContentAddAppeal();
  //   },
  //   backgroundColor: Colors.transparent,
  // );

  showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: AppKeys.scaffoldKey.currentContext, builder: (context)=>ContentAddAppeal());
  return true;
}

class ContentAddAppeal extends StatefulWidget {
  @override
  _ContentAddAppealState createState() => _ContentAddAppealState();
}

class _ContentAddAppealState extends State<ContentAddAppeal> {
  PageController pageController = PageController(initialPage: 0);
  Set<Marker> _markers = {};
  int count = 0;
  bool initStatus = false;
  LatLng position;
  bool checkBoxState = false;
  bool checkBoxStateAnon = false;
  TextEditingController controllerRName = TextEditingController();
  TextEditingController controllerCity = TextEditingController();
  TextEditingController controllerAddress = TextEditingController();
  List<Category> listCategory;
  TextEditingController controllerComment = TextEditingController();

  List<String> responsePhoto = [];
  bool loading = true;
  int currentCategory;

  loadCategory() async {
    listCategory = await CategoryProvider.get();
    loading = false;
    print("category ${listCategory.length}");
    setState(() {});
  }

  List<String> images = [];
  final picker = ImagePicker();

  initPosition() async {
    position = await getPosition();
    print(position);
    if (position != null) {
      initStatus = true;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    initPosition();
    pageController.addListener(() {
      setState(() {});
    });
    loadCategory();
  }

  addAppeal() async {
    setState(() {
      loading = true;
    });
    if (position == null) {
      setState(() {
        loading = false;
      });
      showDialogIntegronError(context, "Вы не указали местоположение");
    } else if ((controllerAddress.text.isEmpty || controllerCity.text.isEmpty ||
        controllerRName.text.isEmpty)&&(!checkBoxStateAnon)) {
      setState(() {
        loading = false;
      });
      showDialogIntegronError(context, "Вы заполнили не все данные");
    } else {
      responsePhoto = [];
      if (images.isNotEmpty) {
        for (int i = 0; i < images.length; i++) {
          await uploadPhoto(images[i]);
        }
      }
      Address address = Address(
          latitude: position.latitude, longitude: position.longitude);
      Appeal appeal = Appeal(comment: controllerComment.text.isEmpty?"Нет комментария":controllerComment.text,
          photos: responsePhoto,
          address: address,
          anonim: checkBoxStateAnon,
          category: CategoryChild(id: currentCategory, parent: 0, name: ""));
      Put response = await AppealProvider.create(appeal);
      if (response.error == 200) {
        Navigator.pop(context);
        showDialogIntegronError(context,
            "Обращение создано, его можно просмотреть в личном кабинете");
      } else {
        if(response.error == 6){
          await UserProvider.userSetName(controllerRName.text);
          await UserProvider.userSetAddress(controllerCity.text +" "+controllerAddress.text);
          response = await AppealProvider.create(appeal);
          if (response.error == 200) {
            Navigator.pop(context);
            showDialogIntegronError(context,
                "Обращение создано, его можно просмотреть в личном кабинете");
          } else {
            setState(() {
              loading = false;
            });
            showDialogIntegronError(context, response.mess);
          }
        }
        setState(() {
          loading = false;
        });
        showDialogIntegronError(context, response.mess);
      }
    }
  }

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
                      S
                          .of(context)
                          .addAppeal,
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
                    Text(
                      "Шаг ${pageController == null ? 1 : pageController
                          .positions.length == 0 ? 1 : (pageController.page + 1)
                          .round()
                          .toString()} из 5",
                      style: TextStyle(color: cBlack.withOpacity(0.3)),
                    ),
                    Container(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.80 - 128,
                      color: cWhite,
                      child: PageView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: pageController,
                        children: [
                          _selectPosition(),
                          _addPhoto(),
                          _commentStep(),
                          _selectCategory(),
                          _inputDataPerson()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _commentStep() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          SizedBox(
            height: 15,
          ),
          _headerBold("Обращение"),
          SizedBox(
            height: 24,
          ),
          _descriptionText(
              "Опишите суть проблемы или предложения."),
          SizedBox(
            height: 24,
          ),
          commentField(),
          SizedBox(
            height: 24,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width / 2 - 18,
                  child: _buttonBack(onTap: () {
                    pageController.animateToPage(1,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeOut);
                  })),
              Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width / 2 - 18,
                  child: _buttonNext(onTap: () {
                    pageController.animateToPage(3,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeOut);
                  })),
            ],
          ),          SizedBox(height: 60,),


        ],
      ),
    );
  }

  Widget _selectPosition() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 15,
          ),
          _headerBold("Выберите район"),
          SizedBox(
            height: 24,
          ),
          _descriptionText(
              "Геолокация определяется автоматичесик, но Вы можете вручную указать нужный район на карте просто переместив точку на карте."),
          SizedBox(
            height: 24,
          ),
          ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: _Map()),
          SizedBox(
            height: 25,
          ),
          Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: 60,
              child: _buttonNext(onTap: () {
                pageController.animateToPage(1,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOut);
              })),
          SizedBox(
            height: 80,
          ),
        ],
      ),
    );
  }


  Widget _addPhoto() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 15,
          ),
          _headerBold("Загрузите фотографии"),
          SizedBox(
            height: 24,
          ),
          _descriptionText(
              "Максимально можно загрузить 5 фотографий. Если у вас фотографий нет, то пропустите этот шаг."),
          SizedBox(
            height: 24,
          ),
          _photoList(0),
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width / 2 - 18,
                  child: _buttonBack(onTap: () {
                    pageController.animateToPage(0,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeOut);
                  })),
              Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width / 2 - 18,
                  child: _buttonNext(onTap: () {
                    pageController.animateToPage(2,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeOut);
                  })),
            ],
          )
        ],
      ),
    );
  }

  Widget _selectCategory() {
    double menuW = 0;
    if (MediaQuery
        .of(context)
        .size
        .width < 400) {
      menuW = MediaQuery
          .of(context)
          .size
          .width * 0.50;
    } else {
      menuW = MediaQuery
          .of(context)
          .size
          .width * 0.40;
    }

    return loading ? Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 15,
          ),
          _headerBold("Выберите категорию"),
          SizedBox(
            height: 24,
          ),
          _descriptionText(
              "Выберите категорию государственных органов которым вы хотите отправить обращение. Если вы не знаете к какой категории относится обращение то поставьте галочку под списком и сервис автоматически определит обращение к нужной категории."),
          SizedBox(
            height: 24,
          ),
          _selectCategoryWidget(),
          SizedBox(
            height: 24,
          ),
          _checkBox(),
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width / 2 - 18,
                  child: _buttonBack(onTap: () {
                    pageController.animateToPage(2,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeOut);
                  })),
              Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width / 2 - 18,
                  child: _buttonNext(onTap: () {
                    pageController.animateToPage(4,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeOut);
                  })),
            ],
          ),
          SizedBox(height: 60,),

        ],
      ),
    );
  }

  Widget _inputDataPerson() {
    return loading ? Center(child: CircularProgressIndicator()) : SingleChildScrollView(
      physics: BouncingScrollPhysics(),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 15,
          ),
          _headerBold("Введите данные"),
          SizedBox(
            height: 24,
          ),
          _descriptionText(
              "Тут стоит уточнить зачем нужны данные от человека, чтобы не боялись оставлять и не бросали заполнение анкеты на этом шаге"),
          SizedBox(
            height: 24,
          ),
          regForm(),
          SizedBox(
            height: 24,
          ),
          _checkBoxAnon(),
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width / 2 - 18,
                  child: _buttonBack(onTap: () {
                    pageController.animateToPage(3,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeOut);
                  })),
              Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width / 2 - 18,
                  child: _buttonNext(onTap: () {
                    addAppeal();
                  })),
            ],
          ),
          SizedBox(height: 60,),
        ],
      ),
    );
  }

  Widget _headerBold(String text) {
    return Text(
      text,
      style: TextStyle(
          color: cBlack,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          fontFamily: fontFamily),
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

  Widget _Map() {
    return AspectRatio(
      aspectRatio: 4 / 2,
      child: !initStatus
          ? Container(
        height: MediaQuery
            .of(context)
            .size
            .height,
        width: MediaQuery
            .of(context)
            .size
            .width,
        color: cBlack,
      )
          : GoogleMap(
        onTap: (locale)async{
          LatLng res = await Navigator.push(context, MaterialPageRoute(builder: (context)=>GoogleMapPage(position)));
          if(res != null){
            position = res;
            updateMap();
          }
        },
        onMapCreated: _onMapCreated,
        myLocationButtonEnabled: false,
        myLocationEnabled: false,
        zoomControlsEnabled: false,
        markers: _markers,
        initialCameraPosition: CameraPosition(
          target: position,
          zoom: 15,
        ),
      ),
    );
  }
  updateMap(){
    _markers = {};
    _markers.add(
      Marker(
        markerId: MarkerId("id-$count"),
        position: position,
        draggable: true,
      ),
    );
    setState(() {});
    count++;
  }

  _onMapCreated(GoogleMapController controller) {
    _markers = {};
    _markers.add(
      Marker(
        markerId: MarkerId("id-$count"),
        position: position,
        draggable: true,
      ),
    );
    setState(() {});
    count++;
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
                "Дальше",
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
            controller: controllerComment,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintStyle: TextStyle(
                fontSize: 14,
                fontFamily: fontFamily,
                fontWeight: FontWeight.w400,
                color: cBlack,
              ),
              hintText: "Введите текст",
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
                "Назад",
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

  Widget _selectCategoryWidget() {
    return FilterMenuHolder(
      menuWidth: MediaQuery
          .of(context)
          .size
          .width - 24,
      blurSize: 0.0,
      menuItemExtent: 62,
      onPressed: () {},
      menuOffset: -56.0,
      // Offset value to show menuItem from the selected item
      bottomOffsetHeight: 30.0,
      menuItems: List.generate(listCategory.length, (index) {
        return FocusedMenuItem(
            title: Text(
              listCategory[index].name,
              style: TextStyle(
                  color: cBlack,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: fontFamily),
            ),
            onPressed: () {
              setState(() {
                currentCategory = index;
              });
            });
      }),
      currentItem: 0,
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          border: Border.all(color: cBlack.withOpacity(0.1)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(currentCategory == null
                  ? "Выберите категорию"
                  : listCategory[currentCategory].name),
              Icon(
                Icons.keyboard_arrow_down,
                color: cBlack,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _checkBox() {
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTap: () {
        setState(() {
          checkBoxState = !checkBoxState;
        });
      },
      child: Row(
        children: [
          Icon(
            checkBoxState
                ? Icons.check_box_outlined
                : Icons.check_box_outline_blank,
            color: checkBoxState ? cBlue : cBlack.withOpacity(0.2),
            size: 24,
          ),
          SizedBox(
            width: 14,
          ),
          _descriptionText("Автоназначение категории"),
        ],
      ),
    );
  }

  Widget _checkBoxAnon() {
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTap: () {
        setState(() {
          checkBoxStateAnon = !checkBoxStateAnon;
        });
      },
      child: Row(
        children: [
          Icon(
            checkBoxStateAnon
                ? Icons.check_box_outlined
                : Icons.check_box_outline_blank,
            color: checkBoxStateAnon ? cBlue : cBlack.withOpacity(0.2),
            size: 24,
          ),
          SizedBox(
            width: 14,
          ),
          _descriptionText("Анонимно"),
        ],
      ),
    );
  }

  Widget regForm() {
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
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: 14,
                  fontFamily: fontFamily,
                  fontWeight: FontWeight.w400,
                  color: cBlack,
                ),
                hintText: "Фамилия Имя Отчество",
              ),
              style: TextStyle(
                  color: cBlack,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: fontFamily),
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            border: Border.all(color: cBlack.withOpacity(0.1)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              keyboardType: TextInputType.streetAddress,
              controller: controllerCity,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: 14,
                  fontFamily: fontFamily,
                  fontWeight: FontWeight.w400,
                  color: cBlack,
                ),
                hintText: "Город или область",
              ),
              style: TextStyle(
                  color: cBlack,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: fontFamily),
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            border: Border.all(color: cBlack.withOpacity(0.1)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              keyboardType: TextInputType.visiblePassword,
              controller: controllerAddress,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: 14,
                  fontFamily: fontFamily,
                  fontWeight: FontWeight.w400,
                  color: cBlack,
                ),
                hintText: "Адрес",
              ),
              style: TextStyle(
                  color: cBlack,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: fontFamily),
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
      ],
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
