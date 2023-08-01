
import 'package:flutter/material.dart';
import 'package:get/get.dart';

snackbarcustom({required String text }){
     Get.snackbar(
       
       
   '', '',
   // ignore: prefer_const_constructors
   backgroundColor: Color.fromARGB(255, 4, 64, 58),
    titleText:  const Text('Updated',
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
    messageText: Text(text,
        style:  const TextStyle(color: Colors.white)),
   // forwardAnimationCurve: Curves.bounceInOut,
    duration: const Duration(milliseconds: 700),
    icon: const Icon(Icons.music_note,color: Colors.red,),
    isDismissible: true
    
    //overlayBlur: 5,
  );
  }

