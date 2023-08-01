import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:get/get.dart';

import '../db/box.dart';
import '../db/songsmodel.dart';

class SearchController extends GetxController{
  @override
  void onInit() {
searchSongs();
    // TODO: implement onInit
    super.onInit();
  }
String search = "";
 List<Songsdb> dbSongs = [];

  List<Audio> allSongs = [];
  final box = Boxes.getInstance();
  searchSongs() {

    dbSongs = box.get("musics") as List<Songsdb>;
    for (var element in dbSongs) {
      allSongs.add(
        Audio.file(
          element.image.toString(),
          metas: Metas(
              title: element.title,
              id: element.id.toString(),
              artist: element.artist),
        ),
      );
    }
  }
}