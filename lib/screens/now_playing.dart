import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';

import 'package:music_player/Controller/Getx_Controller.dart';
import 'package:music_player/screens/custum/snackbar.dart';

import 'package:on_audio_query/on_audio_query.dart';

import '../db/box.dart';
import '../db/songsmodel.dart';
import 'custum/buildsheet.dart';

// ignore: must_be_immutable
class NowPlaying extends StatelessWidget {
  List<Audio> allsong = [];

  int index;
  NowPlaying({
    Key? key,
    required this.allsong,
    required this.index,
  }) : super(key: key);

  final AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer.withId("0");
  Songsdb? music;
  final List<StreamSubscription> subscription = [];
  final box = Boxes.getInstance();
  List<Songsdb> dbSongs = [];
  List<dynamic>? likedSongs = [];
  List<dynamic>? favorites = [];

  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) => element.path == fromPath);
  }

  @override
  Widget build(BuildContext context) {
    final _controller = Get.put(Controller());
    dbSongs = box.get("musics") as List<Songsdb>;
    //double myHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_drop_down),
        ),
        backgroundColor: const Color.fromARGB(255, 5, 54, 50),
        centerTitle: true,
        title: const Text(
          'Now Playing',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        actions: [],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomLeft,
          stops: [
            0.1,
            0.4,
            0.6,
            0.9,
          ],
          colors: [
            Color.fromARGB(255, 5, 54, 50),
            Color.fromARGB(255, 2, 30, 34),
            Color.fromARGB(255, 2, 87, 87),
            Color.fromARGB(255, 5, 77, 69),
          ],
        )),
        child: assetsAudioPlayer.builderCurrent(
          builder: (context, Playing? playing) {
            final myaudio = find(allsong, playing!.audio.assetAudioPath);
            final currentSong = dbSongs.firstWhere((element) =>
                element.id.toString() == myaudio.metas.id.toString());
            likedSongs = box.get("favorites");
            String artist;
            if (myaudio.metas.artist.toString() == "<unknown>") {
              artist = 'No artist';
            } else {
              artist = myaudio.metas.artist.toString();
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 34.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: QueryArtworkWidget(
                        artworkBorder: BorderRadius.circular(5),
                        artworkHeight: 280,
                        artworkWidth: 280,
                        artworkFit: BoxFit.fill,
                        artworkClipBehavior: Clip.antiAliasWithSaveLayer,
                        nullArtworkWidget: Image.asset(
                          "assets/istockphoto-1175435360-612x612.jpg",
                          height: 250,
                          width: 280,
                          fit: BoxFit.cover,
                        ),
                        id: int.parse(myaudio.metas.id.toString()),
                        type: ArtworkType.AUDIO),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 40,
                          child: Marquee(
                            text:
                              "${myaudio.metas.title}",
                              
                              style: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: Colors.white,
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold),
                            ),
                        ),
                        
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Text(
                      artist,
                      style: const TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    GetBuilder<Controller>(
                      builder: (_) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: Icon(Icons.my_library_music_outlined),
                              onPressed: () {
                                //Navigator.of(context).pop();
                                showModalBottomSheet(
                                  backgroundColor:
                                      Color.fromARGB(159, 6, 63, 63)
                                          .withOpacity(1.0),
                                  // backgroundColor:Colors.white,
                                  //  const Color.fromARGB(96, 11, 61, 62),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(30),
                                    ),
                                  ),
                                  context: context,
                                  builder: (context) => BuildSheet(
                                    song: allsong[index],
                                  ),
                                );
                              },
                            ),
                            !_controller.isShuffle
                                ? IconButton(
                                    onPressed: () {
                                      //  setState(() {
                                      _controller.isShuffle = true;
                                      assetsAudioPlayer.toggleShuffle();
                                      _controller.update();
                                      //   });
                                    },
                                    icon: const Icon(Icons.shuffle),
                                  )
                                : IconButton(
                                    onPressed: () {
                                      //  setState(() {
                                      _controller.isShuffle = false;
                                      assetsAudioPlayer
                                          .setLoopMode(LoopMode.playlist);
                                      _controller.update();
                                      //    });
                                    },
                                    icon: const Icon(Icons.loop_sharp),
                                  ),
                            _controller.likedSongs!
                                    .where((element) =>
                                        element.id.toString() ==
                                        currentSong.id.toString())
                                    .isEmpty
                                ? IconButton(
                                    onPressed: () {
                                      print(
                                          "Nowplaying....................$currentSong");
                                      _controller.Addtofavorite(currentSong);
                                      // likedSongs?.add(currentSong);
                                      // box.put("favorites", likedSongs!);
                                      // likedSongs = box.get("favorites");
                                      _controller.update();
                                      // setState(() {});
                                      snackbarcustom(text: 'ADDED TO FAVORITE');
                                      _controller.update();
                                    },
                                    icon: const Icon(Icons.favorite_border),
                                  )
                                : IconButton(
                                    onPressed: () async {
                                      _controller
                                          .removeFromfavourite(currentSong);
                                      // setState(() {
                                      //   likedSongs?.removeWhere((elemet) =>
                                      //       elemet.id.toString() ==
                                      //      currentSong.id.toString());
                                      //  box.put("favorites", likedSongs!);
                                      _controller.update();
                                      //   });
                                      snackbarcustom(
                                          text: 'REMOVED to FROM FAVORITE');
                                    },
                                    icon: const Icon(Icons.favorite),
                                  ),
                            !_controller.isLooping
                                ? IconButton(
                                    onPressed: () {
                                      //   setState(() {
                                      _controller.isLooping = true;
                                      assetsAudioPlayer
                                          .setLoopMode(LoopMode.single);
                                      _controller.update();
                                      //  });
                                    },
                                    icon: const Icon(Icons.repeat),
                                  )
                                : IconButton(
                                    onPressed: () {
                                      //   setState(() {
                                      _controller.isLooping = false;
                                      assetsAudioPlayer
                                          .setLoopMode(LoopMode.playlist);
                                      _controller.update();
                                      //  });
                                    },
                                    icon: const Icon(Icons.repeat_one),
                                  ),
                          ],
                        );
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: seekBarWidget(context),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {
                            assetsAudioPlayer.previous();
                          },
                          icon: const Icon(
                            Icons.skip_previous_rounded,
                            size: 45,
                            color: Colors.white,
                          ),
                        ),
                        PlayerBuilder.isPlaying(
                          player: assetsAudioPlayer,
                          builder: (context, isPlaying) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(top: 18.0, left: 13),
                              child: IconButton(
                                iconSize: 70,
                                onPressed: () async {
                                  await assetsAudioPlayer.playOrPause();
                                },
                                icon: Icon(
                                  isPlaying
                                      ? Icons.pause_circle_sharp
                                      : Icons.play_circle_rounded,
                                ),
                              ),
                            );
                          },
                        ),

                        //  dbSongs ==dbSongs[dbSongs.length-1]

                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: IconButton(
                            onPressed: () {
                              assetsAudioPlayer.next();
                            },
                            icon: const Icon(
                              Icons.skip_next_rounded,
                              size: 45,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget seekBarWidget(BuildContext ctx) {
    return assetsAudioPlayer.builderRealtimePlayingInfos(builder: (ctx, infos) {
      Duration currentPosition = infos.currentPosition;
      Duration total = infos.duration;
      return Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: ProgressBar(
          progress: currentPosition,
          total: total,
          onSeek: (to) {
            assetsAudioPlayer.seek(to);
          },
          timeLabelTextStyle: const TextStyle(color: Colors.white),
          baseBarColor: const Color.fromARGB(255, 190, 190, 190),
          progressBarColor: const Color(0xFF32C437),
          bufferedBarColor: const Color(0xFF32C437),
          thumbColor: const Color(0xFF32C437),
        ),
      );
    });
  }
}
