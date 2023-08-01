// ignore_for_file: unnecessary_const, camel_case_types

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/openassetaudio/openassetaudio.dart';
import 'package:music_player/screens/custum/CustomPage.dart';
import 'package:music_player/screens/custum/snackbar.dart';
import 'package:music_player/screens/now_playing.dart';
import 'package:music_player/screens/search.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../db/box.dart';
import '../db/songsmodel.dart';
import 'custum/buildsheet.dart';

// ignore: must_be_immutable
class design_main_paage extends StatelessWidget {
  design_main_paage({Key? key, required this.allsong}) : super(key: key);
  List<Audio> allsong;
  List<dynamic>? likedSongs = [];

  final AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer.withId("0");
  double screenheight = 0;
  double screenwidth = 0;
  final maincolor = const Color(0xff181c27);
  final inactivecolor = const Color(0xff31bac7);
  //List<dynamic>? likedSongs = [];
  List? dbSongs = [];
  List playlists = [];
  List<dynamic>? favorites = [];
  String? playlistName = '';
  final box = Boxes.getInstance();

  @override
  Widget build(BuildContext context) {
    dbSongs = box.get("musics");
    likedSongs = box.get("favorites");
    screenheight = MediaQuery.of(context).size.height;
    screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      //  resizeToAvoidBottomInset:false,
      backgroundColor: const Color.fromARGB(255, 2, 36, 41),
      appBar: AppBar(
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.only(
            left: 10.0,
          ),
          child: Text(
            'Home',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 2, 36, 41),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 30.0,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) {
                      return SearchScreen(fullSongs: allsong);
                    },
                  ),
                );
              },
              icon: const Icon(
                Icons.manage_search_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),

      body: ListView.separated(
          itemBuilder: (context, index) {
            String artist;
            if (allsong[index].metas.artist.toString() == "<unknown>") {
              artist = 'No artist';
            } else {
              artist = allsong[index].metas.artist.toString();
            }
            return ListTile(
              title: Text(
                allsong[index].metas.title.toString(),
                style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: Colors.white,
                    // const Color.fromARGB(255, 60, 118, 72)
                    fontSize: 15),
              ),
              subtitle: Text(artist,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 189, 218, 195), fontSize: 12)),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: QueryArtworkWidget(
                    artworkHeight: 50,
                    artworkWidth: 50,
                    artworkFit: BoxFit.contain,
                    nullArtworkWidget: Image.asset(
                      "assets/istockphoto-1175435360-612x612.jpg",
                      height: 55,
                      width: 55,
                      fit: BoxFit.cover,
                    ),
                    id: int.parse(allsong[index].metas.id.toString()),
                    type: ArtworkType.AUDIO),
              ),
              onTap: () async {
                OpenPlayer(fullSongs: allsong, index: index)
                    .openAssetPlayer(index: index, songs: allsong);
                Navigator.of(context).push(CustomPageRoute(
                    child: NowPlaying(
                      index: index,
                      allsong: allsong,
                    ),
                    direction: AxisDirection.left));
              },
              onLongPress: () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  // likedSongs = box.get("favorites");
                  return Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    backgroundColor:
                        const Color.fromARGB(159, 6, 63, 63).withOpacity(1.0),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            allsong[index].metas.title.toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 106, 211, 106),
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          ListTile(
                            title: const Text(
                              "Add to Playlist",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 250, 249, 249),
                                  fontSize: 18),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              showModalBottomSheet(
                                backgroundColor: Color.fromARGB(159, 6, 63, 63)
                                    .withOpacity(1.0),
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
                          likedSongs!
                                  .where((element) =>
                                      element.id.toString() ==
                                      dbSongs![index].id.toString())
                                  .isEmpty
                              ? ListTile(
                                  title: const Text(
                                    "Add to Favorites",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 252, 250, 250),
                                        fontSize: 18),
                                  ),
                                  onTap: () async {
                                    final songs =
                                        box.get("musics") as List<Songsdb>;
                                    final temp = songs.firstWhere((element) =>
                                        element.id.toString() ==
                                        allsong[index].metas.id.toString());
                                    favorites = likedSongs;
                                    favorites?.add(temp);
                                    box.put("favorites", favorites!);

                                    Get.back();

                                    snackbarcustom(text: 'Added to favourite');
                                  },
                                )
                              : ListTile(
                                  title: const Text(
                                    "Remove from Favorites",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  trailing: const Icon(
                                    Icons.favorite_rounded,
                                    color: Colors.redAccent,
                                  ),
                                  onTap: () async {
                                    likedSongs?.removeWhere((elemet) =>
                                        elemet.id.toString() ==
                                        dbSongs![index].id.toString());
                                    await box.put("favorites", likedSongs!);
                                    // setState(() {});

                                    Get.back();

                                    snackbarcustom(
                                        text: 'removed from playlist');
                                  },
                                ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
          separatorBuilder: (BuildContext context, index) {
            // print(widget.allsong);
            return const SizedBox(
              height: 1,
            );
          },
          itemCount: allsong.length),
    );
  }
}
