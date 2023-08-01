
import 'package:animated_text_kit/animated_text_kit.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:lottie/lottie.dart';

import '../Controller/Getx_Controller.dart';



class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);


 

//  void onInit() {
//     // TODO: implement onInit
//     super.onInit();
   
//   }
  //void initState() {
   
    //fetchSongs();
    
  // toHomeScreen();
  //  super.initState();
    
 // }
  // final box = Boxes.getInstance();
  // final assetAudioPlayer = AssetsAudioPlayer.withId("0");
  // List<Audio> audiosongs = [];
  // final _audioQuery = OnAudioQuery();
  // List<Songsdb> mappedSongs = [];
  // List<Songsdb> dbSongs = [];
  // List<SongModel> fetchedSongs = [];
  // List<SongModel> allsong = [];
  // fetchSongs() async {
  //   bool permissionStatus = await _audioQuery.permissionsStatus();
  //   if (!permissionStatus) {
  //     await _audioQuery.permissionsRequest();
  //   }
  //   allsong = await _audioQuery.querySongs();

  //   mappedSongs = allsong
  //       .map((e) => Songsdb(
  //           title: e.title,
  //           id: e.id.toString(),
  //           image: e.uri!,
  //           duration: e.duration.toString(),
  //           artist: e.artist))
  //       .toList();
  //   await box.put("musics", mappedSongs);
  //   dbSongs = box.get("musics") as List<Songsdb>;

  //   for (var element in dbSongs) {
  //     audiosongs.add(Audio.file(element.image.toString(),
  //         metas: Metas(
  //             title: element.title,
  //             id: element.id.toString(),
  //             artist: element.artist)));
  //   }
  //   setState(() {});
  // }

  @override
   Widget build(BuildContext context) {
      Get.put(Controller());
    return Scaffold(
      backgroundColor: Colors.black,

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(
              height: 1,
            ),
            Container(
                height: 80,
                width: 100,
               
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    // ignore: prefer_const_constructors
                    image: DecorationImage(
                      image: const AssetImage("assets/Untitled design.png"),
                    ))),
            Column(
              children: [
                DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 30.0,
                  ),
                  child: Center(
                    child: AnimatedTextKit(
                      animatedTexts: [
                        WavyAnimatedText('Muzeeco',
                            speed: const Duration(milliseconds: 200),
                            textAlign: TextAlign.start,
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 30)),

                        // WavyAnimatedText('Enjoy the Music',speed:Duration(milliseconds: 200)),
                      ],
                      isRepeatingAnimation: true,
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  width: 100,
                  child: Lottie.asset("assets/104633-sound-wave-red.json",
                      width: 100, height: 100, fit: BoxFit.fill),
                ),
              ],
            ),
          ],
        ),
      ),

    
    );
  }
  
  // Future<void> toHomeScreen() async {            
  //   await Future.delayed(
  //     // ignore: prefer_const_constructors
  //     Duration(seconds: 5),
  //     () {
  //       Navigator.of(context).pushReplacement(
  //        CustomPageRoute(child: MyStatefulWidget(allsong: audiosongs),direction: AxisDirection.down)
  //       );
  //     },
  //   );
  // }
}
