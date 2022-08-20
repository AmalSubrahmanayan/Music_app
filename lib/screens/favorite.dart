import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:musicapp/db/favoritedb.dart';
import 'package:musicapp/screens/next.dart';
import 'package:musicapp/screens/playscreen.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Favorite extends StatefulWidget {
  const Favorite({Key? key, SongModel? song}) : super(key: key);

  @override
  State<Favorite> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Favorite> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: FavoriteDB.favoriteSongs,
        builder: (BuildContext ctx, List<SongModel> favorData, Widget? child) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
            ),
            body: FavoriteDB.favoriteSongs.value.isEmpty
                ? Center(
                    child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          'assets/images/hart.json',
                          height: 200,
                          width: 200,
                        ),
                        const Text(
                          'No favorites',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ))
                : ListView(children: [
                    ValueListenableBuilder(
                      valueListenable: FavoriteDB.favoriteSongs,
                      builder: (BuildContext ctx, List<SongModel> favorData,
                          Widget? child) {
                        return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (ctx, index) {
                              return ListTile(
                                onTap: () {
                                  // FavoriteDB.favoriteSongs
                                  //     .notifyListeners();
                                  List<SongModel> newlist = [...favorData];
                                  setState(() {});
                                  Getsong.player.stop();
                                  Getsong.player.setAudioSource(
                                      Getsong.createSongList(newlist),
                                      initialIndex: index);
                                  Getsong.player.play();
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (ctx) => PlayScreen(
                                            playerSong: newlist,
                                          )));
                                },
                                leading: Container(
                                  height: 45,
                                  width: 45,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 109, 138, 230),
                                    borderRadius: BorderRadius.circular(09),
                                  ),
                                  child: QueryArtworkWidget(
                                    artworkBorder: BorderRadius.circular(9),
                                    id: favorData[index].id,
                                    type: ArtworkType.AUDIO,
                                    nullArtworkWidget: const Icon(
                                      Icons.music_note_outlined,
                                      color: Colors.white,
                                      size: 35,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  favorData[index].title,
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontSize: 15),
                                ),
                                subtitle: Text(
                                  favorData[index].album!,
                                  style: const TextStyle(
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    // FavoriteDB.favoriteSongs.value
                                    //     .removeAt(index);
                                    FavoriteDB.favoriteSongs.notifyListeners();
                                    FavoriteDB.delete(favorData[index].id);
                                    setState(() {});
                                    const snackbar = SnackBar(
                                        backgroundColor:
                                            Color.fromARGB(255, 255, 255, 255),
                                        content: Text(
                                          'Song deleted from favorite',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        duration: Duration(microseconds: 190));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackbar);
                                  },
                                  icon: const Icon(
                                    Icons.favorite,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (ctx, index) {
                              return const Divider();
                            },
                            itemCount: favorData.length);
                      },
                    ),
                  ]),
          );
        });
  }
}
