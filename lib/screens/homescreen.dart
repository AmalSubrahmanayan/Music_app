import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicapp/db/favoritebtn.dart';
import 'package:musicapp/db/favoritedb.dart';
import 'package:musicapp/screens/next.dart';
import 'package:musicapp/screens/playscreen.dart';
import 'package:musicapp/screens/settings.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static List<SongModel> song = [];
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  void requestPermission() async {
    await Permission.storage.request();
  }

  // playSong(String? uri) {
  //   try {
  //     _audioPlayer.setAudioSource(
  //       AudioSource.uri(
  //         Uri.parse(uri!),
  //       ),
  //     );
  //     _audioPlayer.play();
  //   } on Exception {
  //     log("Error parsing ");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings_outlined,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Settings()));
              FavoriteDB.favoriteSongs.notifyListeners();
            },
          )
        ],
        title: Image.asset(
          'assets/images/name.png',
          width: 200,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<SongModel>>(
          future: _audioQuery.querySongs(
              sortType: null,
              orderType: OrderType.ASC_OR_SMALLER,
              uriType: UriType.EXTERNAL,
              ignoreCase: true),
          builder: (context, item) {
            if (item.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (item.data!.isEmpty) {
              return const Text("No Songs Found");
            }
            HomeScreen.song = item.data!;
            if (!FavoriteDB.isInitialized) {
              FavoriteDB.initialise(item.data!);
            }
            Getsong.songCopy = item.data!;

            return ListView.separated(
              padding: const EdgeInsets.only(left: 9, right: 9),
              itemBuilder: (context, index) {
                return ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  leading: Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 109, 138, 230),
                      borderRadius: BorderRadius.circular(09),
                    ),
                    child: QueryArtworkWidget(
                      artworkBorder: BorderRadius.circular(9),
                      id: item.data![index].id,
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: const Icon(
                        Icons.music_note_outlined,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  title: Text(
                    item.data![index].displayNameWOExt,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    item.data![index].artist.toString(),
                    style: const TextStyle(
                        color: Color.fromARGB(255, 149, 167, 232)),
                  ),
                  trailing: FavoriteBt(
                    song: HomeScreen.song[index],
                  ),
                  onTap: () {
                    Getsong.player.setAudioSource(
                        Getsong.createSongList(item.data!),
                        initialIndex: index);
                    Getsong.player.play();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlayScreen(
                          playerSong: item.data!,
                        ),
                      ),
                    );
                    FavoriteDB.favoriteSongs.notifyListeners();
                  },
                );
              },
              separatorBuilder: (_, __) {
                return const SizedBox(height: 10.0);
              },
              itemCount: item.data!.length,
            );
          },
        ),
      ),
    );
  }
}
