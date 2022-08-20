import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lottie/lottie.dart';
import 'package:musicapp/db/playlist_db.dart';
import 'package:musicapp/model/music_player.dart';
import 'package:musicapp/screens/next.dart';
import 'package:musicapp/screens/playlisttwo.dart';
import 'package:musicapp/screens/playscreen.dart';

import 'package:on_audio_query/on_audio_query.dart';

class AddButton extends StatefulWidget {
  const AddButton({Key? key, required this.playlist, required this.folderindex})
      : super(key: key);
  final MusicPlayer playlist;
  final int folderindex;
  // static List<SongModel> playlistSongid = [];
  @override
  State<AddButton> createState() => _PlaylistDataState();
}

class _PlaylistDataState extends State<AddButton> {
  late List<SongModel> playlistsong;
  @override
  Widget build(BuildContext context) {
    getAllPlaylist();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Songs',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: SafeArea(
              child: Column(
            children: [
              Lottie.asset(
                'assets/images/playlist.json',
                height: 150,
                width: 150,
              ),
              FloatingActionButton.extended(
                onPressed: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => PlaylistTwo(
                            playlist: widget.playlist,
                          )));
                },
                label: const Text('Add Songs'),
                icon: const Icon(Icons.post_add_rounded),
                backgroundColor: const Color.fromARGB(255, 109, 138, 230),
              ),
              ValueListenableBuilder(
                valueListenable:
                    Hive.box<MusicPlayer>('playlistDB').listenable(),
                builder: (BuildContext context, Box<MusicPlayer> value,
                    Widget? child) {
                  playlistsong = listPlaylist(
                      value.values.toList()[widget.folderindex].songIds);
                  //  PlaylistData.playlistSongid = playlistsong;

                  return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (ctx, index) {
                        return ListTile(
                            onTap: () {
                              List<SongModel> newlist = [...playlistsong];

                              Getsong.player.stop();
                              Getsong.player.setAudioSource(
                                  Getsong.createSongList(newlist),
                                  initialIndex: index);
                              Getsong.player.play();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => PlayScreen(
                                        playerSong: playlistsong,
                                      )));
                            },
                            leading: Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 109, 138, 230),
                                borderRadius: BorderRadius.circular(09),
                              ),
                              child: QueryArtworkWidget(
                                artworkBorder: BorderRadius.circular(9),
                                id: playlistsong[index].id,
                                type: ArtworkType.AUDIO,
                                nullArtworkWidget: const Icon(
                                  Icons.music_note,
                                  color: Colors.white,
                                ),
                                errorBuilder: (context, excepion, gdb) {
                                  setState(() {});
                                  return Image.asset('');
                                },
                              ),
                            ),
                            title: Text(
                              playlistsong[index].title,
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.white),
                            ),
                            subtitle: Text(
                              playlistsong[index].artist!,
                              style: const TextStyle(color: Colors.white),
                            ),
                            trailing: IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                      backgroundColor: Colors.black,
                                      context: context,
                                      builder: (builder) {
                                        return SizedBox(
                                          height: 300,
                                          child: Column(
                                            children: [
                                              // const SizedBox(
                                              //   height: 20,
                                              // ),
                                              Container(
                                                height: 150,
                                                width: 150,
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 109, 138, 230),
                                                  borderRadius:
                                                      BorderRadius.circular(09),
                                                ),
                                                child: QueryArtworkWidget(
                                                    artworkBorder:
                                                        BorderRadius.circular(
                                                            1),
                                                    artworkWidth: 100,
                                                    artworkHeight: 400,
                                                    nullArtworkWidget:
                                                        const Icon(
                                                      Icons.music_note,
                                                      size: 80,
                                                      color: Colors.white,
                                                    ),
                                                    id: playlistsong[index].id,
                                                    type: ArtworkType.AUDIO),
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  playlistsong[index].title,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(18.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ElevatedButton.icon(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                primary: const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    109,
                                                                    138,
                                                                    230)),
                                                        onPressed: () {
                                                          widget.playlist
                                                              .deleteData(
                                                                  playlistsong[
                                                                          index]
                                                                      .id);
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        icon: const Icon(
                                                          Icons
                                                              .delete_outline_outlined,
                                                          color: Colors.red,
                                                          size: 25,
                                                        ),
                                                        label: const Text(
                                                          'Remove Song',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 20,
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      });
                                },
                                icon: const Icon(
                                  Icons.more_vert_sharp,
                                  color: Colors.white,
                                )));
                      },
                      separatorBuilder: (ctx, index) {
                        return const Divider();
                      },
                      itemCount: playlistsong.length);
                },
              ),
            ],
          )),
        ),
      ),
    );
  }

  List<SongModel> listPlaylist(List<int> data) {
    List<SongModel> plsongs = [];
    for (int i = 0; i < Getsong.songCopy.length; i++) {
      for (int j = 0; j < data.length; j++) {
        if (Getsong.songCopy[i].id == data[j]) {
          plsongs.add(Getsong.songCopy[i]);
        }
      }
    }
    return plsongs;
  }
}
