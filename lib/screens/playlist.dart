import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:musicapp/db/playlist_db.dart';
import 'package:musicapp/model/music_player.dart';
import 'package:musicapp/screens/playlistsong.dart';
import 'package:on_audio_query_platform_interface/details/on_audio_query_helper.dart';

import 'glass.dart';

class PlayList extends StatefulWidget {
  const PlayList({Key? key, List<SongModel>? playerSong}) : super(key: key);

  @override
  State<PlayList> createState() => _PlayListScState();
}

final nameController = TextEditingController();
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _PlayListScState extends State<PlayList> {
  @override
  Widget build(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    return ValueListenableBuilder(
        valueListenable: Hive.box<MusicPlayer>('playlistDB').listenable(),
        builder:
            (BuildContext context, Box<MusicPlayer> musicList, Widget? child) {
          return Scaffold(
            backgroundColor: Colors.black,
            // appBar: AppBar(
            // ),
            body: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SafeArea(
                child: Hive.box<MusicPlayer>('playlistDB').isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              'assets/images/playlist.json',
                              height: 200,
                              width: 200,
                            ),
                            const Text(
                              'Add your Playlist',
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 5,
                        ),
                        itemCount: musicList.length,
                        itemBuilder: (context, index) {
                          final data = musicList.values.toList()[index];
                          return ValueListenableBuilder(
                              valueListenable:
                                  Hive.box<MusicPlayer>('playlistDB')
                                      .listenable(),
                              builder: (BuildContext context,
                                  Box<MusicPlayer> musicList, Widget? child) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return AddButton(
                                        playlist: data,
                                        folderindex: index,
                                      );
                                    }));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: GlassMorphism(
                                      end: 0.6,
                                      start: 0.2,
                                      child: Card(
                                        color: Colors.transparent,
                                        elevation: 0,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Image.asset(
                                              'assets/images/name and logo.png',
                                              fit: BoxFit.cover,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 9,
                                                right: 9,
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 4,
                                                    child:
                                                        SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      // ignore: sized_box_for_whitespace
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            data.name,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white60,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                      flex: 1,
                                                      child: IconButton(
                                                          icon: const Icon(
                                                              Icons.delete,
                                                              color:
                                                                  Colors.white),
                                                          onPressed: () {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return AlertDialog(
                                                                    title: const Text(
                                                                        'Delete Playlist'),
                                                                    content:
                                                                        const Text(
                                                                            'Are you sure you want to delete this playlist?'),
                                                                    actions: <
                                                                        Widget>[
                                                                      TextButton(
                                                                        child: const Text(
                                                                            'No'),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                      ),
                                                                      TextButton(
                                                                        child: const Text(
                                                                            'Yes'),
                                                                        onPressed:
                                                                            () {
                                                                          musicList
                                                                              .deleteAt(index);
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                      ),
                                                                    ],
                                                                  );
                                                                });
                                                          }))
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              });
                        },
                      ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              splashColor: Colors.black,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      // playlistnotifier.notifyListeners();

                      return Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        child: SizedBox(
                          height: 250,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Center(
                                  child: Text(
                                    'Create Your Playlist',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Form(
                                  key: _formKey,
                                  child: TextFormField(
                                      controller: nameController,
                                      decoration: const InputDecoration(
                                          // border: InputBorder.none,
                                          hintText: '  Playlist Name'),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please enter playlist name";
                                        } else {
                                          return null;
                                        }
                                      }),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                        width: 100.0,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: const Color.fromARGB(
                                                    255, 109, 138, 240)),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text(
                                              'Cancel',
                                            ))),
                                    SizedBox(
                                        width: 100.0,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: const Color.fromARGB(
                                                    255, 109, 138, 240)),
                                            onPressed: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                whenButtonClicked();
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: const Text(
                                              'Save',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ))),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              },
              backgroundColor: const Color.fromARGB(255, 109, 138, 240),
              child: const Icon(Icons.add),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
        });
  }

  Future<void> whenButtonClicked() async {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      return;
    } else {
      final music = MusicPlayer(
        songIds: [],
        name: name,
      );
      AddFolder(music);
      nameController.clear();
    }
  }
}
