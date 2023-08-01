// ignore_for_file: prefer_const_constructors

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_player/screens/custum/snackbar.dart';

import '../../db/box.dart';
import '../../db/songsmodel.dart';


// ignore: must_be_immutable
class BuildSheet extends StatelessWidget {
  BuildSheet({Key? key, this.song}) : super(key: key);
  Audio? song;

  
  List playlists = [];

  String? playlistName = '';

  List<dynamic>? playlistSongs = [];

  @override
  Widget build(BuildContext context) {
    final box = Boxes.getInstance();
    playlists = box.keys.toList();
    return Container(
      padding: const EdgeInsets.only(top: 30, bottom: 20),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
            child: ListTile(
              onTap: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  backgroundColor: Color.fromARGB(133, 14, 74, 81),
                  title: const Text(
                    "Add new Playlist",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 102, 197, 105)),
                  ),
                  content: TextField(
                    style: TextStyle(color: Colors.white),
                    onChanged: (value) {
                      playlistName = value;
                    },
                    autofocus: true,
                    cursorRadius: const Radius.circular(50),
                    cursorColor: Color.fromARGB(255, 202, 187, 187),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          List<Songsdb> librayry = [];
                          List? excistingName = [];
                          if (playlists.isNotEmpty) {
                            excistingName = playlists
                                .where((element) => element == playlistName)
                                .toList();
                          }

                          if (playlistName != '' && excistingName.isEmpty) {
                            box.put(playlistName, librayry);
                            Navigator.of(context).pop();
                           // setState(() {
                              playlists = box.keys.toList();
                          //  });
                            snackbarcustom(text: 'CREATED NEW LIST');
                          } else {
                            snackbarcustom(text: 'file exist');
                          }
                        },
                        child: const Text(
                          "ADD",
                          style: TextStyle(
                            color: Color.fromARGB(255, 240, 237, 237),
                          ),
                        ))
                  ],
                ),
              ),
              leading: Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(103, 0, 0, 0),
                  borderRadius: BorderRadius.all(Radius.circular(17)),
                ),
                child: const Center(
                    child: Icon(
                  Icons.add,
                  color: Color.fromARGB(183, 252, 250, 250),
                  size: 28,
                )),
              ),
              
              title: const Text(
                "Create Playlist",
                style: TextStyle(
                  color: Color.fromARGB(183, 252, 250, 250),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
         ... playlists
              .map((e) => e != "musics" && e != "favorites"
                  ? libraryList(
                      child: ListTile(
                      onTap: () async {
                        playlistSongs = box.get(e);
                        List existingSongs = [];
                        existingSongs = playlistSongs!
                            .where((element) =>
                                element.id.toString() ==
                                song!.metas.id.toString())
                            .toList();

                        if (existingSongs.isEmpty) {
                          final songs = box.get("musics") as List<Songsdb>;
                          final temp = songs.firstWhere((element) =>
                              element.id.toString() ==
                              song!.metas.id.toString());
                          playlistSongs?.add(temp);

                          await box.put(e, playlistSongs!);

                         
                          Navigator.of(context).pop();
                          
                          snackbarcustom(text: 'ADDED');
                        } else {
                          Navigator.of(context).pop();
                          snackbarcustom(text: 'existing song');
                        }
                      },
                      leading: Container(
                        height: 50,
                        width: 50,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/unnamed.png"),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.all(Radius.circular(17)),
                        ),
                      ),
                      title: Text(
                        e.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ))
                  : Container())
              .toList()
        ],
      ),
    );
  }

  Padding libraryList({required child}) {
    return Padding(
        padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
        child: child);
  }
}
