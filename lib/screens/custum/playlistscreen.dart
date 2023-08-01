import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/openassetaudio/openassetaudio.dart';
import 'package:music_player/screens/custum/snackbar.dart';

import 'package:on_audio_query/on_audio_query.dart';

import '../../db/box.dart';
import '../../db/songsmodel.dart';
import '../now_playing.dart';
import 'bottomsheet.dart';

// ignore: must_be_immutable
class PlaylistScreen extends StatelessWidget {
  String? playlistName;

  PlaylistScreen({Key? key, this.playlistName}) : super(key: key);

  List<Songsdb>? dbSongs = [];

  List<Songsdb>? playlistSongs = [];
  List<Audio> playPlaylist = [];
  // ignore: prefer_typing_uninitialized_variables
  var backarrow;

  final box = Boxes.getInstance();

  @override
  Widget build(BuildContext context) {
    if (playlistName != 'favorites') {
      backarrow = IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 2, 36, 41),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 2, 36, 41),
        title: Text(
          playlistName!,
          style: const TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.teal),
        ),
        leading: backarrow,
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                backgroundColor: const Color.fromARGB(255, 2, 36, 41),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(40),
                  ),
                ),
                context: context,
                builder: (context) {
                  return buildSheet(
                    playlistName: playlistName!,
                  );
                },
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      // ignore: sized_box_for_whitespace
      body: Container(
        height: double.maxFinite,
        width: double.infinity,
        // decoration: const BoxDecoration(
        //   gradient: LinearGradient(colors: [
        //     Color.fromARGB(255, 3, 46, 43),
        //     Color(0xff181c27),
        //   ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        // ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: box.listenable(),
                builder: (context, boxes, _) {
                  final playlistSongs = box.get(playlistName)!;
                  return playlistSongs.isEmpty
                      ? const SizedBox(
                          child: Center(
                            child: Text(
                              "No songs here!",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: playlistSongs.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                // ignore: avoid_function_literals_in_foreach_calls
                                playlistSongs.forEach(
                                  (element) {
                                    playPlaylist.add(
                                      Audio.file(
                                        element.image.toString(),
                                        metas: Metas(
                                            title: element.title,
                                            id: element.id.toString(),
                                            artist: element.artist),
                                      ),
                                    );
                                  },
                                );
                                OpenPlayer(
                                        fullSongs: playPlaylist, index: index)
                                    .openAssetPlayer(
                                        index: index, songs: playPlaylist);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NowPlaying(
                                      allsong: playPlaylist,
                                      index: index,
                                    ),
                                  ),
                                );
                              },
                              child: ListTile(
                                leading: SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: QueryArtworkWidget(
                                    id: int.parse(playlistSongs[index].id!),
                                    type: ArtworkType.AUDIO,
                                    artworkBorder: BorderRadius.circular(15),
                                    artworkFit: BoxFit.cover,
                                    nullArtworkWidget: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        image: DecorationImage(
                                          image: AssetImage(
                                              "assets/istockphoto-1175435360-612x612.jpg"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  playlistSongs[index].title!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                                subtitle: Text(
                                  playlistSongs[index].artist!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    //   setState(
                                    //    () {
                                    playlistSongs.removeAt(index);
                                    box.put(playlistName, playlistSongs);
                                    //   },
                                    //  );
                                    snackbarcustom(text: 'DELETED');
                                  },
                                  icon: const Icon(Icons.delete,
                                      color: Colors.white),
                                ),
                              ),
                            );
                          },
                        );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
