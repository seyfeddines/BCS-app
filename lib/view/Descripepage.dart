import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/view/registerpqge.dart';
class DescripePage extends StatelessWidget{
  DescripePage({required this.height,required this.widthe});
  late double height;
  late double widthe;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(fit: BoxFit.cover,image: AssetImage("images/pexels-trupert-1032650.jpg"))
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:CrossAxisAlignment.start ,
         children: [
           SizedBox(height: height!/1.5,),
           Row(
             children: [
               SizedBox(width: widthe!/6,),
               Text("Lets` make",style: TextStyle(color: Colors.black,fontSize: 27),),
             ],
           ),
           Row(
             children: [
               SizedBox(width: widthe!/6,),
               Text("your dream",style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.bold)),
             ],
           ),
           Row(
             children: [
               SizedBox(width: widthe!/6,),
               Text("Vocation.",style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.bold)),
             ],
           ),
           SizedBox(height: height!/17,),
           Center(
             child: ElevatedButton(
               onPressed: () {
                 Get.to(RegisterPage());
               },
               style: ButtonStyle(
                 backgroundColor: MaterialStateProperty.all(Color(0xFFF59350)),
                 padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 65.0, vertical: 15.0)),
               ),
               child: Text(
                 "Get Started",
                 style: TextStyle(fontSize: 18.0,color: Colors.white), // Increased font size
               ),
             ),
           )

         ],
          ),
        ),
      ),
    );
  }

}