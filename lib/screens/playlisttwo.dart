import 'package:flutter/material.dart';
import 'package:musicapp/db/playlist_db.dart';
import 'package:musicapp/model/music_player.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlaylistTwo extends StatefulWidget {
  const PlaylistTwo({Key? key, required this.playlist}) : super(key: key);

  final MusicPlayer playlist;
  @override
  State<PlaylistTwo> createState() => _SongListPageState();
}

class _SongListPageState extends State<PlaylistTwo> {
  final OnAudioQuery audioQuery = OnAudioQuery();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_ios_new)),
          backgroundColor: Colors.black,
          elevation: 0,
          title: const Text(
            'Add Songs',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SafeArea(
              child: Column(children: [
                const SizedBox(
                  height: 15,
                ),
                FutureBuilder<List<SongModel>>(
                    future: audioQuery.querySongs(
                        sortType: null,
                        orderType: OrderType.ASC_OR_SMALLER,
                        uriType: UriType.EXTERNAL,
                        ignoreCase: true),
                    builder: (context, item) {
                      if (item.data == null) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );
                      }
                      if (item.data!.isEmpty) {
                        return const Center(
                          child: Text(
                            'NO Songs Found',
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                        );
                      }
                      return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (ctx, index) {
                            return ListTile(
                              onTap: () {},
                              iconColor:
                                  const Color.fromARGB(255, 255, 255, 255),
                              textColor:
                                  const Color.fromARGB(255, 255, 255, 255),
                              leading: Container(
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 109, 138, 230),
                                  borderRadius: BorderRadius.circular(09),
                                ),
                                child: QueryArtworkWidget(
                                  artworkBorder: BorderRadius.circular(9),
                                  id: item.data![index].id,
                                  type: ArtworkType.AUDIO,
                                  nullArtworkWidget: const Icon(
                                    Icons.music_note_outlined,
                                    color: Colors.white,
                                  ),
                                  artworkFit: BoxFit.fill,
                                ),
                              ),
                              title: Text(
                                item.data![index].displayNameWOExt,
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text("${item.data![index].artist}"),
                              trailing: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      playlistCheck(item.data![index]);
                                      playlistnotifier.notifyListeners();
                                    });
                                  },
                                  icon: !widget.playlist
                                          .isValueIn(item.data![index].id)
                                      ? const Icon(Icons.add)
                                      : const Icon(Icons.check)),
                            );
                          },
                          separatorBuilder: (ctx, index) {
                            return const Divider();
                          },
                          itemCount: item.data!.length);
                    })
              ]),
            ),
          ),
        ));
  }

  void playlistCheck(SongModel data) {
    if (!widget.playlist.isValueIn(data.id)) {
      widget.playlist.add(data.id);
      const snackbar = SnackBar(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          content: Text(
            'song Added to Playlist',
            style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
          ));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }
}
