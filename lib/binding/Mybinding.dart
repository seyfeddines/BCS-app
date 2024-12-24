import 'package:get/get.dart';
import 'package:untitled/controler/ControllerOne.dart';

import '../controler/controlersavedata.dart';
class Mybinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>ControllerOne(),fenix: true);
    Get.lazyPut(()=>ControlerSaveData(),fenix: true);
  }

}