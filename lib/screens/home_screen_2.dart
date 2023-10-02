import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

import '../components/HomeItemWidget.dart';
import '../components/LastEditedListWidget.dart';
import '../main.dart';
import '../services/FileService.dart';
import '../utils/Colors.dart';
import 'CollegeMakerScreen.dart';
import 'DashboardScreen.dart';
import 'PhotoEditScreen.dart';

class HomeScreen2 extends StatefulWidget {
  const HomeScreen2({Key? key}) : super(key: key);

  @override
  State<HomeScreen2> createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2> {
  DateTime? currentBackPressTime;

  bool isEmpty = true;
  void pickImageSource(ImageSource imageSource) {
    pickImage(imageSource: imageSource).then((value) async {
      await PhotoEditScreen(file: value).launch(context, pageRouteAnimation: PageRouteAnimation.Fade, duration: 1000.milliseconds);
    }).catchError((e) {
      log(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(

      onWillPop: () async {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null || now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
          currentBackPressTime = now;
          toast('Press back again to exit');
          return Future.value(false);
        }
        return Future.value(true);
      },



      child: SafeArea(
          child: Scaffold(

              backgroundColor: Colors.black,
              body: Container(
                decoration: BoxDecoration(image: DecorationImage(

                    fit: BoxFit.cover,
                    image: AssetImage("images/1.jpg"))),


                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  height: double.infinity,
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [


                        Text("FW",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 90,
                                color: Colors.white)),

                        Text("Photo Editor",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: Colors.white)),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(

                              onTap: () {
                                showInDialog(context, contentPadding: EdgeInsets.zero, builder: (context) {
                                  return Container(
                                    width: context.width(),
                                    padding: EdgeInsets.all(8),
                                    decoration: boxDecorationWithShadow(borderRadius: radius(8)),
                                    child: Row(
                                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            finish(context);

                                            pickImageSource(ImageSource.gallery);
                                          },
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              8.height,
                                              Icon(Ionicons.image_outline, color: Colors.black, size: 32),
                                              Text('Gallery', style: primaryTextStyle(color: Colors.black)).paddingAll(16),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            finish(context);

                                            pickImageSource(ImageSource.camera);
                                            //var image = ImageSource.camera;
                                          },
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              8.height,
                                              Icon(Ionicons.camera_outline, color: Colors.black, size: 32),
                                              Text('Camera', style: primaryTextStyle(color: Colors.black)).paddingAll(16),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                              },

                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(colors: [
                                    itemGradient1,
                                    itemGradient2,
                                  ], end: Alignment.topCenter, begin: Alignment.bottomCenter),
                                ),
                                width: 150,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      // Image(image: AssetImage("")),
                                      Icon(Ionicons.create_outline, color: Colors.white, size: 28),
                                      Text("Pick Image",
                                          style: TextStyle(color: Colors.white)),
                                    ]),
                              ),
                            ),
                            GestureDetector(

                              onTap: () async {
                                bool? isConfirm = false;
                                await showConfirmDialogCustom(context, title: 'Choose at least 2 and maximum 9 images', positiveText: 'Choose', negativeText: 'Cancel', primaryColor: colorPrimary, onAccept: (context) {
                                  isConfirm = true;
                                });
                                if (isConfirm ?? true) {
                                  pickMultipleImage().then((value) async {
                                    if (value.length >= 2 && value.length <= 9) {
                                      appStore.clearCollegeImageList();

                                      ///compress all image before making college photo
                                      await Future.forEach(value, (File? e) async {
                                        await FlutterNativeImage.compressImage(e!.path, quality: 70).then((File? f) {
                                          if (f != null) {
                                            appStore.addCollegeImages(f);
                                          }
                                        });
                                      });
                                      await showInDialog(context, builder: (c) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            AppButton(
                                              width: context.width(),
                                              padding: EdgeInsets.zero,
                                              color: colorPrimary,
                                              child: Text('Default Collage', style: boldTextStyle(color: Colors.white)),
                                              onTap: () {
                                                finish(context);
                                                CollegeMakerScreen(isAutomatic: true).launch(context);
                                              },
                                            ),
                                            4.height,
                                            AppButton(
                                              width: context.width(),
                                              padding: EdgeInsets.zero,
                                              color: colorPrimary,
                                              child: Text('Manual Collage', style: boldTextStyle(color: Colors.white)),
                                              onTap: () {
                                                finish(context);
                                                CollegeMakerScreen(isAutomatic: false).launch(context);
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                    } else {
                                      toast('Choose at least 2 and maximum 9 images');
                                    }
                                  }).catchError((error) {
                                    log(error.toString());
                                  });
                                }
                              },

                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(colors: [
                                    itemGradient1,
                                    itemGradient2,
                                  ], end: Alignment.topCenter, begin: Alignment.bottomCenter),
                                ),
                                width: 150,
                                child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      // Image(image: AssetImage("")),
                                      Icon(MaterialCommunityIcons.view_dashboard_outline, color: Colors.white),
                                      Text("Make Collage",
                                          style: TextStyle(color: Colors.white)),
                                    ]),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(

                              onTap: () async {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => DashboardScreen(),));
                              },

                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(colors: [
                                    itemGradient1,
                                    itemGradient2,
                                  ], end: Alignment.topCenter, begin: Alignment.bottomCenter),
                                ),
                                width: 150,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      // Image(image: AssetImage("")),
                                      Icon(Icons.double_arrow_sharp, color: Colors.white),
                                      Text("More",
                                          style: TextStyle(color: Colors.white)),
                                    ]),
                              ),
                            ),
                            GestureDetector(

                              onTap: () async {

                              },

                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(colors: [
                                    itemGradient1,
                                    itemGradient2,
                                  ], end: Alignment.topCenter, begin: Alignment.bottomCenter),
                                ),
                                width: 150,
                                child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      // Image(image: AssetImage("")),
                                      Icon(Icons.star, color: Colors.white),
                                      Text("Rate Us",
                                          style: TextStyle(color: Colors.white)),
                                    ]),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 10),
                        ElevatedButton(
                            onPressed: () {},
                            child: Text("Share",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              elevation: 30,
                              fixedSize: Size(300, 30),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            )),


                        LastEditedListWidget(
                          isDashboard: true,
                          onUpdate: () {
                            setState(()  {
                              getLocalSavedImageDirectories().then((value) {
                                if (value.isNotEmpty) {
                                  isEmpty = false;
                                }else{
                                  isEmpty=true;
                                  setState(() { });
                                }
                              });
                            });
                          },
                        ),



                      ],
                    ),
                  )))),
    );
  }
}
