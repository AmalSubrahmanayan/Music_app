import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicapp/db/favoritedb.dart';
import 'package:musicapp/model/music_player.dart';
import 'package:musicapp/screens/splashscreen.dart';


ValueNotifier<List<MusicPlayer>> playlistnotifier = ValueNotifier([]);
ValueNotifier<bool> refreshNotifier = ValueNotifier(true);


Future<void> AddFolder(MusicPlayer value) async {
  final playListDb = Hive.box<MusicPlayer>('playlistDB');
  await playListDb.add(value);

  playlistnotifier.value.add(value);
}

Future<void> getAllPlaylist() async {
  final playListDb = Hive.box<MusicPlayer>('playlistDB');
  playlistnotifier.value.clear();
  playlistnotifier.value.addAll(playListDb.values);

  playlistnotifier.notifyListeners();
}

Future<void> playlistDelete(int index) async {
  final playListDb = Hive.box<MusicPlayer>('playlistDB');

  await playListDb.deleteAt(index);
  getAllPlaylist();
}

Future<void> appReset(context) async {
  final playListDb = Hive.box<MusicPlayer>('playlistDB');
  final musicDb = Hive.box<int>('favoriteDB');
  await musicDb.clear();
  await playListDb.clear();
  FavoriteDB.favoriteSongs.value.clear();
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) =>  SplashScreen(),
      ),
      (route) => false);
}