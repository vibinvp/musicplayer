import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';


import 'package:music_player/screens/splashscreen.dart';

import 'db/box.dart';
import 'db/songsmodel.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(SongsdbAdapter());
  await Hive.openBox<List>(boxname);

  final box = Boxes.getInstance();
  //newly editing for marquee 
  //Add for playlist working
  List<dynamic> libraryKeys = box.keys.toList();
  if (!libraryKeys.contains("favorites")) {
    List<dynamic> likedSongs = [];
    await box.put("favorites", likedSongs);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          //  textTheme: GoogleFonts.adventProTextTheme(
          //      Theme.of(context).textTheme,

          // ),
          ),
      home:const  SplashScreen(),
    );
  }
}
