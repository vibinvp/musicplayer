import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/Controller/Getx_Controller.dart';
import 'package:music_player/screens/custum/snackbar.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../db/box.dart';
import '../../db/songsmodel.dart';


// ignore: must_be_immutable, camel_case_types
class buildSheet extends StatelessWidget {
  String playlistName;
  buildSheet({Key? key, required this.playlistName}) : super(key: key);

  
  final box = Boxes.getInstance();

  //List<Songsdb> dbSongs = [];
 // List<Songsdb> playlistSongs = [];
  @override
  

 

  @override
  Widget build(BuildContext context) {
    
    final _controller =Get.put(Controller());
    _controller.dbSongs= box.get("musics") as List<Songsdb>;
  _controller.  playlistSongs = box.get(playlistName)!.cast<Songsdb>();
    return GetBuilder<Controller>(
     
      builder: (_) {
        return Container(
          padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
          child: ListView.builder(
            itemCount:_controller. dbSongs.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: SizedBox(
                    height: 50,
                    width: 50,
                    child: QueryArtworkWidget(
                      id: int.parse(_controller. dbSongs[index].id.toString()),
                      type: ArtworkType.AUDIO,
                      artworkBorder: BorderRadius.circular(15),
                      artworkFit: BoxFit.cover,
                      nullArtworkWidget: Container(
                        height: 50,
                        width: 50,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          image: DecorationImage(
                            image: AssetImage("assets/istockphoto-1175435360-612x612.jpg"),
                            fit: BoxFit.cover,
                          ),
                     
   
    )
                  ),
                ),
              ),
              title: Text(
              _controller.  dbSongs[index].title!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w500,color: Colors.white),
              ),
              trailing:_controller. playlistSongs
                      .where((element) =>
                          element.id.toString() ==_controller. dbSongs[index].id.toString())
                      .isEmpty
                  ? IconButton(
                      onPressed: () {
                        _controller.AddtoPlaylist(index,playlistName);
                        _controller.update();

                      //  playlistSongs.add(dbSongs[index]);
                      //  print(dbSongs[index]);
                       // await box.put(widget.playlistName, playlistSongs);
                       // setState(() {});
                        snackbarcustom(text: 'ADDED ');
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    )
                  : IconButton(
                      onPressed: () {
                        // playlistSongs.removeWhere(
                        //   (elemet) =>
                        //       elemet.id.toString() ==
                        //       dbSongs[index].id.toString(),
                        // );
                      //  await box.put(widget.playlistName, playlistSongs);
                       // setState(() {});
                       _controller.RemoveFromPlaylist(index, playlistName);
                       _controller.update();
                        snackbarcustom(text: 'REMOVED');
                      },
                      icon: const Icon(
                        Icons.remove,
                        color: Colors.red,

                      ),
                    ),
            ),
          );
        },
      ),
    );
      },
    );
  }
}
