import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/Controller/Search_controller.dart';
import 'package:music_player/screens/custum/CustomPage.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../Controller/Getx_Controller.dart';
import '../db/box.dart';
import '../db/songsmodel.dart';
import '../openassetaudio/openassetaudio.dart';
import 'now_playing.dart';

// ignore: must_be_immutable
class SearchScreen extends StatelessWidget {
  List<Audio> fullSongs = [];

  SearchScreen({Key? key, required this.fullSongs}) : super(key: key);

  
  //final box = Boxes.getInstance();

  // String search = "";

  // List<Songsdb> dbSongs = [];

  //List<Audio> allSongs = [];

  // searchSongs() {
  //   dbSongs = box.get("musics") as List<Songsdb>;
  //   for (var element in dbSongs) {
  //     allSongs.add(
  //       Audio.file(
  //         element.image.toString(),
  //         metas: Metas(
  //             title: element.title,
  //             id: element.id.toString(),
  //             artist: element.artist),
  //       ),
  //     );
  //   }
  // }

//  @override
//   void initState() {
//     super.initState();
//     searchSongs();
//   }

  @override
  Widget build(BuildContext context) {
    final Controllers = Get.put(SearchController());

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Scaffold(
        backgroundColor: const Color.fromARGB(255, 2, 36, 41),
        appBar: AppBar(
          //  centerTitle: true,
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 2, 36, 41),
        ),
        body: SizedBox(
          height: 950,
          width: double.infinity,
          child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: GetBuilder<SearchController>(builder: (_controller) {
                List<Audio> searchArtist =
                    Controllers.allSongs.where((element) {
                  return element.metas.artist!.toLowerCase().startsWith(
                        Controllers.search.toLowerCase(),
                      );
                }).toList();
                List<Audio> searchTitle = Controllers.allSongs.where((element) {
                  return element.metas.title!.toLowerCase().startsWith(
                        Controllers.search.toLowerCase(),
                      );
                }).toList();
                List<Audio> searchResult = searchTitle + searchArtist;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10.0,
                      ),
                      child: Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text(
                              'Search',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.85,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0)),
                      child: TextField(
                        cursorColor: Colors.grey,
                        enableSuggestions: true,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 20),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          hintText: ' Search a song',
                          filled: true,
                        ),
                        onChanged: (value) {
                          Controllers.search = value;
                          Controllers.update();
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Controllers.search.isNotEmpty
                        ? searchResult.isNotEmpty
                            ? Expanded(
                                child: Stack(
                                  children: [
                                    ListView.builder(
                                      itemCount: searchResult.length,
                                      itemBuilder: ((context, index) {
                                        return FutureBuilder(
                                          future: Future.delayed(
                                            const Duration(microseconds: 0),
                                          ),
                                          builder: ((context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.done) {
                                              return GestureDetector(
                                                onTap: () {
                                                  OpenPlayer(
                                                          fullSongs:
                                                              searchResult,
                                                          index: index)
                                                      .openAssetPlayer(
                                                          index: index,
                                                          songs: searchResult);
                                                  Navigator.push(context,
                                                     CustomPageRoute(child: NowPlaying(
                                                      allsong:
                                                          Controllers.allSongs,
                                                      index: index,
                                                    ),
                                                    direction: AxisDirection.right
                                                    ));
                                                },
                                                child: ListTile(
                                                  leading: SizedBox(
                                                    height: 50,
                                                    width: 50,
                                                    child: QueryArtworkWidget(
                                                      id: int.parse(
                                                          searchResult[index]
                                                              .metas
                                                              .id!),
                                                      type: ArtworkType.AUDIO,
                                                      artworkBorder:
                                                          BorderRadius.circular(
                                                              15),
                                                      artworkFit: BoxFit.cover,
                                                      nullArtworkWidget:
                                                          Container(
                                                        height: 50,
                                                        width: 50,
                                                        decoration:
                                                            const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(15),
                                                          ),
                                                          image:
                                                              DecorationImage(
                                                            image: AssetImage(
                                                                'assets/istockphoto-1175435360-612x612.jpg'),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  title: Text(
                                                    searchResult[index]
                                                        .metas
                                                        .title!,
                                                    maxLines: 1,
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                  subtitle: Text(
                                                    searchResult[index]
                                                        .metas
                                                        .artist!,
                                                    maxLines: 1,
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              );
                                            }
                                            return Container();
                                          }),
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                              )
                            : const Padding(
                                padding: EdgeInsets.all(30),
                                child: Text(
                                  "No Result Found",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                        : const SizedBox(),
                  ],
                );
              })),
        ),
      ),
    );
  }
}
