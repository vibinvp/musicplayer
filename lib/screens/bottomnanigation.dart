// ignore_for_file: unnecessary_const

import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import 'package:music_player/Controller/Getx_Controller.dart';
import 'package:music_player/screens/custum/Bottom_sheet.dart';
import 'package:music_player/screens/custum/CustomPage.dart';
import 'package:music_player/screens/custum/playlistscreen.dart';

import 'package:music_player/screens/main_page_design_page.dart';
import 'package:music_player/screens/playlist.dart';
import 'package:music_player/screens/search.dart';
import 'package:music_player/screens/settings_page.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'now_playing.dart';

// ignore: must_be_immutable
class MyStatefulWidget extends StatelessWidget {
  List<Audio> allsong;
  MyStatefulWidget({Key? key, required this.allsong}) : super(key: key);

  final AssetsAudioPlayer assetAudioPlayer = AssetsAudioPlayer.withId("0");

  final maincolor = const Color(0xff181c27);
  //int _selectedIndex = 0;
  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) => element.path == fromPath);
  }

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final _controller = Get.put(Controller());
    final pages = [
      design_main_paage(
        allsong: allsong,
      ),
      // SearchScreen(fullSongs: allsong),
      PlaylistScreen(playlistName: 'favorites'),
      play_List(
        playListname: '',
      ),
      settings(),
    ];
    double screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 2, 36, 41),
      body: GetBuilder<Controller>(builder: (_) {
        return pages[_controller.selectedIndex];
      }),

      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: const Radius.circular(30),
            topRight: const Radius.circular(30)),
        child: FancyBottomBar(
          // type: FancyType.FancyV1,

          selectedIndex: _controller.selectedIndex,
          items: [
            FancyItem(
              textColor: Colors.teal,
              title: 'Home',
              icon: Icon(
                Icons.home,
                color: Colors.white,
                size: 29,
              ),
            ),
            // FancyItem(
            //   textColor: Colors.orange,
            //   title: 'Search',
            //   icon: Icon(
            //     Icons.search,
            //     color: Colors.white,
            //   ),
            // ),
            FancyItem(
              textColor: Colors.green,
              title: 'Favourit',
              icon: Icon(Icons.music_note, color: Colors.white, size: 29),
            ),
            FancyItem(
              textColor: Colors.white,
              title: 'Playlist',
              icon: Icon(Icons.create_new_folder_outlined,
                  color: Colors.white, size: 29),
            ),
            FancyItem(
              textColor: Colors.red,
              title: 'Settings',
              icon: Icon(Icons.settings, color: Colors.white, size: 29),
            ),
          ],
          onItemSelected: (newIndex) {
            _controller.OnitemSelected(newIndex);
            _controller.update();

            //  setState(() {
            //    _selectedIndex = newIndex;

            //  });
          },
        ),
      ),

//down player
      bottomSheet: SizedBox(
        height: 75,
        child: assetAudioPlayer.builderCurrent(
            builder: (BuildContext context, Playing? playing) {
          final myAudio = find(allsong, playing!.audio.assetAudioPath);
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      CustomPageRoute(
                          child: NowPlaying(
                            index: 0,
                            allsong: allsong,
                          ),
                          direction: AxisDirection.up)
                      //   ), )
                      // MaterialPageRoute(
                      //   builder: (context) => NowPlaying(
                      //     index: 0,
                      //     allsong: allsong,
                      //   ),
                      // ),
                      );
                },
                child: Container(
                  height: 75,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(121, 4, 61, 66),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 55,
                          width: 55,
                          child: QueryArtworkWidget(
                            id: int.parse(myAudio.metas.id!),
                            type: ArtworkType.AUDIO,
                            artworkBorder: const BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                topLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                                topRight: Radius.circular(20)),
                            artworkFit: BoxFit.cover,
                            nullArtworkWidget: Container(
                              height: 55,
                              width: 55,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    topLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                    topRight: Radius.circular(20)),
                                image: DecorationImage(
                                  image: AssetImage(
                                      "assets/istockphoto-1175435360-612x612.jpg"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 12,
                              top: 12,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20,
                                  child: Marquee(
                                    text: myAudio.metas.title!,
                                    style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      // fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                               // const SizedBox(height: 4),
                                Text(
                                  myAudio.metas.artist!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                assetAudioPlayer.previous();
                              },
                              child: const Icon(
                                Icons.skip_previous,
                                size: 35,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 10),
                            PlayerBuilder.isPlaying(
                                player: assetAudioPlayer,
                                builder: (context, isPlaying) {
                                  return GestureDetector(
                                    onTap: () async {
                                      await assetAudioPlayer.playOrPause();
                                    },
                                    child: Icon(
                                      isPlaying
                                          ? Icons.pause_rounded
                                          : Icons.play_arrow_rounded,
                                      size: 45,
                                      color: Colors.white,
                                    ),
                                  );
                                }),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                assetAudioPlayer.next();
                              },
                              child: const Icon(
                                Icons.skip_next_rounded,
                                size: 35,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 15),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
