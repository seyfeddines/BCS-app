import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/binding/Mybinding.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:untitled/view/Descripepage.dart';
import 'package:untitled/view/Firrstepqge.dart';
import 'package:untitled/view/Sectionpage.dart';
import 'package:untitled/view/newAcount.dart';
void main() {
  runApp( MyApp());
}
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    print(screenWidth);
    print(screenHeight);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: DescripePage(widthe: screenWidth,height: screenHeight,),
      getPages: [
        GetPage(name: ("/"), page: ()=>FirsePage(height:screenHeight ,widthe: screenWidth,),binding: Mybinding()),
        GetPage(name: ("/descripepage"), page: ()=>DescripePage(widthe: screenWidth,height: screenHeight,)),
        GetPage(name: ("/singup"), page: ()=>CreateAccountPage(height:screenHeight ,widthe: screenWidth,),binding: Mybinding()),
        GetPage(name: ("/homepage"), page: ()=>HomePage(height:screenHeight ,width: screenWidth,),binding: Mybinding()),

      ],
    );
  }
}