import 'package:hive_flutter/adapters.dart';
part 'songsmodel.g.dart';

@HiveType(typeId: 1)
class Songsdb extends HiveObject {
  @HiveField(0)
  String? title;
  @HiveField(1)
  String? artist;
  @HiveField(2)
  String? duration;
  @HiveField(3)
  String? id;
  @HiveField(4)
  String? image;

  Songsdb({
    required this.title,
    required this.artist,
    required this.duration,
    required this.id,
    required this.image,
  });
}