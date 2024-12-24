import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../controler/ControllerOne.dart';
import 'package:get/get.dart';

import 'Map.dart';
class FirsePage extends StatelessWidget{
  FirsePage({required this.height,required this.widthe});
  late double widthe;
  late double height;
  ControllerOne cntrl = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapPage(),
    );
  }

}