// ignore_for_file: non_constant_identifier_names

import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:get/get.dart';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../db/box.dart';
import '../db/songsmodel.dart';
import '../screens/bottomnanigation.dart';

class Controller extends GetxController {
  @override
  Future <void> onInit()async {
    fetchSongs();

    toHomeScreen();
    // TODO: implement onInit
    super.onInit();
  }

  final box = Boxes.getInstance();
  bool toggled = false;

  int selectedIndex = 0;

  bool isPlaying = false;
  bool isLooping = false;
  bool isShuffle = false;

  List<dynamic>? likedSongs = [];

  List<Songsdb> playlistSongs = [];
  List<SongModel> fetchedSongs = [];
  List<Songsdb> dbSongs = [];
  final _audioQuery = OnAudioQuery();
  List<Songsdb> mappedSongs = [];
  List<SongModel> allsong = [];
  List<Audio> audiosongs = [];
  final assetAudioPlayer = AssetsAudioPlayer.withId("0");

  fetchSongs() async {
    bool permissionStatus = await _audioQuery.permissionsStatus();
    if (!permissionStatus) {
      await _audioQuery.permissionsRequest();
    }
    allsong = await _audioQuery.querySongs();

    mappedSongs = allsong
        .map((e) => Songsdb(
            title: e.title,
            id: e.id.toString(),
            image: e.uri!,
            duration: e.duration.toString(),
            artist: e.artist))
        .toList();
    await box.put("musics", mappedSongs);
    dbSongs = box.get("musics") as List<Songsdb>;

    for (var element in dbSongs) {
      audiosongs.add(Audio.file(element.image.toString(),
          metas: Metas(
              title: element.title,
              id: element.id.toString(),
              artist: element.artist)));
    }
    update();
  }

  Future<void> toHomeScreen() async {
    await Future.delayed(
      // ignore: prefer_const_constructors
      Duration(seconds: 5),
      () {
        Get.off(() => MyStatefulWidget(allsong: audiosongs));
        // CustomPageRoute(child: MyStatefulWidget(allsong: audiosongs),direction: AxisDirection.down)
        //);
      },
    );
  }

  // searchSongs() {
  //   List<Audio> allSongs = [];
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

  getSwitchValues() async {
    toggled = await getSwitchState();
    update();
  }

  Future<bool> saveSwitchState(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("notification", value);
    return prefs.setBool("notification", value);
  }

  Future<bool> getSwitchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? toggled = prefs.getBool("notification");

    return toggled ?? true;
  }

  //BottomNavigationIndexselection
  OnitemSelected(int newIndex) {
    selectedIndex = newIndex;
    update();
  }

//NOw playing Scren
  Addtofavorite(currentSong) {
    print("GetxNowplaying....................$currentSong");
    likedSongs?.add(currentSong);
    box.put("favorites", likedSongs!);
    likedSongs = box.get("favorites");
    update();
  }

  removeFromfavourite(currentSong) {
    likedSongs?.removeWhere(
        (elemet) => elemet.id.toString() == currentSong.id.toString());
    box.put("favorites", likedSongs!);
    update();
  }

  //Bottom sheet
  AddtoPlaylist(int index, String playlistName) async {

    print("GEtx................${dbSongs[index]}");
    playlistSongs.add(dbSongs[index]);
    await box.put(playlistName, playlistSongs);
    update();
  }

  RemoveFromPlaylist(int index, String playlistName) async {
    playlistSongs.removeWhere(
      (elemet) => elemet.id.toString() == dbSongs[index].id.toString(),
    );
    await box.put(playlistName, playlistSongs);
    update();
  }
}
