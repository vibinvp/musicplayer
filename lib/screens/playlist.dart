// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'package:hive_flutter/adapters.dart';
import 'package:music_player/screens/custum/snackbar.dart';

import '../Controller/Getx_Controller.dart';
import '../db/box.dart';
import '../db/songsmodel.dart';
import 'custum/editplaylist.dart';
import 'custum/playlistscreen.dart';

// ignore: must_be_immutable
class play_List extends StatelessWidget {
  String playListname = '';

  play_List({Key? key, required this.playListname}) : super(key: key);

  @override



  final _controller = Get.put(Controller());
  List playlists = [];
  String? playlistName = '';
  final box = Boxes.getInstance();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 2, 36, 41),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 2, 36, 41),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // const SizedBox(
              //   height: 2,
              // ),
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        showDialog(
                          
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            backgroundColor:
                            Colors.white,
                              //  const Color.fromARGB(146, 241, 243, 247),
                            title: const Text(
                              "Add new Playlist",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.teal),
                            ),
                            content: TextField(
                              style: const TextStyle(color: Color.fromARGB(255, 3, 84, 65)),
                              onChanged: (value) {
                                playlistName = value.trim();
                              },
                              autofocus: true,
                              cursorRadius: const Radius.circular(50),
                              cursorColor: Colors.black,
                            ),
                            actions: [
                              GetBuilder<Controller>(
                                
                                builder: (_) {
                                  return TextButton(
                                    onPressed: () {
                                      List<Songsdb> librayry = [];
                                      List? excistingName = [];
                                      if (playlists.isNotEmpty) {
                                        excistingName = playlists
                                            .where((element) =>
                                                element == playlistName)
                                            .toList();
                                      }

                                      if (playlistName != '' &&
                                          excistingName.isEmpty) {
                                        box.put(playlistName, librayry);
                                        Navigator.of(context).pop();
                                       // setState(() {
                                          playlists = box.keys.toList();
                                      //  });
                                        snackbarcustom(
                                            text: 'CREATED NEW LIST');
                                      }
                                      if (playlistName == '') {
                                        snackbarcustom(
                                            text: 'please type valid input');
                                      } else {
                                         // snackbarcustom(text: 'alredy exist');
                                      }
                                    },
                                    child: const Text(
                                      "ADD",
                                      style: TextStyle(
                                        color:Colors.teal
                                           // Color.fromARGB(255, 233, 225, 225),
                                      ),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Color.fromARGB(255, 192, 181, 181),
                      ),
                      label: const Text(
                        'Create Playlist',
                        style: TextStyle(
                            color: Color.fromARGB(255, 216, 228, 217),
                            fontSize: 23),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: ValueListenableBuilder(
                  valueListenable: box.listenable(),
                  builder: (context, boxes, _) {
                    playlists = box.keys.toList();
                    return Padding(
                      padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                      child: ListView.builder(
                        itemCount: playlists.length,
                        itemBuilder: (context, index) {
                          return Container(
                            child: playlists[index] != "musics" &&
                                    playlists[index] != "favorites"
                                ? ListTile(
                                    title: Text(
                                      playlists[index].toString(),
                                      style: const TextStyle(
                                        color:
                                        //Colors.white,
                                            Color.fromARGB(255, 27, 190, 128),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    leading: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        image: DecorationImage(
                                          image: AssetImage(
                                              "assets/unnamed.png"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),

                                    // leading: const Icon(
                                    //   Icons.queue_sharp,
                                    //   color: Color.fromARGB(255, 219, 231, 229),
                                    // ),
                                    trailing: popupMenuBar(index ,context),
                                    iconColor: Colors.white,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PlaylistScreen(
                                            playlistName: playlists[index],
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Container(),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  popupMenuBar(int index,BuildContext context ) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: const Color.fromARGB(255, 27, 21, 21),
      itemBuilder: (context) => [
        const PopupMenuItem(
          child: Text(
            'Remove Playlist',
            style: TextStyle(color: Colors.red),
          ),
          value: "0",
        ),
        const PopupMenuItem(
          value: "1",
          child: Text("Rename Playlist", style: TextStyle(color: Colors.white)),
        ),
      ],
      onSelected: (value ) {
        if (value == "0") {
          Get.defaultDialog(
            
                    backgroundColor: Colors.white,
                    title: 
                      playlistName.toString(),
                   
                    
                    content: const Text('Delete ?'),
                    actions: [
                       TextButton(
                        onPressed: () {
                        Get.back();
                        },
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () {
                          box.delete(
                            playlists[index],
                          );
                          Get.back();
                          snackbarcustom(text: 'DELETED');
                        },
                        child: const Text(
                          'Yes',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                     
                    ],
                
                  );

        }
        if (value == "1") {
          showDialog(
            context: context,
            builder: (context) => EditPlaylist(
              playlistName: playlists[index],
            ),
          );
        }
      },
    );
  }
}
